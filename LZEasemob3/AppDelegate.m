//
//  AppDelegate.m
//  LZEasemob3
/**
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"
#import "RedPacketUserConfig.h"
#import "AlipaySDK.h"
#import "RedpacketOpenConst.h"
#import <UserNotifications/UserNotifications.h>

#import "LZLoginViewController.h"
#import "LZTabBarController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

#define EaseMobAppKey @"nacker#lzeasemob"
#define EMSDKApnsCertName @"lzeasemob"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
#ifdef REDPACKET_AVALABLE
    /**
     *  TODO: 通过环信的AppKey注册红包
     */
    [[RedPacketUserConfig sharedConfig] configWithAppKey:EaseMobAppKey];
#endif
    
    _connectionState = EMConnectionConnected;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:EaseMobAppKey
                apnsCertName:EMSDKApnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (_mainController) {
        [_mainController didReceiveUserNotification:response.notification];
    }
    completionHandler();
}

#ifdef REDPACKET_AVALABLE

#pragma mark - Alipay

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketAlipayNotifaction object:nil];
}

// NOTE: iOS9.0之前使用的API接口
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketAlipayNotifaction object:resultDic];
        }];
    }
    return YES;
}

// NOTE: iOS9.0之后使用新的API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RedpacketAlipayNotifaction object:resultDic];
        }];
    }
    return YES;
}

#endif
@end
