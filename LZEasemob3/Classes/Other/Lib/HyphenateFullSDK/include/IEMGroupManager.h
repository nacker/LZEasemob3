/*!
 *  \~chinese
 *  @header IEMGroupManager.h
 *  @abstract 此协议定义了群组相关操作
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header IEMGroupManager.h
 *  @abstract This protocol defined the group operations
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMGroupManagerDelegate.h"
#import "EMGroup.h"
#import "EMGroupOptions.h"
#import "EMCursorResult.h"

/*!
 *  \~chinese
 *  群组相关操作
 *
 *  \~english
 *  Group operations
 */
@protocol IEMGroupManager <NSObject>

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
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate
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
- (void)removeDelegate:(id)aDelegate;

#pragma mark - Get Group

/*!
 *  \~chinese
 *  获取所有群组，如果内存中不存在，则先从DB加载
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Get all groups, will load from DB if not exist in memory
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)getAllGroups;

/*!
 *  \~chinese
 *  从数据库加载所有群组，加载后更新内存中的群组列表
 *
 *  @result 群组列表<EMGroup>
 *
 *  \~english
 *  Load all groups from DB, will update group list in memory after loading
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)loadAllMyGroupsFromDB;

/*!
 *  \~chinese
 *  从内存中获取屏蔽了推送的群组ID列表
 *
 *  @result 群组ID列表<NSString>
 *
 *  \~english
 *  Get ID list of groups which block push from memory
 *
 *  @result Group id list<NSString>
 */
- (NSArray *)getAllIgnoredGroupIds;

#pragma mark - Sync method

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param pError  错误信息
 *
 *  @return 群组列表<EMGroup>
 *
 *  \~english
 *  Get all of user's groups from server, will update group list in memory and DB after success
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError  Error
 *
 *  @result Group list<EMGroup>
 */
- (NSArray *)getMyGroupsFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aCursor   获取公开群的cursor，首次调用传空
 *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param pError    出错信息
 *
 *  @return    获取的公开群结果
 *
 *  \~english
 *  Get public groups in the specified range from the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param aCursor   Cursor, input nil the first time
 *  @param aPageSize Expect result count, will return all results if < 0
 *  @param pError    Error
 *
 *  @return    The result
 */
- (EMCursorResult *)getPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                               pageSize:(NSInteger)aPageSize
                                                  error:(EMError **)pError;

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroundId   群组id
 *  @param pError      错误信息
 *
 *  @return 搜索到的群组
 *
 *  \~english
 *  Search public group with the id
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroundId   Group id
 *  @param pError      Error
 *
 *  @return The group with the id
 */
- (EMGroup *)searchPublicGroupWithId:(NSString *)aGroundId
                               error:(EMError **)pError;

#pragma mark - Create

/*!
 *  \~chinese
 *  创建群组
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject        群组名称
 *  @param aDescription    群组描述
 *  @param aInvitees       群组成员（不包括创建者自己）
 *  @param aMessage        邀请消息
 *  @param aSetting        群组属性
 *  @param pError          出错信息
 *
 *  @return    创建的群组
 *
 *  \~english
 *  Create a group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject        Group subject
 *  @param aDescription    Group description
 *  @param aInvitees       Group members, without creater
 *  @param aMessage        Invitation message
 *  @param aSetting        Group options
 *  @param pError          Error
 *
 *  @return    Created group
 */
- (EMGroup *)createGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                              error:(EMError **)pError;

#pragma mark - Fetch Info

/*!
 *  \~chinese
 *  获取群组详情
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param pError                错误信息
 *
 *  @return    群组
 *
 *  \~english
 *  Fetch group info
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether get member list
 *  @param pError                Error
 *
 *  @return    Group instance
 */
- (EMGroup *)fetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                      error:(EMError **)pError;

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @return    群组黑名单列表<NSString>
 *
 *  \~english
 *  Get group‘s blacklist, need owner’s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @return    Group blacklist<NSString>
 */
- (NSArray *)fetchGroupBansList:(NSString *)aGroupId
                          error:(EMError **)pError;

#pragma mark - Edit Group

/*!
 *  \~chinese
 *  邀请用户加入群组
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants      被邀请的用户名列表
 *  @param aGroupId        群组ID
 *  @param aWelcomeMessage 欢迎信息
 *  @param pError          错误信息
 *
 *  @result    群组实例, 失败返回nil
 *
 *  \~english
 *  Invite User to join a group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants      Invited users
 *  @param aGroupId        Group id
 *  @param aWelcomeMessage Welcome message
 *  @param pError          Error
 *
 *  @result    Group instance, return nil if fail
 */
- (EMGroup *)addOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                    error:(EMError **)pError;

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要移出群组的用户列表
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组实例
 *
 *  \~english
 *  Remove members from group, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be removed
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)removeOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要加入黑名单的用户
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组实例
 *
 *  \~english
 *  Add users to group’s blacklist, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be added
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)blockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                      error:(EMError **)pError;


/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aOccupants 要从黑名单中移除的用户名列表
 *  @param aGroupId   群组ID
 *  @param pError     错误信息
 *
 *  @result    群组对象
 *
 *  \~english
 *  Remove users from group‘s blacklist, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aOccupants Users to be removed
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)unblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                        error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aSubject  新主题
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @result    群组对象
 *
 *  \~english
 *  Change group’s subject, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aSubject  New group‘s subject
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Group instance
 */
- (EMGroup *)changeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                          error:(EMError **)pError;

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aDescription 说明信息
 *  @param aGroupId     群组ID
 *  @param pError       错误信息
 *
 *  @result    群组对象
 *
 *  \~english
 *  Change group’s description, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDescription New group‘s description
 *  @param aGroupId     Group id
 *  @param pError       Error
 *
 *  @result    Group
 */
- (EMGroup *)changeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                         error:(EMError **)pError;

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @result    退出的群组对象, 失败返回nil
 *
 *  \~english
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Leaved group, return nil if fail
 */
- (EMGroup *)leaveGroup:(NSString *)aGroupId
                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  群组ID
 *  @param pError    错误信息
 *
 *  @result    销毁的群组实例, 失败返回nil
 *
 *  \~english
 *  Destroy a group, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param pError    Error
 *
 *  @result    Destroyed group, return nil if fail
 */
- (EMGroup *)destroyGroup:(NSString *)aGroupId
                    error:(EMError **)pError;


/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   要屏蔽的群ID
 *  @param pError     错误信息
 *
 *  @result           群组实例
 *
 *  \~english
 *  Block group’s message, server will blocks the messages of the group to user, owner can't block the group's message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)blockGroup:(NSString *)aGroupId
                  error:(EMError **)pError;

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   要取消屏蔽的群ID
 *  @param pError     错误信息
 *
 *  @result    返回群组实例
 *
 *  \~english
 *  Unblock group message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param pError     Error
 *
 *  @result    Group instance
 */
- (EMGroup *)unblockGroup:(NSString *)aGroupId
                    error:(EMError **)pError;

#pragma mark - Edit Public Group

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId 公开群组的ID
 *  @param pError   错误信息
 *
 *  @result    所加入的公开群组
 *
 *  \~english
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId Public group id
 *  @param pError   Error
 *
 *  @result    Joined public group
 */
- (EMGroup *)joinPublicGroup:(NSString *)aGroupId
                       error:(EMError **)pError;

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId    公开群组的ID
 *  @param aMessage    请求加入的信息
 *  @param pError      错误信息
 *
 *  @result    申请加入的公开群组
 *
 *  \~english
 *  Apply to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId    Public group id
 *  @param aMessage    Apply info
 *  @param pError      Error
 *
 *  @result    Group instance
 */
- (EMGroup *)applyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                            error:(EMError **)pError;

#pragma mark - Application

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId   所申请的群组ID
 *  @param aUsername  申请人
 *
 *  @result 错误信息
 *
 *  \~english
 *  Accept user's application, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId   Group id
 *  @param aUsername  The applicant
 *
 *  @result Error
 */
- (EMError *)acceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername;

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  被拒绝的群组ID
 *  @param aUsername 申请人
 *  @param aReason   拒绝理由
 *
 *  @result 错误信息
 *
 *  \~english
 *  Decline user's application, need owner‘s authority
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param aUsername The applicant
 *  @param aReason   Decline reason
 *
 *  @result Error
 */
- (EMError *)declineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason;

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param groupId     接受的群组ID
 *  @param aUsername   邀请者
 *  @param pError      错误信息
 *
 *  @result 接受的群组实例
 *
 *  \~english
 *  Accept group's invitation
 *
 *  Synchronization method will block the current thread
 *
 *  @param groupId     Group id
 *  @param aUsername   Inviter
 *  @param pError      Error
 *
 *  @result Joined group instance
 */
- (EMGroup *)acceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                                 error:(EMError **)pError;

/*!
 *  \~chinese
 *  拒绝入群邀请
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId  被拒绝的群组ID
 *  @param aUsername 邀请人
 *  @param aReason   拒绝理由
 *
 *  @result 错误信息
 *
 *  \~english
 *  Decline a group invitation
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId  Group id
 *  @param aUsername Inviter
 *  @param aReason   Decline reason
 *
 *  @result Error
 */
- (EMError *)declineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason;

#pragma mark - Apns

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *  
 *  同步方法，会阻塞当前线程
 *
 *  @param aGroupId    群组ID
 *  @param aIgnore     是否屏蔽
 *
 *  @result 错误信息
 *
 *  \~english
 *  Block / unblock group message‘s push notification
 *
 *  Synchronization method will block the current thread
 *
 *  @param aGroupId    Group id
 *  @param aIgnore     Whether block
 *
 *  @result Error
 */
- (EMError *)ignoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore;

#pragma mark - Async method

/**
 *  \~chinese
 *  从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Get all of user's groups from server, will update group list in memory and DB after success
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetMyGroupsFromServer:(void (^)(NSArray *aList))aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  从服务器获取指定范围内的公开群
 *
 *  @param aCursor          获取公开群的cursor，首次调用传空
 *  @param aPageSize        期望返回结果的数量, 如果 < 0 则一次返回所有结果
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Get public groups in the specified range from the server
 *
 *  @param aCursor          Cursor, input nil the first time
 *  @param aPageSize        Expect result count, will return all results if < 0
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncGetPublicGroupsFromServerWithCursor:(NSString *)aCursor
                                        pageSize:(NSInteger)aPageSize
                                         success:(void (^)(EMCursorResult *aCursor))aSuccessBlock
                                         failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  根据群ID搜索公开群
 *
 *  @param aGroundId        群组id
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Search public group with the id
 *
 *  @param aGroundId        Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncSearchPublicGroupWithId:(NSString *)aGroundId
                             success:(void (^)(EMGroup *aGroup))aSuccessBlock
                             failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  创建群组
 *
 *  @param aSubject         群组名称
 *  @param aDescription     群组描述
 *  @param aInvitees        群组成员（不包括创建者自己）
 *  @param aMessage         邀请消息
 *  @param aSetting         群组属性
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 *
 *  \~english
 *  Create a group
 *
 *  @param aSubject         Group subject
 *  @param aDescription     Group description
 *  @param aInvitees        Group members, without creater
 *  @param aMessage         Invitation message
 *  @param aSetting         Group options
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncCreateGroupWithSubject:(NSString *)aSubject
                        description:(NSString *)aDescription
                           invitees:(NSArray *)aInvitees
                            message:(NSString *)aMessage
                            setting:(EMGroupOptions *)aSetting
                            success:(void (^)(EMGroup *aGroup))aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  获取群组详情
 *
 *  @param aGroupId              群组ID
 *  @param aIncludeMembersList   是否获取成员列表
 *  @param aSuccessBlock         成功的回调
 *  @param aFailureBlock         失败的回调
 *
 *
 *  \~english
 *  Fetch group info
 *
 *  @param aGroupId              Group id
 *  @param aIncludeMembersList   Whether get member list
 *  @param aSuccessBlock         The callback block of success
 *  @param aFailureBlock         The callback block of failure
 *
 */
- (void)asyncFetchGroupInfo:(NSString *)aGroupId
         includeMembersList:(BOOL)aIncludeMembersList
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  获取群组黑名单列表, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Get group‘s blacklist, need owner’s authority
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncFetchGroupBansList:(NSString *)aGroupId
                        success:(void (^)(NSArray *aList))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  邀请用户加入群组
 *
 *  @param aOccupants       被邀请的用户名列表
 *  @param aGroupId         群组ID
 *  @param aWelcomeMessage  欢迎信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Invite User to join a group
 *
 *  @param aOccupants       Invited users
 *  @param aGroupId         Group id
 *  @param aWelcomeMessage  Welcome message
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAddOccupants:(NSArray *)aOccupants
                  toGroup:(NSString *)aGroupId
           welcomeMessage:(NSString *)aWelcomeMessage
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  将群成员移出群组, 需要owner权限
 *
 *  @param aOccupants       要移出群组的用户列表
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Remove members from group, need owner‘s authority
 *
 *  @param aOccupants       Users to be removed
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRemoveOccupants:(NSArray *)aOccupants
                   fromGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  加人到群组黑名单, 需要owner权限
 *
 *  @param aOccupants       要加入黑名单的用户
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Add users to group’s blacklist, need owner‘s authority
 *
 *  @param aOccupants       Users to be added
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncBlockOccupants:(NSArray *)aOccupants
                  fromGroup:(NSString *)aGroupId
                    success:(void (^)(EMGroup *aGroup))aSuccessBlock
                    failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  从群组黑名单中减人, 需要owner权限
 *
 *  @param aOccupants       要从黑名单中移除的用户名列表
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Remove users from group‘s blacklist, need owner‘s authority
 *
 *  @param aOccupants       Users to be removed
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUnblockOccupants:(NSArray *)aOccupants
                     forGroup:(NSString *)aGroupId
                      success:(void (^)(EMGroup *aGroup))aSuccessBlock
                      failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  更改群组主题, 需要owner权限
 *
 *  @param aSubject         新主题
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Change group’s subject, need owner‘s authority
 *
 *  @param aSubject         New group‘s subject
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncChangeGroupSubject:(NSString *)aSubject
                       forGroup:(NSString *)aGroupId
                        success:(void (^)(EMGroup *aGroup))aSuccessBlock
                        failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  更改群组说明信息, 需要owner权限
 *
 *  @param aDescription     说明信息
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Change group’s description, need owner‘s authority
 *
 *  @param aDescription     New group‘s description
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncChangeDescription:(NSString *)aDescription
                      forGroup:(NSString *)aGroupId
                       success:(void (^)(EMGroup *aGroup))aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  退出群组，owner不能退出群，只能销毁群
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Leave a group, owner can't leave the group, can only destroy the group
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncLeaveGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  解散群组, 需要owner权限
 *
 *  @param aGroupId         群组ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Destroy a group, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDestroyGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
 *
 *  @param aGroupId         要屏蔽的群ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Block group’s message, server will blocks the messages of the group to user, owner can't block the group's message
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncBlockGroup:(NSString *)aGroupId
                success:(void (^)(EMGroup *aGroup))aSuccessBlock
                failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  取消屏蔽群消息
 *
 *  @param aGroupId         要取消屏蔽的群ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Unblock group message
 *
 *  @param aGroupId         Group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUnblockGroup:(NSString *)aGroupId
                  success:(void (^)(EMGroup *aGroup))aSuccessBlock
                  failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         公开群组的ID
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Join a public group, group style should be EMGroupStylePublicOpenJoin
 *
 *  @param aGroupId         Public group id
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncJoinPublicGroup:(NSString *)aGroupId
                     success:(void (^)(EMGroup *aGroup))aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         公开群组的ID
 *  @param aMessage         请求加入的信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Apply to join a public group, group style should be EMGroupStylePublicJoinNeedApproval
 *
 *  @param aGroupId         Public group id
 *  @param aMessage         Apply info
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncApplyJoinPublicGroup:(NSString *)aGroupId
                          message:(NSString *)aMessage
                          success:(void (^)(EMGroup *aGroup))aSuccessBlock
                          failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  批准入群申请, 需要Owner权限
 *
 *  @param aGroupId         所申请的群组ID
 *  @param aUsername        申请人
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Accept user's application, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aUsername        The applicant
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptJoinApplication:(NSString *)aGroupId
                         applicant:(NSString *)aUsername
                           success:(void (^)())aSuccessBlock
                           failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  拒绝入群申请, 需要Owner权限
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        申请人
 *  @param aReason          拒绝理由
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Decline user's application, need owner‘s authority
 *
 *  @param aGroupId         Group id
 *  @param aUsername        The applicant
 *  @param aReason          Decline reason
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineJoinApplication:(NSString *)aGroupId
                          applicant:(NSString *)aUsername
                             reason:(NSString *)aReason
                            success:(void (^)())aSuccessBlock
                            failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  接受入群邀请
 *
 *  @param groupId          接受的群组ID
 *  @param aUsername        邀请者
 *  @param pError           错误信息
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Accept group's invitation
 *
 *  @param groupId          Group id
 *  @param aUsername        Inviter
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncAcceptInvitationFromGroup:(NSString *)aGroupId
                               inviter:(NSString *)aUsername
                               success:(void (^)(EMGroup *aGroup))aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  拒绝入群邀请
 *
 *  @param aGroupId         被拒绝的群组ID
 *  @param aUsername        邀请人
 *  @param aReason          拒绝理由
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *
 *  \~english
 *  Decline a group invitation
 *
 *  @param aGroupId         Group id
 *  @param aUsername        Inviter
 *  @param aReason          Decline reason
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncDeclineInvitationFromGroup:(NSString *)aGroupId
                                inviter:(NSString *)aUsername
                                 reason:(NSString *)aReason
                                success:(void (^)())aSuccessBlock
                                failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  屏蔽/取消屏蔽群组消息的推送
 *
 *  @param aGroupId          群组ID
 *  @param aIgnore           是否屏蔽
 *  @param aSuccessBlock     成功的回调
 *  @param aFailureBlock     失败的回调
 *
 *
 *  \~english
 *  Block / unblock group message‘s push notification
 *
 *  @param aGroupId          Group id
 *  @param aIgnore           Whether block
 *  @param aSuccessBlock     The callback block of success
 *  @param aFailureBlock     The callback block of failure
 *
 */
- (void)asyncIgnoreGroupPush:(NSString *)aGroupId
                      ignore:(BOOL)aIsIgnore
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock;

@end
