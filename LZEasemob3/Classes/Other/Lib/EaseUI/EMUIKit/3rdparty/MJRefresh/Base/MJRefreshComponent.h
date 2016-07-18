//  MJRefreshComponent.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.

#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"

typedef NS_ENUM(NSInteger, MJRefreshState) {
    MJRefreshStateIdle = 1,
    MJRefreshStatePulling,
    MJRefreshStateRefreshing,
    MJRefreshStateWillRefresh,
    MJRefreshStateNoMoreData
};

typedef void (^MJRefreshComponentRefreshingBlock)();

@interface MJRefreshComponent : UIView
{
    UIEdgeInsets _scrollViewOriginalInset;
    __weak UIScrollView *_scrollView;
}
#pragma mark - Call backs

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;

@property (copy, nonatomic) MJRefreshComponentRefreshingBlock refreshingBlock;
@property (weak, nonatomic) id refreshingTarget;
@property (assign, nonatomic) SEL refreshingAction;
- (void)executeRefreshingCallback;

#pragma mark - State management

- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

@property (assign, nonatomic) MJRefreshState state;
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark - Overwritten by subclass

- (void)prepare NS_REQUIRES_SUPER;
- (void)placeSubviews NS_REQUIRES_SUPER;
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;


#pragma mark - Extra
@property (assign, nonatomic) CGFloat pullingPercent;
@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha MJRefreshDeprecated("Please use automaticallyChangeAlpha property");
@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end

@interface UILabel(MJRefresh)
+ (instancetype)label;
@end
