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

#import "EMCDDeviceManager+Microphone.h"
#import "EMAudioRecorderUtil.h"

@implementation EMCDDeviceManager (Microphone)
// 判断麦克风是否可用
- (BOOL)emCheckMicrophoneAvailability{
    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            ret = granted;
        }];
    } else {
        ret = YES;
    }
    
    return ret;
}

// 获取录制音频时的音量(0~1)
- (double)emPeekRecorderVoiceMeter{
    double ret = 0.0;
    if ([EMAudioRecorderUtil recorder].isRecording) {
        [[EMAudioRecorderUtil recorder] updateMeters];
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        double lowPassResults = pow(10, (0.05 * [[EMAudioRecorderUtil recorder] peakPowerForChannel:0]));
        ret = lowPassResults;
    }
    
    return ret;
}
@end
