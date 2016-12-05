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


#import "RobotManager.h"

//#import "EMRobot.h"

@interface RobotManager ()

@property (nonatomic,strong) NSMutableDictionary *robotSource;

@end

static RobotManager *sharedInstance = nil;
@implementation RobotManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _robotSource = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)isRobotWithUsername:(NSString*)username
{
    if ([[_robotSource allKeys] count] == 0) {
//        [self addRobotsToMemory:[[EMClient sharedClient].chatManager robotList]];
    }
    if ([_robotSource objectForKey:[username lowercaseString]]) {
        return YES;
    }
    return NO;
}

- (NSString*)getRobotNickWithUsername:(NSString*)username
{
    if ([_robotSource objectForKey:[username lowercaseString]]) {
//        EMRobot *robot = [_robotSource objectForKey:[username lowercaseString]];
//        return robot.nickname;
    }
    return username;
}

- (void)addRobotsToMemory:(NSArray *)robots
{
    if (robots && [robots count] > 0) {
        [_robotSource removeAllObjects];
//        for (EMRobot *robot in robots) {
//            if ([robot isKindOfClass:[EMRobot class]]) {
//                [_robotSource setObject:robot forKey:[robot.username lowercaseString]];
//            }
//        }
    }
}

- (BOOL)isRobotMenuMessage:(EMMessage *)message
{
    if (message.ext && [message.ext objectForKey:kRobot_Message_Ext]) {
        if ([message.ext objectForKey:kRobot_Message_Type]) {
            NSDictionary *dic = [message.ext objectForKey:kRobot_Message_Type];
            if ([dic objectForKey:kRobot_Message_Choice]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSString*)getRobotMenuMessageDigest:(EMMessage*)message
{
    if ([self isRobotMenuMessage:message]) {
        if ([message.ext objectForKey:kRobot_Message_Type]) {
            NSDictionary *dic = [message.ext objectForKey:kRobot_Message_Type];
            if ([dic objectForKey:kRobot_Message_Choice]) {
                NSDictionary *choice = [dic objectForKey:kRobot_Message_Choice];
                return [choice objectForKey:kRobot_Message_Title];
            }
        }
    }
    return @"";
}

- (NSString*)getRobotMenuMessageContent:(EMMessage*)message
{
    NSString *content = @"";
    if ([self isRobotMenuMessage:message]) {
        if ([message.ext objectForKey:kRobot_Message_Type]) {
            NSDictionary *dic = [message.ext objectForKey:kRobot_Message_Type];
            if ([dic objectForKey:kRobot_Message_Choice]) {
                NSDictionary *choice = [dic objectForKey:kRobot_Message_Choice];
                NSArray *menu = [choice objectForKey:kRobot_Message_List];
                content = [choice objectForKey:kRobot_Message_Title];
                for (NSString *string in menu) {
                    content = [content stringByAppendingString:[NSString stringWithFormat:@"\n%@",string]];
                }
            }
        }
    }
    return content;
}

@end
