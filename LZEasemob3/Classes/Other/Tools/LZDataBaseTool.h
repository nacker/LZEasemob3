//
//  LZDataBaseTool.h
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZDataBaseTool : NSObject

// 沙盒相关
+ (void)saveToUserDefaults:(id)object key:(NSString *)key;
+ (id)getUserDefaultsWithKey:(NSString *)key;

+ (void)saveLastLoginUsername;
+ (NSString*)lastLoginUsername;

@end
