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

@interface EaseChatToolbarItem : NSObject

/**
 *  按钮
 */
@property (strong, nonatomic, readonly) UIButton *button;

/**
 *  点击按钮之后在toolbar下方延伸出的页面
 */
@property (strong, nonatomic) UIView *button2View;

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)button2View;

@end
