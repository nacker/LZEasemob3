//
//  LZMeViewController.m
//  LZEasemobV2
//
//  Created by nacker on 2021/3/8.
//

#import "LZMeViewController.h"

@interface LZMeViewController ()

@end

@implementation LZMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
}

#pragma mark - 退出
- (void)logout
{
    
}

@end
