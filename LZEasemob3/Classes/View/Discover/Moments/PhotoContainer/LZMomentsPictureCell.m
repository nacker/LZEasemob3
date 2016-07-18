//
//  LZMomentsPictureCell.m
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsPictureCell.h"

@interface LZMomentsPictureCell()

@property (nonatomic, strong) UIImageView *gifIconView;

@end

@implementation LZMomentsPictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    
    [self.imageView getImageWithURL:imageURL placeholder:imageURL];
}
@end
