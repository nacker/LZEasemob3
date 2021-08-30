//
//  UIImageView+Extension.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)zz_setImageWithURL:(NSString *)url placeholder:(NSString *)placeholder
{
//    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//
//    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholder]];
    
    [self sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:placeholder]];
    
//    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:placeholder]];
}

@end
