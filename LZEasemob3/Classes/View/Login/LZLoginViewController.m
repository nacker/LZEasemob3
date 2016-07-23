//
//  LZLoginViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZLoginViewController.h"

@interface LZLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *usernamefield;
@property (nonatomic, weak) IBOutlet UITextField *passwordfield;

@property (nonatomic, weak) IBOutlet UIButton *registerBtn;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;


@end

@implementation LZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _usernamefield.text = @"nacker";
    _passwordfield.text = @"123456";
}

- (void)loginBtnClick
{
    [self.view endEditing:YES];
    
    if (self.usernamefield.text.length == 0 || self.passwordfield.text.length == 0) {
        [MBProgressHUD showError:@"请输入用户名和密码"];
        return;
    }
    
    [MBProgressHUD showMessage:@"登录中"];
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:self.usernamefield.text password:self.passwordfield.text];
        if (!error) {
            
            [MBProgressHUD hideHUD];
            
            // 设置自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            [LZDataBaseTool saveToUserDefaults:self.usernamefield.text key:@"userId"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KSwitchRootViewControllerNotification object:nil];
            KLog(@"---登录成功");
            
        } else {
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showError:@"登录失败"];
            KLog(@"---登录失败%u",error.code);
            
        }
    }
}

- (void)registerBtnClick
{
    if (!self.usernamefield.text.length) {
        [MBProgressHUD showError:@"请输入用户名"];
        return ;
    }else if (!self.passwordfield.text.length) {
        [MBProgressHUD showError:@"请输入密码"];
        return ;
    }
    
    NSString *account = self.usernamefield.text;
    NSString *pwd = self.passwordfield.text;
    EMError *error = [[EMClient sharedClient] registerWithUsername:account password:pwd];
    if (error) {
        KLog(@"注册失败%@", error.description);
        [MBProgressHUD showError:@"注册失败"];
    } else {
        [MBProgressHUD showSuccess:@"注册成功"];
        
        KLog(@"注册成功%@", error.description);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    NSLog(@"%s", __func__);
    if (textField == self.usernamefield) {
        [textField resignFirstResponder];
        [self.passwordfield becomeFirstResponder];
    } else{
        [self loginBtnClick];
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
