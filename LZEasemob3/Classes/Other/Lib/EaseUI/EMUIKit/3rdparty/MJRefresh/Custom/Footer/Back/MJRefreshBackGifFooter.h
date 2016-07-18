//
//  MJRefreshBackGifFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackGifFooter : MJRefreshBackStateFooter

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;

@end
