//
//  EMPluginVideoRecorder.h
//  HyphenateSDK
//
//  Created by XieYajie on 23/09/2016.
//  Copyright © 2016 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMError;
@interface EMPluginVideoRecorder : NSObject

/*!
 *  \~chinese
 *  获取插件实例
 *
 *  \~english
 *  Get plugin singleton instance
 */
+ (instancetype)sharedInstance;

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
- (void)screenCaptureToFilePath:(NSString *)aPath
                          error:(EMError**)pError;

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

@end
