//
//  LZConversationViewController.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZConversationViewController.h"
//#import "LZChatViewController.h"
//#import "LZConversationCell.h"

//static LZConversationViewController *controller = nil;

@interface LZConversationViewController ()//<EMClientDelegate,EMContactManagerDelegate,EMChatManagerDelegate,UIAlertViewDelegate>

///** 好友的名称 */
//@property (nonatomic, copy) NSString *buddyUsername;
//
//@property (nonatomic , strong) NSArray *conversations;
//
//@property (nonatomic , strong) NSMutableArray *amsgArray;

@end

@implementation LZConversationViewController

//+ (instancetype)shareController
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        controller = [[self alloc] init];
//    });
//    return controller;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [self loadConversations];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    //登录接口相关的代理
//    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
//    //联系人模块代理
////    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
//    //消息，聊天
//    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//    
//    [self loadConversations];
//}
//
//-(void)loadConversations{
//    //获取历史会话记录
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    if (conversations.count == 0) {
//        conversations =  [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
//    }
//    
//    self.conversations = [conversations sortedArrayUsingComparator:
//                          ^(EMConversation *obj1, EMConversation* obj2){
//                              EMMessage *message1 = [obj1 latestMessage];
//                              EMMessage *message2 = [obj2 latestMessage];
//                              if(message1.timestamp > message2.timestamp) {
//                                  return(NSComparisonResult)NSOrderedAscending;
//                              }else {
//                                  return(NSComparisonResult)NSOrderedDescending;
//                              }
//                          }];
//    //显示总的未读数
//    [self showTabBarBadge];
//}
//
//- (void)showTabBarBadge{
//    NSInteger totalUnreadCount = 0;
//    for (EMConversation *conversation in self.conversations) {
//        totalUnreadCount += [conversation unreadMessagesCount];
//    }
//    KLog(@"未读消息总数:%ld",(long)totalUnreadCount);
//    
//    if (totalUnreadCount == 0) {
//        self.tabBarItem.badgeValue = nil;
//    }else {
//        if (totalUnreadCount > 99) {
//            self.tabBarItem.badgeValue = @"99+";
//        }else {
//            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)totalUnreadCount];
//        }
//        
//    }
//    [self.tableView reloadData];
//}
//
//
//#pragma mark - 历史会话列表更新
//- (void)didUpdateConversationList:(NSArray *)conversationList{
//    //给数据源重新赋值
//    self.conversations = conversationList;
//    //显示总的未读数
//    [self showTabBarBadge];
//}
//
//#pragma mark - 接收到消息
//- (void)didReceiveMessages:(NSArray *)aMessages
//{
//    [self loadConversations];
//}
//
//#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.conversations.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LZConversationCell *cell = [LZConversationCell cellWithTableView:tableView];
//    cell.conversaion = self.conversations[indexPath.row];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    EMConversation *conversaion = self.conversations[indexPath.row];
//    KLog(@"%@",conversaion.conversationId);
//    LZChatViewController *vc = [[LZChatViewController alloc] initWithConversationChatter:conversaion.conversationId conversationType:EMConversationTypeChat];
//    vc.title = conversaion.conversationId;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        EMConversation *conversaion = self.conversations[indexPath.row];
//        NSString *converstationID = conversaion.conversationId;
//        // 删除会话
//        [[EMClient sharedClient].chatManager deleteConversation:converstationID deleteMessages:YES];
//        [self loadConversations];
//    }
//}
//
////修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//
//#pragma mark - 监听网络状态
//- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
//    
//    if (connectionState == EMConnectionDisconnected) {
//        self.navigationItem.title = @"未连接..";
//    }else{
//        self.navigationItem.title = @"消息";
//    }
//}
//
//
//#pragma mark - 好友请求回调
///*!
// *  用户A发送加用户B为好友的申请，用户B会收到这个回调
// *
// *  @param aUsername   用户名
// *  @param aMessage    附属信息
// */
//- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
//                                       message:(NSString *)aMessage
//{
//    NSLog(@"%@,%@",aUsername,aMessage);
////    self.buddyUsername = aUsername;
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友添加请求" message:aMessage delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
////    [alert show];
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 1) {
//        //同意好友请求
//        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:self.buddyUsername];
//        if (!error) {
//            NSLog(@"同意加好友成功");
//        }else{
//            NSLog(@"同意加好友失败");
//        }
//    }else{
//        //拒绝好友请求
//        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:self.buddyUsername];
//        if (!error) {
//            NSLog(@"拒绝加好友成功");
//        }else{
//            NSLog(@"拒绝加好友失败");
//        }
//    }
//}
//
//
//
//- (void)dealloc
//{
//    [[EMClient sharedClient] removeDelegate:self];
////    [[EMClient sharedClient].contactManager removeDelegate:self];
//    [[EMClient sharedClient].chatManager removeDelegate:self];
//}
//
//- (NSArray *)conversations
//{
//    if (!_conversations) {
//        _conversations = [NSArray array];
//    }
//    return _conversations;
//}
//
//- (NSMutableArray *)amsgArray{
//    if (!_amsgArray) {
//        _amsgArray = [NSMutableArray array];
//    }
//    return _amsgArray;
//}
@end
