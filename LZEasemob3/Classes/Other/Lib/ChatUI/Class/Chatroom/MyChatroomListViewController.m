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

#import "MyChatroomListViewController.h"

#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "BaseTableViewCell.h"
#import "EMSearchDisplayController.h"
#import "ChatViewController.h"
#import "PublicGroupListViewController.h"
#import "RealtimeSearchUtil.h"
#import "ChatroomListViewController.h"
#import "RedPacketChatViewController.h"


@interface MyChatroom : NSObject
@property (nonatomic, strong) NSString *chatroomId;
@property (nonatomic, strong) NSString *chatroomName;
+ (instancetype)chatroomWithId:(NSString *)chatroomId andName:(NSString *)chatroomName;
@end

@implementation MyChatroom
+ (instancetype)chatroomWithId:(NSString *)chatroomId andName:(NSString *)chatroomName
{
    MyChatroom *chatroom = [[MyChatroom alloc] init];
    chatroom.chatroomId = chatroomId;
    chatroom.chatroomName = chatroomName;
    return chatroom;
}
@end

static NSString *kOnceJoinedChatroomsPattern = @"OnceJoinedChatrooms_%@";

@interface MyChatroomListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, SRRefreshDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation MyChatroomListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.title = NSLocalizedString(@"title.mychatroom", @"my chatroom");
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView addSubview:self.slimeView];
    [self searchController];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self reloadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadDataSource];
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak MyChatroomListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            MyChatroom *chatroom = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *imageName = @"groupPublicHeader";
            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.textLabel.text = chatroom.chatroomName;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            MyChatroom *myChatroom = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            
#ifdef REDPACKET_AVALABLE
            RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
#else
                                                           ChatViewController *chatController = [[ChatViewController alloc]
#endif
                                                  initWithConversationChatter:myChatroom.chatroomId conversationType:EMConversationTypeChatRoom];
            chatController.title = myChatroom.chatroomName;
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
    }
    
    return _searchController;
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
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"title.chatroomlist",@"chatroom list");
                cell.imageView.image = [UIImage imageNamed:@"group_joinpublicgroup"];
                break;
            default:
                break;
        }
    } else {
        MyChatroom *chatroom = [self.dataSource objectAtIndex:indexPath.row];
        NSString *imageName = @"groupPublicHeader";
        cell.imageView.image = [UIImage imageNamed:imageName];
        if ([chatroom.chatroomName length]) {
            cell.textLabel.text = chatroom.chatroomName;
        }
        else {
            cell.textLabel.text = chatroom.chatroomId;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyChatroom *chatroom = [self.dataSource objectAtIndex:indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:kOnceJoinedChatroomsPattern, [[EMClient sharedClient] currentUsername]];
        NSMutableDictionary *chatRooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
        [chatRooms removeObjectForKey:chatroom.chatroomId];
        [ud setObject:chatRooms forKey:key];
        [ud synchronize];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self showChatroomList];
                break;
            default:
                break;
        }
    } else {
        MyChatroom *myChatroom = [self.dataSource objectAtIndex:indexPath.row];
#ifdef REDPACKET_AVALABLE
        RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
#else
                                                       ChatViewController *chatController = [[ChatViewController alloc]
#endif
                                              initWithConversationChatter:myChatroom.chatroomId conversationType:EMConversationTypeChatRoom];
        chatController.title = myChatroom.chatroomName;
        [self.navigationController pushViewController:chatController animated:YES];
    }
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
    if (section == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    return contentView;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(chatroomName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.searchBar;
}

#pragma mark - SRRefreshDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [_slimeView endRefresh];
}

#pragma mark - data

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:kOnceJoinedChatroomsPattern, [[EMClient sharedClient] currentUsername]];
    NSDictionary *chatRooms = [ud objectForKey:key];
    for (NSString *chatroomId in [chatRooms allKeys])
    {
        MyChatroom *chatroom = [MyChatroom chatroomWithId:chatroomId andName:chatRooms[chatroomId]];
        [self.dataSource addObject:chatroom];
    }
    NSComparator cmptr = ^(MyChatroom *obj1, MyChatroom *obj2)
    {
        return [obj1.chatroomName caseInsensitiveCompare:obj2.chatroomName];
    };
    [self.dataSource sortUsingComparator:cmptr];
    
    [self.tableView reloadData];
}

#pragma mark - action

- (void)showChatroomList
{
    ChatroomListViewController *controller = [[ChatroomListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)beKickedOutFromChatroom:(EMChatroom *)leavedChatroom reason:(EMChatroomBeKickedReason)reason
{
    MyChatroom *myChatroom = nil;
    for (MyChatroom *chatroom in self.dataSource)
    {
        if ([chatroom.chatroomId isEqualToString:leavedChatroom.chatroomId])
        {
            myChatroom = chatroom;
            break;
        }
    }
    
    if (!myChatroom)
    {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:kOnceJoinedChatroomsPattern, [[EMClient sharedClient] currentUsername]];
    NSMutableDictionary *chatRooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
    [chatRooms removeObjectForKey:myChatroom.chatroomId];
    [ud setObject:chatRooms forKey:key];
    [ud synchronize];
    
    [self.dataSource removeObject:myChatroom];
    [self.tableView reloadData];
}

@end
