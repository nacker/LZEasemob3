//
//  LZMomentsHeaderView.m
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsHeaderView.h"

@interface LZMomentsHeaderView()
{
    UIImageView *_backgroundImageView;
    UIImageView *_iconView;
    UILabel *_nameLabel;
}

@end

@implementation LZMomentsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    _backgroundImageView = [UIImageView new];
    _backgroundImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage.jpg"];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    typeof(self) __weak weakSelf = self;
    _iconView = [UIImageView new];
    _iconView.userInteractionEnabled = YES;
    _iconView.image = [UIImage imageNamed:@"me.jpg"];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 3;
    [_iconView setTapActionWithBlock:^{
        weakSelf.iconButtonClick();
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = [LZDataBaseTool getUserDefaultsWithKey:@"username"];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [self addSubview:_backgroundImageView];
    [self addSubview:_iconView];
    [self addSubview:_nameLabel];
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(-20, 0, 40, 0));
    }];

    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_iconView.mas_left).offset(-15);
        make.centerY.equalTo(_iconView);
    }];
}

- (void)updateHeight:(CGFloat)height
{
    self.height = height;
    
    if (self.height == 200) {
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    }else{
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    [self layoutIfNeeded];
}
@end
