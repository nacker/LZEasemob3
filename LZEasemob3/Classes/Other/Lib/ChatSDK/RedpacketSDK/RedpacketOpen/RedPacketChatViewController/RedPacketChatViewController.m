//
//  ChatWithRedPacketViewController.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/23.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedPacketChatViewController.h"
#import "EaseRedBagCell.h"
#import "UIImageView+EMWebCache.h"
#import "RedpacketMessageCell.h"
#import "RedpacketViewControl.h"
#import "RedpacketMessageModel.h"
#import "RedPacketUserConfig.h"
#import "RedpacketOpenConst.h"
#import "YZHRedpacketBridge.h"
#import "ChatUIHelper.h"

/**
 *  红包聊天窗口
 */
@interface RedPacketChatViewController () < EaseMessageCellDelegate,
EaseMessageViewControllerDataSource>
/**
 *  发红包的控制器
 */
@property (nonatomic, strong)   RedpacketViewControl *viewControl;

@end

@implementation RedPacketChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     RedPacketUserConfig 持有当前聊天窗口
     */
    [RedPacketUserConfig sharedConfig].chatVC = self;
    
    /**
     红包功能的控制器， 产生用户单击红包后的各种动作
     */
    _viewControl = [[RedpacketViewControl alloc] init];
    //  需要当前的聊天窗口
    _viewControl.conversationController = self;
    //  需要当前聊天窗口的会话ID
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = self.conversation.conversationId;
    _viewControl.converstationInfo = userInfo;
    
    __weak typeof(self) weakSelf = self;
    
    //  用户抢红包和用户发送红包的回调
    [_viewControl setRedpacketGrabBlock:^(RedpacketMessageModel *messageModel) {
        //  发送通知到发送红包者处
        [weakSelf sendRedpacketHasBeenTaked:messageModel];
        
    } andRedpacketBlock:^(RedpacketMessageModel *model) {
        //  发送红包
        [weakSelf sendRedPacketMessage:model];
        
    }];
    
    //  同步Token
    [[YZHRedpacketBridge sharedBridge] reRequestRedpacketUserToken];
    
    //  设置用户头像
    [[EaseRedBagCell appearance] setAvatarSize:40.f];
    //  设置头像圆角
    [[EaseRedBagCell appearance] setAvatarCornerRadius:20.f];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:18]};
    
    if ([self.chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        //  MARK: __redbag  红包
        [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redpacket_redpacket"] highlightedImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redpacket_redpacket_high"] title:@"红包"];
        
        //  MARK: __redbag 零钱
        /*
         [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redpacket_changeMoney_high"] highlightedImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redpacket_changeMoney"] title:@"零钱"];
         */
    }
    
    //  显示红包的Cell视图
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RedpacketMessageCell class]) bundle:nil]forCellReuseIdentifier:NSStringFromClass([RedpacketMessageCell class])];
}

//  长时间按在某条Cell上的动作
- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([object conformsToProtocol:NSProtocolFromString(@"IMessageModel")]) {
        id <IMessageModel> messageModel = object;
        NSDictionary *ext = messageModel.message.ext;
        
        //  如果是红包，则只显示删除按钮
        if ([RedpacketMessageModel isRedpacket:ext]) {
            EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:EMMessageBodyTypeCmd];
            
            return NO;
        }else if ([RedpacketMessageModel isRedpacketTakenMessage:ext]) {
            
            return NO;
        }
    }
    
    return [super messageViewController:viewController canLongPressRowAtIndexPath:indexPath];
}


#pragma mrak - 自定义红包的Cell

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *ext = messageModel.message.ext;
    if ([RedpacketMessageModel isRedpacketRelatedMessage:ext]) {
        /**
         *  红包相关的展示
         */
        if ([RedpacketMessageModel isRedpacket:ext]) {
            EaseRedBagCell *cell = [tableView dequeueReusableCellWithIdentifier:[EaseRedBagCell cellIdentifierWithModel:messageModel]];
            
            if (!cell) {
                cell = [[EaseRedBagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[EaseRedBagCell cellIdentifierWithModel:messageModel] model:messageModel];
                cell.delegate = self;
            }
            
            cell.model = messageModel;
            
            return cell;
        }else {
            RedpacketMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RedpacketMessageCell class])];
            cell.model = messageModel;
            
            return cell;
        }
        
    }
    
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    NSDictionary *ext = messageModel.message.ext;
    if ([RedpacketMessageModel isRedpacketRelatedMessage:ext]) {
        if ([RedpacketMessageModel isRedpacket:ext])    {
            return [EaseRedBagCell cellHeightWithModel:messageModel];
        }else{
            return 36;
        }
    }
    
    return 0;
}

#pragma mark - DataSource
//  未读消息回执
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
shouldSendHasReadAckForMessage:(EMMessage *)message
                         read:(BOOL)read
{
    NSDictionary *ext = message.ext;
    
    if ([RedpacketMessageModel isRedpacketRelatedMessage:ext]) {
        return NO;
    }
    
    return [super shouldSendHasReadAckForMessage:message read:read];
}

#pragma mark - 发送红包消息
- (void)messageViewController:(EaseMessageViewController *)viewController didSelectMoreView:(EaseChatBarMoreView *)moreView AtIndex:(NSInteger)index
{
    if (self.conversation.type == EMConversationTypeChat) {
        // 点对点红包
        [self.viewControl presentRedPacketViewController];
        
    }else{
        // 群聊红包发送界面
        [self.viewControl presentRedPacketMoreViewControllerWithCount:(int)[EMGroup groupWithId:self.conversation.conversationId].occupants.count];
    }
}

//  MARK: 发送红包消息
- (void)sendRedPacketMessage:(RedpacketMessageModel *)model
{
    NSDictionary *dic = [model redpacketMessageModelToDic];
    
    NSString *message = [NSString stringWithFormat:@"[%@]%@", model.redpacket.redpacketOrgName, model.redpacket.redpacketGreeting];
    
    [self sendTextMessage:message withExt:dic];
}

//  MARK: 发送红包被抢的消息
- (void)sendRedpacketHasBeenTaked:(RedpacketMessageModel *)messageModel
{
    NSString *currentUser = [EMClient sharedClient].currentUsername;
    NSString *senderId = messageModel.redpacketSender.userId;
    NSString *conversationId = self.conversation.conversationId;
    
    NSMutableDictionary *dic = [messageModel.redpacketMessageModelToDic mutableCopy];
    /**
     *  不推送
     */
    [dic setValue:@(YES) forKey:@"em_ignore_notification"];
    
    NSString *text = [NSString stringWithFormat:@"你领取了%@发的红包", messageModel.redpacketSender.userNickname];
    
    if (self.conversation.type == EMConversationTypeChat) {
        [self sendTextMessage:text withExt:dic];
        /*
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
        EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationId from:currentUser to:conversationId body:body ext:dic];
        message.chatType = (EMChatType)self.conversation.type;
        message.isRead = YES;
        
        [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:nil];
        */
        
    }else{
        if ([senderId isEqualToString:currentUser]) {
            text = @"你领取了自己的红包";
            
        }else {
            /**
             如果不是自己发的红包，则发送抢红包消息给对方
             */
            EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:RedpacketKeyRedapcketCmd];
            EMMessage *message = [[EMMessage alloc] initWithConversationID:conversationId from:currentUser to:conversationId body:body ext:dic];
            message.chatType = (EMChatType)self.conversation.type;
            
            [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:nil];
        }
        
        /*
        NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
         */
        EMTextMessageBody *textMessageBody = [[EMTextMessageBody alloc] initWithText:text];
        EMMessage *textMessage = [[EMMessage alloc] initWithConversationID:conversationId from:currentUser to:conversationId body:textMessageBody ext:dic];
        textMessage.chatType = (EMChatType)self.conversation.type;
        textMessage.isRead = YES;
        
        /**
         *  刷新当前聊天界面
         */
        [self addMessageToDataSource:textMessage progress:nil];
        /**
         *  存入当前会话并存入数据库
         */
        [self.conversation insertMessage:textMessage];
    }
}

#pragma mark - EaseMessageCellDelegate 单击了Cell 事件

- (void)messageCellSelected:(id<IMessageModel>)model
{
    NSDictionary *dict = model.message.ext;
    
    if ([RedpacketMessageModel isRedpacket:dict]) {
        [self.viewControl redpacketCellTouchedWithMessageModel:[self toRedpacketMessageModel:model]];
        
    }else {
        [super messageCellSelected:model];
    }
}

- (RedpacketMessageModel *)toRedpacketMessageModel:(id <IMessageModel>)model
{
    RedpacketMessageModel *messageModel = [RedpacketMessageModel redpacketMessageModelWithDic:model.message.ext];
    BOOL isGroup = self.conversation.type == EMConversationTypeChat;
    messageModel.redpacketReceiver.isGroup = isGroup;
    
    messageModel.redpacketSender.userAvatar = model.avatarURLPath;

    NSString *nickName = model.nickname;
    if (nickName.length == 0) {
        nickName = model.message.from;
    }
    messageModel.redpacketSender.userNickname = nickName;
    if (messageModel.redpacketSender.userId.length == 0) {
        messageModel.redpacketSender.userId = model.message.from;
    }
    
    return messageModel;
}

@end
