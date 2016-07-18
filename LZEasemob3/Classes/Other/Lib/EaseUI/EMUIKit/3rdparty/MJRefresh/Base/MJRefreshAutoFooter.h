//
//  MJRefreshAutoFooter.h
//  MJRefreshExample
//

#import "MJRefreshFooter.h"

@interface MJRefreshAutoFooter : MJRefreshFooter

@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh MJRefreshDeprecated("请使用automaticallyChangeAlpha属性");
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@end
