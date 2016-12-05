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

#import "IModelCell.h"

@protocol IModelChatCell <NSObject,IModelCell>

@required

@property (strong, nonatomic) id model;

@optional

- (BOOL)isCustomBubbleView:(id)model;

- (void)setCustomBubbleView:(id)model;

- (void)setCustomModel:(id)model;

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id)mode;

@optional

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;

@end