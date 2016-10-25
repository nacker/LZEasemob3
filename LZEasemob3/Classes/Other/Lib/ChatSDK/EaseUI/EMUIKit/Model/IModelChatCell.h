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

/*!
 @method
 @brief 判断是否为自定义Cell
 @discussion
 @param model 消息
 @result
 */
- (BOOL)isCustomBubbleView:(id)model;

/*!
 @method
 @brief 设置自定义Cell气泡
 @discussion
 @param model 消息
 @result
 */
- (void)setCustomBubbleView:(id)model;

/*!
 @method
 @brief 设置自定义Cell
 @discussion
 @param model 消息
 @result
 */
- (void)setCustomModel:(id)model;

/*!
 @method
 @brief 修改自定义气泡位置
 @discussion
 @param bubbleMargin
 @param model 消息
 @result
 */
- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id)mode;

@optional

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;

@end