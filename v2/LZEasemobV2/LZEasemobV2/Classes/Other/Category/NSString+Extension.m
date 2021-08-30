//
//  NSString+Extension.m
//  Easemob
//
//  Created by nacker on 15/12/22.
//  Copyright © 2015年 帶頭二哥. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Extension)

- (NSString *)md5
{
    const char *cStr = self.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

+ (NSString *)utf8String:(NSString *)str
{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)transformedValue:(long long)value {
    double convertedValue = value;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes", @"KB", @"MB", @"GB", @"TB", nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

- (BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isURL{
    NSString * url = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:url];
    if (URL && URL.scheme && URL.host) {
        return YES;
    }
    else{
        return NO;
    }
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
//    if (iOS7) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    } else {
//        return [self sizeWithFont:font constrainedToSize:maxSize];
//    }
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (NSString *)timeWithDate:(NSDate *)date
{
    if (date == nil)
    {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *now = [NSDate date];
    
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [calendar components:unit fromDate:now];
    NSInteger nowHour = components.hour;
    NSInteger nowMinute = components.minute;
    NSInteger nowSecond = components.second;
    NSInteger nowWeekday = components.weekday;
    
    components = [calendar components:unit fromDate:date];
    NSInteger dateHour = components.hour;
    NSInteger dateMinute = components.minute;
    NSInteger dateWeekday = components.weekday;
    
    NSTimeInterval interval = [now timeIntervalSinceDate:date];
    
    NSString *result = @"";
    if (interval > 24*60*60*7)
    {
        //一个星期之前显示全部时间
        result = [formatter stringFromDate:date];
    }
    else if(interval >= 24*60*60*1+nowHour*60*60+nowMinute*60+nowSecond)//大于等于2天
    {
        //上个星期
        if(nowWeekday<dateWeekday)
        {
            result = [formatter stringFromDate:date];
        }
        else    //本星期要显示星期
        {
            result = [NSString stringWithFormat:@"%@ %02zi:%02zi", [self stringedWeekday:dateWeekday], dateHour, dateMinute];
        }
    }
    else if(interval >= nowHour*60*60+nowMinute*60+nowSecond)    //昨天
    {
        result = [NSString stringWithFormat:@"%@ %02zi:%02zi", @"昨天", dateHour, dateMinute];
    }
    else
    {
        result = [NSString stringWithFormat:@"%02zi:%02zi", dateHour, dateMinute];
    }
    
    return result;
}

+ (NSString *)stringedWeekday:(NSUInteger)weekday
{
    assert(weekday>=1 && weekday<=7);
    
    return @[@"星期日",
             @"星期一",
             @"星期二",
             @"星期三",
             @"星期四",
             @"星期五",
             @"星期六"][weekday-1];
}


- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pinyinInitial
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    return initial;
}

- (BOOL)isMobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186,183
     * 电信：133,1349,153,180,189,177
     * 其他    170
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[07])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[356])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349|7[07])\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    if (res1 || res2 || res3 || res4 ){
        return YES;
    }else{
        return NO;
    }
}

// 去除字符串中所有的空格和换行符(包括中间和首尾)
- (NSString *)removeSpaceAndNewline{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


+ (NSString*)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
//    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

/**
 手机号加密
 */
- (NSString *)strEncryption
{
    NSString *start = [self substringToIndex:3];
    NSString *end = [self substringFromIndex:self.length - 4];
    return [NSString stringWithFormat:@"%@****%@",start,end];
}

/**
 字符串4个一组进行分割
 * type 分隔符
 */
- (NSString *)stringCutOutTypeStr:(NSString *)type{
   NSMutableArray *dataArrs = [NSMutableArray arrayWithCapacity:0];
   NSInteger tmp = self.length/4;
    for (int i = 0; i < self.length+1; i++) {
      if (i%4 == 0 & i != 0) {
          [dataArrs addObject:[NSString stringWithFormat:@"%@",[self substringWithRange:NSMakeRange(i-4,4)]]];
      }
      if (tmp*4 == i) {
          [dataArrs addObject:[NSString stringWithFormat:@"%@",[self substringWithRange:NSMakeRange(tmp*4,self.length-tmp*4)]]];
      }
   }
   return [dataArrs componentsJoinedByString:type];
}

/**
 判断字符串位为空
 */
- (BOOL)isBlankString {
    if (!self) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!self.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [self stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr{
    NSTimeInterval time=[self doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SS"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

- (NSString *)getDateStringWithTime
{
    NSTimeInterval time = [self doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
@end
