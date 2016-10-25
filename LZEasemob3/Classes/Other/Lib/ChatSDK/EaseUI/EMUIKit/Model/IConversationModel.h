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

@class EMConversation;
@protocol IConversationModel <NSObject>

@property (strong, nonatomic, readonly) EMConversation *conversation;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
