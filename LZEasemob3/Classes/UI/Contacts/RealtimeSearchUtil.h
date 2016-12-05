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

typedef void (^RealtimeSearchResultsBlock)(NSArray *results);

@interface RealtimeSearchUtil : NSObject

/**
 *  是否连续搜索，默认YES(要搜索的字符串作为一个整体)
 */
@property (nonatomic) BOOL asWholeSearch;

/**
 *  实时搜索单例实例化
 *
 *  @return 实时搜索单例
 */
+ (instancetype)currentUtil;

/**
 *  开始搜索，与[realtimeSearchStop]配套使用
 *
 *  @param source      要搜索的数据源
 *  @param searchText  要搜索的字符串
 *  @param selector    获取元素中要比较的字段的方法
 *  @param resultBlock 回调方法，返回搜索结果
 */
- (void)realtimeSearchWithSource:(id)source searchText:(NSString *)searchText collationStringSelector:(SEL)selector resultBlock:(RealtimeSearchResultsBlock)resultBlock;

/**
 *  从fromString中搜索是否包含searchString
 *
 *  @param searchString 要搜索的字串
 *  @param fromString   从哪个字符串搜索
 *
 *  @return 是否包含字串
 */
- (BOOL)realtimeSearchString:(NSString *)searchString fromString:(NSString *)fromString;

/**
 * 结束搜索，只需要调用一次，在[realtimeSearchBegin...:]之后使用，主要用于释放资源
 */
- (void)realtimeSearchStop;

@end
