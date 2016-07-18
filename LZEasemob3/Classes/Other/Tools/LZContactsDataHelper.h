//
//  LZContactsDataHelper.h
//  LZEasemob
//
//  Created by nacker on 16/4/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZContactsDataHelper : NSObject

/**
 *  格式化好友列表
 */
+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array;
+ (NSMutableArray *) getFriendListSectionBy:(NSMutableArray *)array;

@end
