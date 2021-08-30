//
//  LZConversationViewController.m
//  LZEasemobV2
//
//  Created by nacker on 2021/8/30.
//

#import "LZConversationViewController.h"
#import "ChatViewController.h"

@interface LZConversationViewController ()
//<TUIConversationListControllerListener>

@end

@implementation LZConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[TUIKitListenerManager sharedInstance] addConversationListControllerListener:self];
//
//
//    TUIConversationListController *vc = [[TUIConversationListController alloc] init];
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
//    //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
//    vc.tableView.delaysContentTouches = NO;
    
    
    
}
//
///**
// *推送默认跳转
// */
//- (void)pushToChatViewController:(NSString *)groupID userID:(NSString *)userID {
//
//    UIViewController *topVc = self.navigationController.topViewController;
//    BOOL isSameTarget = NO;
//    BOOL isInChat = NO;
//    if ([topVc isKindOfClass:ChatViewController.class]) {
//        TUIConversationCellData *cellData = [(ChatViewController *)topVc conversationData];
//        isSameTarget = [cellData.groupID isEqualToString:groupID] || [cellData.userID isEqualToString:userID];
//        isInChat = YES;
//    }
//    if (isInChat && isSameTarget) {
//        return;
//    }
//    
//    if (isInChat && !isSameTarget) {
//        [self.navigationController popViewControllerAnimated:NO];
//    }
//    
//    ChatViewController *chat = [[ChatViewController alloc] init];
//    TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
//    conversationData.groupID = groupID;
//    conversationData.userID = userID;
//    chat.conversationData = conversationData;
//    [self.navigationController pushViewController:chat animated:YES];
//}
//
//
////- (void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversationCell
////{
////
////}
//
//#pragma mark - 移除监听|通知
//- (void)dealloc
//{
//    [[TUIKitListenerManager sharedInstance] removeConversationListControllerListener:self];
//    [NSNotificationCenter.defaultCenter removeObserver:self];
//}

@end
