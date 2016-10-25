/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "GroupListViewController.h"

@interface ContactListViewController : EaseUsersListViewController

@property (strong, nonatomic) GroupListViewController *groupController;

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//群组变化时，更新群组页面
- (void)reloadGroupView;

//好友个数变化时，重新获取数据
- (void)reloadDataSource;

//添加好友的操作被触发
- (void)addFriendAction;

@end
