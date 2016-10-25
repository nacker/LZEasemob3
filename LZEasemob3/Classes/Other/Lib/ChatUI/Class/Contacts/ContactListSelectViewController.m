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

#import "ContactListSelectViewController.h"

#import "ChatViewController.h"
#import "UserCacheManager.h"
#import "RedPacketChatViewController.h"


@interface ContactListSelectViewController () <EMUserListViewControllerDelegate,EMUserListViewControllerDataSource>

@end

@implementation ContactListSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark - EMUserListViewControllerDelegate
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel
{
    BOOL flag = YES;
    if (self.messageModel) {
        if (self.messageModel.bodyType == EMMessageBodyTypeText) {
            EMMessage *message = [EaseSDKHelper sendTextMessage:self.messageModel.text to:userModel.buddy messageType:EMChatTypeChat messageExt:self.messageModel.message.ext];
            __weak typeof(self) weakself = self;
            [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
                if (!aError) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
#ifdef REDPACKET_AVALABLE
                    RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
#else
                    ChatViewController *chatController = [[ChatViewController alloc]
#endif
                                                          initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
                    chatController.title = userModel.nickname.length != 0 ? [userModel.nickname copy] : [userModel.buddy copy];
                    if ([array count] >= 3) {
                        [array removeLastObject];
                        [array removeLastObject];
                    }
                    [array addObject:chatController];
                    [weakself.navigationController setViewControllers:array animated:YES];
                } else {
                    [self showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                }
            }];
        } else if (self.messageModel.bodyType == EMMessageBodyTypeImage) {
            flag = NO;
            [self showHudInView:self.view hint:NSLocalizedString(@"transponding", @"transpondFailing...")];
            
            UIImage *image = self.messageModel.image;
            if (!image) {
                image = [UIImage imageWithContentsOfFile:self.messageModel.fileLocalPath];
            }
            
            if (!image) {
                [self hideHud];
                [self showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5];
                return;
            }
            
            EMMessage *message= [EaseSDKHelper sendImageMessageWithImage:image to:userModel.buddy messageType:EMChatTypeChat messageExt:self.messageModel.message.ext];
            
            [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
#ifdef REDPACKET_AVALABLE
                    RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
#else
                    ChatViewController *chatController = [[ChatViewController alloc]
#endif
                                                          initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
                    chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
                    if ([array count] >= 3) {
                        [array removeLastObject];
                        [array removeLastObject];
                    }
                    [array addObject:chatController];
                    [self.navigationController setViewControllers:array animated:YES];
                } else {
                    [self showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                }
            }];
        }
    }
}

#pragma mark - EMUserListViewControllerDataSource
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy
{
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:buddy];
    UserCacheInfo * userInfo = [UserCacheManager getById:model.buddy];
    if (userInfo) {
        model.avatarURLPath = userInfo.AvatarUrl;
        model.nickname = userInfo.NickName;
    }
    return model;
}

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                   userModelForIndexPath:(NSIndexPath *)indexPath
{
    id<IUserModel> model = nil;
    model = [self.dataArray objectAtIndex:indexPath.row];
    UserCacheInfo * userInfo = [UserCacheManager getById:model.buddy];
    if (userInfo) {
        model.avatarURLPath = userInfo.AvatarUrl;
        model.nickname = userInfo.NickName;
    }
    return model;
}

#pragma mark - action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
