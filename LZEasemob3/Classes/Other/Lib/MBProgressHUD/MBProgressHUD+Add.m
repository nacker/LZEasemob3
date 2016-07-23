//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

static MBProgressHUD *_hud;

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[[UIApplication sharedApplication] delegate] window];
    // 快速显示一个提示信息
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.labelText = text;
    // 设置图片
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    
    // 隐藏时候从父控件中移除
    _hud.removeFromSuperViewOnHide = YES;
    
    // 0.7秒之后再消失
    [_hud hide:YES afterDelay:2.0];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[[UIApplication sharedApplication] delegate] window];
    // 快速显示一个提示信息
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.labelText = message;
    // 隐藏时候从父控件中移除
    _hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    _hud.dimBackground = YES;
    return _hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[[UIApplication sharedApplication] delegate] window];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [_hud hide:YES];
}
@end
