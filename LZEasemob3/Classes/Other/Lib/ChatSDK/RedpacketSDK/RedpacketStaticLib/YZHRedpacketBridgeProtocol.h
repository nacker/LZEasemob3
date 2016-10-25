//
//  YZHRedpacketBridgeProtocol.h
//  RedpacketLib
//
//  Created by Mr.Yang on 16/4/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#ifndef YZHRedpacketBridgeProtocol_h
#define YZHRedpacketBridgeProtocol_h

 /// 用通知减少耦合

@class RedpacketUserInfo;

typedef NS_ENUM(NSInteger, RequestTokenMethod) {
    /**
     *  通过ImToken验证
     */
    RequestTokenMethodByImToken,
    /**
     *  通过签名验证
     */
    RequestTokenMethodBySign
};

@protocol YZHRedpacketBridgeDataSource <NSObject>

/**
 *  主动获取App用户的用户信息
 *
 *  @return 用户信息Info
 */
- (RedpacketUserInfo *)redpacketUserInfo;

@end


@protocol YZHRedpacketBridgeDelegate <NSObject>

/**
 *  环信Token过期会回调这个方法
 *
 *  @param method 用到的获取Token的方法
 */
- (void)redpacketUserTokenGetInfoByMethod:(RequestTokenMethod)method;

@end


#endif /* YZHRedpacketBridgeProtocol_h */
