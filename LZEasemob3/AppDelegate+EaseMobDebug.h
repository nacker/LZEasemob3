/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AppDelegate.h"

@interface AppDelegate (EaseMobDebug)

/*!
 *  @brief 判断是否开启了测试模式，本类以及本方法开发者不需要集成使用，直接调用registerSDKWithAppKey:apnsCertName:otherConfig即可
 *  @return 返回结果
 *  @remark 本类以及本方法开发者不需要集成使用
 */
-(BOOL)isSpecifyServer;

@end
