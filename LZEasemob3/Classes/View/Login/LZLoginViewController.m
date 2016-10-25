//
//  LZLoginViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZLoginViewController.h"
#import "ChatUIHelper.h"

@interface LZLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *usernamefield;
@property (nonatomic, weak) IBOutlet UITextField *passwordfield;

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
    _usernamefield.delegate = self;
    _passwordfield.delegate = self;
    
    NSString *username = [self lastLoginUsername];
    if (username && username.length > 0) {
        _usernamefield.text = username;
    }
    
    self.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
    
    [self.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    _usernamefield.text = @"nacker";
    _passwordfield.text = @"123456";
}

- (void)doLogin
{
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        //支持是否为中文
        if ([self.usernamefield.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        [self loginWithUsername:_usernamefield.text password:_passwordfield.text];
    }
}

//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
#pragma - 暂时关闭了红包功能,需要红包自行导入
    //#ifdef REDPACKET_AVALABLE
    //    //TODO: 服务器二次校验
    //    [[RedPacketUserConfig sharedConfig] configWithImUserId:username andImUserPass:password];
    //#endif
    
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                // 保存用户信息
                [UserCacheManager saveInfo:username imgUrl:@"http://avatar.csdn.net/A/2/1/1_mengmakies.jpg" nickName:username];
                
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //获取数据库中数据
                [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] dataMigrationTo3];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChatUIHelper shareHelper] asyncGroupFromServer];
                        [[ChatUIHelper shareHelper] asyncConversationFromDB];
                        [[ChatUIHelper shareHelper] asyncPushOptions];
                        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                        
                        //保存最近一次登录用户名
                        [weakself saveLastLoginUsername];
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
    [self loginWithUsername:_usernamefield.text password:_passwordfield.text];
}

- (void)registerBtnClick
{
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
        if ([self.usernamefield.text isChinese]) {
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
            EMError *error = [[EMClient sharedClient] registerWithUsername:weakself.usernamefield.text password:weakself.passwordfield.text];
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
    NSString *username = _usernamefield.text;
    NSString *password = _passwordfield.text;
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
    if (textField == _usernamefield) {
        _passwordfield.text = @"";
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernamefield) {
        [_usernamefield resignFirstResponder];
        [_passwordfield becomeFirstResponder];
    } else if (textField == _passwordfield) {
        [_passwordfield resignFirstResponder];
        [self doLogin];
    }
    return YES;
}

#pragma  mark - privat e
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
