/*!
 *  \~chinese
 *  @header EMImageMessageBody.h
 *  @abstract 图片消息体
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMImageMessageBody.h
 *  @abstract Image message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMFileMessageBody.h"

/*!
 *  \~chinese
 *  图片消息体，SDK发送消息前会根据compressRatio压缩通过-(instancetype)initWithData:displayName:或
 *  -(instancetype)initWithData:thumbnailData:创建的消息体的图片
 *
 *  \~english
 *  Image message body
 */
@interface EMImageMessageBody : EMFileMessageBody

/*!
 *  \~chinese
 *  图片附件的尺寸
 *
 *  \~english
 *  Size of image attachment
 */
@property (nonatomic) CGSize size;

/*!
 *  \~chinese
 *  设置发送图片消息时的压缩率，1.0时不压缩，默认值是0.6，如果设置了小于等于0的值，则使用默认值
 *
 *  \~english
 *  Image compression ratio. 1.0 without compression, default value is 0.6. SDK uses the default value if the given value is less than zero.
 */
@property (nonatomic) CGFloat compressRatio __deprecated_msg("Use - compressionRatio");

@property (nonatomic) CGFloat compressionRatio;

/*!
 *  \~chinese
 *  缩略图的显示名
 *
 *  \~english
 *  Display name of thumbnail
 */
@property (nonatomic, copy) NSString *thumbnailDisplayName;

/*!
 *  \~chinese
 *  缩略图的本地路径
 *
 *  \~english
 *  Local path of thumbnail
 */
@property (nonatomic, copy) NSString *thumbnailLocalPath;

/*!
 *  \~chinese
 *  缩略图在服务器的路径
 *
 *  \~english
 *  Server path of thumbnail
 */
@property (nonatomic, copy) NSString *thumbnailRemotePath;

/*!
 *  \~chinese
 *  缩略图的密钥, 下载缩略图时需要密匙做校验
 *
 *  \~english
 *  Secret key for downloading a thumbnail image
 */
@property (nonatomic, copy) NSString *thumbnailSecretKey;

/*!
 *  \~chinese
 *  缩略图的尺寸
 *
 *  \~english
 *  Size of a thumbnail
 */
@property (nonatomic) CGSize thumbnailSize;

/*!
 *  \~chinese
 *  缩略图文件的大小, 以字节为单位
 *
 *  \~english
 *  File length of a thumbnail, in bytes
 */
@property (nonatomic) long long thumbnailFileLength;

/*!
 *  \~chinese
 *  缩略图下载状态
 *
 *  \~english
 *  Download status of a thumbnail
 */
@property (nonatomic)EMDownloadStatus thumbnailDownloadStatus;

/*!
 *  \~chinese
 *  初始化图片消息体
 *
 *  @param aData          图片数据
 *  @param aThumbnailData 缩略图数据
 *
 *  @result 图片消息体实例
 *
 *  \~english
 *  Initialize an image message body instance
 *
 *  @param aData          The data of image
 *  @param aThumbnailData The data of thumbnail
 *
 *  @result An image message body instance
 */
- (instancetype)initWithData:(NSData *)aData
               thumbnailData:(NSData *)aThumbnailData;

@end
