/*!
 *  \~chinese
 *  @header EMContactManagerDelegate.h
 *  @abstract 此协议定义了好友相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMContactManagerDelegate.h
 *  @abstract This protocol defined the callbacks of contact
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@class EMError;

/*!
 *  \~chinese
 *  好友相关的回调
 *
 *  \~english
 *  Callbacks of contact
 */
@protocol EMContactManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  用户B同意用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after user B agreed user A's add-friend invitation
 *
 *  @param aUsername   User B
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B拒绝用户A的加好友请求后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after user B declined user A's add-friend invitation
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B删除与用户A的好友关系后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *
 *  \~english
 *  User A will receive this callback after User B delete the friend relationship between user A
 *
 *  @param aUsername   User B
 */
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
 *
 *  @param aUsername   用户好友关系的另一方
 *
 *  \~english
 *  Both user A and B will receive this callback after User B agreed user A's add-friend invitation
 *
 *  @param aUsername   Another user of user‘s friend relationship
 */
- (void)didReceiveAddedFromUsername:(NSString *)aUsername;

/*!
 *  \~chinese
 *  用户B申请加A为好友后，用户A会收到这个回调
 *
 *  @param aUsername   用户B
 *  @param aMessage    好友邀请信息
 *
 *  \~english
 *  User A will receive this callback after user B requested to add user A as a friend
 *
 *  @param aUsername   User B
 *  @param aMessage    Friend invitation message
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage;


@end
