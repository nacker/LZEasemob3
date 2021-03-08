//
//  UIFont+runtime.m
//  YSWS-iOS
//
//  Created by nacker on 2020/7/3.
//  Copyright © 2020 nacker. All rights reserved.
//

#import "UIFont+Extension.h"
#import <objc/runtime.h>

@implementation UIFont (Extension)

//+ (void)load {
//    // 获取替换后的类方法
//    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
//    // 获取替换前的类方法
//    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
//    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
//    method_exchangeImplementations(newMethod, method);
//}
//
//+ (UIFont *)adjustFont:(CGFloat)fontSize {
//    UIFont *newFont = nil;
//    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/MyUIScreen];
//    return newFont;
//}

@end
