/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "EMCDDeviceManager+Media.h"
#import "EMAudioPlayerUtil.h"
#import "EMAudioRecorderUtil.h"
#import "EMVoiceConverter.h"
#import "DemoErrorCode.h"
#import "EaseLocalDefine.h"

typedef NS_ENUM(NSInteger, EMAudioSession){
    EM_DEFAULT = 0,
    EM_AUDIOPLAYER,
    EM_AUDIORECORDER
};

@implementation EMCDDeviceManager (Media)
#pragma mark - AudioPlayer

+ (NSString*)dataPath
{
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

// 播放音频
- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon{
    BOOL isNeedSetActive = YES;
    // 如果正在播放音频，停止当前播放。
    if([EMAudioPlayerUtil isPlaying]){
        [EMAudioPlayerUtil stopCurrentPlaying];
        isNeedSetActive = NO;
    }
    
    if (isNeedSetActive) {
        // 设置播放时需要的category
        [self setupAudioSessionCategory:EM_AUDIOPLAYER
                               isActive:YES];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
    //如果转换后的wav文件不存在, 则去转换一下
    if (![fileManager fileExistsAtPath:wavFilePath]) {
        BOOL covertRet = [self convertAMR:aFilePath toWAV:wavFilePath];
        if (!covertRet) {
            if (completon) {
                completon([NSError errorWithDomain:NSEaseLocalizedString(@"error.initRecorderFail", @"File format conversion failed")
                                              code:EMErrorFileTypeConvertionFailure
                                          userInfo:nil]);
            }
            return ;
        }
    }
    [EMAudioPlayerUtil asyncPlayingWithPath:wavFilePath
                                 completion:^(NSError *error)
     {
         [self setupAudioSessionCategory:EM_DEFAULT
                                isActive:NO];
         if (completon) {
             completon(error);
         }
     }];
}

// 停止播放
- (void)stopPlaying{
    [EMAudioPlayerUtil stopCurrentPlaying];
    [self setupAudioSessionCategory:EM_DEFAULT
                           isActive:NO];
}

- (void)stopPlayingWithChangeCategory:(BOOL)isChange{
    [EMAudioPlayerUtil stopCurrentPlaying];
    if (isChange) {
        [self setupAudioSessionCategory:EM_DEFAULT
                               isActive:NO];
    }
}

// 获取播放状态
- (BOOL)isPlaying{
    return [EMAudioPlayerUtil isPlaying];
}

#pragma mark - Recorder

+(NSTimeInterval)recordMinDuration{
    return 1.0;
}

// 开始录音
- (void)asyncStartRecordingWithFileName:(NSString *)fileName
                             completion:(void(^)(NSError *error))completion{
    NSError *error = nil;
    
    // 判断当前是否是录音状态
    if ([self isRecording]) {
        if (completion) {
            error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.recordStoping", @"Record voice is not over yet")
                                        code:EMErrorAudioRecordStoping
                                    userInfo:nil];
            completion(error);
        }
        return ;
    }
    
    // 文件名不存在
    if (!fileName || [fileName length] == 0) {
        error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.notFound", @"File path not exist")
                                    code:-1
                                userInfo:nil];
        completion(error);
        return ;
    }
    
    BOOL isNeedSetActive = YES;
    if ([self isRecording]) {
        [EMAudioRecorderUtil cancelCurrentRecording];
        isNeedSetActive = NO;
    }
    
    [self setupAudioSessionCategory:EM_AUDIORECORDER
                           isActive:YES];
    
    _recorderStartDate = [NSDate date];

    NSString *recordPath = [NSString stringWithFormat:@"%@/%@", [EMCDDeviceManager dataPath], fileName];
    [EMAudioRecorderUtil asyncStartRecordingWithPreparePath:recordPath
                                                 completion:completion];
}

// 停止录音
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath,
                                                 NSInteger aDuration,
                                                 NSError *error))completion{
    NSError *error = nil;
    // 当前是否在录音
    if(![self isRecording]){
        if (completion) {
            error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.recordNotBegin", @"Recording has not yet begun")
                                        code:EMErrorAudioRecordNotStarted
                                    userInfo:nil];
            completion(nil,0,error);
            return;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    _recorderEndDate = [NSDate date];
    
    if([_recorderEndDate timeIntervalSinceDate:_recorderStartDate] < [EMCDDeviceManager recordMinDuration]){
        if (completion) {
            error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.recordTooShort", @"Recording time is too short")
                                        code:EMErrorAudioRecordDurationTooShort
                                    userInfo:nil];
            completion(nil,0,error);
        }
        
        // 如果录音时间较短，延迟1秒停止录音（iOS中，如果快速开始，停止录音，UI上会出现红条,为了防止用户又迅速按下，UI上需要也加一个延迟，长度大于此处的延迟时间，不允许用户循序重新录音。PS:研究了QQ和微信，就这么玩的,聪明）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([EMCDDeviceManager recordMinDuration] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [EMAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
                [weakSelf setupAudioSessionCategory:EM_DEFAULT isActive:NO];
            }];
        });
        return ;
    }
    
    [EMAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
        if (completion) {
            if (recordPath) {
                //录音格式转换，从wav转为amr
                NSString *amrFilePath = [[recordPath stringByDeletingPathExtension]
                                         stringByAppendingPathExtension:@"amr"];
                BOOL convertResult = [self convertWAV:recordPath toAMR:amrFilePath];
                if (convertResult) {
                    // 删除录的wav
                    NSFileManager *fm = [NSFileManager defaultManager];
                    [fm removeItemAtPath:recordPath error:nil];
                }
                completion(amrFilePath,(int)[self->_recorderEndDate timeIntervalSinceDate:self->_recorderStartDate],nil);
            }
            [weakSelf setupAudioSessionCategory:EM_DEFAULT isActive:NO];
        }
    }];
}

// 取消录音
-(void)cancelCurrentRecording{
    [EMAudioRecorderUtil cancelCurrentRecording];
}

// 获取录音状态
-(BOOL)isRecording{
    return [EMAudioRecorderUtil isRecording];
}

#pragma mark - Private
-(NSError *)setupAudioSessionCategory:(EMAudioSession)session
                             isActive:(BOOL)isActive{
    BOOL isNeedActive = NO;
    if (isActive != _currActive) {
        isNeedActive = YES;
        _currActive = isActive;
    }
    NSError *error = nil;
    NSString *audioSessionCategory = nil;
    switch (session) {
        case EM_AUDIOPLAYER:
            // 设置播放category
            audioSessionCategory = AVAudioSessionCategoryPlayback;
            break;
        case EM_AUDIORECORDER:
            // 设置录音category
            audioSessionCategory = AVAudioSessionCategoryRecord;
            break;
        default:
            // 还原category
            audioSessionCategory = AVAudioSessionCategoryAmbient;
            break;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 如果当前category等于要设置的，不需要再设置
    if (![_currCategory isEqualToString:audioSessionCategory]) {
        [audioSession setCategory:audioSessionCategory error:nil];
    }
    if (isNeedActive) {
        BOOL success = [audioSession setActive:isActive
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
        if(!success || error){
            error = [NSError errorWithDomain:NSEaseLocalizedString(@"error.initPlayerFail", @"Failed to initialize AVAudioPlayer")
                                        code:-1
                                    userInfo:nil];
            return error;
        }
    }
    _currCategory = audioSessionCategory;
    
    return error;
}

#pragma mark - Convert

- (BOOL)convertAMR:(NSString *)amrFilePath
             toWAV:(NSString *)wavFilePath
{
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
    if (isFileExists) {
        [EMVoiceConverter amrToWav:amrFilePath wavSavePath:wavFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
        if (isFileExists) {
            ret = YES;
        }
    }
    
    return ret;
}

- (BOOL)convertWAV:(NSString *)wavFilePath
             toAMR:(NSString *)amrFilePath {
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
    if (isFileExists) {
        [EMVoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
        if (!isFileExists) {
            
        } else {
            ret = YES;
        }
    }
    
    return ret;
}

@end
