//
//  MJRefreshAutoStateFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//

#import "MJRefreshAutoStateFooter.h"
#import "EaseLocalDefine.h"

@interface MJRefreshAutoStateFooter()
{
    __unsafe_unretained UILabel *_stateLabel;
}

@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation MJRefreshAutoStateFooter

#pragma mark - Lazy initialization
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

#pragma mark - Public methords
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - Private methods
- (void)stateLabelClick
{
    if (self.state == MJRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - Overwrite parent class methods
- (void)prepare
{
    [super prepare];
    
    [self setTitle:NSEaseLocalizedString(@"ui.clickOrPull", @"Click or pull up to download") forState:MJRefreshStateIdle];
    [self setTitle:NSEaseLocalizedString(@"ui.downloading", @"Downloading...") forState:MJRefreshStateRefreshing];
    [self setTitle:NSEaseLocalizedString(@"ui.downloadComplete", @"Download complete") forState:MJRefreshStateNoMoreData];
    
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == MJRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}
@end