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

#import "EMSearchBar.h"

@implementation EMSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subView removeFromSuperview];
            }
            
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)subView;
                [textField setBorderStyle:UITextBorderStyleNone];
                textField.background = nil;
                textField.frame = CGRectMake(8, 8, self.bounds.size.width - 2* 8,
                                             self.bounds.size.height - 2* 8);
                textField.layer.cornerRadius = 6;
                
                textField.clipsToBounds = YES;
                textField.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    return self;
}

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
- (void)setCancelButtonTitle:(NSString *)title
{
    for (UIView *searchbuttons in self.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            [cancelButton setTitle:title forState:UIControlStateNormal];
            break;
        }
    }
}

@end
