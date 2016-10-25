/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "EMSDK.h"

@class EMMessage;
@protocol IMessageModel <NSObject>

//缓存数据模型对应的cell的高度，只需要计算一次并赋值，以后就无需计算了
@property (nonatomic) CGFloat cellHeight;

//SDK中的消息
@property (strong, nonatomic, readonly) EMMessage *message;

//消息ID
@property (strong, nonatomic, readonly) NSString *messageId;
//消息发送状态
@property (nonatomic, readonly) EMMessageStatus messageStatus;
//消息类型
@property (nonatomic, readonly) EMMessageBodyType bodyType;
//是否已读
@property (nonatomic) BOOL isMessageRead;

//是否是当前登录者发送的消息
@property (nonatomic) BOOL isSender;
//消息显示的昵称
@property (strong, nonatomic) NSString *nickname;
//消息显示的头像的网络地址
@property (strong, nonatomic) NSString *avatarURLPath;
//消息显示的头像
@property (strong, nonatomic) UIImage *avatarImage;

//文本消息：文本
@property (strong, nonatomic) NSString *text;

//文本消息：文本
@property (strong, nonatomic) NSAttributedString *attrBody;

//获取图片失败后显示的图片
@property (strong, nonatomic) NSString *failImageName;
//图片消息：图片原图的宽高
@property (nonatomic) CGSize imageSize;
//图片消息：图片缩略图的宽高
@property (nonatomic) CGSize thumbnailImageSize;
//图片消息：图片原图
@property (strong, nonatomic) UIImage *image;
//图片消息：图片缩略图
@property (strong, nonatomic) UIImage *thumbnailImage;

//地址消息：地址描述
@property (strong, nonatomic) NSString *address;
//地址消息：地址经度
@property (nonatomic) double latitude;
//地址消息：地址纬度
@property (nonatomic) double longitude;

//多媒体消息：是否正在播放
@property (nonatomic) BOOL isMediaPlaying;
//多媒体消息：是否播放过
@property (nonatomic) BOOL isMediaPlayed;
//多媒体消息：长度
@property (nonatomic) CGFloat mediaDuration;

//文件消息：文件图标 TODO:???
@property (strong, nonatomic) NSString *fileIconName;
//文件消息：文件名称
@property (strong, nonatomic) NSString *fileName;
//文件消息：文件大小描述
@property (strong, nonatomic) NSString *fileSizeDes;

//带附件的消息的上传或下载进度
@property (nonatomic) float progress;

//消息：附件本地地址
@property (strong, nonatomic, readonly) NSString *fileLocalPath;
//消息：压缩附件本地地址
@property (strong, nonatomic) NSString *thumbnailFileLocalPath;
//消息：附件下载地址
@property (strong, nonatomic) NSString *fileURLPath;
//消息：压缩附件下载地址
@property (strong, nonatomic) NSString *thumbnailFileURLPath;

- (instancetype)initWithMessage:(EMMessage *)message;

@end
