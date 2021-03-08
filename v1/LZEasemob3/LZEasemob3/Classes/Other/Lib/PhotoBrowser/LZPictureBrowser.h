//
//  LZPictureBrowser.h
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

#import <UIKit/UIKit.h>

@class LZPictureBrowser;
@class LZPictureBrowserCell;
@class LZBroadcastView;
@protocol LZPictureBrowserDelegate <NSObject>

@optional
- (void)didScrollToIndex:(NSUInteger)index ofMLPictureBrowser:(LZPictureBrowser*)pictureBrowser;
- (void)didDisappearOfMLPictureBrowser:(LZPictureBrowser*)pictureBrowser;

@optional
- (UIView*)customOverlayViewOfMLPictureBrowser:(LZPictureBrowser*)pictureBrowser;
- (CGRect)customOverlayViewFrameOfMLPictureBrowser:(LZPictureBrowser*)pictureBrowser;

@optional
- (UIView*)customOverlayViewOfMLPictureCell:(LZPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;
- (CGRect)customOverlayViewFrameOfMLPictureCell:(LZPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index;
@end

@interface LZPictureBrowser : UIViewController

@property(nonatomic,readonly,getter = mainView) LZBroadcastView *broadcastView;

@property(nonatomic,weak) id<LZPictureBrowserDelegate> delegate;
@property(nonatomic,strong) NSArray *pictures;
@property(nonatomic,assign,readonly) NSUInteger currentIndex;

- (void)showWithPictureURLs:(NSArray*)pictureURLs atIndex:(NSUInteger)index;

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated;
@end
