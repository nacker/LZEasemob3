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


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "EMSDK.h"

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_CALL @"callOutWithChatter"
#define KNOTIFICATION_CALL_CLOSE @"callControllerClose"

#define kGroupMessageAtList      @"em_at_list"
#define kGroupMessageAtAll       @"all"

#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
#define kEaseUISDKConfigIsUseLite @"isUselibHyphenateClientSDKLite"

@interface EaseSDKHelper : NSObject<EMClientDelegate>

@property (nonatomic) BOOL isShowingimagePicker;

@property (nonatomic) BOOL isLite;

+ (instancetype)shareHelper;

#pragma mark - init Hyphenate

- (void)hyphenateApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig;

#pragma mark - send message

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendCmdMessage:(NSString *)action
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt
                     cmdParams:(NSArray *)params;

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt;

#pragma mark - call

@end
