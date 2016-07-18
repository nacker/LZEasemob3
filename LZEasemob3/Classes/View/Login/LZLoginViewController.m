//
//  LZLoginViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZLoginViewController.h"

@interface LZLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *usernamefield;
@property (nonatomic, weak) UITextField *passwordfield;

@end

@implementation LZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *usernamefield = [[UITextField alloc]init];
    usernamefield.frame = CGRectMake(20, 150, KScreenW-40, 30);
    usernamefield.placeholder = @"请输入用户名";
    [self.view addSubview:usernamefield];
    [usernamefield.layer setBorderWidth:1];
    [usernamefield.layer setBorderColor:[UIColor grayColor].CGColor];
    [usernamefield.layer setCornerRadius:15];
    usernamefield.clipsToBounds = YES;
    usernamefield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 0)];
    usernamefield.leftViewMode = UITextFieldViewModeAlways;
    self.usernamefield = usernamefield;
    
    UITextField *passwordfield = [[UITextField alloc]init];
    passwordfield.frame = CGRectMake(20, 190, KScreenW-40, 30);
    passwordfield.placeholder = @"请输入密码";
    [self.view addSubview:passwordfield];
    [passwordfield.layer setBorderWidth:1];
    [passwordfield.layer setBorderColor:[UIColor grayColor].CGColor];
    [passwordfield.layer setCornerRadius:15];
    passwordfield.clipsToBounds = YES;
    passwordfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 0)];
    passwordfield.leftViewMode = UITextFieldViewModeAlways;
    passwordfield.secureTextEntry = YES;
    self.passwordfield = passwordfield;
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, 230, KScreenW-20, 30);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *loginbtn = [[UIButton alloc]init];
    loginbtn.frame = CGRectMake(10, 270, KScreenW-20, 30);
    loginbtn.backgroundColor = [UIColor redColor];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginbtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    
    
    usernamefield.text = @"nacker";
    passwordfield.text = @"123456";
}

- (void)loginBtnClick
{
    [self.view endEditing:YES];
    
    [MBProgressHUD showMessage:@"登录中"];
    
    if (self.usernamefield.text.length == 0 || self.passwordfield.text.length == 0) {
        NSLog(@"请输入用户名和密码");
        return;
    }
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:self.usernamefield.text password:self.passwordfield.text];
        if (!error) {
            
            [MBProgressHUD hideHUD];
            
            // 设置自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
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
    NSString *account = self.usernamefield.text;
    NSString *pwd = self.passwordfield.text;
    EMError *error = [[EMClient sharedClient] registerWithUsername:account password:pwd];
    if (error) {
        KLog(@"注册失败%@", error.description);
        [MBProgressHUD showError:@"注册失败"];
    } else {
        [MBProgressHUD showError:@"注册成功"];
        
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
