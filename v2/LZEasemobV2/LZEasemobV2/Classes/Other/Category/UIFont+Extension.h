//
//  UIFont+runtime.h
//  YSWS-iOS
//
//  Created by nacker on 2020/7/3.
//  Copyright © 2020 nacker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//class_getInstanceMethod得到类的实例方法
//class_getClassMethod得到类的类方法
//
//1. 首先需要创建一个UIFont的分类
//2. 自己UI设计原型图的手机尺寸宽度
#define MyUIScreen  375 // UI设计原型图的手机尺寸宽度(6), 6p的--414

@interface UIFont(Extension)

@end

NS_ASSUME_NONNULL_END
