//
//  LZTextView.h
//  黑马微博
//
//  Created by nacker on 15/1/4.
//  Copyright (c) 2015年 nacker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZTextView : UITextView

@property (nonatomic, copy) NSString *placehoder;
@property (nonatomic, strong) UIColor *placehoderColor;

@property (nonatomic, weak) UILabel *placehoderLabel;

@end
