//
//  AppDelegate.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#define EMSDKAppKey @"nacker#lzeasemob"
#define EMSDKApnsCertName @"lzeasemob"

#import "AppDelegate.h"
#import "LZTabBarController.h"
#import "LZLoginViewController.h"
#import "EMAlertView.h"

@interface AppDelegate ()<EMClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    [self setupEMSDK];
    [self chooseRootViewControllerWithVersion];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)chooseRootViewControllerWithVersion
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:KSwitchRootViewControllerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLoginViewController:) name:KGoToLoginViewControllerNotification object:nil];
    
    [self switchRootViewController:nil];
}

- (void)switchRootViewController:(NSNotification *)note
{
    NSString *userName = [[EMClient sharedClient] currentUsername];
    if (userName.length) {
        LZTabBarController *tabBarVC = [[LZTabBarController alloc] init];
        self.window.rootViewController = tabBarVC;
    }else {
        [self goToLoginViewController:note];
    }
}

- (void)goToLoginViewController:(NSNotification *)note
{
    LZLoginViewController *loginVC = [[LZLoginViewController alloc] init];
    self.window.rootViewController = loginVC;
}

#pragma mark - setupEMSDK
- (void)setupEMSDK
{
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:EMSDKAppKey];
    options.enableConsoleLog = NO;
    options.apnsCertName = EMSDKApnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - <EMClientDelegate>
/* !自动登录返回结果 @param aError 错误信息*/
- (void)didAutoLoginWithError:(EMError *)aError {
    KLog(@"#####%d, %@", aError.code, aError.errorDescription);
    if (!aError) {//自动登录没有错误

    } else {
        KLog(@"%@",aError);
    }
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState
{
    
}

/* 当前登录账号在其它设备登录时会接收到该回调 */
- (void)didLoginFromOtherDevice
{
    [self didGoToLoginVC];
}

/* 当前登录账号已经被从服务器端删除时会收到该回调 */
- (void)didRemovedFromServer
{
    [self didGoToLoginVC];
}

- (void)didGoToLoginVC
{
    [[EMClient sharedClient] logout:NO];
    LZLoginViewController * loginVC = [[LZLoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    
    [EMAlertView showAlertWithTitle:@"警告" message:@"您被T下线了" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
        
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
}
@end
