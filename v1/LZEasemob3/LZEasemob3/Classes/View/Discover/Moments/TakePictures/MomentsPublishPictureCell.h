//
//  MomentsPublishPictureCell.h
//  Moments
//
//  Created by Thomson on 16/2/18.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZMomentsSendViewModel;
@protocol MomentsPublishPictureCellDelegate;

@interface MomentsPublishPictureCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<MomentsPublishPictureCellDelegate> delegate;
@property (nonatomic, strong) LZMomentsSendViewModel *viewModel;

+ (CGFloat)estimatedHeightWithViewModel:(LZMomentsSendViewModel *)viewModel;

@end

@protocol MomentsPublishPictureCellDelegate <NSObject>

- (void)didSelectAddItem;

@end