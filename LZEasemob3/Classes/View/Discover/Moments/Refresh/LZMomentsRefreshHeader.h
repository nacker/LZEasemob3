//
//  LZMomentsRefreshHeader.h
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZBaseRefreshView.h"

@interface LZMomentsRefreshHeader : LZBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (nonatomic, copy) void(^refreshingBlock)();


@end
