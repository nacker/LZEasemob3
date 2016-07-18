/*!
 *  \~chinese
 *  @header EMOptions.h
 *  @abstract SDK的设置选项
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMOptions.h
 *  @abstract SDK setting options
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/*!
 *  \~chinese 
 *  日志输出级别
 *
 *  \~english 
 *  Log output level
 */
typedef enum {
    EMLogLevelDebug = 0, /*! \~chinese 输出所有日志 \~english Output all log */
    EMLogLevelWarning,   /*! \~chinese 输出警告及错误 \~english Output warning and error */
    EMLogLevelError      /*! \~chinese 只输出错误 \~english Output error only */
} EMLogLevel;

/*!
 *  \~chinese 
 *  SDK的设置选项
 *
 *  \~english 
 *  SDK setting options
 */
@interface EMOptions : NSObject

/*!
 *  \~chinese 
 *  app唯一标识符
 *
 *  \~english 
 *  Application's unique identifier
 */
@property (nonatomic, strong, readonly) NSString *appkey;

/*!
 *  \~chinese 
 *  控制台是否输出log, 默认为NO
 *
 *  \~english 
 *  Whether print log to console, default is NO
 */
@property (nonatomic, assign) BOOL enableConsoleLog;

/*!
 *  \~chinese 
 *  日志输出级别, 默认为EMLogLevelDebug
 *
 *  \~english 
 *  Log output level, default is EMLogLevelDebug
 */
@property (nonatomic, assign) EMLogLevel logLevel;

/*!
 *  \~chinese 
 *  是否使用https, 默认为YES
 *
 *  \~english 
 *  Whether using https, default is YES
 */
@property (nonatomic, assign) BOOL usingHttps;

/*!
 *  \~chinese 
 *  是否使用开发环境, 默认为NO
 *
 *  只能在[EMClient initializeSDKWithOptions:]时设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  Whether using development environment, default is NO
 *
 *  Can only set when initialize sdk [EMClient initializeSDKWithOptions:], can't change it in runtime
 */
@property (nonatomic, assign) BOOL isSandboxMode;

/*!
 *  \~chinese 
 *  是否自动登录, 默认为YES
 *
 *  设置的值会保存到本地。初始化EMOptions时，首先获取本地保存的值
 *
 *  \~english
 *  Whether auto login, default is YES
 *
 *  Value will be saved to the local. When initialization EMOptions, the first to get the value of the local saved
 */
@property (nonatomic, assign) BOOL isAutoLogin;

/*!
 *  \~chinese 
 *  离开群组时是否删除该群所有消息, 默认为YES
 *
 *  \~english
 *  Whether delete all of the group's message when leave group, default is YES
 */
@property (nonatomic, assign) BOOL isDeleteMessagesWhenExitGroup;

/*!
 *  \~chinese
 *  离开聊天室时是否删除所有消息, 默认为YES
 *
 *  \~english 
 *  Whether delete all of the chatroom's message when leave chatroom, default is YES
 */
@property (nonatomic, assign) BOOL isDeleteMessagesWhenExitChatRoom;

/*!
 *  \~chinese 
 *  是否允许聊天室Owner离开, 默认为YES
 *
 *  \~english
 *  Whether chatroom's owner can leave chatroom, default is YES
 */
@property (nonatomic, assign) BOOL isChatroomOwnerLeaveAllowed;

/*!
 *  \~chinese 
 *  用户自动同意群邀请, 默认为YES
 *
 *  \~english 
 *  Whether automatically accept group invitation, default is YES
 */
@property (nonatomic, assign) BOOL isAutoAcceptGroupInvitation;

/*!
 *  \~chinese 
 *  自动同意好友申请, 默认为NO
 *
 *  \~english 
 *  Whether automatically accept friend invitation, default is NO
 */
@property (nonatomic, assign) BOOL isAutoAcceptFriendInvitation;

/*!
 *  \~chinese 
 *  是否发送消息送达回执, 默认为NO，如果设置为YES，SDK收到单聊消息时会自动发送送达回执
 *
 *  \~english 
 *  Whether send delivery ack, default is NO, SDK will automatically send delivery ack when receive a single chat message if it's set to YES
 */
@property (nonatomic, assign) BOOL enableDeliveryAck;

/*!
 *  \~chinese 
 *  从数据库加载消息时是否按服务器时间排序，默认为YES，按服务器时间排序
 *
 *  \~english 
 *  Whether sort message by server time when load message from database, default is YES, sort by server time
 */
@property (nonatomic, assign) BOOL sortMessageByServerTime;

/*!
 *  \~chinese 
 *  iOS特有属性，推送证书的名称
 *
 *  只能在[EMClient initializeSDKWithOptions:]时设置，不能在程序运行过程中动态修改
 *
 *  \~english
 *  iOS only, push certificate name
 *
 *  Can only set when initialize SDK [EMClient initializeSDKWithOptions:], can't change it in runtime
 */
@property (nonatomic, strong) NSString *apnsCertName;

/*!
 *  \~chinese 
 *  获取实例
 *
 *  @param aAppkey  App的appkey
 *
 *  @result SDK设置项实例
 *
 *  \~english
 *  Get SDK setting options instance
 *
 *  @param aAppkey  App‘s unique identifier
 *
 *  @result SDK’s setting options instance
 */
+ (instancetype)optionsWithAppkey:(NSString *)aAppkey;

@end
