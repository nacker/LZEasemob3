//
//  LZUIHelper.m
//  LZEasemob
//
//  Created by nacker on 16/4/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZUIHelper.h"
#import "LZContactsGrounp.h"

@implementation LZUIHelper

+ (NSMutableArray *)getFriensListItemsGroup
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *dicts = @[@{@"title" : NSLocalizedString(@"title.apply", @"Application and notification"), @"icon" : @"plugins_FriendNotify"},
                       @{@"title" : NSLocalizedString(@"title.group", @"Group"), @"icon" : @"add_friend_icon_addgroup"},
                       @{@"title" : NSLocalizedString(@"title.chatroomlist",@"chatroom list"), @"icon" : @"Contact_icon_ContactTag"},
                       @{@"title" : NSLocalizedString(@"title.robotlist",@"robot list"), @"icon" : @"add_friend_icon_offical"}];
    array = [LZContactsGrounp mj_objectArrayWithKeyValuesArray:dicts];
    return array;
}

@end
