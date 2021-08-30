//
//  AlertController+Extension.m
//  OC_AlertController
//
//  Created by 魏文咸 on 2018/10/26.
//  Copyright © 2018 魏文咸. All rights reserved.
//

#import "AlertController+Extension.h"

@implementation UIAlertController(Extension)

+(UIAlertController *)showAlertController:(NSString *)title message:(NSString *)msg alertStyle:(UIAlertControllerStyle)style actions:(NSArray *)actions{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    
    for (UIAlertAction *action in actions){
        [alertController addAction:action];
    }
    
    UIViewController *VC = [UIViewController getCurrentVC];
    [VC presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif
@end
