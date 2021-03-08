//
//  UIButton+Extension.h
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    UIButtonEdgeInsetsStyleTop,
    UIButtonEdgeInsetsStyleLeft,
    UIButtonEdgeInsetsStyleBottom,
    UIButtonEdgeInsetsStyleRight,
}UIButtonEdgeInsetsStyle;

typedef NS_ENUM(NSInteger, KButtonTitlePostionType) {
    KButtonTitlePostionTypeBottom = 0,
};

@interface UIButton (Extension)

/// 使用图像名创建图像
///
/// @param title 按钮名称(可选)
/// @param imageName 图像名(可选)
/// @param target 监听对象
/// @param action 监听方法(可选)
///
/// @return UIButton
+ (instancetype)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target action:(SEL)action;

/// 创建按钮
///
/// @param title         标题
/// @param color         字体颜色
/// @param fontSize      字号
/// @param imageName     图像
/// @param backImageName 背景图像
///
/// @return UIButton
+ (instancetype)buttonWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize imageName:(NSString *)imageName backImageName:(NSString *)backImageName;

/// 创建按钮
///
/// @param title         标题
/// @param titleColor    标题颜色
/// @param backImageName 背景图像名称
///
/// @return UIButton
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backImageName:(NSString *)backImageName;

- (void)setTitlePositionWithType:(KButtonTitlePostionType)type;

/** button的name */
@property (nonatomic,copy) NSString *name;


/**
 *style：内容的位置，
 *space：图片和文字之间的距离
 *offset：内容距离边界的偏移
 */
- (void)layoutButtonWithEdgeInsetsStyle:(UIButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space offset:(CGFloat)offset;

@end
