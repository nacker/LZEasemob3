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
#import "ChatViewController.h"

#if DEMO_CALL == 1

#import "CallViewController.h"

@interface ChatUIHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>

#else

@interface ChatUIHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

#endif

@property (nonatomic, weak) ContactListViewController *contactViewVC;

@property (nonatomic, weak) ConversationListController *conversationListVC;

@property (nonatomic, weak) UIViewController *mainVC;

@property (nonatomic, weak) ChatViewController *chatVC;

#if DEMO_CALL == 1

@property (strong, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) CallViewController *callController;

#endif

@property (nonatomic, assign)EMConnectionState connectionState;


+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

#if DEMO_CALL == 1

- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;

#endif

- (void)playSoundAndVibration;
@end
