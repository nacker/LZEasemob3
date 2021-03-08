//
//  EMCallOptions+NSCoding.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 15/10/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import "EMCallOptions+NSCoding.h"

@implementation EMCallOptions (NSCoding)

#pragma mark - NSKeyedArchiver

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.isSendPushIfOffline = [aDecoder decodeBoolForKey:@"emIsSendPushIfOffline"];
        self.videoResolution = (EMCallVideoResolution)[aDecoder decodeIntegerForKey:@"emVideoResolution"];
        self.videoKbps = [aDecoder decodeIntForKey:@"emVideoKbps"];
        self.offlineMessageText = @"You have incoming call...";
    }

    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.isSendPushIfOffline forKey:@"emIsSendPushIfOffline"];
    [aCoder encodeInteger:self.videoResolution forKey:@"emVideoResolution"];
    [aCoder encodeInt:self.videoKbps forKey:@"emVideoKbps"];
}

@end
