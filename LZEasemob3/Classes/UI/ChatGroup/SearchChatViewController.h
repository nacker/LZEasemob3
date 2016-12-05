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

#ifdef REDPACKET_AVALABLE
#import "RedPacketChatViewController.h"
#endif

#import "ChatViewController.h"

#ifdef REDPACKET_AVALABLE
@interface SearchChatViewController : RedPacketChatViewController
#else
@interface SearchChatViewController : ChatViewController
#endif
- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType
                              fromMessageId:(NSString*)messageId;

@end
