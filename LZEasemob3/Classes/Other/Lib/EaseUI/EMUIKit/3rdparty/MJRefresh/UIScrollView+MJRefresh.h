//  UIScrollView+MJRefresh.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.

#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"

@class MJRefreshHeader, MJRefreshFooter;

@interface UIScrollView (MJRefresh)

@property (strong, nonatomic) MJRefreshHeader *mj_header;
@property (strong, nonatomic) MJRefreshHeader *header MJRefreshDeprecated("mj_header");
@property (strong, nonatomic) MJRefreshFooter *mj_footer;
@property (strong, nonatomic) MJRefreshFooter *footer MJRefreshDeprecated("mj_footer");
@property (copy, nonatomic) void (^mj_reloadDataBlock)(NSInteger totalDataCount);

- (NSInteger)mj_totalDataCount;

@end
