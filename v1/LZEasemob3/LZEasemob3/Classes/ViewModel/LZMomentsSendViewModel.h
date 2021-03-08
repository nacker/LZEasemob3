//
//  LZMomentsSendViewModel.h
//  LZEasemob
//
//  Created by nacker on 16/4/6.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//  发送朋友圈

#import <Foundation/Foundation.h>

@interface LZMomentsSendViewModel : NSObject

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, copy) NSString *textPlain;

- (RACSignal *)publish;
- (RACSignal *)publishContent;

@end
