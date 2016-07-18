//
//  AppDelegate.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "AppDelegate.h"
#import "LZTabBarController.h"
#import "LZLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    LZTabBarController *tabBarVC = [[LZTabBarController alloc] init];
    self.window.rootViewController = tabBarVC;
    
//    [self chooseRootViewControllerWithVersion];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//- (void)chooseRootViewControllerWithVersion
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:KSwitchRootViewControllerNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLoginViewController:) name:KGoToLoginViewControllerNotification object:nil];
//    
//    [self switchRootViewController:nil];
//}
//
//- (void)switchRootViewController:(NSNotification *)note
//{
//    NSString *userName = [[EMClient sharedClient] currentUsername];
//    if (userName.length) {
//        LZTabBarController *tabBarVC = [[LZTabBarController alloc] init];
//        self.window.rootViewController = tabBarVC;
//    }else {
//        //        LZLoginViewController *loginVC = [[LZLoginViewController alloc] init];
//        //        self.window.rootViewController = loginVC;
//        
//        [self goToLoginViewController:note];
//    }
//    
//    //    User *user = [LZUserTool getUser];
//    //    KLog(@"%@",user.token);
//    //    if (user.token.length) {
//    //        LZTabBarController *tabBarVC = [[LZTabBarController alloc] init];
//    //        self.window.rootViewController = tabBarVC;
//    //    }else{
//    //        LZLoginViewController *loginVC = [[LZLoginViewController alloc] init];
//    //        LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:loginVC];
//    //        self.window.rootViewController = nav;
//    //    }
//}

- (void)goToLoginViewController:(NSNotification *)note
{
    LZLoginViewController *loginVC = [[LZLoginViewController alloc] init];
    self.window.rootViewController = loginVC;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
