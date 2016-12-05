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

@interface EMAlertView : UIAlertView

/**
 *  弹出提示框
 *
 *  @param title             <#title description#>
 *  @param message           <#message description#>
 *  @param block             <#block description#>
 *  @param cancelButtonTitle <#cancelButtonTitle description#>
 *  @param otherButtonTitles <#otherButtonTitles description#>
 *
 *  @return <#return value description#>
 */
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
               completionBlock:(void (^)(NSUInteger buttonIndex, EMAlertView *alertView))block
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
