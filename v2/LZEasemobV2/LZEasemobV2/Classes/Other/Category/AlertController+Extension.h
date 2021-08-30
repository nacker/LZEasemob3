//
//  AlertController+Extension.h
//  OC_AlertController
//
//  Created by 魏文咸 on 2018/10/26.
//  Copyright © 2018 魏文咸. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlertAction+Extension.h"
#import "RootViewController+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController(Extension)

+(UIAlertController *)showAlertController:(nullable NSString *)title message:(nullable NSString *)msg alertStyle:(UIAlertControllerStyle)style actions:(NSArray *)action;

@end

NS_ASSUME_NONNULL_END
