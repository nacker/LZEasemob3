//
//  MJRefreshAutoStateFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//

#import "MJRefreshAutoFooter.h"

@interface MJRefreshAutoStateFooter : MJRefreshAutoFooter

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@property (weak, nonatomic, readonly) UILabel *stateLabel;

@end
