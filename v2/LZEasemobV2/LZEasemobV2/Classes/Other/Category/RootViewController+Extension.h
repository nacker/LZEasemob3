//
//  RootViewController+Extension.h
//  OC_AlertController
//
//  Created by 魏文咸 on 2018/10/26.
//  Copyright © 2018 魏文咸. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController(Extension)

+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getRootViewController;
@end

NS_ASSUME_NONNULL_END
