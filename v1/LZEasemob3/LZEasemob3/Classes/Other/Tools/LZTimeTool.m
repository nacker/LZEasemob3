//
//  LZTimeTool.m
//  testhuanxin
//
//  Created by nacker on 15-3-9.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZTimeTool.h"

@implementation LZTimeTool

+(NSString *)timeStr:(long long)timestamp{
    //返回时间格式
    
    
    //currentDate 2015-09-28 16:28:09 +0000
    //msgDate 2015-09-28 10:36:22 +0000
    NSCalendar   *calendar = [NSCalendar currentCalendar];
    //1.获取当前的时间
    NSDate *currentDate = [NSDate date];
    
    // 获取年，月，日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    //    NSLog(@"currentYear %ld",components.year);
    //    NSLog(@"currentMonth %ld",components.month);
    //    NSLog(@"currentDay %ld",components.day);
    
    
    //2.获取消息发送时间
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    // 获取年，月，日
    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYead = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    //    NSLog(@"msgYear %ld",components.year);
    //    NSLog(@"msgMonth %ld",components.month);
    //    NSLog(@"msgDay %ld",components.day);
    
    
    //3.判断:
    /*今天：(HH:mm)
     *昨天: (昨天 HH:mm)
     *昨天以前:（2015-09-26 15:27）
     */
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYead
        && currentMonth == msgMonth
        && currentDay == msgDay) {//今天
        dateFmt.dateFormat= @"HH:mm";
    }else if(currentYear == msgYead
             && currentMonth == msgMonth
             && currentDay - 1 == msgDay){//昨天
        dateFmt.dateFormat= @"昨天 HH:mm";
    }else{//昨天以前
        dateFmt.dateFormat= @"yyy-MM-dd HH:mm";
    }
    
    return [dateFmt stringFromDate:msgDate];
}

@end
