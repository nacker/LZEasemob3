//
//  LZApplyViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZApplyViewController.h"
#import "LZApplyFriendCell.h"

static LZApplyViewController *controller = nil;

@interface LZApplyViewController ()<LZApplyFriendCellDelegate>

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

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
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
    
    [self loadDataSourceFromLocalDB];
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
    static NSString *CellIdentifier = @"ApplyFriendCell";
    LZApplyFriendCell *cell = (LZApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[LZApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
//    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
//    return [LZApplyFriendCell heightWithContent:entity.reason];
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate
- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row < [self.dataSource count]) {
//        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
//        
//        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
//        ApplyStyle applyStyle = [entity.style intValue];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            EMError *error;
//            if (applyStyle == ApplyStyleGroupInvitation) {
//                [[EMClient sharedClient].groupManager acceptInvitationFromGroup:entity.groupId inviter:entity.applicantUsername error:&error];
//            }
//            else if (applyStyle == ApplyStyleJoinGroup)
//            {
//                error = [[EMClient sharedClient].groupManager acceptJoinApplication:entity.groupId applicant:entity.applicantUsername];
//            }
//            else if(applyStyle == ApplyStyleFriend){
//                error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:entity.applicantUsername];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self hideHud];
//                if (!error) {
//                    [self.dataSource removeObject:entity];
//                    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//                    [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//                    [self.tableView reloadData];
//                }
//                else{
//                    [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
//                }
//            });
//        });
//    }
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row < [self.dataSource count]) {
//        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
//        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
//        ApplyStyle applyStyle = [entity.style intValue];
//        EMError *error;
//        
//        if (applyStyle == ApplyStyleGroupInvitation) {
//            error = [[EMClient sharedClient].groupManager declineInvitationFromGroup:entity.groupId inviter:entity.applicantUsername reason:nil];
//        }
//        else if (applyStyle == ApplyStyleJoinGroup)
//        {
//            error = [[EMClient sharedClient].groupManager declineJoinApplication:entity.groupId applicant:entity.applicantUsername reason:nil];
//        }
//        else if(applyStyle == ApplyStyleFriend){
//            [[EMClient sharedClient].contactManager declineInvitationForUsername:entity.applicantUsername];
//        }
//        
//        [self hideHud];
//        if (!error) {
//            [self.dataSource removeObject:entity];
//            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//            
//            [self.tableView reloadData];
//        }
//        else{
//            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
//            [self.dataSource removeObject:entity];
//            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//            
//            [self.tableView reloadData];
//            
//        }
//    }
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
    [_dataSource removeAllObjects];
    NSString *loginName = [self loginUsername];
    if(loginName && [loginName length] > 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *defalutData = [defaults objectForKey:loginName];
        NSArray *applyArray = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
        [self.dataSource addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
}

- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

@end
