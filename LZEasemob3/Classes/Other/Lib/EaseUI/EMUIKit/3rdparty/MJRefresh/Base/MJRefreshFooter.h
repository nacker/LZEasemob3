//  MJRefreshFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/5.

#import "MJRefreshComponent.h"

@interface MJRefreshFooter : MJRefreshComponent

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData MJRefreshDeprecated("Please use endRefreshingWithNoMoreData");
- (void)resetNoMoreData;

@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;

@end
