//
//  YZHUserConfig.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedPacketUserConfig.h"
#import "UserCacheManager.h"
#import "YZHRedpacketBridge.h"
#import "RedpacketMessageModel.h"
#import "ChatUIHelper.h"


static RedPacketUserConfig *__sharedConfig__ = nil;

@interface RedPacketUserConfig () <EMClientDelegate,
                                    EMChatManagerDelegate,
                                    YZHRedpacketBridgeDataSource,
                                    YZHRedpacketBridgeDelegate>
{
    NSString *_dealerAppKey;
    
    NSString *_imUserId;
    NSString *_imUserPass;
    /**
     *  环信登陆用户名
     */
    NSString *_imUserName;
    /**
     *  是否已经注册了消息代理
     */
    BOOL _isRegeistMessageDelegate;
}

@end

@implementation RedPacketUserConfig

- (void)beginObserve
{
    //  登录代理
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    //  如果接入的用户有通知，则接收通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginChanged:) name:KNOTIFICATION_LOGINCHANGE object:nil];
}

- (void)beginObserveMessage
{
    if (!_isRegeistMessageDelegate && [EMClient sharedClient].chatManager) {
        _isRegeistMessageDelegate = YES;
        //  消息代理
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    }
}

- (void)removeObserver
{
    _isRegeistMessageDelegate = NO;
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self removeObserver];
}

+ (RedPacketUserConfig *)sharedConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedConfig__ = [[RedPacketUserConfig alloc] init];
        
        [YZHRedpacketBridge sharedBridge].dataSource = __sharedConfig__;
        [YZHRedpacketBridge sharedBridge].delegate = __sharedConfig__;
        
        [__sharedConfig__ beginObserve];
    });
    
    [__sharedConfig__ beginObserveMessage];
    
    return __sharedConfig__;
}

- (void)configWithAppKey:(NSString *)appKey
{
    _dealerAppKey = appKey;
}

- (void)configWithImUserId:(NSString *)imUserId andImUserPass:(NSString *)imUserPass
{
    [self beginObserve];
    
    NSAssert(imUserId.length > 0, @"IM平台：用户登录id为空");
    NSAssert(imUserPass.length > 0, @"IM平台：用户密码为空");
    
    _imUserId = imUserId;
    _imUserPass = imUserPass;
    
    NSString *userId = self.redpacketUserInfo.userId;
    
    
    /*
    [[YZHRedpacketBridge sharedBridge] configWithAppKey:_dealerAppKey
                                              appUserId:userId
                                               imUserId:userId
                                          andImUserpass:_imUserPass];
     */
}

#pragma mark - YZHRedpacketBridgeDataSource

/**
 *  获取当前用户登陆信息，YZHRedpacketBridgeDataSource
 */
- (RedpacketUserInfo *)redpacketUserInfo
{
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = [EMClient sharedClient].currentUsername;
    
    UserCacheInfo *entity = [UserCacheManager getCurrUser];
    NSString *nickname = entity.NickName;
    userInfo.userNickname = nickname.length > 0 ? nickname : userInfo.userId;
    userInfo.userAvatar = entity.AvatarUrl;;
    
    return userInfo;
}

#pragma mark - YZHRedpacketBridgeDelegate

/**
 *  环信Token过期后的回调
 */
- (void)redpacketUserTokenGetInfoByMethod:(RequestTokenMethod)method
{
    [self configUserToken:YES];
}

#pragma mark - 
#pragma mark 用户登录状态监控

//  监测用户登录状态
- (void)userLoginChanged:(NSNotification *)notifaction
{
    BOOL isLoginSuccess = [[notifaction object] boolValue];
    if (isLoginSuccess) {
        [self configUserToken:NO];
        
    }else  {
        //  用户退出，清除数据
        [self clearUserInfo];
    }
}

- (void)configUserToken:(BOOL)isRefresh
{
    if (![EMClient sharedClient].isLoggedIn) {
        return;
    }
    
    NSString *userToken = nil;
    if ([[EMClient sharedClient] respondsToSelector:@selector(getUserToken:)]) {
        userToken = [[EMClient sharedClient] performSelector:@selector(getUserToken:) withObject:@(isRefresh)];
    }
    
    NSString *userId = self.redpacketUserInfo.userId;
    if (userToken.length) {
        [[YZHRedpacketBridge sharedBridge] configWithAppKey:_dealerAppKey
                                                  appUserId:userId
                                                    imToken:userToken];
    }else {
        [[YZHRedpacketBridge sharedBridge] configWithAppKey:_dealerAppKey
                                                  appUserId:userId
                                                   imUserId:userId
                                              andImUserpass:_imUserPass];
    }
}

- (void)didLoginFromOtherDevice
{
    [self clearUserInfo];
}

- (void)didAutoLoginWithError:(EMError *)aError
{
    if (!aError) {
        [self configUserToken:NO];
    }
}

- (void)clearUserInfo
{
    [[YZHRedpacketBridge sharedBridge] redpacketUserLoginOut];
    _imUserId = nil;
}

#pragma mark -
#pragma mark  红包被抢消息监控

- (void)didReceiveMessages:(NSArray *)aMessages
{
    /**
     *  收到消息
     */
    [self handleMessage:aMessages];
}
-(void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    /**
     *  处理红包被抢的消息
     */
    [self handleCmdMessages:aCmdMessages];
}

/**
 *  点对点红包，红包被抢的消息
 */
- (void)handleMessage:(NSArray <EMMessage *> *)aMessages
{
    for (EMMessage *message in aMessages) {
        NSDictionary *dict = message.ext;
        if (dict && [RedpacketMessageModel isRedpacketTakenMessage:dict]) {
            NSString *senderID = [dict valueForKey:RedpacketKeyRedpacketSenderId];
            NSString *receiverID = [dict valueForKey:RedpacketKeyRedpacketReceiverId];
            NSString *currentUserID = [EMClient sharedClient].currentUsername;
            //  标记为已读
            if ([senderID isEqualToString:currentUserID]){
                /**
                 *  当前用户是红包发送者。
                 */
                NSString *text = [NSString stringWithFormat:@"%@领取了你的红包",receiverID];
                EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
                message.body = body;
                
                [[EMClient sharedClient].chatManager updateMessage:message];
            }
        }
    }
}

/**
 *  群红包，红包被抢的消息
 */
- (void)handleCmdMessages:(NSArray <EMMessage *> *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody * body = (EMCmdMessageBody *)message.body;
        if ([body.action isEqualToString:RedpacketKeyRedapcketCmd]) {
            NSDictionary *dict = message.ext;
            NSString *senderID = [dict valueForKey:RedpacketKeyRedpacketSenderId];
            NSString *receiverID = [dict valueForKey:RedpacketKeyRedpacketReceiverId];
            NSString *currentUserID = [EMClient sharedClient].currentUsername;
            
            if ([senderID isEqualToString:currentUserID]){
                /**
                 *  当前用户是红包发送者。
                 */
                NSString *text = [NSString stringWithFormat:@"%@领取了你的红包",receiverID];
                /*
                 NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
                 */
                EMTextMessageBody *body1 = [[EMTextMessageBody alloc] initWithText:text];
                EMMessage *textMessage = [[EMMessage alloc] initWithConversationID:message.conversationId from:message.from to:message.to body:body1 ext:message.ext];
                textMessage.chatType = message.chatType;
                textMessage.isRead = YES;

                /**
                 *  更新界面
                 */
                BOOL isCurrentConversation = [self.chatVC.conversation.conversationId isEqualToString:message.conversationId];
                
                if (self.chatVC && isCurrentConversation){
                    /**
                     *  刷新当前聊天界面
                     */
                    [self.chatVC addMessageToDataSource:textMessage progress:nil];
                    /**
                     *  存入当前会话并存入数据库
                     */
                    [self.chatVC.conversation insertMessage:textMessage];
                    
                }else {
                    /**
                     *  插入数据库
                     */
                    ConversationListController *listVc = [ChatUIHelper shareHelper].conversationListVC;
                    if (listVc) {
                        for (id <IConversationModel> model in [listVc.dataArray copy]) {
                            EMConversation *conversation = model.conversation;
                            if ([conversation.conversationId isEqualToString:textMessage.conversationId]) {
                                [conversation insertMessage:textMessage];
                            }
                        }
                        
                        [listVc refresh];
                        
                    }else {
                        [[EMClient sharedClient].chatManager importMessages:@[textMessage]];
                    }
                }
            }
        }
    }
}


@end
