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
    EMCallSessionStatusConnecting,          /*! \~chinese 通话已经准备好，等待接听 \~english Waiting for the recipient to pickup */
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
 *  Call end cause
 */
typedef enum{
    EMCallEndReasonHangup   = 0,    /*! \~chinese 对方挂断 \~english The recipient hung up */
    EMCallEndReasonNoResponse,      /*! \~chinese 对方没有响应 \~english No response from recipient */
    EMCallEndReasonDecline,         /*! \~chinese 对方拒接 \~english The recipient declined the call */
    EMCallEndReasonBusy,            /*! \~chinese 对方占线 \~english The recipient was busy */
    EMCallEndReasonFailed,          /*! \~chinese 失败 \~english Failed to establishing the connection */
}EMCallEndReason;

/*!
 *  \~chinese 
 *  通话连接方式
 *
 *  \~english
 *  Call connection type
 */
typedef enum{
    EMCallConnectTypeNone = 0,  /*! \~chinese 无连接 \~english No connection */
    EMCallConnectTypeDirect,    /*! \~chinese 直连 \~english  Direct connection */
    EMCallConnectTypeRelay,     /*! \~chinese 转媒体服务器连接 \~english Relay connection */
}EMCallConnectType;


/*!
 *  \~chinese
 *  通话数据流状态
 *
 *  \~english
 *  Call status
 */
typedef enum{
    EMCallStreamStatusVoicePause = 0,  /*! \~chinese 中断语音 \~english Pause voice streaming */
    EMCallStreamStatusVoiceResume,     /*! \~chinese 继续语音 \~english Resume voice streaming */
    EMCallStreamStatusVideoPause,      /*! \~chinese 中断视频 \~english Pause video streaming */
    EMCallStreamStatusVideoResume,     /*! \~chinese 继续视频 \~english Resume video streaming */
}EMCallStreamingStatus;

/*!
 *  \~chinese
 *  通话网络状态
 *
 *  \~english
 *  Call Network status
 */
typedef enum{
    EMCallNetworkStatusNormal = 0,  /*! \~chinese 正常 \~english Network Available  */
    EMCallNetworkStatusUnstable,    /*! \~chinese 不稳定 \~english Network Unstable */
    EMCallNetworkStatusNoData,      /*! \~chinese 没有数据 \~english Network Unavailable */
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
 *  The other party's username
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
 *  The other party's display view
 */
@property (nonatomic, strong) EMCallRemoteView *remoteVideoView;

/*!
 *  \~chinese
 *  设置视频码率，必须在通话开始前设置
 *
 *  码率范围为150-1000， 默认为600
 *
 *  \~english
 *  Video bit rate, must be set before call session is started.
 *
 *  Value range is 150-1000, the default is 600.
 */
@property (nonatomic) int videoBitrate;

/*!
 *  \~chinese
 *  获取音频音量，实时变化
 *
 *  @return 音量
 *
 *  \~english
 *  Get voice volume of the call
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
 *  Get video latency, in milliseconds, changing in real time
 *
 *  @result The delay time
 */
- (int)getVideoLatency;

/*!
 *  \~chinese
 *  获取视频的帧率，实时变化
 *
 *  @result 视频帧率数值
 *
 *  \~english
 *  Get video frame rate, changing in real time
 *
 *  @result The video frame rate
 */
- (int)getVideoFrameRate;

/*!
 *  \~chinese
 *  获取视频丢包率
 *
 *  @result 视频丢包率
 *
 *  \~english
 *  Get video package lost rate
 *
 *  @result Video package lost rate
 */
- (int)getVideoLostRateInPercent;

/*!
 *  \~chinese
 *  获取视频的宽度，固定值，不会实时变化
 *
 *  @result 视频宽度
 *
 *  \~english
 *  Get video original width
 *
 *  @result Video original width
 */
- (int)getVideoWidth;

/*!
 *  \~chinese
 *  获取视频的高度，固定值，不会实时变化
 *
 *  @result 视频高度
 *
 *  \~english
 *  Get fixed video original height
 *
 *  @result Video original height
 */
- (int)getVideoHeight;

/*!
 *  \~chinese
 *  获取视频通话对方的比特率kbps，实时变化
 *
 *  @result 对方比特率
 *
 *  \~english
 *  Get the other party's bitrate, changing in real time
 *
 *  @result The other party's bitrate
 */
- (int)getVideoRemoteBitrate;

/*!
 *  \~chinese
 *  获取视频的比特率kbps，实时变化
 *
 *  @result 视频比特率
 *
 *  \~english
 *  Get bitrate of video call, changing in real time
 *
 *  @result Bitrate of video call
 */
- (int)getVideoLocalBitrate;

/*!
 *  \~chinese
 *  获取视频快照，只支持JPEG格式
 *
 *  @param aPath  图片存储路径
 *
 *  \~english
 *  Get a snapshot of current video screen as jpeg picture and save to the local file system.
 *
 *  @param aPath  Saved path of picture
 */
- (void)screenCaptureToFilePath:(NSString *)aPath error:(EMError**)pError;

/*!
 *  \~chinese
 *  开始录制视频
 *
 *  @param aPath            文件保存路径
 *  @param aError           错误
 *
 *  \~english
 *  Start recording video
 *
 *  @param aPath            File saved path
 *  @param aError           Error

 *
 */
- (void)startVideoRecordingToFilePath:(NSString*)aPath
                                error:(EMError**)aError;

/*!
 *  \~chinese
 *  停止录制视频
 *
 *  @param aError           错误
 *
 *  \~english
 *  Stop recording video
 *
 *  @param aError           Error
 *
 */
- (NSString *)stopVideoRecording:(EMError**)aError;

/*!
 *  \~chinese
 *  设置使用前置摄像头还是后置摄像头,默认使用前置摄像头
 *
 *  @param  aIsFrontCamera    是否使用前置摄像头, YES使用前置, NO使用后置
 *
 *  \~english
 *  Use front camera or back camera, default use front
 *
 *  @param  aIsFrontCamera    YES for front camera, NO for back camera.
 */
- (void)switchCameraPosition:(BOOL)aIsFrontCamera;

#pragma mark - Deprecated methods

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
- (int)getVideoTimedelay __deprecated_msg("Use -getVideoLatency");

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
- (int)getVideoFramerate __deprecated_msg("Use -getVideoFrameRate");

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
- (int)getVideoLostcnt __deprecated_msg("Use -getVideoLostRateInPercent");

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
- (void)takeRemotePicture:(NSString *)aFullPath __deprecated_msg("Use -screenCaptureToFilePath:");

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
- (BOOL)startVideoRecord:(NSString*)aPath __deprecated_msg("Use startVideoRecordingToFilePath:error:");

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
- (NSString *)stopVideoRecord __deprecated_msg("Use -stopVideoRecording:");

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
- (void)setCameraBackOrFront:(BOOL)isFont __deprecated_msg("Use -switchCameraPosition:");

@end

/*!
 *  \~chinese
 *  通话数据流状态
 *
 *  \~english
 *  Stream control
 */
typedef enum{
    EMCallStreamControlTypeVoicePause __deprecated_msg("Use EMCallStreamStatusVoicePause") = 0,  /*! \~chinese 中断语音 \~english Pause Voice */
    EMCallStreamControlTypeVoiceResume __deprecated_msg("Use EMCallStreamStatusVoiceResume"),     /*! \~chinese 继续语音 \~english Resume Voice */
    EMCallStreamControlTypeVideoPause __deprecated_msg("Use EMCallStreamStatusVideoPause"),      /*! \~chinese 中断视频 \~english Pause Video */
    EMCallStreamControlTypeVideoResume __deprecated_msg("Use EMCallStreamStatusVideoResume"),     /*! \~chinese 继续视频 \~english Resume Video */
}EMCallStreamControlType __deprecated_msg("Use EMCallStreamingStatus");

