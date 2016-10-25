//
//  LZMomentsCell.h
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZMomentsOriginalView.h"

@class LZMomentsViewModel,LZMomentsCell;

@protocol LZMomentsCellDelegate <NSObject>

- (void)didClickLickButtonInCell:(LZMomentsCell *)cell;
- (void)didClickcCommentButtonInCell:(LZMomentsCell *)cell;

@end

@interface LZMomentsCell : UITableViewCell

@property (nonatomic, weak) id<LZMomentsCellDelegate> delegate;

// 原创
@property (nonatomic, strong) LZMomentsOriginalView *originalView;

@property (nonatomic, strong) LZMomentsViewModel *viewModel;

@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, copy) void (^operationButtonClick)(NSIndexPath *indexPath);

@end
