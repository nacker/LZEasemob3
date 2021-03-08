//
//  YZHUserConfig.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedPacketUserConfig.h"
#import "UserProfileManager.h"
#import "YZHRedpacketBridge.h"
#import "RedpacketMessageModel.h"
#import "ChatDemoHelper.h"

/**
 *  环信IMToken过期
 */
#define RedpacketEaseMobTokenOutDate  20304


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
        [YZHRedpacketBridge sharedBridge].isDebug = YES;
        
        [__sharedConfig__ beginObserve];
    });
    
    [__sharedConfig__ beginObserveMessage];
    
    return __sharedConfig__;
}

- (void)configWithAppKey:(NSString *)appKey
{
    _dealerAppKey = appKey;
}

#pragma mark - YZHRedpacketBridgeDataSource

/**
 *  获取当前用户登陆信息，YZHRedpacketBridgeDataSource
 */
- (RedpacketUserInfo *)redpacketUserInfo
{
    RedpacketUserInfo *userInfo = [RedpacketUserInfo new];
    userInfo.userId = [EMClient sharedClient].currentUsername;
    
    UserProfileEntity *entity = [[UserProfileManager sharedInstance] getCurUserProfile];
    NSString *nickname = entity.nickname;
    userInfo.userNickname = nickname.length > 0 ? nickname : userInfo.userId;
    userInfo.userAvatar = entity.imageUrl;;
    
    return userInfo;
}

#pragma mark - YZHRedpacketBridgeDelegate

- (void)redpacketError:(NSString *)error withErrorCode:(NSInteger)code
{
    if (code == RedpacketEaseMobTokenOutDate) {
        //  环信IMToken 过期
        [self configUserToken:YES];
    }
}

#pragma mark - 
#pragma mark 用户登录状态监控

//  监测用户登录状态
- (void)userLoginChanged:(NSNotification *)notifaction
{
    BOOL isLoginSuccess = [[notifaction object] boolValue];
    if (isLoginSuccess) {
        [self configUserToken:NO];
    }
}

- (void)didAutoLoginWithError:(EMError *)aError
{
    if (!aError) {
        [self configUserToken:NO];
    }
}

- (void)configUserToken:(BOOL)isRefresh
{
    if (![EMClient sharedClient].isLoggedIn) {
        return;
    }
    
    NSString *userToken = nil;
    EMClient *client = [EMClient sharedClient];
    SEL selector = NSSelectorFromString(@"getUserToken:");
    if ([client respondsToSelector:selector]) {
        IMP imp = [client methodForSelector:selector];
        NSString *(*func)(id, SEL, NSNumber *) = (void *)imp;
        userToken = func(client, selector, @(isRefresh));
    }
    /*
    if ([[EMClient sharedClient] respondsToSelector:@selector(getUserToken:)]) {
        userToken = [[EMClient sharedClient] performSelector:@selector(getUserToken:) withObject:@(isRefresh)];
    }
    */
    
    NSString *userId = self.redpacketUserInfo.userId;
    if (userToken.length) {
        [[YZHRedpacketBridge sharedBridge] configWithAppKey:_dealerAppKey
                                                  appUserId:userId
                                                    imToken:userToken];
    }
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
        if (dict) {
            NSString *senderID = [dict valueForKey:RedpacketKeyRedpacketSenderId];
            NSString *currentUserID = [EMClient sharedClient].currentUsername;
            BOOL isSender = [senderID isEqualToString:currentUserID];
            
            NSString *text;
            
            /**
             *  当前用户是红包发送者。
             */
            if ([RedpacketMessageModel isRedpacketTakenMessage:dict] && isSender) {
                NSString *receiver = [dict valueForKey:RedpacketKeyRedpacketReceiverNickname];
                if (receiver.length == 0) {
                    receiver = [dict valueForKey:RedpacketKeyRedpacketReceiverId];
                }
                
                text = [NSString stringWithFormat:@"%@领取了你的红包",receiver];
                
            }else if ([RedpacketMessageModel isRedpacketTransferMessage:message.ext]) {
                /**
                 *  转账且不是转账发送方，则需要修改文案
                 */
                if (!isSender) {
                    text = [NSString stringWithFormat:@"[转账]向你转账%@元", [dict valueForKey:RedpacketKeyRedpacketTransferAmout]];
                }
            }
            
            if (text && text.length > 0) {
                EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
                message.body = body;
                /**
                 *  把相应数据更新到数据库
                 */
                [[EMClient sharedClient].chatManager updateMessage:message completion:nil];
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
            NSString *conversationId = [message.ext valueForKey:RedpacketKeyRedpacketCmdToGroup];
            
            if ([senderID isEqualToString:currentUserID]){
                /**
                 *  当前用户是红包发送者
                 */
                NSString *text = [NSString stringWithFormat:@"%@领取了你的红包",receiverID];
                /*
                 NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
                 */
                EMTextMessageBody *body1 = [[EMTextMessageBody alloc] initWithText:text];
                EMMessage *textMessage = [[EMMessage alloc] initWithConversationID:conversationId from:message.from to:conversationId body:body1 ext:message.ext];
                textMessage.chatType = EMChatTypeGroupChat;
                textMessage.isRead = YES;

                /**
                 *  更新界面
                 */
                BOOL isCurrentConversation = [self.chatVC.conversation.conversationId isEqualToString:conversationId];
                
                if (self.chatVC && isCurrentConversation){
                    /**
                     *  刷新当前聊天界面
                     */
                    [self.chatVC addMessageToDataSource:textMessage progress:nil];
                    /**
                     *  存入当前会话并存入数据库
                     */
                    [self.chatVC.conversation appendMessage:textMessage error:nil];
                    
                }else {
                    /**
                     *  插入数据库
                     */
                    ConversationListController *listVc = [ChatDemoHelper shareHelper].conversationListVC;
                    if (listVc) {
                        for (id <IConversationModel> model in [listVc.dataArray copy]) {
                            EMConversation *conversation = model.conversation;
                            if ([conversation.conversationId isEqualToString:textMessage.conversationId]) {
                                [conversation appendMessage:textMessage error:nil];
                                break;
                            }
                        }
                        
                        [listVc refresh];
                        
                    }else {
                        [[EMClient sharedClient].chatManager importMessages:@[textMessage] completion:nil];
                    }
                }
            }
        }
    }
}


@end
