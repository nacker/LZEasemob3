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

typedef NS_ENUM(NSUInteger, DXTextViewInputViewType) {
    DXTextViewNormalInputType = 0,
    DXTextViewTextInputType,
    DXTextViewFaceInputType,
    DXTextViewShareMenuInputType,
};

@interface EaseTextView : UITextView

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) UIColor *placeHolderTextColor;

- (NSUInteger)numberOfLinesOfText;

+ (NSUInteger)maxCharactersPerLine;

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@end
