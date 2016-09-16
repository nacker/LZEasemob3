/*!
 *  \~chinese
 *  @header EMClientDelegate.h
 *  @abstract 此协议提供了一些实用工具类的回调
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMClientDelegate.h
 *  @abstract This protocol provides a number of utility classes callback
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese 
 *  网络连接状态
 *
 *  \~english 
 *  Network Connection Status
 */
typedef enum{
    EMConnectionConnected = 0,  /*! *\~chinese 已连接 *\~english Connected */
    EMConnectionDisconnected,   /*! *\~chinese 未连接 *\~english Not connected */
}EMConnectionState;

@class EMError;

/*!
 *  \~chinese 
 *  @abstract 此协议提供了一些实用工具类的回调
 *
 *  \~english 
 *  @abstract This protocol provides a number of utility classes callback
 */
@protocol EMClientDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 *
 *  @param aConnectionState 当前状态
 *
 *  \~english
 *  Delegate method will be invoked when server connection state has changed
 *
 *  @param aConnectionState Current state
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState;

/*!
 *  \~chinese
 *  自动登录失败时的回调
 *
 *  @param aError 错误信息
 *
 *  \~english
 *  Delegate method will be invoked when auto login is completed
 *
 *  @param aError Error
 */
- (void)autoLoginDidCompleteWithError:(EMError *)aError;

/*!
 *  \~chinese
 *  当前登录账号在其它设备登录时会接收到此回调
 *
 *  \~english
 *  Delegate method will be invoked when current IM account logged into another device
 */
- (void)userAccountDidLoginFromOtherDevice;

/*!
 *  \~chinese
 *  当前登录账号已经被从服务器端删除时会收到该回调
 *
 *  \~english
 *  Delegate method will be invoked when current IM account is removed from server
 */
- (void)userAccountDidRemoveFromServer;

#pragma mark - Deprecated methods

/*!
 *  \~chinese
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 *
 *  @param aConnectionState 当前状态
 *
 *  \~english
 *  Connection to the server status changes will receive the callback
 *  
 *  calling the method causes:
 *  1. After successful login, the phone can not access
 *  2. After a successful login, network status change
 *  
 *  @param aConnectionState Current state
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState __deprecated_msg("Use -connectionStateDidChange:");

/*!
 *  \~chinese
 *  自动登录失败时的回调
 *
 *  @param aError 错误信息
 *
 *  \~english
 *  Callback Automatic login fails
 *
 *  @param aError Error
 */
- (void)didAutoLoginWithError:(EMError *)aError __deprecated_msg("Use -autoLoginDidCompleteWithError:");

/*!
 *  \~chinese
 *  当前登录账号在其它设备登录时会接收到此回调
 *
 *  \~english
 *  Will receive this callback when current account login from other device
 */
- (void)didLoginFromOtherDevice __deprecated_msg("Use -userAccountDidLoginFromOtherDevice");

/*!
 *  \~chinese
 *  当前登录账号已经被从服务器端删除时会收到该回调
 *
 *  \~english
 *  Current login account will receive the callback is deleted from the server
 */
- (void)didRemovedFromServer __deprecated_msg("Use -userAccountDidRemoveFromServer");

@end
