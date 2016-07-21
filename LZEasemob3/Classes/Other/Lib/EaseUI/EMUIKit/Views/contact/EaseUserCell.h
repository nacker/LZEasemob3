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

#import "IUserModel.h"
#import "IModelCell.h"
#import "EaseImageView.h"

static CGFloat EaseUserCellMinHeight = 50;

@protocol EaseUserCellDelegate;
@interface EaseUserCell : UITableViewCell<IModelCell>

@property (weak, nonatomic) id<EaseUserCellDelegate> delegate;

@property (strong, nonatomic) EaseImageView *avatarView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) id<IUserModel> model;

@property (nonatomic) BOOL showAvatar; //default is "YES"

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (nonatomic) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR;

@end

@protocol EaseUserCellDelegate <NSObject>

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end
