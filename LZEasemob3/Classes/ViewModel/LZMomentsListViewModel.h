//
//  LZMomentsListtViewModel.h
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZMomentsListViewModel : NSObject

/// 微博视图模型数组
@property (nonatomic, strong) NSMutableArray *statusList;


- (void)loadStatusWithCount:(NSInteger)count Completed:(void (^)(BOOL isSuccessed))completed;

- (void)loadMoreStatusWithCount:(NSInteger)count Completed:(void (^)(BOOL isSuccessed))completed;
@end
