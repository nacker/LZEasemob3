//
//  LZNavigationController.m
//  LZEasemobV2
//
//  Created by nacker on 2021/2/26.
//

#import "LZNavigationController.h"

@interface LZNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"nav_ic_back") target:self action:@selector(back)];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


@end
