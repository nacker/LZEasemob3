//
//  UILabel+Extension.h
//  HXClient
//
//  Created by nacker on 16/1/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (UILabel *)labelWithText:(NSString *)text sizeFont:(UIFont *)sizeFont textColor:(UIColor *)textColor;

+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;

//+ (CGFloat)heightForExpressionText:(NSAttributedString *)expressionText width:(CGFloat)width;
@end
