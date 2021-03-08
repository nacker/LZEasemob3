//
//  LZMomentsSendViewModel.m
//  LZEasemob
//
//  Created by nacker on 16/4/6.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsSendViewModel.h"

@implementation LZMomentsSendViewModel

- (instancetype)init
{
    if (self = [super init]){
        self.assets = @[];
    }
    return self;
}

- (RACSignal *)publish
{
    return [RACSignal empty];
}

- (RACSignal *)publishContent
{
    return [RACSignal empty];
}


@end
