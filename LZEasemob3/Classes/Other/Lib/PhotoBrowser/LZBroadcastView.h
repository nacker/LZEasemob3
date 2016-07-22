//
//  LZBroadcastView.h
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
#import "LZBroadcastViewCell.h"

@class LZBroadcastView;

@protocol LZBroadcastViewDataSource <NSObject>

@required

- (NSUInteger)cellCountOfBroadcastView:(LZBroadcastView *)broadcastView;
- (LZBroadcastViewCell *)broadcastView:(LZBroadcastView *)broadcastView cellAtPageIndex:(NSUInteger)pageIndex;

@end

@protocol LZBroadcastViewDelegate <NSObject>

@optional
- (void)didScrollToPageIndex:(NSUInteger)pageIndex ofBroadcastView:(LZBroadcastView *)broadcastView;
- (void)preOperateInBackgroundAtPageIndex:(NSUInteger)pageIndex ofBroadcastView:(LZBroadcastView *)broadcastView;
@end

@interface LZBroadcastView : UIView
@property (nonatomic,assign) NSUInteger padding;

@property (nonatomic,weak) id<LZBroadcastViewDataSource> dataSource;
@property (nonatomic,weak) id<LZBroadcastViewDelegate> delegate;
@property(nonatomic,assign) BOOL isAutoRoll;
@property (nonatomic,assign,readonly) NSUInteger currentPageIndex;

- (void)reloadData;
- (void)scrollToPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

- (id)dequeueReusableCellWithIdentifier:(NSString*)identifier;

@end
