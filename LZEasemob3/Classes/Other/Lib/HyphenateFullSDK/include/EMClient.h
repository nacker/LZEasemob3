/*!
 *  @header EMClient.h
 *  @abstract SDK Client
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMClientDelegate.h"
#import "EMOptions.h"
#import "EMPushOptions.h"
#import "EMError.h"

#import "IEMChatManager.h"
#import "IEMContactManager.h"
#import "IEMGroupManager.h"
#import "IEMChatroomManager.h"

/*!
 *  SDK Client
 */
@interface EMClient : NSObject
{
    EMPushOptions *_pushOptions;
}

/*!
 *  \~chinese 
 *  SDK版本号
 *
 *  \~english 
 *  SDK version
 */
@property (nonatomic, strong, readonly) NSString *version;

/*!
 *  \~chinese 
 *  当前登录账号
 *
 *  \~english 
 *  Current logined account
 */
@property (nonatomic, strong, readonly) NSString *currentUsername;

/*!
 *  \~chinese 
 *  SDK属性
 *
 *  \~english
 *  SDK setting options
 */
@property (nonatomic, strong, readonly) EMOptions *options;

/*!
 *  \~chinese 
 *  推送设置
 *
 *  \~english 
 *  Apple APNS setting
 */
@property (nonatomic, strong, readonly) EMPushOptions *pushOptions;

/*!
 *  \~chinese 
 *  聊天模块
 *
 *  \~english 
 *  Chat module
 */
@property (nonatomic, strong, readonly) id<IEMChatManager> chatManager;

/*!
 *  \~chinese 
 *  好友模块
 *
 *  \~english 
 *  Contact module
 */
@property (nonatomic, strong, readonly) id<IEMContactManager> contactManager;

/*!
 *  \~chinese 
 *  群组模块
 *
 *  \~english 
 *  Group module
 */
@property (nonatomic, strong, readonly) id<IEMGroupManager> groupManager;

/*!
 *  \~chinese 
 *  聊天室模块
 *
 *  \~english 
 *  Chatroom module
 */
@property (nonatomic, strong, readonly) id<IEMChatroomManager> roomManager;

/*!
 *  \~chinese 
 *  SDK是否自动登录上次登录的账号
 *
 *  \~english
 *  Whether SDK will automatically login last logined account
 */
@property (nonatomic, readonly) BOOL isAutoLogin;

/*!
 *  \~chinese 
 *  用户是否已登录
 *
 *  \~english 
 *  Whether user has logged in
 */
@property (nonatomic, readonly) BOOL isLoggedIn;

/*!
 *  \~chinese 
 *  是否连上聊天服务器
 *
 *  \~english 
 *  Whether has connected to chat server
 */
@property (nonatomic, readonly) BOOL isConnected;

/*!
 *  \~chinese 
 *  获取SDK实例
 *
 *  \~english
 *  Get SDK single instance
 */
+ (instancetype)sharedClient;

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
- (void)addDelegate:(id<EMClientDelegate>)aDelegate
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

#pragma mark - Initialize SDK

/*!
 *  \~chinese 
 *  初始化sdk
 *
 *  @param aOptions  SDK配置项
 *
 *  @result 错误信息
 *
 *  \~english 
 *  Initialization sdk
 *  
 *  @param aOptions  SDK setting options
 *
 *  @result Error
 */
- (EMError *)initializeSDKWithOptions:(EMOptions *)aOptions;

#pragma mark - Sync method

#pragma mark - Register

/*!
 *  \~chinese
 *  注册用户
 *
 *  同步方法，会阻塞当前线程. 不推荐使用，建议后台通过REST注册
 *
 *  @param aUsername  用户名
 *  @param aPassword  密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Register a new user
 *
 *  Synchronization method will block the current thread. It is not recommended, advise to register new user through REST API
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (EMError *)registerWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword;

#pragma mark - Login

/*!
 *  \~chinese
 *  登录
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aUsername  用户名
 *  @param aPassword  密码
 *
 *  @result 错误信息
 *
 *  \~english
 *  Login
 *
 *  Synchronization method will block the current thread
 *
 *  @param aUsername  Username
 *  @param aPassword  Password
 *
 *  @result Error
 */
- (EMError *)loginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword;

#pragma makr - Logout

/*!
 *  \~chinese
 *  退出
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aIsUnbindDeviceToken 是否解除device token的绑定，解除绑定后设备不会再收到消息推送
 *         如果传入YES, 解除绑定失败，将返回error
 *
 *  @result 错误信息
 *
 *  \~english
 *  Logout
 *
 *  Synchronization method will block the current thread
 *
 *  @param aIsUnbindDeviceToken Whether unbind device token, device will don't receive message push after unbind token, if input YES, unbind failed will return error
 *
 *  @result Error
 */
- (EMError *)logout:(BOOL)aIsUnbindDeviceToken;

#pragma mark - Apns

/*!
 *  \~chinese
 *  绑定device token
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aDeviceToken  要绑定的token
 *
 *  @result 错误信息
 *
 *  \~english
 *  Bind device token
 *
 *  Synchronization method will block the current thread
 *
 *  @param aDeviceToken  Device token to bind
 *
 *  @result Error
 */
- (EMError *)bindDeviceToken:(NSData *)aDeviceToken;

/*!
 *  \~chinese
 *  设置推送消息显示的昵称
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param aNickname  要设置的昵称
 *
 *  @result 错误信息
 *
 *  \~english
 *  Set nick name to show in push message
 *
 *  Synchronization method will block the current thread
 *
 *  @param aNickname  Nickname
 *
 *  @result Error
 */
- (EMError *)setApnsNickname:(NSString *)aNickname;

/*!
 *  \~chinese 
 *  从服务器获取推送属性
 *
 *  同步方法，会阻塞当前线程
 *
 *  @param pError  错误信息
 *
 *  @result 推送属性
 *
 *  \~english
 *  Get apns options from the server
 *
 *  Synchronization method will block the current thread
 *
 *  @param pError  Error
 *
 *  @result Apns options
 */
- (EMPushOptions *)getPushOptionsFromServerWithError:(EMError **)pError;

/*!
 *  \~chinese 
 *  更新推送设置到服务器
 *
 *  同步方法，会阻塞当前线程
 *
 *  @result 错误信息
 *
 *  \~english
 *  Update APNS options to the server
 *
 *  Synchronization method will block the current thread
 *
 *  @result Error
 */
- (EMError *)updatePushOptionsToServer;

/*!
 *  \~chinese
 *  上传日志到服务器
 *
 *  同步方法，会阻塞当前线程
 *
 *  @result 错误信息
 *
 *  \~english
 *  Upload log to server
 *
 *  Synchronization method will block the current thread
 *
 *  @result Error
 */
- (EMError *)uploadLogToServer;

#pragma mark - Async method

/*!
 *  \~chinese
 *  注册用户
 *
 *  不推荐使用，建议后台通过REST注册
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Register a new user
 *
 *  It is not recommended, advise to register new user through REST API
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncRegisterWithUsername:(NSString *)aUsername
                         password:(NSString *)aPassword
                          success:(void (^)())aSuccessBlock
                          failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  登录
 *
 *  @param aUsername        用户名
 *  @param aPassword        密码
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Login
 *
 *  @param aUsername        Username
 *  @param aPassword        Password
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncLoginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword
                       success:(void (^)())aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  退出
 *
 *  @param aIsUnbindDeviceToken 是否解除device token的绑定，解除绑定后设备不会再收到消息推送
 *         如果传入YES, 解除绑定失败，将返回error
 *
 *  @result 错误信息
 *
 *  \~english
 *  Logout
 *
 *  @param aIsUnbindDeviceToken Whether unbind device token, device will don't receive message push after unbind token, if input YES, unbind failed will return error
 *
 *  @result Error
 */
- (void)asyncLogout:(BOOL)aIsUnbindDeviceToken
            success:(void (^)())aSuccessBlock
            failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  绑定device token
 *
 *  @param aDeviceToken     要绑定的token
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Bind device token
 *
 *  @param aDeviceToken     Device token to bind
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncBindDeviceToken:(NSData *)aDeviceToken
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  设置推送消息显示的昵称
 *
 *  @param aNickname        要设置的昵称
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Set nick name to show in push message
 *
 *  @param aNickname        Nickname
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncSetApnsNickname:(NSString *)aNickname
                     success:(void (^)())aSuccessBlock
                     failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  从服务器获取推送属性
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Get apns options from the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncGetPushOptionsFromServer:(void (^)(EMPushOptions *aOptions))aSuccessBlock
                              failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  更新推送设置到服务器
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Update APNS options to the server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 *
 */
- (void)asyncUpdatePushOptionsToServer:(void (^)())aSuccessBlock
                               failure:(void (^)(EMError *aError))aFailureBlock;

/*!
 *  \~chinese
 *  上传日志到服务器
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  \~english
 *  Upload log to server
 *
 *  @param aSuccessBlock    The callback block of success
 *  @param aFailureBlock    The callback block of failure
 */
- (void)asyncUploadLogToServer:(void (^)())aSuccessBlock
                       failure:(void (^)(EMError *aError))aFailureBlock;

#pragma mark - iOS

/*!
 *  \~chinese 
 *  iOS专用，数据迁移到SDK3.0
 *
 *  同步方法，会阻塞当前线程
 *
 *  升级到SDK3.0版本需要调用该方法，开发者需要等该方法执行完后再进行数据库相关操作
 *
 *  @result 是否迁移成功
 *
 *  \~english 
 *  iOS-specific, data migration to SDK3.0
 *
 *  Synchronization method will block the current thread
 *
 *  It's needed to call this method when update to SDK3.0, developers need to wait this method complete before DB related operations
 *
 *  @result Whether migration successful
 */
- (BOOL)dataMigrationTo3;

/*!
 *  \~chinese 
 *  iOS专用，程序进入后台时，需要调用此方法断开连接
 *
 *  @param aApplication  UIApplication
 *
 *  \~english
 *  iOS only, should call this method to disconnect from server when app enter backgroup
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationDidEnterBackground:(id)aApplication;

/*!
 *  \~chinese 
 *  iOS专用，程序进入前台时，需要调用此方法进行重连
 *
 *  @param aApplication  UIApplication
 *
 *  \~english
 *  iOS only, should call this method to re-connect to server when app restore to foreground
 *
 *  @param aApplication  UIApplication
 */
- (void)applicationWillEnterForeground:(id)aApplication;


@end
