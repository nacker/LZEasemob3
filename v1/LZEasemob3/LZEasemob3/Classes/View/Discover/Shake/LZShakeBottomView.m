//
//  LZShakeBottomView.m
//  Easemob
//
//  Created by nacker on 15/12/24.
//  Copyright © 2015年 帶頭二哥. All rights reserved.
//

#import "LZShakeBottomView.h"
#import "LZBaseBtn.h"

@interface LZShakeBottomView()

@property (nonatomic, strong) LZBaseBtn *peopleButton;
@property (nonatomic, strong) LZBaseBtn *musicButton;
@property (nonatomic, strong) LZBaseBtn *tvButton;

@property (nonatomic, weak) LZBaseBtn *selectedButton;

@end

@implementation LZShakeBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.peopleButton = [self setupBtnWithTitle:@"人" imageNormal:@"Shake_icon_people" imageSelected:@"Shake_icon_peopleHL" index:LZShakePeopleButton];
        self.musicButton = [self setupBtnWithTitle:@"歌曲" imageNormal:@"Shake_icon_music" imageSelected:@"Shake_icon_musicHL" index:LZShakeMusicButton];
        self.tvButton = [self setupBtnWithTitle:@"电视" imageNormal:@"Shake_icon_tv" imageSelected:@"Shake_icon_tvHL" index:LZShakeTvButton];
        
        [self buttonClick:self.peopleButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat w = self.width / self.subviews.count;
    CGFloat h = self.height;
    for (int i = 0; i < self.subviews.count; i++) {
        LZBaseBtn *btn = self.subviews[i];
        btn.width = w;
        btn.height = h;
        btn.x = i * w;
        btn.y = 0;
    }
}

- (LZBaseBtn *)setupBtnWithTitle:(NSString *)title imageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected index:(LZShakeButtonType)index
{
    LZBaseBtn *btn = [[LZBaseBtn alloc] init];
    btn.tag = index;
    [btn setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitlePositionWithType:KButtonTitlePostionTypeBottom];
    [self addSubview:btn];
    return btn;
}

- (void)buttonClick:(LZBaseBtn *)btn
{
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}
@end
