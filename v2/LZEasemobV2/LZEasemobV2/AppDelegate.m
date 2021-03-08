//
//  AppDelegate.m
//  LZEasemobV2
//
//  Created by nacker on 2021/2/26.
//

#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"

#define FIRSTLAUNCH @"firstLaunch"

#import "LZTabBarController.h"
#import "LZNavigationController.h"
#import "LZLoginViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    [self goToTabBarController];
//    [self goToLoginViewController];
    
    return YES;
}

- (void)goToLoginViewController
{
    LZLoginViewController *vc = [LZLoginViewController new];
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

- (void)goToTabBarController
{
    LZTabBarController *tabBarController =
    [[LZTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
}


@end
