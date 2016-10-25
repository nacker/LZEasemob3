//
//  LZMomentsViewModel.m
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsViewModel.h"

extern CGFloat maxContentLabelHeight;

@implementation LZMomentsViewModel
{
    CGFloat _lastContentWidth;
}

+ (instancetype)viewModelWithStatus:(LZMoments *)status {
    LZMomentsViewModel *obj = [[self alloc] init];
    
    obj.status = status;
    
    return obj;
}

- (NSString *)description {
    return self.status.description;
}

- (NSString *)name
{
    return self.status.name;
}

- (NSString *)iconName
{
    return self.status.iconName;
}

- (NSString *)time
{
    return self.status.time;
}

- (NSString *)msgContent
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGSize textSize = [self.status.msgContent sizeWithFont:[UIFont systemFontOfSize:15] maxW:contentW];
        if (textSize.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }

    return self.status.msgContent;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}
@end
