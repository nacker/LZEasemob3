//
//  UserCacheManager.m
//  ypp
//
//  Created by Stephen Chin on 16/06/05.
//  Copyright © 2016 martin. All rights reserved.
//

#import <Foundation/Foundation.h>

// 环信聊天用的昵称和头像（发送聊天消息时，要附带这3个属性）
#define kChatUserId @"ChatUserId"// 环信账号
#define kChatUserNick @"ChatUserNick"
#define kChatUserPic @"ChatUserPic"

#define kCurrEaseUserId [[EMClient sharedClient] currentUsername]// 当前用户的环信ID

@interface UserCacheInfo : NSObject
@property(nonatomic,copy)NSString* Id;
@property(nonatomic,copy)NSString* NickName;
@property(nonatomic,copy)NSString* AvatarUrl;
@end


@interface UserCacheManager : NSObject

/*
 *保存用户信息（如果已存在，则更新）
 *userId: 用户环信ID
 *imgUrl：用户头像链接（完整路径）
 *nickName: 用户昵称
 */
+(void)saveInfo:(NSString *)userId
         imgUrl:(NSString*)imgUrl
       nickName:(NSString*)nickName;

/*
 *保存用户信息
 */
+(void)saveInfo:(NSDictionary *)userinfo;

// 更新当前用户的昵称
+(void)updateCurrNick:(NSString*)nickName;

/*
 *根据环信ID获取用户信息
 *userId 用户的环信ID
 */
+(UserCacheInfo*)getById:(NSString *)userid;

/*
 * 根据环信ID获取昵称
 * userId:环信用户id
 */
+(NSString*)getNickById:(NSString*)userId;

/*
 * 获取当前环信用户信息
 */
+(UserCacheInfo*)getCurrUser;

/*
 * 获取当前环信用户的昵称
 */
+(NSString*)getCurrNickName;

@end

