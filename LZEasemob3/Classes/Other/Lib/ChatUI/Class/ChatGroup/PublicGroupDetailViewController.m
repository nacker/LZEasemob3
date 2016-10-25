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

#import "PublicGroupDetailViewController.h"

@interface PublicGroupDetailViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) EMGroup *group;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *footerButton;

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation PublicGroupDetailViewController

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _groupId = groupId;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self fetchGroupInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
        imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
        [_headerView addSubview:imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, _headerView.frame.size.width - 80 - 20, 30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = (_group.subject && _group.subject.length) > 0 ? _group.subject : _group.groupId;
        [_headerView addSubview:_nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height - 0.5, _headerView.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headerView addSubview:line];
    }
    
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
        
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, _footerView.frame.size.width - 80, 40)];
        [_footerButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
        [_footerView addSubview:_footerButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"group.owner", @"Owner");
        cell.detailTextLabel.text = _group.owner;
    }
    else{
        cell.textLabel.text = NSLocalizedString(@"group.describe", @"Describe");
        cell.detailTextLabel.text = _group.description;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }
    else{
        CGSize size = [_group.description sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(220, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        
        return size.height > 30 ? (20 + size.height) : 50;
    }
}

#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
        NSString *messageStr = @"";
        if (messageTextField.text.length > 0) {
            messageStr = messageTextField.text;
        }
        [self applyJoinGroup:_groupId withGroupname:_group.subject message:messageStr];
    }
}

#pragma mark - action

- (BOOL)isJoined:(EMGroup *)group
{
    if (group) {
        NSArray *groupList = [[EMClient sharedClient].groupManager getAllGroups];
        for (EMGroup *tmpGroup in groupList) {
            if (tmpGroup.isPublic == group.isPublic && [group.groupId isEqualToString:tmpGroup.groupId]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)fetchGroupInfo
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:weakSelf.groupId includeMembersList:NO error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                weakSelf.group = group;
                [weakSelf reloadSubviewsInfo];
            }
            [weakSelf hideHud];
        });
    });
}

- (void)reloadSubviewsInfo
{
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.nameLabel.text = (weakSelf.group.subject && weakSelf.group.subject.length) > 0 ? weakSelf.group.subject : weakSelf.group.groupId;
        if ([weakSelf isJoined:weakSelf.group]) {
            weakSelf.footerButton.enabled = NO;
            [weakSelf.footerButton setTitle:NSLocalizedString(@"group.joined", @"joined") forState:UIControlStateNormal | UIControlStateDisabled];
        }
        else{
            weakSelf.footerButton.enabled = YES;
            [weakSelf.footerButton setTitle:NSLocalizedString(@"group.join", @"join the group") forState:UIControlStateNormal];
        }
        [weakSelf.tableView reloadData];
    });
}

- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"saySomething", @"say somthing") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)joinAction
{
    if (self.group.setting.style == EMGroupStylePublicJoinNeedApproval) {
        [self showMessageAlertView];
    }
    else if (self.group.setting.style == EMGroupStylePublicOpenJoin)
    {
        [self joinGroup:_groupId];
    }
}

- (void)joinGroup:(NSString *)groupId
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.join.ongoing", @"join the group...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient].groupManager joinPublicGroup:groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error) {
                [weakSelf hideHud];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf showHint:NSLocalizedString(@"group.join.fail", @"again failed to join the group, please")];
            }
        });
    });
}

- (void)applyJoinGroup:(NSString *)groupId withGroupname:(NSString *)groupName message:(NSString *)message
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.sendingApply", @"send group of application...")];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient].groupManager applyJoinPublicGroup:groupId message:groupName error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                [weakSelf showHint:NSLocalizedString(@"group.sendApplyRepeat", @"application has been sent")];
            }
            else{
                [weakSelf showHint:error.errorDescription];
            }
        });
    });}

@end
