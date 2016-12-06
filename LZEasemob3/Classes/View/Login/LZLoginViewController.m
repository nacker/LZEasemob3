//
//  LZLoginViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZLoginViewController.h"
#import "EMError.h"
#import "ChatDemoHelper.h"

@interface LZLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, weak) IBOutlet UIButton *registerBtn;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;


@end

@implementation LZLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupForDismissKeyboard];
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    NSString *username = [LZDataBaseTool lastLoginUsername];
    if (username && username.length > 0) {
        _usernameTextField.text = username;
    }
    
    self.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
    
    [self.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    _usernameTextField.text = @"h18";
    _passwordTextField.text = @"123456";
}

//登陆账号
- (void)doLogin
{
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        //支持是否为中文
        if ([self.usernameTextField.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        /*
         #if !TARGET_IPHONE_SIMULATOR
         //弹出提示
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"login.inputApnsNickname", @"Please enter nickname for apns") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
         [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
         UITextField *nameTextField = [alert textFieldAtIndex:0];
         nameTextField.text = self.usernameTextField.text;
         [alert show];
         #elif TARGET_IPHONE_SIMULATOR
         [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
         #endif
         */
        [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
    }
}

//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //获取数据库中数据
                [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
                        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
                        [[ChatDemoHelper shareHelper] asyncPushOptions];
                        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                        
                        //保存最近一次登录用户名
                        [LZDataBaseTool saveLastLoginUsername];
                    });
                });
            } else {
                switch (error.code)
                {
//                    case EMErrorNotFound:
//                        TTAlertNoTitle(error.errorDescription);
//                        break;
                    case EMErrorNetworkUnavailable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAuthenticationFailed:
                        TTAlertNoTitle(error.errorDescription);
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    case EMErrorServerServingForbidden:
                        TTAlertNoTitle(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                        break;
                    default:
                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                        break;
                }
            }
        });
    });
}

//弹出提示的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        //获取文本输入框
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0)
        {
            //设置推送设置
            [[EMClient sharedClient] setApnsNickname:nameTextField.text];
        }
    }
    //登陆
    [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
}

//注册账号
//Registered account
- (void)registerBtnClick
{
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
        if ([self.usernameTextField.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        [self showHudInView:self.view hint:NSLocalizedString(@"register.ongoing", @"Is to register...")];
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] registerWithUsername:weakself.usernameTextField.text password:weakself.passwordTextField.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself hideHud];
                if (!error) {
                    TTAlertNoTitle(NSLocalizedString(@"register.success", @"Registered successfully, please log in"));
                }else{
                    switch (error.code) {
                        case EMErrorServerNotReachable:
                            TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                            break;
                        case EMErrorUserAlreadyExist:
                            TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
                            break;
                        case EMErrorNetworkUnavailable:
                            TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                            break;
                        case EMErrorServerTimeout:
                            TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                            break;
                        case EMErrorServerServingForbidden:
                            TTAlertNoTitle(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                            break;
                        default:
                            TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                            break;
                    }
                }
            });
        });
    }
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"login.inputNameAndPswd", @"Please enter username and password")
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
    }
    
    return ret;
}


#pragma  mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _usernameTextField) {
        _passwordTextField.text = @"";
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernameTextField) {
        [_usernameTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
        [self doLogin];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
