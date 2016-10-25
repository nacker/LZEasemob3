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
#import <AudioToolbox/AudioToolbox.h>
@interface EMCDDeviceManager (Remind)
// 播放接收到新消息时的声音
- (SystemSoundID)playNewMessageSound;

// 震动
- (void)playVibration;
@end
