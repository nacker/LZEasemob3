//
//  UIAlertView+Extension.h
//  LZEasemob3
//
//  Created by nacker on 16/7/23.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DismissBlock)(int buttonIndex);
typedef void (^CancelBlock)(void);

@interface UIAlertView (Extension) <UIAlertViewDelegate>

+ (UIAlertView *)showAlertViewWithTitle:(NSString*) title
                                message:(NSString*) message
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(DismissBlock) dismissed
                               onCancel:(CancelBlock) cancelled;
@end
