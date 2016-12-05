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

#import <Foundation/Foundation.h>

#import "ConversationListController.h"
#import "ContactListViewController.h"
#import "MainViewController.h"
#import "ChatViewController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

#if DEMO_CALL == 1

#import "CallViewController.h"
#import "EMCallOptions+NSCoding.h"

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>

#else

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

#endif

@property (nonatomic, weak) ContactListViewController *contactViewVC;

@property (nonatomic, weak) ConversationListController *conversationListVC;

@property (nonatomic, weak) MainViewController *mainVC;

@property (nonatomic, weak) ChatViewController *chatVC;

#if DEMO_CALL == 1

@property (strong, nonatomic) NSObject *callLock;
@property (strong, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) CallViewController *callController;

#endif

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

#if DEMO_CALL == 1

+ (void)updateCallOptions;

- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall:(NSString *)aCallId;

- (void)dismissCurrentCallController;

#endif

@end
