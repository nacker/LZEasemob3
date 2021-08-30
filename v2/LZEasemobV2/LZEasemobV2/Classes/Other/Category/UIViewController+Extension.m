//
//  UIViewController+Extension.m
//  TTServe
//
//  Created by nacker on 2020/12/16.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>

@implementation UIViewController (Extension)

//+ (void)load{
//    [super load];
//    
//    SEL originalSel = @selector(presentViewController:animated:completion:);
//    SEL overrideSel = @selector(override_presentViewController:animated:completion:);
//    
//    Method originalMet = class_getInstanceMethod(self.class, originalSel);
//    Method overrideMet = class_getInstanceMethod(self.class, overrideSel);
//    
//    method_exchangeImplementations(originalMet, overrideMet);
//}
// 
//#pragma mark - Swizzling
//- (void)override_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
//    if(@available(iOS 13.0, *)){
//        if (viewControllerToPresent.modalPresentationStyle ==  UIModalPresentationPageSheet){
//            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
//        }
//    }
//    
//    [self override_presentViewController:viewControllerToPresent animated:flag completion:completion];
//}
@end
