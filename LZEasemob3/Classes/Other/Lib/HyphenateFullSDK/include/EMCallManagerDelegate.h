/*!
 *  \~chinese
 *  @header EMCallManagerDelegate.h
 *  @abstract 此协议定义了实时语音/视频相关的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallManagerDelegate.h
 *  @abstract This protocol defines the callbacks of voice/video calling
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCallSession.h"

@class EMError;

/*!
 *  \~chinese 
 *  实时语音/视频相关的回调
 *
 *  \~english
 *  Callbacks of real time voice/video
 */
@protocol EMCallManagerDelegate <NSObject>
    
@optional

/*!
 *  \~chinese
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  Delegate method will be invoked when receiving a call.
 *  User B will receive this callback after user A dial user B.
 *
 *  @param aSession  Session instance
 */
- (void)callDidReceive:(EMCallSession *)aSession;

/*!
 *  \~chinese
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  Delegate method invokes when the connection is established.
 *  Both user A and B will receive this callback.
 *
 *  @param aSession  Session instance
 */
- (void)callDidConnect:(EMCallSession *)aSession;

/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  Delegate method invokes when the outgoing call is accepted by the recipient. 
 *  User A will receive this callback after user B accept A's call.
 *
 *  @param Session instance
 */
- (void)callDidAccept:(EMCallSession *)aSession;

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 *
 *  \~english
 *  Delegate method invokes when the other party ends the call or some error happens.
 *  1.The another party will receive this callback after user A or user B end the call.
 *  2.Both user A and B will receive this callback after error occured.
 *
 *  @param aSession  Session instance
 *  @param aOption   The reason of ending the call
 *  @param aError    EMError
 */
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError;

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A暂停或者恢复数据流传输时，用户B会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aType     改变类型
 *
 *  \~english
 *  Delegate method invokes when the other party pauses or resumes the call.
 *  User A and B are on the same call, A pauses or resumes the call, B will receive this callback.
 *
 *  @param aSession  Session instance
 *  @param aType     Current call status
 */
- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType;

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aStatus   当前状态
 *
 *  \~english
 *  Delegate method invokes when the local network status changes.
 *  User A and B are on the same call, A's network status changes from active to unstable or unavailable, and A will receive the callback.
 *
 *  @param aSession  Session instance
 *  @param aStatus   Current network status
 */
- (void)callNetworkStatusDidChange:(EMCallSession *)aSession
                            status:(EMCallNetworkStatus)aStatus;

#pragma mark - Deprecated methods

/*!
 *  \~chinese 
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  Delegate method invokes when receiving a incoming call.
 *  User B will receive this callback when user A calls user B.
 *
 *  @param aSession  Session instance
 */
- (void)didReceiveCallIncoming:(EMCallSession *)aSession __deprecated_msg("Use -callDidReceive:");

/*!
 *  \~chinese 
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  Both user A and B will receive this callback after connection is established
 *
 *  @param aSession  Session instance
 */
- (void)didReceiveCallConnected:(EMCallSession *)aSession __deprecated_msg("Use -callDidConnect:");

/*!
 *  \~chinese 
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 *
 *  \~english
 *  User A will receive this callback after user B accept A's call
 *
 *  @param aSession
 */
- (void)didReceiveCallAccepted:(EMCallSession *)aSession __deprecated_msg("Use -callDidAccept:");

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 *
 *  \~english
 *  1.The another peer will receive this callback after user A or user B terminate the call.
 *  2.Both user A and B will receive this callback after error occur.
 *
 *  @param aSession  Session instance
 *  @param aReason   Terminate reason
 *  @param aError    Error
 */
- (void)didReceiveCallTerminated:(EMCallSession *)aSession
                          reason:(EMCallEndReason)aReason
                           error:(EMError *)aError __deprecated_msg("Use -callDidEnd:reason:error");

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aType     改变类型
 *
 *  \~english
 *  User A and B is on the call, A pause or resume the data stream, B will receive the callback
 *
 *  @param aSession  Session instance
 *  @param aType     Type
 */
- (void)didReceiveCallUpdated:(EMCallSession *)aSession
                         type:(EMCallStreamControlType)aType __deprecated_msg("Use -callStateDidChange:type");

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aStatus   当前状态
 *
 *  \~english
 *  User A and B is on the call, A network status is not stable, A will receive the callback
 *
 *  @param aSession  Session instance
 *  @param aStatus   Current status
 */
- (void)didReceiveCallNetworkChanged:(EMCallSession *)aSession
                              status:(EMCallNetworkStatus)aStatus __deprecated_msg("Use -callNetworkStatusDidChange:status:");
@end
