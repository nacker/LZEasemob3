//
//  ChatUIDefine.h
//  ChatDemo-UI3.0
//
//  Created by 马骏斌 on 16/6/6.
//  Copyright © 2016年 马骏斌. All rights reserved.
//

#ifndef ChatUIDefine_h
#define ChatUIDefine_h

// 消息通知
#define kSetupUntreatedApplyCount @"setupUntreatedApplyCount"// 未处理的好友申请
#define kSetupUnreadMessageCount @"setupUnreadMessageCount"// 未读聊天消息数
#define kConnectionStateChanged @"ChatConnectionStateChanged"// 环信服务器连接状态改变

// 注册通知
#define NOTIFY_ADD(_noParamsFunc, _notifyName)  [[NSNotificationCenter defaultCenter] \
addObserver:self \
selector:@selector(_noParamsFunc) \
name:_notifyName \
object:nil];

// 发送通知
#define NOTIFY_POST(_notifyName)   [[NSNotificationCenter defaultCenter] postNotificationName:_notifyName object:nil];

// 移除通知
#define NOTIFY_REMOVE(_notifyName) [[NSNotificationCenter defaultCenter] removeObserver:self name:_notifyName object:nil];

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#endif /* GlobalDefine_h */
