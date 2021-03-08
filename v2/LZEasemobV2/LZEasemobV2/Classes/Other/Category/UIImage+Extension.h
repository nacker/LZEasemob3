//
//  UIImage+Extension.h
//  
//
//  Created by nacker on 15-3-9.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name;

+ (UIImage *)resizedImage:(NSString *)name;

+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/* 裁剪圆形图片 */
+ (UIImage *)clipImage:(UIImage *)image;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

+ (UIImage *)imageWithImageName:(NSString *)imageName;

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

#pragma mark - 压缩图片
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

// 通过URL构建UIImage
+ (UIImage *)imageFromURLString:(NSString *)urlstring;
@end
