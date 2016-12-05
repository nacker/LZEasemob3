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

#import "EaseRefreshTableViewController.h"

#import "EaseUserModel.h"
#import "EaseUserCell.h"
#import "EaseSDKHelper.h"

@class EaseUsersListViewController;

@protocol EMUserListViewControllerDelegate <NSObject>

- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel;

@optional

- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didDeleteUserModel:(id<IUserModel>)userModel;

@end

@protocol EMUserListViewControllerDataSource <NSObject>

@optional

- (NSInteger)numberOfRowInUserListViewController:(EaseUsersListViewController *)userListViewController;

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy;

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                   userModelForIndexPath:(NSIndexPath *)indexPath;

@end

@interface EaseUsersListViewController : EaseRefreshTableViewController

@property (weak, nonatomic) id<EMUserListViewControllerDelegate> delegate;

@property (weak, nonatomic) id<EMUserListViewControllerDataSource> dataSource;

@property (nonatomic) BOOL showSearchBar;

- (void)tableViewDidTriggerHeaderRefresh;

@end
