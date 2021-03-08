//
//  LZShakeViewController.m
//  Easemob
//
//  Created by nacker on 15/12/24.
//  Copyright © 2015年 帶頭二哥. All rights reserved.
//

#import "LZShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LZShakeBottomView.h"
#import "LZFoundationMacro.h"

#define kXHSelectedButtonSpacing (kIsiPad ? 80 : 40)

@interface LZShakeViewController ()
{
    SystemSoundID shakingSoundID;
}

@property (nonatomic, strong) UIImageView *shakeUpImageView;
@property (nonatomic, strong) UIImageView *shakeDownImageView;

@property (nonatomic, strong) UIImageView *shakeUpLineImageView;
@property (nonatomic, strong) UIImageView *shakeDownLineImageView;

@property (nonatomic, strong) UIImageView *shakeBackgroundImageView;

@property (nonatomic, assign) CGFloat animationDistans;

@property (nonatomic, weak) LZShakeBottomView *shakeBottomView;

@end

@implementation LZShakeViewController

- (void)shaking {
    CABasicAnimation *shakeUpImageViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeUpImageViewAnimation.fromValue = 0;
    shakeUpImageViewAnimation.toValue = [NSNumber numberWithFloat:-self.animationDistans];
    shakeUpImageViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shakeUpImageViewAnimation.duration = 0.4;
    shakeUpImageViewAnimation.removedOnCompletion = NO;
    shakeUpImageViewAnimation.fillMode = kCAFillModeBoth;
    shakeUpImageViewAnimation.autoreverses = YES;
    
    CABasicAnimation *shakeDownImageViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeDownImageViewAnimation.delegate = self;
    shakeDownImageViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shakeDownImageViewAnimation.fromValue = 0;
    shakeDownImageViewAnimation.toValue = [NSNumber numberWithFloat:self.animationDistans];
    shakeDownImageViewAnimation.duration = 0.4;
    shakeDownImageViewAnimation.removedOnCompletion = NO;
    shakeDownImageViewAnimation.autoreverses = YES;
    shakeDownImageViewAnimation.fillMode = kCAFillModeBoth;
    
    [self.shakeUpImageView.layer addAnimation:shakeUpImageViewAnimation forKey:@"shakeUpImageViewAnimationKey"];
    [self.shakeDownImageView.layer addAnimation:shakeDownImageViewAnimation forKey:@"shakeDownImageViewAnimationKey"];
}

- (void)pullServerNearUsers {
    
}

#pragma mark - Propertys
- (UIImageView *)shakeUpImageView {
    if (!_shakeUpImageView) {
        _shakeUpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 1.0 / 3)];
        _shakeUpImageView.backgroundColor = self.view.backgroundColor;
        _shakeUpImageView.image = [UIImage imageNamed:@"Shake_Logo_Up"];
        _shakeUpImageView.contentMode = UIViewContentModeBottom;
        
        [_shakeUpImageView addSubview:self.shakeUpLineImageView];
    }
    return _shakeUpImageView;
}

- (UIImageView *)shakeDownImageView {
    if (!_shakeDownImageView) {
        _shakeDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shakeUpImageView.frame), CGRectGetWidth(self.shakeUpImageView.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.shakeUpImageView.bounds))];
        _shakeDownImageView.backgroundColor = self.view.backgroundColor;
        _shakeDownImageView.userInteractionEnabled = YES;
        _shakeDownImageView.image = [UIImage imageNamed:@"Shake_Logo_Down"];
        _shakeDownImageView.contentMode = UIViewContentModeTop;
        
        [_shakeDownImageView addSubview:self.shakeDownLineImageView];
    }
    return _shakeDownImageView;
}

- (UIImageView *)shakeUpLineImageView {
    if (!_shakeUpLineImageView) {
        _shakeUpLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_shakeUpImageView.frame) - 3, CGRectGetWidth(self.view.bounds), 10)];
        _shakeUpLineImageView.image = [UIImage imageNamed:@"Shake_Line_Up"];
        _shakeUpLineImageView.hidden = YES;
    }
    return _shakeUpLineImageView;
}

- (UIImageView *)shakeDownLineImageView {
    if (!_shakeDownLineImageView) {
        _shakeDownLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -7, CGRectGetWidth(self.view.bounds), 10)];
        _shakeDownLineImageView.image = [UIImage imageNamed:@"Shake_Line_Down"];
        _shakeDownLineImageView.hidden = YES;
    }
    return _shakeDownLineImageView;
}

- (UIImageView *)shakeBackgroundImageView {
    if (!_shakeBackgroundImageView) {
        _shakeBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.shakeUpImageView.frame) - self.animationDistans, CGRectGetWidth(self.view.bounds), self.animationDistans * 2)];
        _shakeBackgroundImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage.jpg"];
    }
    return _shakeBackgroundImageView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = NSLocalizedStringFromTable(@"Shake", @"MessageDisplayKitString", @"摇一摇");
    
    self.animationDistans = kIsiPad ? 230 : 100;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.102 green:0.102 blue:0.114 alpha:1.000];
    
    [self.view addSubview:self.shakeUpImageView];
    [self.view addSubview:self.shakeDownImageView];
    
    [self.view addSubview:self.shakeBackgroundImageView];
    [self.view sendSubviewToBack:self.shakeBackgroundImageView];
    
    
    LZShakeBottomView *shakeBottomView = [[LZShakeBottomView alloc] init];
    [self.view addSubview:shakeBottomView];
    self.shakeBottomView = shakeBottomView;
    [shakeBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.height.equalTo(@70);
        make.width.equalTo(@(self.view.width - 80));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    //想摇你的手机嘛？就写在这，然后，然后，没有然后了
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shake_sound_male.wav" ofType:@""]]), &shakingSoundID);
}

#pragma mark - Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
    self.shakeUpLineImageView.hidden = NO;
    self.shakeDownLineImageView.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.shakeUpLineImageView.hidden = flag;
    self.shakeDownLineImageView.hidden = flag;
    if (flag) {
        [self pullServerNearUsers];
    }
}

#pragma mark - Event Delegate

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(motion == UIEventSubtypeMotionShake) {
        // 播放声音
        AudioServicesPlaySystemSound(shakingSoundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // 真实一点的摇动动画
        [self shaking];
    }
}
@end
