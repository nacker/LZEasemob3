//
//  LZPictureBrowserCell.h
//  teacher
/**
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */
//  Created by nacker on 15/8/6.
//  Copyright (c) 2015年 Shanghai Minlan Information & Technology Co ., Ltd. All rights reserved.
//

#import "LZBroadcastViewCell.h"

@class LZPicture;

@class LZPictureBrowserCell;
@protocol LZPictureBrowserCellDelegate <NSObject>

- (void)didTapForMLPictureCell:(LZPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

@optional

- (UIView*)customOverlayViewOfMLPictureCell:(LZPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

- (CGRect)customOverlayViewFrameOfMLPictureCell:(LZPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;

@end

@interface LZPictureBrowserCell : LZBroadcastViewCell

@property(nonatomic,strong) LZPicture *picture;
@property(nonatomic,weak) id<LZPictureBrowserCellDelegate> delegate;

@end
