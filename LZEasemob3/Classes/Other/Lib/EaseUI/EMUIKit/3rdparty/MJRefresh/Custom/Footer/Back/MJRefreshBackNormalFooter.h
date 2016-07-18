//
//  MJRefreshBackNormalFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//

#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackNormalFooter : MJRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
