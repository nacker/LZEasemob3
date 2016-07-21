/*!
 *  \~chinese
 *  @header IEMChatroomManager.h
 *  @abstract 此协议定义了聊天室相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMChatroomManager.h
 *  @abstract This protocol defined the chatroom operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMChatroomManagerDelegate.h"
#import "EMChatroom.h"

@class EMError;

/*!
 *  \~chinese
 *  聊天室相关操作
 *
 *  \~english
 *  Chatroom operations
 */
@protocol IEMChatroomManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *  @param aQueue     添加回调代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 *  @param aQueue     The queue of call delegate method
 */
- (void)addDelegate:(id<EMChatroomManagerDelegate>)aDelegate
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
- (void)removeDelegate:(id<EMChatroomManagerDelegate>)aDelegate;

#pragma mark - Sync method

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError   出错信息
 *
 *  @return 聊天室列表<EMChatroom>
 *
 *  \~english
 *  Get all the chatrooms from server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError   Error
 *
 *  @return Chat room list<EMChatroom>
 */
- (NSArray *)getAllChatroomsFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室的ID
 *  @param pError       返回的错误信息
 *
 *  @result 所加入的聊天室
 *
 *  \~english
 *  Join a chatroom
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result Joined chatroom
 */
- (EMChatroom *)joinChatroom:(NSString *)aChatroomId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId  聊天室ID
 *  @param pError       错误信息
 *
 *  @result 退出的聊天室, 失败返回nil
 *
 *  \~english
 *  Leave a chatroom
 *
 *  Synchronization method will block the current thread
 *
 *  @param aChatroomId  Chatroom id
 *  @param pError       Error
 *
 *  @result Leaved chatroom
 */
- (EMChatroom *)leaveChatroom:(NSString *)aChatroomId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取聊天室详情
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param pError                错误信息
 *
 *  @return    聊天室
 *
 *  \~english
 *  Fetch chatroom's specification
 *
 *  Synchronization method, will block the current thread
 *
 *  @param aChatroomId           Chatroom id
 *  @param aIncludeMembersList   Whether get member list
 *  @param pError                Error
 *
 *  @return    Chatroom instance
 */
- (EMChatroom *)fetchChatroomInfo:(NSString *)aChatroomId
               includeMembersList:(BOOL)aIncludeMembersList
                            error:(EMError **)pError;

#pragma mark - Async method

/*!
 *  \~chinese
 *  从服务器获取所有的聊天室
 *
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *  \~english
 *  Get all the chatrooms from server
 *
 *  @param aSuccessBlock         The callback block of success
 *  @param aFailureBlock         The callback block of failure
 *
 */
- (void)asyncGetAllChatroomsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  加入聊天室
 *
 *  @param aChatroomId      聊天室的ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Join a chatroom
 *
 *  @param aChatroomId      Chatroom id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncJoinChatroom:(NSString *)aChatroomId
                  success:(void (^)(EMChatroom *aRoom))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  退出聊天室
 *
 *  @param aChatroomId          聊天室ID
 *  @param aSuccessBlock        成功的回调
 *  @param aFailureBlock        失败的回调
 *
 *  @result 退出的聊天室
 *
 *  \~english
 *  Leave a chatroom
 *
 *  @param aChatroomId      Chatroom id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 *  @result Leaved chatroom
 */
- (void)asyncLeaveChatroom:(NSString *)aChatroomId
                   success:(void (^)(EMChatroom *aRoom))aSuccessBlock
                   failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  获取聊天室详情
 *
 *  @param aChatroomId           聊天室ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *  \~english
 *  Fetch chatroom's specification
 *
 *  @param aChatroomId           Chatroom id
 *  @param aIncludeMembersList   Whether get member list
 *  @param aSuccessBlock         The callback block of success
 *  @param aFailureBlock         The callback block of failure
 *
 */
- (void)asyncFetchChatroomInfo:(NSString *)aChatroomId
            includeMembersList:(BOOL)aIncludeMembersList
                       success:(void (^)(EMChatroom *aChatroom))aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock;
@end
