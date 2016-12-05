/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import <UIKit/UIKit.h>

@interface EMRemarkImageView : UIView
{
    UILabel *_remarkLabel;
    UIImageView *_imageView;
    
    NSInteger _index;
    BOOL _editing;
}

@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL editing;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) UIImage *image;

@end
