//
//  DateTimeHelper.h
//  YSWS
//
//  Created by nacker on 2020/6/28.
//  Copyright © 2020 common. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*

 1.以便DateTimeHelper.m代码的单个方法考到项目中单独使用
   每个类方法都解耦独立，不共用任何属性或类方法

 2.方便直接控件显示，返回类型都是字符串NSString类型
   数值类型请自行用NSString类方法转换

*/
@interface DateTimeHelper : NSObject
// 获取当前时间: 格式为20161013101801
+ (NSString *)getCurrentTimeString;


// 获取当前日期：格式为2016-01-13
+ (NSString *)getCurrentDateWithFormatterString;

// 获取当前时间：格式为10:18:01
+ (NSString *)getCurrentTimeWithFormatterString;

// 获取当前日期时间：格式为2016-01-13 10:18:01
+ (NSString *)getCurrentDateTimeWithFormatterString;

// 获取当前日期：格式为 2016年1月15日
+ (NSString *)getCurrentDateForChineseString;

/*
   当前时间与给定时间timeString的时间【秒】差
   timeString格式参考：20161013101801
 */
+ (NSString *)secondsFromTimeString:(NSString *)timeString;


/*
   当前时间与给定时间timeString的时间【分】差
   timeString格式参考：20161013101801
 */
+ (NSString *)minutesFromTimeString:(NSString *)timeString;


/*
   当前时间与给定时间timeString的时间【时】差
   timeString格式参考：20161013101801
 */
+ (NSString *)hoursFromTimeString:(NSString *)timeString;


/*
   当前时间与给定时间timeString的时间【日】差
   timeString格式参考：20161013101801
 */
+ (NSString *)daysFromTimeString:(NSString *)timeString;


/*
   获取给定某年某月的月份【第一天】日期
   dateString格式为：yyyy-MM，例如 2016-09
   返回格式为：yyyy-MM-dd    ，例如 2016-09-01
 */
+ (NSString *)getMonthBeginFromDateString:(NSString *)dateString;


/*
  获取给定某年某月的月份【最后一天】日期
  dateString格式为：yyyy-MM，例如 2016-02
  返回格式为：yyyy-MM-dd    ，例如 2016-02-29
 */
+ (NSString *)getMonthEndFromDateString:(NSString *)dateString;



/**
   时间格式互相转换
 @param dateString                格式要转换的日期时间     例如：2015-06-26 08:08:08
 @param inputDateStringFormatter  输入的dateString格式   例如：yyyy-MM-dd HH:mm:ss
 @param outputDateStringFormatter 想要输出的日期格式       例如：yy/MM/dd
 @return 想要的日期格式字符串
 参考示例：
 1,
 inputDateStringFormatter:@"yyyy-MM-dd HH:mm:ss"
 outputDateStringFormatter:@"yy/MM/dd"
 
 2,
 inputDateStringFormatter:@"yyyy-MM-dd HH:mm:ss"
 outputDateStringFormatter:@"HH:mm:ss"
 
 3,
 inputDateStringFormatter:@"yyyy-MM-dd HH:mm:ss"
 outputDateStringFormatter:@"yyyy-MM-dd"
 
 4,
 inputDateStringFormatter:@"yyyy年M月"
 outputDateStringFormatter:@"yyyy-MM"
 
 5,
 inputDateStringFormatter:@"yyyy年M月"
 outputDateStringFormatter:@"yyyy-MM-01"
 
 */
+ (NSString *)dateFormatterWithInputDateString:(NSString *)dateString
                      inputDateStringFormatter:(NSString *)inputDateStringFormatter
                     outputDateStringFormatter:(NSString *)outputDateStringFormatter;



// 给定总秒数，返回日期和时间，例如：YYYY-MM-dd HH:mm:ss
+ (NSString *)secondsToDateFormatted:(NSString *)totalSeconds;
@end

NS_ASSUME_NONNULL_END
