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

#import "RobotListViewController.h"

#import "BaseTableViewCell.h"
#import "ChatViewController.h"
#import "EMCursorResult.h"
//#import "EMRobot.h"
#import "RobotManager.h"
#import "SRRefreshView.h"
#import "RobotChatViewController.h"
@interface RobotListViewController ()<EMChatManagerDelegate,SRRefreshDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) SRRefreshView *slimeView;

@end

@implementation RobotListViewController

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
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

    self.title = NSLocalizedString(@"title.robotlist",@"robot list");
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addSubview:self.slimeView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self reloadDataSource];
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
    
//    EMRobot *robot = [self.dataSource objectAtIndex:indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
//    if ([robot.nickname length]) {
//        cell.textLabel.text = robot.nickname;
//    }
//    else {
//        cell.textLabel.text = robot.username;
//    }
    
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
    
//    EMRobot *robot = [self.dataSource objectAtIndex:indexPath.row];
//    ChatViewController *chatVC = [[RobotChatViewController alloc]
//                                  initWithConversationChatter:robot.username
//                                  conversationType:eConversationTypeChat];
//    if ([robot.nickname length]) {
//        chatVC.title = robot.nickname;
//    }
//    else {
//        chatVC.title = robot.username;
//    }
//    [self.navigationController pushViewController:chatVC animated:YES];
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
//    [self hideHud];
//    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
//    
//    __weak typeof(self) weakSelf = self;
//    [[EMClient sharedClient].chatManager asyncFetchRobotsFromServerWithCompletion:^(NSArray *robots, EMError *error) {
//        [weakSelf hideHud];
//        if (!error) {
//            [weakSelf.dataSource removeAllObjects];
//            [weakSelf.dataSource addObjectsFromArray:robots];
//            [weakSelf.tableView reloadData];
//            [[RobotManager sharedInstance] addRobotsToMemory:robots];
//        } else {
//            NSArray *robots = [[EMClient sharedClient].chatManager robotList];
//            if (robots) {
//                [weakSelf.dataSource removeAllObjects];
//                for (EMRobot *robot in robots) {
//                    if (robot && robot.activated) {
//                        [weakSelf.dataSource addObject:robot];
//                    }
//                }
//                [weakSelf.tableView reloadData];
//            }
//        }
//    }];
}

- (void)dealloc
{
    //由于离开页面时可能有大量聊天室对象需要释放，所以把释放操作放到一个独立线程
    if ([self.dataSource count])
    {
        NSMutableArray *robots = self.dataSource;
        self.dataSource = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [robots removeAllObjects];
        });
    }
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

@end
