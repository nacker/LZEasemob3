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

#import <Foundation/Foundation.h>

#define EASEUI_EMOTION_DEFAULT_EXT @"em_emotion"

#define MESSAGE_ATTR_IS_BIG_EXPRESSION @"em_is_big_expression"
#define MESSAGE_ATTR_EXPRESSION_ID @"em_expression_id"

typedef NS_ENUM(NSUInteger, EMEmotionType) {
    EMEmotionDefault = 0,//默认表情
    EMEmotionPng,//
    EMEmotionGif//大表情或者Gif表情
};

@interface EaseEmotionManager : NSObject

/*!
 @property
 @brief EaseEmotion数组
 */
@property (nonatomic, strong) NSArray *emotions;

/*!
 @property
 @brief 表情控件显示行数
 */
@property (nonatomic, assign) NSInteger emotionRow;

/*!
 @property
 @brief 表情控件显示列数
 */
@property (nonatomic, assign) NSInteger emotionCol;

/*!
 @property
 @brief 表情类型
 */
@property (nonatomic, assign) EMEmotionType emotionType;

/*!
 @property
 @brief 表情控件底部按钮表情
 */
@property (nonatomic, strong) UIImage *tagImage;

- (id)initWithType:(EMEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions;

- (id)initWithType:(EMEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage;

@end

@interface EaseEmotion : NSObject

/*!
 @property
 @brief 表情类型
 */
@property (nonatomic, assign) EMEmotionType emotionType;

/*!
 @property
 @brief 表情文字
 */
@property (nonatomic, copy) NSString *emotionTitle;

/*!
 @property
 @brief 表情Id
 */
@property (nonatomic, copy) NSString *emotionId;

/*!
 @property
 @brief 表情本地缩略图地址
 */
@property (nonatomic, copy) NSString *emotionThumbnail;

/*!
 @property
 @brief 表情本地原始图片地址
 */
@property (nonatomic, copy) NSString *emotionOriginal;

/*!
 @property
 @brief 表情本地原始网络地址
 */
@property (nonatomic, copy) NSString *emotionOriginalURL;

- (id)initWithName:(NSString*)emotionTitle
         emotionId:(NSString*)emotionId
  emotionThumbnail:(NSString*)emotionThumbnail
   emotionOriginal:(NSString*)emotionOriginal
emotionOriginalURL:(NSString*)emotionOriginalURL
       emotionType:(EMEmotionType)emotionType;

@end
