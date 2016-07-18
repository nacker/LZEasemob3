//
//  LZContactsViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZContactsViewController.h"
#import "LZAddFriendViewController.h"

@interface LZContactsViewController ()
{
    NSIndexPath *_currentLongPressIndex;
}

// 功能列表
@property (nonatomic, strong) NSMutableArray *functionGroup;
/** 好友的数组 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 格式化的好友列表数据 */
@property (nonatomic, strong) NSMutableArray *data;
/** 拼音首字母列表 */
@property (nonatomic, strong) NSMutableArray *section;

@property (nonatomic) NSInteger unapplyCount;

@end

@implementation LZContactsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self reloadApplyView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNavItem];
    
    [self setTableView];
    
    [self reloadDataSource];
}

- (void)setupNavItem
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"addContact" highImage:@"addContact" target:self action:@selector(addContactAction)];
}

- (void)setTableView{
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
//    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 50.f;
    
//    [self.tableView setTableHeaderView:self.searchController.searchBar];
//    [self.tableView setTableFooterView:self.footerLabel];
}


- (void)addContactAction
{
    LZAddFriendViewController *addController = [[LZAddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    [self getDataSource];
}

- (void)getDataSource
{
    EMError *error = nil;
    NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        KLog(@"获取成功 -- %@",buddyList);
    }
//    else {
//        buddyList = [[EMClient sharedClient].contactManager getContactsFromDB];
//    }
    
    [self.dataSource addObjectsFromArray:buddyList];
    
    _functionGroup = [LZUIHelper getFriensListItemsGroup];
    _data = [LZContactsDataHelper getFriendListDataBy:self.dataSource];
    _section = [LZContactsDataHelper getFriendListSectionBy:_data];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _functionGroup.count;
    }
    NSArray *array = [_data objectAtIndex:section - 1];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *CellIdentifier = @"addFriend";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.avatarView.image = [UIImage imageNamed:@"newFriends"];
            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.avatarView.badge = self.unapplyCount;
            return cell;
        }
        
        NSString *CellIdentifier = @"commonCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 1) {
            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
            cell.titleLabel.text = NSLocalizedString(@"title.group", @"Group");
        }
        else if (indexPath.row == 2) {
            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
            cell.titleLabel.text = NSLocalizedString(@"title.chatroomlist",@"chatroom list");
        }
        else if (indexPath.row == 3) {
            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
            cell.titleLabel.text = NSLocalizedString(@"title.robotlist",@"robot list");
        }
        return cell;
    }
    else{
        NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.titleLabel.text = self.dataSource[indexPath.row];
        cell.indexPath = indexPath;
//        cell.delegate = self;

        
//        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
//        EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
//        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy];
//        if (profileEntity) {
//            model.avatarURLPath = profileEntity.imageUrl;
//            model.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
//        }
//        cell.indexPath = indexPath;
//        cell.delegate = self;
//        cell.model = model;
        
        return cell;
    }
}

#pragma mark - Table view delegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.section;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.section objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}


- (NSMutableArray *)functionGroup
{
    if (_functionGroup == nil){
        self.functionGroup = [NSMutableArray array];
    }
    return _functionGroup;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil){
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)data
{
    if (_data == nil){
        self.data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableArray *)section
{
    if (_section == nil){
        self.section = [NSMutableArray array];
    }
    return _section;
}
@end
