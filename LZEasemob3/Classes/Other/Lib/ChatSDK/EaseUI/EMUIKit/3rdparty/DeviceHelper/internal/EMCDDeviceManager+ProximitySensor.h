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

#import "EMCDDeviceManagerBase.h"

@interface EMCDDeviceManager (ProximitySensor)
#pragma mark - proximity sensor
@property (nonatomic, readonly) BOOL isSupportProximitySensor;
@property (nonatomic, readonly) BOOL isCloseToUser;
@property (nonatomic, readonly) BOOL isProximitySensorEnabled;

- (BOOL)enableProximitySensor;
- (BOOL)disableProximitySensor;
- (void)sensorStateChanged:(NSNotification *)notification;
@end
