/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "PushNotificationViewController.h"

@interface PushNotificationViewController ()
{
    EMPushDisplayStyle _pushDisplayStyle;
    EMPushNoDisturbStatus _noDisturbingStatus;
    NSInteger _noDisturbingStart;
    NSInteger _noDisturbingEnd;
    NSString *_nickName;
}

@property (strong, nonatomic) UISwitch *pushDisplaySwitch;

@end

@implementation PushNotificationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _noDisturbingStart = -1;
        _noDisturbingEnd = -1;
        _noDisturbingStatus = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"title.apnsSetting", @"Apns Settings");
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [saveButton setTitle:NSLocalizedString(@"save", @"Save") forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(savePushOptions) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadPushOptions];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UISwitch *)pushDisplaySwitch
{
    if (_pushDisplaySwitch == nil) {
        _pushDisplaySwitch = [[UISwitch alloc] init];
        [_pushDisplaySwitch addTarget:self action:@selector(pushDisplayChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pushDisplaySwitch;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return NSLocalizedString(@"setting.notDisturb", @"Do Not Disturb");
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"setting.showDetail", @"notify the display messages");
            
            self.pushDisplaySwitch.frame = CGRectMake(self.tableView.frame.size.width - self.pushDisplaySwitch.frame.size.width - 10, (cell.contentView.frame.size.height - self.pushDisplaySwitch.frame.size.height) / 2, self.pushDisplaySwitch.frame.size.width, self.pushDisplaySwitch.frame.size.height);
            [cell.contentView addSubview:self.pushDisplaySwitch];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"setting.open", @"On");
            cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusDay ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"setting.nightOpen", @"On only from 10pm to 7am.");
            cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusCustom ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"setting.close", @"Off");
            cell.accessoryType = _noDisturbingStatus == EMPushNoDisturbStatusClose ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 30;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL needReload = YES;
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                needReload = NO;
                [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                        message:NSLocalizedString(@"setting.sureNotDisturb", @"this setting will cause all day in the don't disturb mode, will no longer receive push messages. Whether or not to continue?")
                                completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                                    switch (buttonIndex) {
                                        case 0: {
                                        } break;
                                        default: {
                                            self->_noDisturbingStart = 0;
                                            self->_noDisturbingEnd = 24;
                                            self->_noDisturbingStatus = EMPushNoDisturbStatusDay;
                                            [tableView reloadData];
                                        } break;
                                    }
                                    
                                } cancelButtonTitle:NSLocalizedString(@"no", @"NO")
                              otherButtonTitles:NSLocalizedString(@"yes", @"YES"), nil];
                
            } break;
            case 1:
            {
                _noDisturbingStart = 22;
                _noDisturbingEnd = 7;
                _noDisturbingStatus = EMPushNoDisturbStatusCustom;
            }
                break;
            case 2:
            {
                _noDisturbingStart = -1;
                _noDisturbingEnd = -1;
                _noDisturbingStatus = EMPushNoDisturbStatusClose;
            }
                break;
                
            default:
                break;
        }
        
        if (needReload) {
            [tableView reloadData];
        }
    }
}

#pragma mark - action

- (void)savePushOptions
{
    BOOL isUpdate = NO;
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    if (_pushDisplayStyle != options.displayStyle) {
        options.displayStyle = _pushDisplayStyle;
        isUpdate = YES;
    }
    
    if (_nickName && _nickName.length > 0 && ![_nickName isEqualToString:options.nickname])
    {
        options.nickname = _nickName;
        isUpdate = YES;
    }
    if (options.noDisturbingStartH != _noDisturbingStart || options.noDisturbingEndH != _noDisturbingEnd){
        isUpdate = YES;
        options.noDisturbStatus = _noDisturbingStatus;
        options.noDisturbingStartH = _noDisturbingStart;
        options.noDisturbingEndH = _noDisturbingEnd;
    }
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        if (isUpdate) {
            error = [[EMClient sharedClient] updatePushOptionsToServer];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [weakself.navigationController popViewControllerAnimated:YES];
            } else {
                [weakself showHint:[NSString stringWithFormat:@"保存失败-error:%@",error.errorDescription]];
            }
        });
    });
}

- (void)pushDisplayChanged:(UISwitch *)pushDisplaySwitch
{
    if (pushDisplaySwitch.isOn) {
#warning 此处设置详情显示时的昵称，比如_nickName = @"环信";
        _pushDisplayStyle = EMPushDisplayStyleMessageSummary;
    }
    else{
        _pushDisplayStyle = EMPushDisplayStyleSimpleBanner;
    }
}

- (void)loadPushOptions
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                [weakself refreshPushOptions];
            } else {
                
            }
        });
    });
}

- (void)refreshPushOptions
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    _nickName = options.nickname;
    _pushDisplayStyle = options.displayStyle;
    _noDisturbingStatus = options.noDisturbStatus;
    if (_noDisturbingStatus != EMPushNoDisturbStatusClose) {
        _noDisturbingStart = options.noDisturbingStartH;
        _noDisturbingEnd = options.noDisturbingEndH;
    }
    
    BOOL isDisplayOn = _pushDisplayStyle == EMPushDisplayStyleSimpleBanner ? NO : YES;
    [self.pushDisplaySwitch setOn:isDisplayOn animated:YES];
    [self.tableView reloadData];
}

@end
