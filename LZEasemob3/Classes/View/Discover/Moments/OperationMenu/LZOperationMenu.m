//
//  LZOperationMenu.m
//  LZEasemob
//
//  Created by nacker on 16/4/1.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZOperationMenu.h"

@implementation LZOperationMenu
{
    UIButton *_likeButton;
    UIButton *_commentButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = KRGBACOLOR(69, 74, 76, 1);
    
    // 添加控件
    _likeButton = [self creatButtonWithTitle:@"赞" image:[UIImage imageNamed:@"AlbumLike"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"AlbumComment"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    
    [self addSubview:_likeButton];
    [self addSubview:_commentButton];
    [self addSubview:centerLine];
    
    
    // 布局
    CGFloat margin = 5;
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(margin);
        make.top.bottom.equalTo(self);
        make.width.equalTo(@80);
    }];
    
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.equalTo(self.mas_top).offset(margin);
        make.bottom.equalTo(self.mas_bottom).offset(-margin);
        make.centerX.equalTo(self);
    }];
    
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(centerLine.mas_right).offset(margin);
        make.width.equalTo(_likeButton);
        make.top.bottom.equalTo(_likeButton);
        make.right.equalTo(self.mas_right).offset(-margin);
    }];
}

- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sele
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sele forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

-(void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
    self.show = NO;
}

-(void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.show = NO;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    
//    [self setNeedsUpdateConstraints];
// 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
        } else {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@180);
            }];
        }
        [self layoutIfNeeded];
    }];
}

@end
