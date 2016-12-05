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

#import "ChatroomListViewController.h"

#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "EMSearchDisplayController.h"
#import "ChatViewController.h"
#import "RealtimeSearchUtil.h"
#import "EMCursorResult.h"
#import "BaseTableViewCell.h"
#import "GettingMoreFooterView.h"

#define FetchChatroomPageSize   20

@interface ChatroomListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, SRRefreshDelegate, EMChatroomManagerDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) GettingMoreFooterView *footerView;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) BOOL isGettingMore;
@end

@implementation ChatroomListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
        _pageNum = 1;
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
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    // Uncomment the following line to preserve selection between presentations.
    self.title = NSLocalizedString(@"title.chatroomlist",@"chatroom list");
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView addSubview:self.slimeView];
    [self searchController];
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];

    [self reloadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //由于离开页面时可能有大量聊天室对象需要释放，所以把释放操作放到一个独立线程
    if ([self.dataSource count])
    {
        NSMutableArray *chatrooms = self.dataSource;
        self.dataSource = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [chatrooms removeAllObjects];
        });
    }
    [[EMClient sharedClient].roomManager removeDelegate:self];
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

- (GettingMoreFooterView *)footerView
{
    if (!_footerView) {
        CGRect frame = self.view.bounds;
        frame.size.height = 50;
        _footerView = [[GettingMoreFooterView alloc] initWithFrame:frame];
    }
    return _footerView;
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
        
        __weak ChatroomListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMChatroom *chatroom = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *imageName =  @"groupPublicHeader";
            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.textLabel.text = chatroom.subject;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMChatroom *myChatroom = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:myChatroom.chatroomId conversationType:EMConversationTypeChatRoom];
            chatController.title = myChatroom.subject;
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
    }
    
    return _searchController;
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
    
    EMChatroom *chatroom = [self.dataSource objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    if ([chatroom.subject length]) {
        cell.textLabel.text = chatroom.subject;
    }
    else {
        cell.textLabel.text = chatroom.chatroomId;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMChatroom *myChatroom = [self.dataSource objectAtIndex:indexPath.row];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:myChatroom.chatroomId conversationType:EMConversationTypeChatRoom];
    chatController.title = myChatroom.subject;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isGettingMore && indexPath.row == ([self.dataSource count] - 1) && _pageNum > 0)
    {
        __weak typeof(self) weakSelf = self;
        self.footerView.state = eGettingMoreFooterViewStateGetting;
        _isGettingMore = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
            EMPageResult *result = [[EMClient sharedClient].roomManager getChatroomsFromServerWithPage:weakSelf.pageNum++ pageSize:FetchChatroomPageSize error:&error];
            if (weakSelf)
            {
                ChatroomListViewController *strongSelf = weakSelf;
                strongSelf.isGettingMore = NO;
                if (!error)
                {
                    [strongSelf.dataSource addObjectsFromArray:result.list];
                    [strongSelf.tableView reloadData];
                    if (result.count > 0)
                    {
                        self.footerView.state = eGettingMoreFooterViewStateIdle;
                    }
                    else
                    {
                        self.footerView.state = eGettingMoreFooterViewStateComplete;
                    }
                }
                else
                {
                    self.footerView.state = eGettingMoreFooterViewStateFailed;
                }
            }
        });
    }
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
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(subject) resultBlock:^(NSArray *results) {
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
    
    if ([self.searchController.resultsSource count]) 
    {
        return;
    }
    else
    {
        __block EMChatroom *foundChatroom = nil;
        [self.dataSource enumerateObjectsUsingBlock:^(EMChatroom *chatroom, NSUInteger idx, BOOL *stop){
            if ([chatroom.chatroomId isEqualToString:searchBar.text])
            {
                foundChatroom = chatroom;
                *stop = YES;
            }
        }];
        
        if (foundChatroom)
        {
            [self.searchController.resultsSource removeAllObjects];
            [self.searchController.resultsSource addObject:foundChatroom];
            [self.searchController.searchResultsTableView reloadData];
        }
        else
        {
            __weak typeof(self) weakSelf = self;
            [self showHudInView:self.view hint:NSLocalizedString(@"searching", @"Searching")];
            dispatch_async(dispatch_get_main_queue(), ^{
                EMError *error = nil;
                EMChatroom *chatroom = [[EMClient sharedClient].roomManager fetchChatroomInfo:searchBar.text includeMembersList:false error:&error];
                if (weakSelf)
                {
                    ChatroomListViewController *strongSelf = weakSelf;
                    [strongSelf hideHud];
                    if (!error) {
                        [strongSelf.searchController.resultsSource removeAllObjects];
                        [strongSelf.searchController.resultsSource addObject:chatroom];
                        [strongSelf.searchController.searchResultsTableView reloadData];
                    }
                    else
                    {
                        [strongSelf showHint:NSLocalizedString(@"notFound", @"Can't found")];
                    }
                }
            });
        }
    }

//    [[EMClient sharedClient].chatManager asyncSearchPublicGroupWithGroupId:searchBar.text completion:^(EMGroup *group, EMError *error) {
//        if (!error) {
//            [self.searchController.resultsSource removeAllObjects];
//            [self.searchController.resultsSource addObject:group];
//            [self.searchController.searchResultsTableView reloadData];
//        }
//    } onQueue:nil];
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
    [self reloadDataSource];
    [_slimeView endRefresh];
}

#pragma mark - data

- (void)reloadDataSource
{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    _pageNum = 1;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMPageResult *result = [[EMClient sharedClient].roomManager getChatroomsFromServerWithPage:weakSelf.pageNum++ pageSize:FetchChatroomPageSize error:&error];
        if (weakSelf)
        {
            ChatroomListViewController *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf hideHud];
                
                if (!error)
                {
                    NSMutableArray *oldChatrooms = [self.dataSource mutableCopy];
                    [self.dataSource removeAllObjects];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [oldChatrooms removeAllObjects];
                    });
                    [strongSelf.dataSource addObjectsFromArray:result.list];
                    [strongSelf.tableView reloadData];
                    if (result.count > 0)
                    {
                        self.footerView.state = eGettingMoreFooterViewStateIdle;
                    }
                    else
                    {
                        self.footerView.state = eGettingMoreFooterViewStateComplete;
                    }
                }
                else
                {
                    self.footerView.state = eGettingMoreFooterViewStateFailed;
                }
            });
        }
    });
}

#pragma mark - EMChatroomManagerDelegate

- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
                              reason:(EMChatroomBeKickedReason)aReason
{
//    if (aReason != EMChatroomBeKickedReasonDestroyed)
//    {
//        return;
//    }
//    
//    [self.dataSource enumerateObjectsUsingBlock:^(EMChatroom *chatroom, NSUInteger idx, BOOL *stop){
//        if ([aChatroom.chatroomId isEqualToString:chatroom.chatroomId])
//        {
//            [self.dataSource removeObjectAtIndex:idx];
//            *stop = YES;
//        }
//    }];
//    [self.tableView reloadData];
}

@end
