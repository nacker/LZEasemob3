//
//  LZMomentsViewModel.h
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZMoments.h"

@interface LZMomentsViewModel : NSObject

/// 微博模型
@property (nonatomic, strong) LZMoments *status;

/// 用户头像
@property (nonatomic, readonly) NSString *iconName;

/// 用户名字
@property (nonatomic, readonly) NSString *name;

/// 内容
@property (nonatomic, copy) NSString *msgContent;

/// 配图
@property (nonatomic, strong) NSArray *picNamesArray;

/// 配图
@property (nonatomic, readonly) NSString *time;

+ (instancetype)viewModelWithStatus:(LZMoments *)status;

/// 是否展开
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end
