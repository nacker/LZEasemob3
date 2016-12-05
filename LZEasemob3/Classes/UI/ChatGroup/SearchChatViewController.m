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

#import "SearchChatViewController.h"

#define SEARCHCHAT_PAGE_SIZE 10

@interface SearchChatViewController ()
{
    dispatch_queue_t _searchMessageQueue;
}

@property (strong, nonatomic) NSString *upMessageId;
@property (strong, nonatomic) NSString *downMessageId;

@end

@implementation SearchChatViewController

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType
                              fromMessageId:(NSString*)messageId
{
    self = [super initWithConversationChatter:conversationChatter conversationType:conversationType];
    if (self) {
        self.upMessageId = messageId;
        self.downMessageId = messageId;
        _searchMessageQueue = dispatch_queue_create("com.easemob.search.chat", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //隐藏底部输入bar
    self.chatToolbar.hidden = YES;
    CGRect frame = self.tableView.frame;
    frame.size.height += CGRectGetHeight(self.chatToolbar.frame);
    self.tableView.frame = frame;
    
    //隐藏item
    self.navigationItem.rightBarButtonItem = nil;
    
    //设置可以向下翻页
    [self setShowRefreshFooter:YES];
    
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
}

- (void)tableViewDidTriggerHeaderRefresh
{
    if ([self.messsagesSource count] == 0) {
        EMMessage *firstMessage = [self.conversation loadMessageWithId:self.upMessageId error:nil];
        [self addMessageToDataSource:firstMessage progress:nil];
    }
    
    [self _loadMessagesDirection:YES];
}

- (void)tableViewDidTriggerFooterRefresh
{
    [self _loadMessagesDirection:NO];
}


- (void)_loadMessagesDirection:(BOOL)direction
{
    __weak typeof(self) weakSelf = self;
    [self.conversation loadMessagesStartFromId:self.upMessageId count:SEARCHCHAT_PAGE_SIZE searchDirection:direction ? EMMessageSearchDirectionUp : EMMessageSearchDirectionDown completion:^(NSArray *aMessages, EMError *aError) {
        SearchChatViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if (!aError) {
                if ([aMessages count] > 0) {
                    if (direction) {
                        EMMessage *firstMessage = [aMessages firstObject];
                        strongSelf.upMessageId = firstMessage.messageId;
                    }
                    else {
                        EMMessage *lastMessage = [aMessages lastObject];
                        strongSelf.downMessageId = lastMessage.messageId;
                    }
                    
                    NSArray *formattedMessages = aMessages;
                    NSInteger scrollToIndex = 0;
                    
                    if (direction) {
                        [strongSelf.messsagesSource insertObjects:aMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [aMessages count])]];
                    } else {
                        [strongSelf.messsagesSource addObjectsFromArray:aMessages];
                    }
                    
                    id object = [strongSelf.dataArray firstObject];
                    if ([object isKindOfClass:[NSString class]]) {
                        NSString *timestamp = object;
                        [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                            if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                            {
                                [strongSelf.dataArray removeObjectAtIndex:0];
                                *stop = YES;
                            }
                        }];
                    }
                    scrollToIndex = [strongSelf.dataArray count];
                    if (direction) {
                        [strongSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                    } else {
                        [strongSelf.dataArray addObjectsFromArray:formattedMessages];
                    }
                    
                    [strongSelf.tableView reloadData];
                    if (direction) {
                        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[strongSelf.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    } else {
                        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[strongSelf.dataArray count]  - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }
                [strongSelf tableViewDidFinishTriggerHeader:direction reload:YES];
            }
        }
    }];
}


@end
