//
//  NSObject+Parse.h
//  TTServe
//
//  Created by nacker on 2020/11/26.
//

#import <Foundation/Foundation.h>

@interface NSObject (Parse)
/** 对MJExtension的封装，自动判断参数类型。来解析 */
+ (instancetype)lz_parse:(id)responseObj;


/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)lz_isNullOrNilWithObject:(id)object;

@end
