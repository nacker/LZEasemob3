//
//  RedpacketUserAccount.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/1.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZHRedpacketBridgeProtocol.h"


@interface YZHRedpacketBridge : NSObject

@property (nonatomic, weak) id <YZHRedpacketBridgeDelegate> delegate;

@property (nonatomic, weak) id <YZHRedpacketBridgeDataSource>dataSource;


+ (YZHRedpacketBridge *)sharedBridge;

/**
 *  检测Token是否存在
 */
@property (nonatomic, readonly, getter=isRedpacketTokenExist) BOOL redpacketTokenExist;

/* 以下2种方法，根据IM选择其一 */

/**
 *  Method1:通过签名的方式获取Token (以下参数均需要由AppServer提供签名接口支持，签名方法见集成文档)
 *  此方法目前适应于：腾讯IM， 未适配的可联系我们
 *
 *  @param sign       签名接口返回参数
 *  @param partner    签名接口返回参数
 *  @param appUserid  签名接口返回参数 - 用户在App的用户ID
 *  @param timeStamp  签名接口返回参数 - 时间戳
 */
- (void)configWithSign:(NSString *)sign
               partner:(NSString *)partner
             appUserId:(NSString *)appUserid
             timeStamp:(long)timeStamp;

/**
 *  Method2: 通过验证imToken的方式获取Token
 *
 *  @param appKey    商户在环信申请的APPKey
 *  @param appUserId 用户在App的用户ID，默认与imUserid相同
 *  @param imUserId  用户在IM的登陆ID
 *  @param userPass  用户的登陆密码，用于验证环信Token
 */
- (void)configWithAppKey:(NSString *)appKey
               appUserId:(NSString *)appUserId
                imUserId:(NSString*)imUserId
           andImUserpass:(NSString *)userPass;

/**
 *  Method3: 适用于环信2.0版本SDK
 *
 *  @param appKey    商户在环信申请的AppKey
 *  @param appUserId 用户在App的用户ID， 默认与imUserId相同
 *  @param imToken   环信IM的Token
 */
- (void)configWithAppKey:(NSString *)appKey
               appUserId:(NSString *)appUserId
                 imToken:(NSString *)imToken;


/**
 *  用户退出登录，或者在其它地点登录后，清除用户信息
 */
- (void)redpacketUserLoginOut;

/**
 *   重新请求红包用户Token
 */
- (void)reRequestRedpacketUserToken;



@end
