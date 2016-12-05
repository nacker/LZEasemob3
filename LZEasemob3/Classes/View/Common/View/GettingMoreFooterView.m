//
//  GettingMoreFooterView.m
//  ChatDemo-UI3.0
//
//  Created by jiangwei on 2016/10/31.
//  Copyright © 2016年 jiangwei. All rights reserved.
//

#import "GettingMoreFooterView.h"

@implementation GettingMoreFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.hidesWhenStopped = YES;
        _activity.hidden = YES;
        [self addSubview:_activity];
        
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = NSLocalizedString(@"noMore", @"No more data");
        _label.hidden = YES;
        [self addSubview:_label];
        
        _state = eGettingMoreFooterViewStateInitial;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _label.frame = self.bounds;
    
    CGSize size = self.frame.size;
    _activity.center = CGPointMake(size.width / 2, size.height / 2);
}

- (void)setState:(GettingMoreFooterViewState)state
{
    _state = state;
    switch (_state) {
        case eGettingMoreFooterViewStateInitial:
            _activity.hidden = YES;
            _label.hidden = YES;
            break;
        case eGettingMoreFooterViewStateIdle:
            _activity.hidden = YES;
            _label.hidden = YES;
            break;
        case eGettingMoreFooterViewStateGetting:
            _activity.hidden = NO;
            [_activity startAnimating];
            _label.hidden = YES;
            break;
        case eGettingMoreFooterViewStateComplete:
            _activity.hidden = YES;
            _label.hidden = NO;
            _label.text = NSLocalizedString(@"noMore", @"No more data");
            break;
        case eGettingMoreFooterViewStateFailed:
            _activity.hidden = YES;
            _label.hidden = NO;
            _label.text = NSLocalizedString(@"loadDataFailed", @"Load more failed");
            break;
        default:
            break;
    }
}

@end
