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

#import "EMCDDeviceManager.h"

@interface EMCDDeviceManager (Microphone)
// 判断麦克风是否可用
- (BOOL)emCheckMicrophoneAvailability;

// 获取录制音频时的音量(0~1)
- (double)emPeekRecorderVoiceMeter;
@end
