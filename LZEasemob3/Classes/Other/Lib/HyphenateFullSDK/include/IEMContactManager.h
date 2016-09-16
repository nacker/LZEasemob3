/*!
 *  \~chinese
 *  @header IEMContactManager.h
 *  @abstract 此协议定义了好友相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMContactManager.h
 *  @abstract The protocol defines the operations of contact
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMContactManagerDelegate.h"

@class EMError;

/*!
 *  \~chinese
 *  好友相关操作
 *
 *  \~english
 *  Contact Management
 */
@protocol IEMContactManager <NSObject>

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
- (void)addDelegate:(id<EMContactManagerDelegate>)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/*!
 *  \~chinese
 *  添加回调代理
 *
 *  @param aDelegate  要添加的代理
 *
 *  \~english
 *  Add delegate
 *
 *  @param aDelegate  Delegate
 */
- (void)addDelegate:(id<EMContactManagerDelegate>)aDelegate;

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
- (void)removeDelegate:(id)aDelegate;

/*!
 *  \~chinese
 *  获取本地存储的所有好友
 *
 *  @result 好友列表<NSString>
 *
 *  \~english
 *  Get all contacts
 *
 *  @result Contact list<EMGroup>
 */
- (NSArray *)getContacts;

/*!
 *  \~chinese
 *  从本地获取黑名单列表
 *
 *  @result 黑名单列表<NSString>
 *
 *  \~english
 *  Get the blacklist of blocked users
 *
 *  @result Blacklist<EMGroup>
 */
- (NSArray *)getBlackList;

#pragma mark - Sync method

/*!
 *  \~chinese
 *  从服务器获取所有的好友
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError 错误信息
 *
 *  @return 好友列表<NSString>
 *
 *  \~english
 *  Get all the contacts from the server
 *
 *  @param pError Error
 *
 *  @return Contact list<NSString>
 */
- (NSArray *)getContactsFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  添加好友
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername  要添加的用户
 *  @param aMessage   邀请信息
 *
 *  @return 错误信息
 *
 *  \~english
 *  Add a contact with invitation message
 *
 *  @param aUsername  The user to add
 *  @param aMessage   Invitation message
 *
 *  @return Error
 */
- (EMError *)addContact:(NSString *)aUsername
                message:(NSString *)aMessage;

/*!
 *  \~chinese
 *  删除好友
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 要删除的好友
 *
 *  @return 错误信息
 *
 *  \~english
 *  Delete a contact
 *
 *  @param aUsername The user to delete
 *
 *  @return Error
 */
- (EMError *)deleteContact:(NSString *)aUsername;

#pragma mark - Black List

/*!
 *  \~chinese
 *  从服务器获取黑名单列表
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError 错误信息
 *
 *  @return 黑名单列表<NSString>
 *
 *  \~english
 *  Get the blacklist from the server
 *
 *  @param pError Error
 *
 *  @return Blacklist<NSString>
 */
- (NSArray *)getBlackListFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  将用户加入黑名单
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 要加入黑命单的用户
 *  @param aBoth     是否同时屏蔽发给对方的消息
 *
 *  @return 错误信息
 *
 *  \~english
 *  Add a user to blacklist
 *
 *  @param aUsername Block user
 *  @param aBoth     if aBoth is YES, then hide user and block messages from blocked user; if NO, then hide user from blocked user
 *
 *  @return Error
 */
- (EMError *)addUserToBlackList:(NSString *)aUsername
               relationshipBoth:(BOOL)aBoth;

/*!
 *  \~chinese
 *  将用户移出黑名单
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 要移出黑命单的用户
 *
 *  @return 错误信息
 *
 *  \~english
 *  Remove user out of blacklist
 *
 *  @param aUsername Unblock user
 *
 *  @return Error
 */
- (EMError *)removeUserFromBlackList:(NSString *)aUsername;

/*!
 *  \~chinese
 *  同意加好友的申请
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 申请者
 *
 *  @return 错误信息
 *
 *  \~english
 *  Accept a friend request
 *
 *  @param aUsername User who initiated the friend request
 *
 *  @return Error
 */
- (EMError *)acceptInvitationForUsername:(NSString *)aUsername;

/*!
 *  \~chinese
 *  拒绝加好友的申请
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername 申请者
 *
 *  @return 错误信息
 *
 *  \~english
 *  Decline a friend request
 *
 *  @param aUsername User who initiated the friend request
 *
 *  @return Error
 *
 * Please use the new method 
 * - (void)declineFriendRequestFromUser:(NSString *)aUsername
 *                           completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;
 */
- (EMError *)declineInvitationForUsername:(NSString *)aUsername;

#pragma mark - Async method

/*!
 *  \~chinese
 *  从服务器获取所有的好友
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Get all contacts from the server
 *
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getContactsFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  添加好友
 *
 *  @param aUsername        要添加的用户
 *  @param aMessage         邀请信息
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Add a contact
 *
 *  @param aUsername        The user to be added
 *  @param aMessage         Friend request message
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addContact:(NSString *)aUsername
           message:(NSString *)aMessage
        completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除好友
 *
 *  @param aUsername        要删除的好友
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Delete a contact
 *
 *  @param aUsername        The user to be deleted
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)deleteContact:(NSString *)aUsername
           completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从服务器获取黑名单列表
 *
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Get the blacklist from the server
 *
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)getBlackListFromServerWithCompletion:(void (^)(NSArray *aList, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将用户加入黑名单
 *
 *  @param aUsername        要加入黑命单的用户
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Add a user to blacklist
 *
 *  @param aUsername        Block user
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)addUserToBlackList:(NSString *)aUsername
                completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  将用户移出黑名单
 *
 *  @param aUsername        要移出黑命单的用户
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Remove a user from blacklist
 *
 *  @param aUsername        Unblock user
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)removeUserFromBlackList:(NSString *)aUsername
                     completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  同意加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Apporove a friend request
 *
 *  @param aUsername        User who initiated the friend request
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)approveFriendRequestFromUser:(NSString *)aUsername
                          completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  拒绝加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Decline a friend request
 *
 *  @param aUsername        User who initiated the friend request
 *  @param aCompletionBlock The callback block of completion
 *
 */
- (void)declineFriendRequestFromUser:(NSString *)aUsername
                          completion:(void (^)(NSString *aUsername, EMError *aError))aCompletionBlock;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  从数据库获取所有的好友
 *
 *  @return 好友列表<NSString>
 *
 *  \~english
 *  Get all the friends from the DB
 *
 *  @return Contact list<NSString>
 */
- (NSArray *)getContactsFromDB __deprecated_msg("Use -getContacts");

/*!
 *  \~chinese
 *  从数据库获取黑名单列表
 *
 *  @return 黑名单列表<NSString>
 *
 *  \~english
 *  Get the blacklist from the DB
 *
 *  @return Blacklist<NSString>
 */
- (NSArray *)getBlackListFromDB __deprecated_msg("Use -getBlackList");

/*!
 *  \~chinese
 *  从服务器获取所有的好友
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Get all the friends from the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetContactsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getContactsFromServerWithCompletion:");

/*!
 *  \~chinese
 *  添加好友
 *
 *  @param aUsername        要添加的用户
 *  @param aMessage         邀请信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Add a contact
 *
 *  @param aUsername        The user to add
 *  @param aMessage         Friend invitation message
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAddContact:(NSString *)aUsername
                message:(NSString *)aMessage
                success:(void (^)())aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addContact:message:completion:");

/*!
 *  \~chinese
 *  删除好友
 *
 *  @param aUsername        要删除的好友
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Delete friend
 *
 *  @param aUsername        The user to delete
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeleteContact:(NSString *)aUsername
                   success:(void (^)())aSuccessBlock
                   failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -deleteContact:completion:");

/*!
 *  \~chinese
 *  从服务器获取黑名单列表
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Get the blacklist from the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetBlackListFromServer:(void (^)(NSArray *aList))aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -getBlackListFromServerWithCompletion:");

/*!
 *  \~chinese
 *  将用户加入黑名单
 *
 *  @param aUsername        要加入黑命单的用户
 *  @param aBoth            是否同时屏蔽发给对方的消息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Add user to blacklist
 *
 *  @param aUsername        The user to add
 *  @param aBoth            Whether block messages from me to the user which is added to the black list
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAddUserToBlackList:(NSString *)aUsername
               relationshipBoth:(BOOL)aBoth
                        success:(void (^)())aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -addUserToBlackList:completion:");

/*!
 *  \~chinese
 *  将用户移出黑名单
 *
 *  @param aUsername        要移出黑命单的用户
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Remove user from blacklist
 *
 *  @param aUsername        The user to remove from blacklist
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRemoveUserFromBlackList:(NSString *)aUsername
                             success:(void (^)())aSuccessBlock
                             failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -removeUserFromBlackList:completion:");

/*!
 *  \~chinese
 *  同意加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Agree invitation
 *
 *  @param aUsername        Applicants
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptInvitationForUsername:(NSString *)aUsername
                                 success:(void (^)())aSuccessBlock
                                 failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -approveFriendRequestFromUser:completion:");

/*!
 *  \~chinese
 *  拒绝加好友的申请
 *
 *  @param aUsername        申请者
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Decline invitation
 *
 *  @param aUsername        Applicants
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineInvitationForUsername:(NSString *)aUsername
                                  success:(void (^)())aSuccessBlock
                                  failure:(void (^)(EMError *aError))aFailureBlock __deprecated_msg("Use -declineFriendRequestFromUser:completion:");
@end
