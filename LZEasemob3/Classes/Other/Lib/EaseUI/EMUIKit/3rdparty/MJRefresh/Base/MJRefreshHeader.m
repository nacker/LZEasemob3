//  MJRefreshHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//

#import "MJRefreshHeader.h"

@interface MJRefreshHeader()
@property (assign, nonatomic) CGFloat insetTDelta;
@end

@implementation MJRefreshHeader

#pragma mark - Constructor methods
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - Overwrite parent class methods
- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
    self.mj_h = MJRefreshHeaderHeight;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state == MJRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mj_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
     _scrollViewOriginalInset = self.scrollView.contentInset;
    
    CGFloat offsetY = self.scrollView.mj_offsetY;
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    if (offsetY > happenOffsetY) return;
    
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateIdle) {
        if (oldState != MJRefreshStateRefreshing) return;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            self.scrollView.mj_insetT += self.insetTDelta;
            
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
        }];
    } else if (state == MJRefreshStateRefreshing) {
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
            self.scrollView.mj_insetT = top;
            
            self.scrollView.mj_offsetY = - top;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
}

- (void)endRefreshing
{
    if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super endRefreshing];
        });
    } else {
        [super endRefreshing];
    }
}

- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}
@end
