/*!
 *  \~chinese
 *  @header EMErrorCode.h
 *  @abstract SDK定义的错误类型
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMErrorCode.h
 *  @abstract SDK defined error type
 *  @author Hyphenate
 *  @version 3.00
 */

typedef enum{

    EMErrorGeneral = 1,                      /*! \~chinese 一般错误 \~english General error */
    EMErrorNetworkUnavailable,               /*! \~chinese 网络不可用 \~english Network is unavaliable */
    
    EMErrorInvalidAppkey = 100,              /*! \~chinese Appkey无效 \~english App key is invalid */
    EMErrorInvalidUsername,                  /*! \~chinese 用户名无效 \~english User name is invalid */
    EMErrorInvalidPassword,                  /*! \~chinese 密码无效 \~english Password is invalid */
    EMErrorInvalidURL,                       /*! \~chinese URL无效 \~english URL is invalid */
    
    EMErrorUserAlreadyLogin = 200,           /*! \~chinese 用户已登录 \~english User has already logged in */
    EMErrorUserNotLogin,                     /*! \~chinese 用户未登录 \~english User has not logged in */
    EMErrorUserAuthenticationFailed,         /*! \~chinese 密码验证失败 \~english Password check failed */
    EMErrorUserAlreadyExist,                 /*! \~chinese 用户已存在 \~english User has already exist */
    EMErrorUserNotFound,                     /*! \~chinese 用户不存在 \~english User was not found */
    EMErrorUserIllegalArgument,              /*! \~chinese 参数不合法 \~english Illegal argument */
    EMErrorUserLoginOnAnotherDevice,         /*! \~chinese 当前用户在另一台设备上登录 \~english User has logged in from another device */
    EMErrorUserRemoved,                      /*! \~chinese 当前用户从服务器端被删掉 \~english User was removed from server */
    EMErrorUserRegisterFailed,               /*! \~chinese 用户注册失败 \~english Register user failed */
    EMErrorUpdateApnsConfigsFailed,          /*! \~chinese 更新推送设置失败 \~english Update apns configs failed */
    EMErrorUserPermissionDenied,             /*! \~chinese 用户没有权限做该操作 \~english User has no right for this operation. */
    
    EMErrorServerNotReachable = 300,         /*! \~chinese 服务器未连接 \~english Server is not reachable */
    EMErrorServerTimeout,                    /*! \~chinese 服务器超时 \~english Wait server response timeout */
    EMErrorServerBusy,                       /*! \~chinese 服务器忙碌 \~english Server is busy */
    EMErrorServerUnknownError,               /*! \~chinese 未知服务器错误 \~english Unknown server error */
    EMErrorServerGetDNSConfigFailed,         /*! \~chinese 获取DNS设置失败 \~english Get DNS config failed */
    
    EMErrorFileNotFound = 400,               /*! \~chinese 文件没有找到 \~english Can't find the file */
    EMErrorFileInvalid,                      /*! \~chinese 文件无效 \~english File is invalid */
    EMErrorFileUploadFailed,                 /*! \~chinese 上传文件失败 \~english Upload file failed */
    EMErrorFileDownloadFailed,               /*! \~chinese 下载文件失败 \~english Download file failed */
    
    EMErrorMessageInvalid = 500,             /*! \~chinese 消息无效 \~english Message is invalid */
    EMErrorMessageIncludeIllegalContent,      /*! \~chinese 消息内容包含不合法信息 \~english Message contains illegal content */
    EMErrorMessageTrafficLimit,              /*! \~chinese 单位时间发送消息超过上限 \~english Unit time to send messages over the upper limit */
    EMErrorMessageEncryption,                /*! \~chinese 加密错误 \~english Encryption error */
    
    EMErrorGroupInvalidId = 600,             /*! \~chinese 群组ID无效 \~english Group Id is invalid */
    EMErrorGroupAlreadyJoined,               /*! \~chinese 已加入群组 \~english User has already joined the group */
    EMErrorGroupNotJoined,                   /*! \~chinese 未加入群组 \~english User has not joined the group */
    EMErrorGroupPermissionDenied,            /*! \~chinese 没有权限进行该操作 \~english User has NO authority for the operation */
    EMErrorGroupMembersFull,                 /*! \~chinese 群成员个数已达到上限 \~english Reach group's max member count */
    EMErrorGroupNotExist,                    /*! \~chinese 群组不存在 \~english Group is not exist */
    
    EMErrorChatroomInvalidId = 700,          /*! \~chinese 聊天室ID无效 \~english Chatroom id is invalid */
    EMErrorChatroomAlreadyJoined,            /*! \~chinese 已加入聊天室 \~english User has already joined the chatroom */
    EMErrorChatroomNotJoined,                /*! \~chinese 未加入聊天室 \~english User has not joined the chatroom */
    EMErrorChatroomPermissionDenied,         /*! \~chinese 没有权限进行该操作 \~english User has NO authority for the operation */
    EMErrorChatroomMembersFull,              /*! \~chinese 聊天室成员个数达到上限 \~english Reach chatroom's max member count */
    EMErrorChatroomNotExist,                 /*! \~chinese 聊天室不存在 \~english Chatroom is not exist */
    
    EMErrorCallInvalidId = 800,              /*! \~chinese 实时通话ID无效 \~english Call id is invalid */
    EMErrorCallBusy,                         /*! \~chinese 已经在进行实时通话了 \~english User is busy */
    EMErrorCallRemoteOffline,                /*! \~chinese 对方不在线 \~english Callee is offline */
    EMErrorCallConnectFailed,                /*! \~chinese 实时通话建立连接失败 \~english Establish connection failed */

}EMErrorCode;
