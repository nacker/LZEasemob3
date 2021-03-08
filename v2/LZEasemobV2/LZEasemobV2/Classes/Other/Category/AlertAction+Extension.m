//
//  AlertAction+Extension.m
//  OC_AlertController
//
//  Created by 魏文咸 on 2018/10/26.
//  Copyright © 2018 魏文咸. All rights reserved.
//

#import "AlertAction+Extension.h"

@implementation UIAlertAction(Extension)

+(UIAlertAction *)alertAction:(NSString *)title actionStyle:(UIAlertActionStyle)style headler:(void (^)(UIAlertAction *action))handler{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [action setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
//    [action1 setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
//    [action2 setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
//    [cancleAction setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
    return action;
}

@end
