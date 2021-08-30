//
//  UIScrollView+MJExtension.m
//  TTCF
//
//  Created by nacker on 2020/9/23.
//  Copyright © 2020 nacker. All rights reserved.
//

#import "UIScrollView+MJExtension.h"

@implementation UIScrollView(Refresh)

-(void)addHeaderRefresh:(MJRefreshComponentAction)block{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}
-(void)beginHeaderRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_header beginRefreshing];
    });
}
-(void)endHeaderRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_header endRefreshing];
    });
}
-(void)addAutoFooterRefresh:(MJRefreshComponentAction)block{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
}
-(void)addBackFooterRefresh:(MJRefreshComponentAction)block{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}
-(void)beginFooterRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_footer beginRefreshing];
    });
}
-(void)endFooterRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_footer endRefreshing];
    });
}


@end
