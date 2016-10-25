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

#import <Foundation/Foundation.h>

@interface EMAudioPlayerUtil : NSObject
// 当前是否正在播放
+ (BOOL)isPlaying;

// 得到当前播放音频路径
+ (NSString *)playingFilePath;

// 播放指定路径下音频（wav）
+ (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;

// 停止当前播放音频
+ (void)stopCurrentPlaying;

@end
