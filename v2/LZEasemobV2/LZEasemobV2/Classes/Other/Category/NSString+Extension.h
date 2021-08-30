//
//  NSString+Extension.h
//  Easemob
//
//  Created by nacker on 15/12/22.
//  Copyright © 2015年 帶頭二哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)md5;

/**
 获取当前时间
 */
+ (NSString*)getCurrentTimes;

+ (NSString *)utf8String:(NSString *)str;

+ (NSString *)transformedValue:(long long)value;

- (BOOL)isChinese;

- (BOOL)isURL;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)sizeWithFont:(UIFont *)font;

+ (NSString *)timeWithDate:(NSDate *)date;


- (NSString *)pinyin;
- (NSString *)pinyinInitial;


/**
 *  正则判断手机号码
 */
- (BOOL)isMobileNum;


/**
 去除字符串中所有的空格和换行符(包括中间和首尾)
 */
- (NSString *)removeSpaceAndNewline;


/**
 手机号加密
 */
- (NSString *)strEncryption;

/**
 字符串4个一组进行分割
 * type 分隔符
 */
- (NSString *)stringCutOutTypeStr:(NSString *)type;

/**
 判断字符串位为空
 */
- (BOOL)isBlankString;

/** 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒 */
- (NSString *)getDateStringWithTimeStr;
- (NSString *)getDateStringWithTime;
@end
