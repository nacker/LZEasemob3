//
//  LZTabBarController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZTabBarController.h"
#import "LZNavigationController.h"
#import "LZConversationViewController.h"
#import "LZContactsViewController.h"
#import "LZMeViewController.h"

@interface LZTabBarController ()

@end

@implementation LZTabBarController

+ (void)initialize
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:[[LZConversationViewController alloc] init] title:@"微信" imageName:@"tabbar_mainframe"];
    [self addChildViewController:[[LZContactsViewController alloc] init] title:@"通讯录" imageName:@"tabbar_contacts"];
    
//[self setupChildVc:[[UIViewController alloc] init] title:@"好友" image:@"tabbar_shop" selectedImage:@"tabbar_shopHL"];
    
    [self addChildViewController:[[LZMeViewController alloc] init] title:@"我" imageName:@"tabbar_me"];
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName {
    
    childController.title = title;
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    NSString *selectedImageName = [NSString stringWithFormat:@"%@HL", imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = selectedImage;
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = KColor(14, 180, 0);
    [childController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

@end
