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

#import "UserProfileViewController.h"

#import "ChatViewController.h"
#import "UserCacheManager.h"
#import "UIImageView+HeadImage.h"

@interface UserProfileViewController ()

@property (strong, nonatomic) UserCacheInfo *user;

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *usernameLabel;

@end

@implementation UserProfileViewController

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _username = username;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.profile", @"Profile");
    
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.allowsSelection = NO;
    
    [self setupBarButtonItem];
    [self loadUserProfile];
}

- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(20, 10, 60, 60);
        _headImageView.contentMode = UIViewContentModeScaleToFill;
    }
    [_headImageView imageWithUsername:_username placeholderImage:nil];
    return _headImageView;
}

- (UILabel*)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10.f, 10, 200, 20);
        _usernameLabel.text = _username;
        _usernameLabel.textColor = [UIColor lightGrayColor];
    }
    return _usernameLabel;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = NSLocalizedString(@"setting.personalInfoUpload", @"Upload HeadImage");
        [cell.contentView addSubview:self.headImageView];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"username", @"username");
        cell.detailTextLabel.text = self.usernameLabel.text;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"setting.profileNickname", @"Nickname");
        NSString *nickName = [UserCacheManager getNickById:_username];
        if (nickName && nickName.length>0) {
            cell.detailTextLabel.text = nickName;
        } else {
            cell.detailTextLabel.text = _username;
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)loadUserProfile
{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak typeof(self) weakself = self;
    // del by martin 0606
//    [[UserProfileManager sharedInstance] loadUserProfileInBackground:@[_username] saveToLoacal:YES completion:^(BOOL success, NSError *error) {
//        [weakself hideHud];
//        if (success) {
//            [weakself.tableView reloadData];
//        }
//    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
