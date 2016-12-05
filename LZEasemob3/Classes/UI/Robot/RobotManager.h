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

//  用来处理UIDemo上的机器人

#import <Foundation/Foundation.h>

#define kRobot_Message_Ext @"em_robot_message"
#define kRobot_Message_Type @"msgtype"
#define kRobot_Message_Choice @"choice"
#define kRobot_Message_List @"list"
#define kRobot_Message_Title @"title"

@interface RobotManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isRobotWithUsername:(NSString*)username;

- (NSString*)getRobotNickWithUsername:(NSString*)username;

- (void)addRobotsToMemory:(NSArray*)robots;

- (BOOL)isRobotMenuMessage:(EMMessage*)message;

- (NSString*)getRobotMenuMessageDigest:(EMMessage*)message;

- (NSString*)getRobotMenuMessageContent:(EMMessage*)message;

@end
