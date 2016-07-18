//
//  LZMomentsHeaderView.h
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZMomentsHeaderView : UIView

@property (nonatomic, copy) void (^iconButtonClick)();

- (void)updateHeight:(CGFloat)height;

@end
