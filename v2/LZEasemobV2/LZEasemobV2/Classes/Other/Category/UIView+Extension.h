//
//  UIView+Extension.h
//  MJRefreshExample
//
//  Created by nacker on 15-3-9.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**  起点x坐标  */
@property (nonatomic, assign) CGFloat x;
/**  起点y坐标  */
@property (nonatomic, assign) CGFloat y;
/**  中心点x坐标  */
@property (nonatomic, assign) CGFloat centerX;
/**  中心点y坐标  */
@property (nonatomic, assign) CGFloat centerY;
/**  宽度  */
@property (nonatomic, assign) CGFloat width;
/**  高度  */
@property (nonatomic, assign) CGFloat height;
/**  顶部  */
@property (nonatomic, assign) CGFloat top;
/**  底部  */
@property (nonatomic, assign) CGFloat bottom;
/**  左边  */
@property (nonatomic, assign) CGFloat left;
/**  右边  */
@property (nonatomic, assign) CGFloat right;
/**  size  */
@property (nonatomic, assign) CGSize size;
/**  origin */
@property (nonatomic, assign) CGPoint origin;


/** 获取最大x */
- (CGFloat)maxX;
/** 获取最小x */
- (CGFloat)minX;
/** 获取最大y */
- (CGFloat)maxY;
/** 获取最小y */
- (CGFloat)minY;
@property (nonatomic, weak, readonly) UIViewController *topViewController;


/**
 创建纯色图片
 
 @param color color
 @return uiimage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 创建图片
 
 @param color 颜色
 @return 图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;


/**  设置圆角  */
- (void)rounded:(CGFloat)cornerRadius;

/**  设置圆角和边框  */
- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**  设置边框  */
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**   给哪几个角设置圆角  */
-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

/**  设置阴影  */
-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

+ (CGFloat)getLabelHeightByWidth:(CGFloat)width Title:(NSString *)title font:(UIFont *)font;
@end
