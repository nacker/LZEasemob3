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

#define MAKE_Q(x) @#x
#define MAKE_EM(x,y) MAKE_Q(x##y)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunicode"
#define MAKE_EMOJI(x) MAKE_EM(\U000,x)
#pragma clang diagnostic pop

#define EMOJI_METHOD(x,y) + (NSString *)x { return MAKE_EMOJI(y); }
#define EMOJI_HMETHOD(x) + (NSString *)x;
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

/*!
 @class
 @brief iOS内置表情编码处理类
 */
@interface EaseEmoji : NSObject

/*!
 @method
 @brief unicode编码转换为iOS内置表情字符串
 @discussion
 @param code iOS内置表情对应的unicode编码值
 @result iOS内置表情字符串
 */
+ (NSString *)emojiWithCode:(int)code;

/*!
 @method
 @brief 获取所有iOS内置表情
 @discussion
 @result iOS表情字符串数组
 */
+ (NSArray *)allEmoji;

/*!
 @method
 @brief 判断字符是否为Emoji
 @discussion
 @param string 需要判断是否为emoji的字符
 @result 字符是否为Emoji
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
