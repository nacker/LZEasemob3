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

#import "ChatroomDetailViewController.h"
#import "EMChatroom.h"
#import "ContactView.h"
#import "EMCursorResult.h"

#pragma mark - ChatGroupDetailViewController

#define kColOfRow 5
#define kContactSize 60

@interface ChatroomDetailViewController ()

@property (strong, nonatomic) EMChatroom *chatroom;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSArray *occupants;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ChatroomDetailViewController

- (instancetype)initWithChatroomId:(NSString *)chatroomId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _dataSource = [NSMutableArray array];
        _chatroom = [EMChatroom chatroomWithId:chatroomId];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];

    [self fetchChatroomInfo];
}

#pragma mark - getter

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, kContactSize)];
        _scrollView.tag = 0;
    }
    
    return _scrollView;
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.scrollView];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"chatroom.id", @"chatroom Id");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = _chatroom.chatroomId;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = NSLocalizedString(@"chatroom.description", @"description");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = _chatroom.description;
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = NSLocalizedString(@"chatroom.occupantCount", @"members count");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i / %i", (int)[self.occupants count], (int)_chatroom.maxOccupantsCount];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    if (row == 0) {
        return self.scrollView.frame.size.height + 40;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - data

- (void)fetchChatroomInfo
{
    /*
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMCursorResult *result = nil;
        EMChatroom *chatroom = [[EMClient sharedClient].chatManager fetchChatroomInfo:weakSelf.chatroom.chatroomId error:&error];
        if (!error)
        {
            result = [[EMClient sharedClient].chatManager fetchOccupantsForChatroom:chatroom.chatroomId cursor:nil pageSize:-1 andError:&error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error)
            {
                weakSelf.chatroom = chatroom;
                weakSelf.title = chatroom.chatroomSubject;
                weakSelf.occupants = result.list;
            }
            [weakSelf reloadDataSource];
            if (error)
            {
                [weakSelf showHint:NSLocalizedString(@"chatroom.fetchInfoFail", @"failed to get the chatroom details, please try again later")];
            }
        });
    });*/
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.occupants];
    [self refreshScrollView];
    [self hideHud];
}

- (void)refreshScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int tmp = ([self.dataSource count] + 1) % kColOfRow;
    int row = (int)([self.dataSource count] + 1) / kColOfRow;
    row += tmp == 0 ? 0 : 1;
    self.scrollView.tag = row;
    self.scrollView.frame = CGRectMake(10, 20, self.tableView.frame.size.width - 20, row * kContactSize);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, row * kContactSize);
    
    int i = 0;
    int j = 0;
    BOOL isEnd = NO;
    for (i = 0; i < row; i++) {
        for (j = 0; j < kColOfRow; j++) {
            NSInteger index = i * kColOfRow + j;
            if (index < [self.dataSource count]) {
                NSString *username = [self.dataSource objectAtIndex:index];
                ContactView *contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * kContactSize, i * kContactSize, kContactSize, kContactSize)];
                contactView.index = i * kColOfRow + j;
                contactView.image = [UIImage imageNamed:@"chatListCellHead.png"];
                contactView.remark = username;
                [self.scrollView addSubview:contactView];
            }
            else{
                isEnd = YES;
                break;
            }
        }
        
        if (isEnd) {
            break;
        }
    }
    
    [self.tableView reloadData];
}

@end
