/*!
 *  \~chinese
 *  @header EMCallSession.h
 *  @abstract 会话
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallSession.h
 *  @abstract Call session
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMCallLocalView.h"
#import "EMCallRemoteView.h"

/*!
 *  \~chinese 
 *  会话状态
 *
 *  \~english
 *  Call session status
 */
typedef enum{
    EMCallSessionStatusDisconnected = 0,    /*! \~chinese 通话没开始 \~english Disconnected */
    EMCallSessionStatusRinging,             /*! \~chinese 通话响铃 \~english Callee is Ringing */
    EMCallSessionStatusConnecting,          /*! \~chinese 通话已经准备好，等待接听 \~english It's ready, wait to answer */
    EMCallSessionStatusConnected,           /*! \~chinese 通话已连接 \~english Connection is established */
    EMCallSessionStatusAccepted,            /*! \~chinese 通话双方同意协商 \~english Accepted */
}EMCallSessionStatus;

/*!
 *  \~chinese 
 *  通话类型
 *
 *  \~english
 *  Call type
 */
typedef enum{
    EMCallTypeVoice = 0,    /*! \~chinese 实时语音 \~english Voice call */
    EMCallTypeVideo,        /*! \~chinese 实时视频 \~english Video call */
}EMCallType;

/*!
 *  \~chinese 
 *  通话结束原因
 *
 *  \~english
 *  Call end reason
 */
typedef enum{
    EMCallEndReasonHangup   = 0,    /*! \~chinese 对方挂断 \~english Another peer hang up */
    EMCallEndReasonNoResponse,      /*! \~chinese 对方没有响应 \~english No response */
    EMCallEndReasonDecline,         /*! \~chinese 对方拒接 \~english Another peer declined the call */
    EMCallEndReasonBusy,            /*! \~chinese 对方占线 \~english User is busy */
    EMCallEndReasonFailed,          /*! \~chinese 失败 \~english Establish the call failed */
}EMCallEndReason;

/*!
 *  \~chinese 
 *  通话连接方式
 *
 *  \~english
 *  Connection type of the call
 */
typedef enum{
    EMCallConnectTypeNone = 0,  /*! \~chinese 无连接 \~english None */
    EMCallConnectTypeDirect,    /*! \~chinese 直连 \~english  Direct connect */
    EMCallConnectTypeRelay,     /*! \~chinese 转媒体服务器连接 \~english Relay connect */
}EMCallConnectType;


/*!
 *  \~chinese
 *  通话数据流状态
 *
 *  \~english
 *  Stream control
 */
typedef enum{
    EMCallStreamControlTypeVoicePause = 0,  /*! \~chinese 中断语音 \~english Pause Voice */
    EMCallStreamControlTypeVoiceResume,     /*! \~chinese 继续语音 \~english Resume Voice */
    EMCallStreamControlTypeVideoPause,      /*! \~chinese 中断视频 \~english Pause Video */
    EMCallStreamControlTypeVideoResume,     /*! \~chinese 继续视频 \~english Resume Video */
}EMCallStreamControlType;

/*!
 *  \~chinese
 *  通话网络状态
 *
 *  \~english
 *  Network status
 */
typedef enum{
    EMCallNetworkStatusNormal = 0,  /*! \~chinese 正常 \~english Normal */
    EMCallNetworkStatusUnstable,    /*! \~chinese 不稳定 \~english Unstable */
    EMCallNetworkStatusNoData,      /*! \~chinese 没有数据 \~english No data */
}EMCallNetworkStatus;

/*!
 *  \~chinese
 *  会话
 *
 *  \~english
 *  Call session
 */
@class EMError;
@interface EMCallSession : NSObject

/*!
 *  \~chinese 
 *  会话标识符
 *
 *  \~english
 *  Unique session id
 */
@property (nonatomic, strong, readonly) NSString *sessionId;

/*!
 *  \~chinese 
 *  通话本地的username
 *
 *  \~english
 *  Local username
 */
@property (nonatomic, strong, readonly) NSString *username;

/*!
 *  \~chinese 
 *  对方的username
 *
 *  \~english
 *  The other side's username
 */
@property (nonatomic, strong, readonly) NSString *remoteUsername;

/*!
 *  \~chinese 
 *  通话的类型
 *
 *  \~english
 *  Call type
 */
@property (nonatomic, readonly) EMCallType type;

/*!
 *  \~chinese 
 *  连接类型
 *
 *  \~english
 *  Connection type
 */
@property (nonatomic, readonly) EMCallConnectType connectType;

/*!
 *  \~chinese 
 *  通话的状态
 *
 *  \~english 
 *  Call session status
 */
@property (nonatomic, readonly) EMCallSessionStatus status;

/*!
 *  \~chinese
 *  视频通话时自己的图像显示区域
 *
 *  \~english
 *  Local display view
 */
@property (nonatomic, strong) EMCallLocalView *localVideoView;

/*!
 *  \~chinese
 *  视频通话时对方的图像显示区域
 *
 *  \~english
 *  Remote display view
 */
@property (nonatomic, strong) EMCallRemoteView *remoteVideoView;

/*!
 *  \~chinese
 *  设置视频码率，必须在通话开始前设置
 *
 *  码率范围为150-1000， 默认为600
 *
 *  \~english
 *  Set video bit rate, must set before start the session
 *
 *  Value is 150-1000, the default is 600
 */
@property (nonatomic) int videoBitrate;

/*!
 *  \~chinese
 *  获取音频音量，实时变化
 *
 *  @return 音量
 *
 *  \~english
 *  Get voice volume
 *
 *  @return Volume
 */
- (int)getVoiceVolume;

/*!
 *  \~chinese
 *  获取视频的延迟时间，单位是毫秒，实时变化
 *
 *  @result 视频延迟时间
 *
 *  \~english
 *  Get video delay time, in milliseconds, it's real time changed
 *
 *  @result The delay time
 */
- (int)getVideoTimedelay;

/*!
 *  \~chinese
 *  获取视频的帧率，实时变化
 *
 *  @result 视频帧率数值
 *
 *  \~english
 *  Get video frame rate, it's real time changed
 *
 *  @result The frame rate
 */
- (int)getVideoFramerate;

/*!
 *  \~chinese
 *  获取视频丢包率
 *
 *  @result 视频丢包率
 *
 *  \~english
 *  Get video package lost rate
 *
 *  @result Package lost rate
 */
- (int)getVideoLostcnt;

/*!
 *  \~chinese
 *  获取视频的宽度，固定值，不会实时变化
 *
 *  @result 视频宽度
 *
 *  \~english
 *  Get video width, fix size, it's not real time changed
 *
 *  @result Video width
 */
- (int)getVideoWidth;

/*!
 *  \~chinese
 *  获取视频的高度，固定值，不会实时变化
 *
 *  @result 视频高度
 *
 *  \~english
 *  Get video height, fix size, it's not real time changed
 *
 *  @result Video height
 */
- (int)getVideoHeight;

/*!
 *  \~chinese
 *  获取视频通话对方的比特率kbps，实时变化
 *
 *  @result 对方比特率
 *
 *  \~english
 *  Get another peer's bitrate, it's real time changed
 *
 *  @result Another peer's bitrate
 */
- (int)getVideoRemoteBitrate;

/*!
 *  \~chinese
 *  获取视频的比特率kbps，实时变化
 *
 *  @result 视频比特率
 *
 *  \~english
 *  Get bitrate of video call, it's real time changed
 *
 *  @result Bitrate of video
 */
- (int)getVideoLocalBitrate;

/*!
 *  \~chinese
 *  获取视频快照
 *
 *  @param aFullPath  图片存储路径
 *
 *  \~english
 *  Get snapshot of video
 *
 *  @param aFullPath  Save path of picture
 */
- (void)takeRemotePicture:(NSString *)aFullPath;

/*!
 *  \~chinese
 *  开始录制视频
 *
 *  @param  aPath    文件保存路径
 *
 *  \~english
 *  Start recording video
 *
 *  @param  aPath    File save path
 */
- (BOOL)startVideoRecord:(NSString*)aPath;

/*!
 *  \~chinese
 *  停止录制视频
 *
 *  @result 录制视频的路径
 *
 *  \~english
 *  Stop recording video
 *
 *  @result path of record file
 */
- (NSString *)stopVideoRecord;

/*!
 *  \~chinese
 *  设置使用前置摄像头还是后置摄像头,默认使用前置摄像头
 *
 *  @param  isFont    是否使用前置摄像头,YES使用前置,NO使用后置
 *
 *  \~english
 *  Use front camera or back camera,default use front
 *
 *  @param  isFont    Weather use front camera or not,Yes is Front,No is Back
 */
- (void)setCameraBackOrFront:(BOOL)isFont;

@end
