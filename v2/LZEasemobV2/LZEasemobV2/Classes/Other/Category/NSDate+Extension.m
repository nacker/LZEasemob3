//
//  NSDate+Extension.m
//  LZEasemob3
//
//  Created by nacker on 15/12/17.
//  Copyright © 2015年 帶頭二哥. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

- (NSString *)dateDescription {
    
    // 1. 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 2. 判断是否是今天
    if ([calendar isDateInToday:self]) {
        
        NSInteger interval = ABS((NSInteger)[self timeIntervalSinceNow]);
        
        if (interval < 60) {
            return @"刚刚";
        }
        interval /= 60;
        if (interval < 60) {
            return [NSString stringWithFormat:@"%zd 分钟前", interval];
        }
        
        return [NSString stringWithFormat:@"%zd 小时前", interval / 60];
    }
    
    // 3. 昨天
    NSMutableString *formatString = [NSMutableString stringWithString:@" HH:mm"];
    if ([calendar isDateInYesterday:self]) {
        [formatString insertString:@"昨天" atIndex:0];
    } else {
        [formatString insertString:@"MM-dd" atIndex:0];
        
        // 4. 是否当年
        NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];
        
        if (components.year != 0) {
            [formatString insertString:@"yyyy-" atIndex:0];
        }
    }
    
    // 5. 转换格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    fmt.dateFormat = formatString;
    
    return [fmt stringFromDate:self];
}


+ (NSDate *)dateFromLongLong:(long long)msSince1970
{
    return [NSDate dateWithTimeIntervalSince1970:msSince1970 / 1000];
}

/// 获取年
+ (NSInteger)year:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.year;
}

/// 获取月
+ (NSInteger)month:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.month;
}


/// 获取星期
+ (NSInteger)week:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:startDate];
    return components.weekday - 1;
}

/// 获取星期 中文
+ (NSString *)getWeekFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    NSInteger week = components.weekday - 1;
    NSDictionary *weekDic = @{@"0":@"日",@"1":@"一",@"2":@"二",@"3":@"三",@"4":@"四",@"5":@"五",@"6":@"六"};
    NSString *key = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[key];
}

/// 获取星期中文
+ (NSString *)getChineseWeekFrom:(NSString *)dateStr {
    NSDictionary *weekDic = @{@"0":@"周日",@"1":@"周一",@"2":@"周二",@"3":@"周三",@"4":@"周四",@"5":@"周五",@"6":@"周六"};
    NSInteger week = [NSDate week:dateStr];
    NSString *weekKey = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[weekKey];
}

/// 获取日
+ (NSInteger)day:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.day;
}

/// 获取月共有多少天
+ (NSInteger)daysInMonth:(NSString *)dateStr {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate timeIntervalFromDateString:dateStr] / 1000];
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

//获取当前日期
+ (NSString *)currentDay {
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * time = [formater stringFromDate:date];
    return time;
}

//获取当前小时
+ (NSString *)currentHour {
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];
    [formater setDateFormat:@"H:mm"];
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}

//找到两个月后的第一天~ 然后通过减一天来找到下个月的最后一天，所以，下月最后一天
+ (NSString *)nextMonthLastDay {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    //设置日为1号
    dateComponents.day =1;
    //设置月份为后延2个月
    dateComponents.month +=2;
    NSDate * endDayOfNextMonth = [calendar dateFromComponents:dateComponents];
    //两个月后的1号往前推1天，即为下个月最后一天
    endDayOfNextMonth = [endDayOfNextMonth dateByAddingTimeInterval:-1];
    //格式化输出
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:endDayOfNextMonth];
    return curTime;
}

///判断是否是今天
+ (BOOL)isToday:(NSString *)dateStr {
    BOOL isDay = NO;
    NSString *day = [NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

///判断是否是明天
+ (BOOL)isTomorrow:(NSString *)dateStr {
    BOOL isDay = NO;
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 24 * 3600;
    NSString *day = [NSDate timeStringWithInterval:time];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

///判断是否是后天
+ (BOOL)isAfterTomorrow:(NSString *)dateStr {
    BOOL isDay = NO;
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 48 * 3600;
    NSString *day = [NSDate timeStringWithInterval:time];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

/// 判断是否是过去的时间
+ (BOOL)isHistoryTime:(NSString *)dateStr {
    BOOL activity = NO;
    NSTimeInterval timeInterval = [NSDate timeIntervalFromDateString: dateStr];
    NSTimeInterval currentInterval = [NSDate timeIntervalFromDateString:[NSDate currentDay]];
    if (timeInterval < currentInterval) {
        activity = YES;
    }
    return activity;
}

/// 从时间戳获取具体时间 格式:6:00
+ (NSString *)hourStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H:mm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

/// 从时间戳获取具体小时 格式:6
+ (NSString *)hourTagWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/// 从毫秒级时间戳获取具体小时 格式:600
+ (NSString *)hourNumberWithInterval:(NSTimeInterval)timeInterval {
    NSString *hourStr = [self hourStringWithInterval:timeInterval / 1000];
    NSString *hourNumber = [hourStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    return hourNumber;
}

/// 从时间戳获取具体日期 格式:2018-03-05
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/// 根据具体日期获取时间戳(毫秒)
+ (NSTimeInterval)timeIntervalFromDateString:(NSString *)dateStr {
    //要精确到毫秒2018-01-01 与 2018-01-01 00:00 都要转换成2018-01-01 00:00:00
    if (dateStr.length == 10) {
        dateStr = [dateStr stringByAppendingString:@" 00:00:00"];
    } else if (dateStr.length == 16) {
        dateStr = [dateStr stringByAppendingString:@":00"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    return interval;
}

/// 获取当前天的后几天的星期
+ (NSString *)getWeekAfterDay:(NSInteger)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger currentWeek = components.weekday - 1;
    NSDictionary *weekDic = @{@"0":@"日",@"1":@"一",@"2":@"二",@"3":@"三",@"4":@"四",@"5":@"五",@"6":@"六"};
    NSInteger week = currentWeek + day;
    if (week >= 7) {
        week -= 7;
    }
    NSString *key = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[key];
}


/// 获取当前天的后几天的日
+ (NSString *)getDayAfterDay:(NSInteger)day {
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 24 * 3600 * day;
    NSString *date = [NSDate timeStringWithInterval:time];
    NSInteger dayNum = [self day:date];
    NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)dayNum];
    return dayStr;
}

/// 获取当前月的后几月
+ (NSString *)getMonthAfterMonth:(NSInteger)Month {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:Month];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}
@end
