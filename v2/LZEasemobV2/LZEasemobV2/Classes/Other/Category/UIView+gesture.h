//
//  UIView+gesture.h
//
//
//  Created by nacker on 15/2/8.
//  Copyright (c) 2015年 nacker. All rights reserved.
//  手势控制

#import <UIKit/UIKit.h>

@interface UIView (gesture)
- (void)setTapActionWithBlock:(void (^)(void))block;

- (void)setLongPressActionWithBlock:(void (^)(void))block;
@end
