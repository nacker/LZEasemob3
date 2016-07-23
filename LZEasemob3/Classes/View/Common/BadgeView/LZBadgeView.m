//
//  LZBadgeView.m
//  HXClient
//
//  Created by nacker on 16/6/3.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZBadgeView.h"

@implementation LZBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage resizedImage:@"tabbar_badge"] forState:UIControlStateNormal];
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return self;
}

-(void)setBadgeValue:(NSString *)badgeValue{
    
    _badgeValue = badgeValue.copy;
    if (![badgeValue isEqualToString:@"0"]) {
        self.hidden = NO;
        
        if ([badgeValue intValue] > 99) {
            badgeValue = @"N";
        }
        
        [self setTitle:badgeValue forState:UIControlStateNormal];
        CGFloat bandgeButtonH = self.currentBackgroundImage.size.height;
        CGFloat bandgeButtonW = self.currentBackgroundImage.size.width;
        if (badgeValue.length > 1) {
            CGSize badgeSize = [badgeValue sizeWithFont:self.titleLabel.font];
            bandgeButtonW = badgeSize.width + 10;
        }
        CGRect bandgeFrame = self.frame;
        bandgeFrame.size.width = bandgeButtonW;
        bandgeFrame.size.height = bandgeButtonH;
        self.frame = bandgeFrame;
    }else{
        self.hidden = YES;
    }
}


@end
