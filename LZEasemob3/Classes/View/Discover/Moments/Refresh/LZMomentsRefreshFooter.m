//
//  LZMomentsRefreshFooter.m
//  LZEasemob
//
//  Created by nacker on 16/4/1.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsRefreshFooter.h"

@interface LZMomentsRefreshFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation LZMomentsRefreshFooter

- (void)prepare
{
    [super prepare];
    
    self.mj_h = 50;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    self.loading.center = CGPointMake(self.mj_w * 0.65, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.label.text = @"上拉加载数据";
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            self.label.text = @"加载数据...";
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
            self.label.text = @"木有数据了";
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


@end
