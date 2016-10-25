//
//  UserCacheManager.m
//  ypp
//
//  Created by Stephen Chin on 16/06/05.
//  Copyright © 2016 martin. All rights reserved.
//

#import "UserCacheManager.h"
#import "FMDB.h"

#define DBNAME @"user_cache_data.db"
static FMDatabaseQueue *_queue;

@implementation UserCacheInfo

@end

@implementation UserCacheManager

+(void)initialize{
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:DBNAME];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists userinfo (userid text, username text, userimage text)"];
    }];
}

/**
 *  执行一个更新语句
 *
 *  @param sql 更新语句的sql
 *
 *  @return 更新语句的执行结果
 */
+(BOOL)executeUpdate:(NSString *)sql{
    
    __block BOOL updateRes = NO;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        updateRes = [db executeUpdate:sql];
    }];
    
    return updateRes;
}


/**
 *  执行一个查询语句
 *
 *  @param sql              查询语句sql
 *  @param queryResBlock    查询语句的执行结果
 */
+(void)executeQuery:(NSString *)sql queryResBlock:(void(^)(FMResultSet *set))queryResBlock{
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:sql];
        
        if(queryResBlock != nil) queryResBlock(set);
        
    }];
}

/**
 *  用户是否存在
 *
 *  @param userId 用户环信ID
 *
 *  @return 是否存在
 */
+(BOOL)isExistUser:(NSString *)userId{
    
    NSString *alias=@"count";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS %@ FROM userinfo where userid = '%@'", alias, userId];
    
    __block NSUInteger count=0;
    
    [self executeQuery:sql queryResBlock:^(FMResultSet *set) {
        
        while ([set next]) {
            
            count = [[set stringForColumn:alias] integerValue];
        }
    }];
    
    return count > 0;
}

/**
 *  清空表（但不清除表结构）
 *
 *  @return 操作结果
 */
+(BOOL)clearTableData{
    
    BOOL res = [self executeUpdate:@"DELETE FROM userinfo"];
    [self executeUpdate:@"DELETE FROM sqlite_sequence WHERE name='userinfo';"];
    return res;
}

/*
 *保存用户信息（如果已存在，则更新）
 *userId: 用户环信ID
 *imgUrl：用户头像链接（完整路径）
 *nickName: 用户昵称
 */
+(void)saveInfo:(NSString*)userId
         imgUrl:(NSString*)imgUrl
       nickName:(NSString*)nickName{
    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
    [extDic setValue:userId forKey:kChatUserId];
    [extDic setValue:imgUrl forKey:kChatUserPic];
    [extDic setValue:nickName forKey:kChatUserNick];
    [UserCacheManager saveInfo:extDic];
}

+(void)saveInfo:(NSDictionary *)userinfo{
    NSString *userid = [userinfo objectForKey:kChatUserId];
    NSString *username = [userinfo objectForKey:kChatUserNick];
    NSString *userimage = [userinfo objectForKey:kChatUserPic];
    NSString *sql = @"";
    
    BOOL isExistUser = [self isExistUser:userid];
    if (isExistUser) {
        sql = [NSString stringWithFormat:@"update userinfo set username='%@', userimage='%@' where userid='%@'", username,userimage,userid];
    }else{
        sql = [NSString stringWithFormat:@"INSERT INTO userinfo (userid, username, userimage) VALUES ('%@', '%@', '%@')", userid,username,userimage];
    }
    
    [self executeUpdate:sql];
    
#if DEBUG
    [self queryAll];
#endif
    
}

+(void)queryAll{
    // 列出所有用户信息
    NSString *sql = @"SELECT userid, username, userimage FROM userinfo";
    [self executeQuery:sql queryResBlock:^(FMResultSet *rs) {
        int i=0;
        while ([rs next]) {
            NSLog(@"%d：-------",i);
            NSLog(@"id：%@",[rs stringForColumn:@"userid"]);
            NSLog(@"name：%@",[rs stringForColumn:@"username"]);
            NSLog(@"image：%@",[rs stringForColumn:@"userimage"]);
            NSLog(@"%d：---end--",i);
            i++;
        }
        [rs close];
    }];
}

// 更新当前用户的昵称
+(void)updateCurrNick:(NSString*)nickName{
    UserCacheInfo *user = [self getCurrUser];
    if (!user)  return;
    
    NSString *sql = [NSString stringWithFormat:@"update userinfo set username='%@' where userid='%@'",nickName, user.Id];
    if ([self executeUpdate:sql]) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
}

/*
 *根据环信ID获取用户信息
 *userId 用户的环信ID
 */
+(UserCacheInfo*)getById:(NSString *)userid{
    
    __block UserCacheInfo *userInfo = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT userid, username, userimage FROM userinfo where userid = '%@'",userid];
    [self executeQuery:sql queryResBlock:^(FMResultSet *rs) {
        if ([rs next]) {
            
            userInfo = [[UserCacheInfo alloc] init];
            
            userInfo.Id = [rs stringForColumn:@"userid"];
            userInfo.NickName = [rs stringForColumn:@"username"];
            userInfo.AvatarUrl = [rs stringForColumn:@"userimage"];
        }
        [rs close];
    }];
    
    return userInfo;
}

/*
 * 根据环信ID获取昵称
 * userId:环信用户id
 */
+(NSString*)getNickById:(NSString*)userId{
    UserCacheInfo *user = [UserCacheManager getById:userId];
    if(user == nil || [user  isEqual: @""]) return userId;// 没有昵称就返回用户ID
    
    return user.NickName;
}

/*
 * 获取当前环信用户信息
 */
+(UserCacheInfo*)getCurrUser{
    return [UserCacheManager getById:kCurrEaseUserId];
}

/*
 * 获取当前环信用户的昵称
 */
+(NSString*)getCurrNickName{
    return [UserCacheManager getNickById:kCurrEaseUserId];
}

@end
