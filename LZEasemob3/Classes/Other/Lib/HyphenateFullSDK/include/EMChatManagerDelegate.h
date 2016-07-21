/*!
 *  \~chinese
 *  @header EMChatManagerDelegate.h
 *  @abstract 此协议定义了聊天相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMChatManagerDelegate.h
 *  @abstract This protocol defined the callbacks of chat
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@class EMMessage;
@class EMError;

/*!
 *  \~chinese
 *  聊天相关回调
 *
 *  \~english
 *  Chat related callbacks
 */
@protocol EMChatManagerDelegate <NSObject>

@optional

#pragma mark - Conversation

/*!
 *  \~chinese
 *  会话列表发生变化
 *
 *  @param aConversationList  会话列表<EMConversation>
 *
 *  \~english
 *  The conversation list has changed
 *
 *  @param aConversationList  Conversation list<EMConversation>
 */
- (void)didUpdateConversationList:(NSArray *)aConversationList;

#pragma mark - Message

/*!
 *  \~chinese
 *  收到消息
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  \~english
 *  Received messages
 *
 *  @param aMessages  Message list<EMMessage>
 */
- (void)didReceiveMessages:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到Cmd消息
 *
 *  @param aCmdMessages  Cmd消息列表<EMMessage>
 *
 *  \~english
 *  Received cmd messages
 *
 *  @param aCmdMessages  Cmd message list<EMMessage>
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages;

/*!
 *  \~chinese
 *  收到已读回执
 *
 *  @param aMessages  已读消息列表<EMMessage>
 *
 *  \~english
 *  Received read acks
 *
 *  @param aMessages  Read acked message list<EMMessage>
 */
- (void)didReceiveHasReadAcks:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到消息送达回执
 *
 *  @param aMessages  送达消息列表<EMMessage>
 *
 *  \~english
 *  Received deliver acks
 *
 *  @param aMessages  Deliver acked message list<EMMessage>
 */
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  消息状态发生变化
 *
 *  @param aMessage  状态发生变化的消息
 *  @param aError    出错信息
 *
 *  \~english
 *  Message status has changed
 *
 *  @param aMessage  Message whose status changed
 *  @param aError    Error info
 */
- (void)didMessageStatusChanged:(EMMessage *)aMessage
                          error:(EMError *)aError;

/*!
 *  \~chinese
 *  消息附件状态发生改变
 *  
 *  @param aMessage  附件状态发生变化的消息
 *  @param aError    错误信息
 *
 *  \~english
 *  Attachment status has changed
 *
 *  @param aMessage  Message whose attachment status changed
 *  @param aError    Error
 */
- (void)didMessageAttachmentsStatusChanged:(EMMessage *)aMessage
                                     error:(EMError *)aError;

@end
