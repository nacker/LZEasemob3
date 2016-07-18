/*!
 *  \~chinese
 *  @header OpenGLView20.h
 *  @abstract 视频显示页面
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header OpenGLView20.h
 *  @abstract Video display view
 *  @author Hyphenate
 *  @version 3.00
 */

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@interface OpenGLView20 : UIView

@property (nonatomic) BOOL isRunning;

/*!
 @method
 @brief  将数据画到屏幕上
 @param data      数据
 @param width     宽度
 @param height    高度
 */
- (void)displayYUV420pData:(char *)data width:(GLuint)width height:(GLuint)height;

/*!
 @method
 @brief  设置视频显示区域大小
 @param width     宽度
 @param height    高度
 */
- (void)setVideoSize:(GLuint)width height:(GLuint)height;

/*!
 @method
 @brief  清除画面
 */
- (void)clearFrame;

@end
