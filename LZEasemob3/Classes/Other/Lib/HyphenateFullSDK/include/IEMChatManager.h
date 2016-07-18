/*!
 *  \~chinese
 *  @header IEMChatManager.h
 *  @abstract 此协议定义了聊天相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatManager.h
 *  @abstract This protocol defined the operations of chat
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMChatManagerDelegate.h"
#import "EMConversation.h"

#import "EMMessage.h"
#import "EMTextMessageBody.h"
#import "EMLocationMessageBody.h"
#import "EMCmdMessageBody.h"
#import "EMFileMessageBody.h"
#import "EMImageMessageBody.h"
#import "EMVoiceMessageBody.h"
#import "EMVideoMessageBody.h"

@class EMError;

/*!
 *  \~chinese
 *  聊天相关操作
 *
 *  \~english
 *  Operations of chat
 */
@protocol IEMChatManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     执行代理方法的队列
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<EMChatManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  移除回调代理
 *
 *  @param aDelegate  要移除的代理
 *
 *  \~english
 *  Remove delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)removeDelegate:(id<EMChatManagerDelegate>)aDelegate;

#pragma mark - Conversation

/*!
 *  \~chinese
 *  获取所有会话，如果内存中不存在会从DB中加载
 *
 *  @result 会话列表<EMConversation>
 *
 *  \~english
 *  Get all conversations, will load conversations from DB if not exist in memory
 *
 *  @result Conversation list<EMConversation>
 */
- (NSArray *)getAllConversations;

/*!
 *  \~chinese
 *  从数据库中获取所有的会话，执行后会更新内存中的会话列表
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @result 会话列表<EMConversation>
 *
 *  \~english
 *  Load all conversations from DB, will update conversation list in memory after this method is called
 *
 *  Synchronization method will block the current thread
 *
 *  @result Conversation list<EMConversation>
 */
- (NSArray *)loadAllConversationsFromDB;

/*!
 *  \~chinese
 *  获取一个会话
 *
 *  @param aConversationId  会话ID
 *  @param aType            会话类型
 *  @param aIfCreate        如果不存在是否创建
 *
 *  @result 会话对象
 *
 *  \~english
 *  Get a conversation
 *
 *  @param aConversationId  Conversation id
 *  @param aType            Conversation type
 *  @param aIfCreate        Whether create conversation if not exist
 *
 *  @result Conversation
 */
- (EMConversation *)getConversation:(NSString *)aConversationId
                               type:(EMConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;

/*!
 *  \~chinese
 *  删除会话
 *
 *  @param aConversationId  会话ID
 *  @param aDeleteMessage   是否删除会话中的消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Delete a conversation
 *
 *  @param aConversationId  Conversation id
 *  @param aDeleteMessage   Whether delete messages
 *
 *  @result Whether deleted successfully
 */
- (BOOL)deleteConversation:(NSString *)aConversationId
            deleteMessages:(BOOL)aDeleteMessage;

/*!
 *  \~chinese
 *  删除一组会话
 *
 *  @param aConversations  会话列表<EMConversation>
 *  @param aDeleteMessage  是否删除会话中的消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Delete multiple conversations
 *
 *  @param aConversations  Conversation list<EMConversation>
 *  @param aDeleteMessage  Whether delete messages
 *
 *  @result Whether deleted successfully
 */
- (BOOL)deleteConversations:(NSArray *)aConversations
             deleteMessages:(BOOL)aDeleteMessage;

/*!
 *  \~chinese
 *  导入一组会话到DB
 *
 *  @param aConversations  会话列表<EMConversation>
 *
 *  @result 是否成功
 *
 *  \~english
 *  Import multiple conversations to DB
 *
 *  @param aConversations  Conversation list<EMConversation>
 *
 *  @result Whether imported successfully
 */
- (BOOL)importConversations:(NSArray *)aConversations;

#pragma mark - Message

/*!
 *  \~chinese
 *  获取消息附件路径, 存在这个路径的文件，删除会话时会被删除
 *
 *  @param aConversationId  会话ID
 *
 *  @result 附件路径
 *
 *  \~english
 *  Get message attachment path for the conversation, files in this path will also be deleted when delete the conversation
 *
 *  @param aConversationId  Conversation id
 *
 *  @result Attachment path
 */
- (NSString *)getMessageAttachmentPath:(NSString *)aConversationId;

/*!
 *  \~chinese
 *  导入一组消息到DB
 *
 *  @param aMessages  消息列表<EMMessage>
 *
 *  @result 是否成功
 *
 *  \~english
 *  Import multiple messages
 *
 *  @param aMessages  Message list<EMMessage>
 *
 *  @result Whether imported successfully
 */
- (BOOL)importMessages:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  更新消息到DB
 *
 *  @param aMessage  消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Update message to DB
 *
 *  @param aMessage  Message
 *
 *  @result Whether updated successfully
 */
- (BOOL)updateMessage:(EMMessage *)aMessage;

/*!
 *  \~chinese
 *  发送消息已读回执
 *  
 *  异步方法
 *
 *  @param aMessage  消息
 *
 *  \~english
 *  Send read ack for message
 *
 *  Asynchronous methods
 *
 *  @param aMessage  Message instance
 */
- (void)asyncSendReadAckForMessage:(EMMessage *)aMessage;

/*!
 *  \~chinese
 *  发送消息
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件上传进度回调block
 *  @param aCompletion         发送完成回调block
 *
 *  \~english
 *  Send a message
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The block of attachment upload progress
 *
 *  @param aCompletion         The block of send complete
 */
- (void)asyncSendMessage:(EMMessage *)aMessage
                progress:(void (^)(int progress))aProgressCompletion
              completion:(void (^)(EMMessage *message,
                                   EMError *error))aCompletion;

/*!
 *  \~chinese
 *  重发送消息
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件上传进度回调block
 *  @param aCompletion         发送完成回调block
 *
 *  \~english
 *  Resend Message
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The callback block of attachment upload progress
 *  @param aCompletion         The callback block of send complete
 */
- (void)asyncResendMessage:(EMMessage *)aMessage
                  progress:(void (^)(int progress))aProgressCompletion
                completion:(void (^)(EMMessage *message,
                                     EMError *error))aCompletion;

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message thumbnail attachments (thumbnails of image message or first frame of video image), SDK can download thumbail automatically, so user should NOT download thumbail manually except automatic download failed
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */
- (void)asyncDownloadMessageThumbnail:(EMMessage *)aMessage
                             progress:(void (^)(int progress))aProgressCompletion
                           completion:(void (^)(EMMessage * message,
                                                EMError *error))aCompletion;

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *  
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressCompletion 附件下载进度回调block
 *  @param aCompletion         下载完成回调block
 *
 *  \~english
 *  Download message attachment(voice, video, image or file), SDK can download voice automatically, so user should NOT download voice manually except automatic download failed
 *
 *  Asynchronous methods
 *
 *  @param aMessage            Message instance
 *  @param aProgressCompletion The callback block of attachment download progress
 *  @param aCompletion         The callback block of download complete
 */
- (void)asyncDownloadMessageAttachments:(EMMessage *)aMessage
                               progress:(void (^)(int progress))aProgressCompletion
                             completion:(void (^)(EMMessage *message,
                                                  EMError *error))aCompletion;


@end