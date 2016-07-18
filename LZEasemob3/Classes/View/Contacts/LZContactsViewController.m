//
//  LZContactsViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZContactsViewController.h"
#import "LZAddFriendViewController.h"
#import "LZContactsViewCell.h"
#import "LZChatViewController.h"

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    }else {
        buddyList = [[EMClient sharedClient].contactManager getContactsFromDB];
    }
    
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
        LZContactsViewCell *cell = [LZContactsViewCell cellWithTableView:tableView];
        LZContactsGrounp *model = _functionGroup[indexPath.row];
        cell.status = model;
        if (indexPath.row == 0) {
            cell.badge = self.unapplyCount;
        }
        return cell;
    }else {
        LZContactsViewCell *cell = [LZContactsViewCell cellWithTableView:tableView];
        NSArray *array = [_data objectAtIndex:indexPath.section - 1];
        cell.buddy = [array objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [_data objectAtIndex:indexPath.section - 1];
    NSString *buddy = [array objectAtIndex:indexPath.row];
    LZChatViewController *chatVc = [[LZChatViewController alloc] initWithConversationChatter:buddy conversationType:EMConversationTypeChat];
    chatVc.title = buddy;
    [self.navigationController pushViewController:chatVc animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.section;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0;
    return 22;
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
    if (indexPath.section == 0) return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *array = [_data objectAtIndex:indexPath.section - 1];
        NSString *buddy = [array objectAtIndex:indexPath.row];
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:buddy];
        
        if (!error) {
           [[EMClient sharedClient].chatManager deleteConversation:buddy deleteMessages:YES];
//           [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            [tableView reloadData];
        }
    }
}

#pragma mark - 被好友删除之后回调
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            [_dataSource removeAllObjects];
            KLog(@"被人删除获取用户列表 -- %@",userlist);
            [_dataSource addObjectsFromArray:userlist];
            _data = [LZContactsDataHelper getFriendListDataBy:_dataSource];
            _section = [LZContactsDataHelper getFriendListSectionBy:_data];
            KLog(@"%@",_dataSource);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            KLog(@"被人删除获取用户列表失败 -- %@",error);
        }
    });
}

#pragma mark - 懒加载
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
