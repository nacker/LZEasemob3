//
//  MJRefreshBackGifFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "MJRefreshBackGifFooter.h"

@interface MJRefreshBackGifFooter()

@property (weak, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation MJRefreshBackGifFooter

#pragma mark - Lazy initialization
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - Public methods
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - Overwrite parent class methods
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    [self.gifView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        self.gifView.hidden = NO;
        [self.gifView stopAnimating];
        if (images.count == 1) {
            self.gifView.image = [images lastObject];
        } else {
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        self.gifView.hidden = NO;
    } else if (state == MJRefreshStateNoMoreData) {
        self.gifView.hidden = YES;
    }
}
@end
