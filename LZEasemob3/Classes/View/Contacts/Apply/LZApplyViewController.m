//
//  LZApplyViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZApplyViewController.h"
#import "LZApplyFriendCell.h"
#import "LZApplyUserModel.h"

static LZApplyViewController *controller = nil;

@interface LZApplyViewController ()<LZApplyFriendCellDelegate,EMContactManagerDelegate>

@end

@implementation LZApplyViewController

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    return controller;
}

- (NSArray *)dataSource
{
    if (_dataSource == nil){
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (NSString *)loginUsername
{
    return [[EMClient sharedClient] currentUsername];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"title.apply", @"Application and notification");
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LZApplyFriendCell";
    LZApplyFriendCell *cell = (LZApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LZApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.status = _dataSource[indexPath.row];
        cell.delegate = self;
    }
    
    if(self.dataSource.count > indexPath.row)
    {
//        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
//        if (entity) {
//            cell.indexPath = indexPath;
//            ApplyStyle applyStyle = [entity.style intValue];
//            if (applyStyle == ApplyStyleGroupInvitation) {
//                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
//                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
//            }
//            else if (applyStyle == ApplyStyleJoinGroup)
//            {
//                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
//                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
//            }
//            else if(applyStyle == ApplyStyleFriend){
//                cell.titleLabel.text = entity.applicantUsername;
//                cell.headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
//            }
//            cell.contentLabel.text = entity.reason;
//        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate
#pragma mark - 同意
- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    LZApplyUserModel *obj = _dataSource[indexPath.row];
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:obj.name];
    if (!error) {
        KLog(@"发送同意成功");
        obj.apply = YES;
        [obj update];
        [self.tableView reloadData];
    }
}

#pragma mark - 拒绝
- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    LZApplyUserModel *obj = _dataSource[indexPath.row];
    EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:obj.name];
    if (!error) {
        KLog(@"发送拒绝成功");
        [self.tableView reloadData];
    }
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
//    if (dictionary && [dictionary count] > 0) {
//        NSString *applyUsername = [dictionary objectForKey:@"username"];
//        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
//        
//        if (applyUsername && applyUsername.length > 0) {
//            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
//                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
//                ApplyStyle oldStyle = [oldEntity.style intValue];
//                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
//                    if(style != ApplyStyleFriend)
//                    {
//                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
//                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
//                            break;
//                        }
//                    }
//                    
//                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
//                    [_dataSource removeObject:oldEntity];
//                    [_dataSource insertObject:oldEntity atIndex:0];
//                    [self.tableView reloadData];
//                    
//                    return;
//                }
//            }
//            
//            //new apply
//            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
//            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
//            newEntity.style = [dictionary objectForKey:@"applyStyle"];
//            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
//            
//            NSString *loginName = [[EMClient sharedClient] currentUsername];
//            newEntity.receiverUsername = loginName;
//            
//            NSString *groupId = [dictionary objectForKey:@"groupId"];
//            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
//            
//            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
//            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
//            
//            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
//            
//            [_dataSource insertObject:newEntity atIndex:0];
//            [self.tableView reloadData];
//            
//        }
//    }
}

- (void)loadDataSourceFromLocalDB
{
//    _dataSource = [LZApplyUserModel findByCriteria:@" WHERE apply = 0 "];
     _dataSource = [LZApplyUserModel findAll];
    [self.tableView reloadData];
}

- (void)clear
{
//    [_dataSource removeAllObjects];
//    [self.tableView reloadData];
}

- (void)dealloc
{
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

@end
