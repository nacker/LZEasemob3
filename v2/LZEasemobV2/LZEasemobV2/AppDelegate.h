//
//  AppDelegate.h
//  LZEasemobV2
//
//  Created by nacker on 2021/2/26.
//

#import <UIKit/UIKit.h>

//apns (sdkBusiId 为证书上传控制台后生成，详情请参考文档[离线推送]（https://cloud.tencent.com/document/product/269/44517）)
#ifdef DEBUG
#define sdkBusiId 15108
#else
#define sdkBusiId 16205
#endif

//bugly
#define BUGLY_APP_ID      @"e965e5d928"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (id)sharedInstance;

@property (nonatomic, strong) NSData *deviceToken;
- (UIViewController *)getLoginController;
- (UITabBarController *)getMainController;
- (void)login:(NSString *)identifier userSig:(NSString *)sig succ:(TSucc)succ fail:(TFail)fail;


@end

