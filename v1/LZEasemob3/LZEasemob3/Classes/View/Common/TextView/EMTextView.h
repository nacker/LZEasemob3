//
//  LZTextView.h
//  黑马微博
//
//  Created by nacker on 15/1/4.
//  Copyright (c) 2015年 nacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMTextView : UITextView

{
    UIColor *_contentColor;
    BOOL _editing;
}

@property(strong, nonatomic) NSString *placeholder;
@property(strong, nonatomic) UIColor *placeholderColor;

@end
