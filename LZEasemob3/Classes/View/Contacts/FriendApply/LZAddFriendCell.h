/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@protocol addFriendCellDelegate <NSObject>

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LZAddFriendCell : UITableViewCell
{
    UILongPressGestureRecognizer *_headerLongPress;
}
@property (strong, nonatomic) UILabel *addLabel;
@property (nonatomic, weak) UILabel *nameLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *bottomLineView;

@property (nonatomic, weak) id<addFriendCellDelegate> delegate;

/** 传递的用户名数据 */
@property (strong, nonatomic) NSString *username;

@end
