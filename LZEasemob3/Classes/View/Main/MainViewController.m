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

#import "MainViewController.h"

#import "SettingsViewController.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "UserCacheManager.h"
#import "ConversationListController.h"
#import "ContactListViewController.h"
#import "ChatUIHelper.h"
#import "RedPacketChatViewController.h"

#import "LZNavigationController.h"
#import "LZDiscoverViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

#if DEMO_CALL == 1
@interface MainViewController () <UIAlertViewDelegate, EMCallManagerDelegate>
#else
@interface MainViewController () <UIAlertViewDelegate>
#endif
{
    ConversationListController *_chatListVC;
    ContactListViewController *_contactsVC;
    SettingsViewController *_settingsVC;
    LZDiscoverViewController *_discoverVC;
//    __weak CallViewController *_callController;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation MainViewController

+ (void)initialize
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    self.title = NSLocalizedString(@"title.conversation", @"Conversations");
    
    
    [self setupChildVC];
    
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
//    [self didUnreadMessagesCountChanged];
    NOTIFY_ADD(setupUntreatedApplyCount, kSetupUntreatedApplyCount);
    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
    NOTIFY_ADD(networkChanged, kConnectionStateChanged);
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    
    [ChatUIHelper shareHelper].contactViewVC = _contactsVC;
    [ChatUIHelper shareHelper].conversationListVC = _chatListVC;
}

- (void)setupChildVC
{
    _chatListVC = [[ConversationListController alloc] init];
    [self addChildViewController:_chatListVC title:@"微信" imageName:@"tabbar_mainframe"];
    [_chatListVC networkChanged:_connectionState];
    
    _contactsVC = [[ContactListViewController alloc] init];
    [self addChildViewController:[[ContactListViewController alloc] init] title:@"通讯录" imageName:@"tabbar_contacts"];
    [self addChildViewController:[[LZDiscoverViewController alloc] init] title:@"发现" imageName:@"tabbar_discover"];
    [self addChildViewController:[[SettingsViewController alloc] init] title:@"我" imageName:@"tabbar_me"];
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName {
    
    childController.title = title;
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    NSString *selectedImageName = [NSString stringWithFormat:@"%@HL", imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = selectedImage;
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = KColor(14, 180, 0);
    [childController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

#pragma mark - UITabBarDelegate
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    if (item.tag == 0) {
//        self.title = NSLocalizedString(@"title.conversation", @"Conversations");
//        self.navigationItem.rightBarButtonItem = nil;
//    }else if (item.tag == 1){
//        self.title = NSLocalizedString(@"title.addressbook", @"AddressBook");
//        self.navigationItem.rightBarButtonItem = _addFriendItem;
//    }else if (item.tag == 2){
//        self.title = NSLocalizedString(@"title.addressbook", @"AddressBook");
//        self.navigationItem.rightBarButtonItem = nil;
//    }else if (item.tag == 3){
//        self.title = NSLocalizedString(@"title.setting", @"Setting");
//        self.navigationItem.rightBarButtonItem = nil;
//        [_settingsVC refreshConfig];
//    }
//}

#pragma mark - private

//- (void)setupSubviews
//{
////    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
////    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
//    
//    _chatListVC = [[ConversationListController alloc] initWithNibName:nil bundle:nil];
//    [_chatListVC networkChanged:_connectionState];
//    [self setupChildVc:_chatListVC title:NSLocalizedString(@"title.conversation", @"Conversations") image:@"tabbar_chats" selectedImage:@"tabbar_chatsHL" tag:0];
//    
//    _contactsVC = [[ContactListViewController alloc] initWithNibName:nil bundle:nil];
//     [self setupChildVc:_contactsVC title:NSLocalizedString(@"title.conversation", @"Conversations") image:@"tabbar_chats" selectedImage:@"tabbar_chatsHL" tag:1];
//    
//    
//    _discoverVC = [[LZDiscoverViewController alloc] init];
//    [self setupChildVc:_discoverVC title:NSLocalizedString(@"title.conversation", @"Conversations") image:@"tabbar_chats" selectedImage:@"tabbar_chatsHL" tag:2];
//    
//    _settingsVC = [[SettingsViewController alloc] init];
//    [self setupChildVc:_contactsVC title:NSLocalizedString(@"title.conversation", @"Conversations") image:@"tabbar_chats" selectedImage:@"tabbar_chatsHL" tag:3];
//    
//    
//    self.viewControllers = @[_chatListVC, _contactsVC, _settingsVC];
//    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
//}

//- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage tag:(NSInteger)tag
//{
//    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
//                                                           image:nil
//                                                             tag:tag];
//    [vc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectedImage]
//                         withFinishedUnselectedImage:[UIImage imageNamed:image]];
//    [self unSelectedTapTabBarItems:vc.tabBarItem];
//    [self selectedTapTabBarItems:vc.tabBarItem];
//}


//-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
//{
//    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIFont systemFontOfSize:14], UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,
//                                        nil] forState:UIControlStateNormal];
//}
//
//-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
//{
//    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIFont systemFontOfSize:14],
//                                        UITextAttributeFont,RGBACOLOR(0x00, 0xac, 0xff, 1),UITextAttributeTextColor,
//                                        nil] forState:UIControlStateSelected];
//}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
}

// 网络状态变化
- (void)networkChanged
{
    _connectionState = [ChatUIHelper shareHelper].connectionState;
    [_chatListVC networkChanged:_connectionState];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc]
#else
                        chatViewController = [[ChatViewController alloc]
#endif
                                              initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case EMChatTypeChat:
                                {
                                    NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                                    for (EMGroup *group in groupArray) {
                                        if ([group.groupId isEqualToString:conversationChatter]) {
                                            chatViewController.title = group.subject;
                                            break;
                                        }
                                    }
                                }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                chatViewController = [[RedPacketChatViewController alloc]
#else
                chatViewController = [[ChatViewController alloc]
#endif
                                      initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case EMChatTypeGroupChat:
                    {
                        NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.subject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)dealloc
{
                            
}
@end
