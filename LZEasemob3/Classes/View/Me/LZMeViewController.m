//
//  LZMeViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMeViewController.h"

@interface LZMeViewController ()

@end

@implementation LZMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [[EMClient sharedClient] currentUsername];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
}

- (void)logout
{
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        [MBProgressHUD showSuccess:@"退出成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:KGoToLoginViewControllerNotification object:nil];
    }
}
@end
