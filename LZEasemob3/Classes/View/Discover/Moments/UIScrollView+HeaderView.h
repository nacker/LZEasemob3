//
//  UIScrollView+HeaderView.h
//  tableViewCover
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 sunhw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KScreenSize [UIScreen mainScreen].bounds.size
#define HeaderHeight KScreenSize.width * 2/3.f


@class MyHeaderImageView;
@protocol HeaderDelegate <NSObject>
@required
-(void)clickHeaderView:(MyHeaderImageView *)header;
@end

@interface MyHeaderImageView : UIImageView
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) id <HeaderDelegate>delegate;
@end

@interface UIScrollView (HeaderView)
@property (nonatomic, weak) MyHeaderImageView *headerView;
-(void)addScrollViewHeaderWithImage:(UIImage *)image target:(id)target;
@end

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end