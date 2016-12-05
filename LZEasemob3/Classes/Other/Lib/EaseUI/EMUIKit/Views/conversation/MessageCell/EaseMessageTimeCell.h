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

@interface EaseMessageTimeCell : UITableViewCell

@property (strong, nonatomic) NSString *title;

@property (nonatomic) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12]

@property (nonatomic) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor]

+ (NSString *)cellIdentifier;

@end
