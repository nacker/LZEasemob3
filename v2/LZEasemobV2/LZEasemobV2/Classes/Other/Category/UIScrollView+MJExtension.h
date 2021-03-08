//
//  UIScrollView+MJExtension.h
//  TTCF
//
//  Created by nacker on 2020/9/23.
//  Copyright © 2020 nacker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Refresh)

/** 添加头部刷新 */
-(void)addHeaderRefresh:(MJRefreshComponentAction)block;
/** 开始头部刷新 */
-(void)beginHeaderRefresh;
/** 结束头部刷新 */
-(void)endHeaderRefresh;

/** 添加底部自动刷新 */
-(void)addAutoFooterRefresh:(MJRefreshComponentAction)block;
/** 添加底部返回刷新 */
-(void)addBackFooterRefresh:(MJRefreshComponentAction)block;
/** 开始底部刷新 */
-(void)beginFooterRefresh;
/** 结束底部刷新 */
-(void)endFooterRefresh;

@end

NS_ASSUME_NONNULL_END
