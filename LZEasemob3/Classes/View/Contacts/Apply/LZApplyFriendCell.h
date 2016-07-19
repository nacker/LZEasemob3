//
//  LZApplyFriendCell.h
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZApplyUserModel;

@protocol LZApplyFriendCellDelegate;

@interface LZApplyFriendCell : UITableViewCell

@property (nonatomic) id<LZApplyFriendCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (nonatomic, strong) LZApplyUserModel *status;

@end


@protocol LZApplyFriendCellDelegate <NSObject>

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath;
- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath;

@end