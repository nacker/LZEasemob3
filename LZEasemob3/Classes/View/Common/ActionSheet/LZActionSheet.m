//
//  LZActionSheet.m
//  HXClient
//
//  Created by nacker on 16/2/29.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZActionSheet.h"

#define BUTTON_H 49.0f
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define LZ_ACTION_SHEET_TITLE_FONT  [UIFont systemFontOfSize:18.0f]
#define LZ_DEFAULT_ANIMATION_DURATION 0.3f
#define LZ_DEFAULT_BACKGROUND_OPACITY 0.3f

@interface LZActionSheet ()
@property (nonatomic, strong) NSMutableArray *buttonTitles;

@property (nonatomic, strong) UIView *darkView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIWindow *backWindow;

@end

@implementation LZActionSheet

#pragma mark - getter

- (NSString *)cancelText
{
    if (!_cancelText) {
        _cancelText = @"取消";
    }
    
    return _cancelText;
}

- (UIFont *)textFont
{
    if (!_textFont) {
        _textFont = LZ_ACTION_SHEET_TITLE_FONT;
    }
    
    return _textFont;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor stringTOColor:@"#333333"];
    }
    
    return _textColor;
}

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        _animationDuration = LZ_DEFAULT_ANIMATION_DURATION;
    }
    
    return _animationDuration;
}

- (CGFloat)backgroundOpacity {
    if (!_backgroundOpacity) {
        _backgroundOpacity = LZ_DEFAULT_BACKGROUND_OPACITY;
    }
    
    return _backgroundOpacity;
}

#pragma mark - methods
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                     delegate:(id<LZActionSheetDelegate>)delegate {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = redButtonIndex;
        self.delegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                      clicked:(LZActionSheetBlock)clicked {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = redButtonIndex;
        self.clickedBlock = clicked;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
               cancelTextColor:(UIColor*)cancelTextColor
                      clicked:(LZActionSheetBlock)clicked {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = redButtonIndex;
        self.clickedBlock = clicked;
        self.cancelTextColor = cancelTextColor;
    }
    
    return self;
}

- (void)setupMainView {
    
    // 暗黑色的view
    UIView *darkView = [[UIView alloc] init];
    [darkView setAlpha:0];
    [darkView setUserInteractionEnabled:NO];
    [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
    [darkView setBackgroundColor:KColor(46, 49, 50)];
    [self addSubview:darkView];
    _darkView = darkView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [darkView addGestureRecognizer:tap];
    
    // 所有按钮的底部view
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:[UIColor stringTOColor:@"#f4f4ea"]];
    _bottomView = bottomView;
    
    if (self.title) {
        
        CGFloat vSpace = 0;
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]}];
        if (titleSize.width > SCREEN_SIZE.width - 30.0f) {
            vSpace = 15.0f;
        }
        
        UIView *titleBgView = [[UIView alloc] init];
        titleBgView.backgroundColor = [UIColor whiteColor];
        titleBgView.frame = CGRectMake(0, -vSpace, SCREEN_SIZE.width, BUTTON_H + vSpace);
        [bottomView addSubview:titleBgView];
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        [label setText:self.title];
        [label setNumberOfLines:2.0f];
        [label setTextColor:KColor(111, 111, 111)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setFrame:CGRectMake(15.0f, 0, SCREEN_SIZE.width - 30.0f, titleBgView.frame.size.height)];
        [titleBgView addSubview:label];
    }
    if (self.buttonTitles.count) {
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            
            // 所有按钮
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:i];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
            [[btn titleLabel] setFont:self.textFont];
            UIColor *titleColor = nil;
            if (i == self.redButtonIndex) {
                
                titleColor = KColor(255, 10, 10);
                
            } else {
                
                titleColor = self.textColor ?  self.textColor : [UIColor blackColor];
            }
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            UIImage *bgImage = [UIImage imageNamed:@"bgImage_HL"];
            [btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat btnY = BUTTON_H * (i + (self.title ? 1 : 0));
            [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
            [bottomView addSubview:btn];
        }
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            UIImage *lineImage = [UIImage imageNamed:@"cellLine"];
            // 所有线条
            UIImageView *line = [[UIImageView alloc] init];
            [line setImage:lineImage];
            [line setContentMode:UIViewContentModeTop];
            CGFloat lineY = (i + (self.title ? 1 : 0)) * BUTTON_H;
            [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 1.0f)];
            [bottomView addSubview:line];
        }
    }
    
    UIImage *bgImage = [UIImage imageNamed:@"bgImage_HL"];
    
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTag:self.buttonTitles.count];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:self.cancelText forState:UIControlStateNormal];
    [[cancelBtn titleLabel] setFont:self.textFont];
    [cancelBtn setTitleColor:self.cancelTextColor ? self.cancelTextColor : self.textColor forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnY = BUTTON_H * (self.buttonTitles.count + (self.title ? 1 : 0)) + 5.0f;
    [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
    [bottomView addSubview:cancelBtn];
    
    CGFloat bottomH = (self.title ? BUTTON_H : 0) + BUTTON_H * self.buttonTitles.count + BUTTON_H + 5.0f;
    [bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH)];
    
    [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
}

- (UIWindow *)backWindow {
    if (_backWindow == nil) {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    return _backWindow;
}


- (void)didClickBtn:(UIButton *)btn {
    
    [self dismiss:nil];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        
        [_delegate actionSheet:self didClickedButtonAtIndex:btn.tag];
    }
    
    if (self.clickedBlock) {
        
        self.clickedBlock(btn.tag);
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:0];
        [_darkView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:0];
        [_darkView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
            [_delegate actionSheet:self didClickedButtonAtIndex:self.buttonTitles.count];
        }
        if (self.clickedBlock) {
            __weak typeof(self) weakSelf = self;
            self.clickedBlock(weakSelf.buttonTitles.count);
        }
        [self removeFromSuperview];
        self.backWindow.hidden = YES;
    }];
}

- (void)show {
    [self setupMainView];
    self.backWindow.hidden = NO;
    
    [self addSubview:self.bottomView];
    [self.backWindow addSubview:self];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:self.backgroundOpacity];
        [_darkView setUserInteractionEnabled:YES];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y -= frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:nil];
}

- (void)addButtonTitle:(NSString *)button
{
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    
    [_buttonTitles addObject:button];
}
@end
