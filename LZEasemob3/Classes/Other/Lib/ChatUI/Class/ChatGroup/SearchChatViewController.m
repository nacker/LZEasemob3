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
        EMMessage *firstMessage = [self.conversation loadMessageWithId:self.upMessageId];
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
    dispatch_async(_searchMessageQueue, ^{
        NSArray *moreMessages = nil;
        if (direction) {
            moreMessages = [self.conversation loadMoreMessagesFromId:self.upMessageId limit:SEARCHCHAT_PAGE_SIZE direction:EMMessageSearchDirectionUp];
            if ([moreMessages count] > 0) {
                EMMessage *firstMessage = [moreMessages firstObject];
                self.upMessageId = firstMessage.messageId;
            }
            
        } else {
            moreMessages = [self.conversation loadMoreMessagesFromId:self.downMessageId limit:SEARCHCHAT_PAGE_SIZE direction:EMMessageSearchDirectionDown];
            if ([moreMessages count] > 0) {
                EMMessage *lastMessage = [moreMessages lastObject];
                self.downMessageId = lastMessage.messageId;
            }
        }
        
        if ([moreMessages count] == 0) {
            [weakSelf tableViewDidFinishTriggerHeader:direction reload:YES];
            return;
        }
        
        //格式化消息
        NSArray *formattedMessages;
        if ([weakSelf respondsToSelector:@selector(formatMessages:)]) {
            formattedMessages = [weakSelf performSelector:@selector(formatMessages:) withObject:moreMessages];
        } else {
            formattedMessages = moreMessages;
        }
        
        NSInteger scrollToIndex = 0;
        
        if (direction) {
            [weakSelf.messsagesSource insertObjects:moreMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [moreMessages count])]];
        } else {
            [weakSelf.messsagesSource addObjectsFromArray:moreMessages];
        }
        
        //合并消息
        id object = [weakSelf.dataArray firstObject];
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *timestamp = object;
            [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                {
                    [weakSelf.dataArray removeObjectAtIndex:0];
                    *stop = YES;
                }
            }];
        }
        scrollToIndex = [weakSelf.dataArray count];
        if (direction) {
            [weakSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
        } else {
            [weakSelf.dataArray addObjectsFromArray:formattedMessages];
        }
        
        //刷新页面
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            if (direction) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } else {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count]  - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
        
        [weakSelf tableViewDidFinishTriggerHeader:direction reload:YES];
    });
}


@end
