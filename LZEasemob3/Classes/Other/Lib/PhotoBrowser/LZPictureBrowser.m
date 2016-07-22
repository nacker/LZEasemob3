//
//  LZPictureBrowser.m
//  teacher
/**
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */
//  Created by nacker on 15/8/6.
//  Copyright (c) 2015年 Shanghai Minlan Information & Technology Co ., Ltd. All rights reserved.
//

#import "LZPictureBrowser.h"
#import "LZPictureBrowserCell.h"
#import "LZBroadcastView.h"
#import "LZPicture.h"
#import "UIImage+Tint.h"

#define kPadding 10.0f
#define kIsShowStatusBar NO
#define kShowAndDisappearAnimationDuration .35f

#define kDefaultCurrentIndexLabelTag 111
#define kDefaultDownloadTag 112

@interface LZPictureBrowser ()<UIScrollViewDelegate,LZBroadcastViewDataSource,LZBroadcastViewDelegate,LZPictureBrowserCellDelegate>

@property(nonatomic,strong) LZBroadcastView *mainView;
@property(nonatomic,strong) UIView *overlayView;

@property(nonatomic,strong) UIWindow *actionWindow;

@end

@implementation LZPictureBrowser

- (UIWindow *)actionWindow {
    if (_actionWindow == nil) {
        _actionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionWindow.opaque = YES;
        UIWindowLevel level = UIWindowLevelStatusBar+10.0f;
        if (kIsShowStatusBar) {
            level = UIWindowLevelNormal+10.0f;
        }
        _actionWindow.windowLevel = level;
        _actionWindow.rootViewController = self;
        _actionWindow.backgroundColor = [UIColor blackColor];
        [_actionWindow makeKeyAndVisible];
        _actionWindow.hidden = NO;

    }
    return _actionWindow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.overlayView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self onDeviceOrientationChange];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    NSLog(@"---销毁了");
}

-(void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
#define kAnimationDuration 0.35f
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.view.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            self.view.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:nil];
    }else if (orientation==UIDeviceOrientationPortrait){
        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.view.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            self.view.bounds = screenBounds;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

#pragma mark - seLZer and geLZer
- (LZBroadcastView*)mainView
{
    if (!_mainView) {
        _mainView = [[LZBroadcastView alloc]init];
        _mainView.backgroundColor = [UIColor blackColor];
        _mainView.userInteractionEnabled = YES;
        _mainView.delegate = self;
        _mainView.dataSource = self;
        _mainView.padding = kPadding;
        _mainView.frame = self.view.bounds;
    }
    return _mainView;
}

- (UIView*)overlayView
{
    if (!_overlayView) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {
            _overlayView = [self.delegate customOverlayViewOfMLPictureBrowser:self];
        }
        if (!_overlayView) {
            _overlayView = [[UIView alloc]init];
            _overlayView.userInteractionEnabled = YES;
            _overlayView.backgroundColor = [UIColor clearColor];
            UILabel *currentIndexLabel = [[UILabel alloc]init];
            currentIndexLabel.userInteractionEnabled = NO;
            currentIndexLabel.textColor = [UIColor whiteColor];
            currentIndexLabel.textAlignment = NSTextAlignmentCenter;
            currentIndexLabel.font = [UIFont systemFontOfSize:14.0f];
            currentIndexLabel.tag = kDefaultCurrentIndexLabelTag;
            currentIndexLabel.backgroundColor = [UIColor clearColor];
            currentIndexLabel.contentMode = UIViewContentModeCenter;
            [_overlayView addSubview:currentIndexLabel];
            
            UIButton *downloadBuLZon = [[UIButton alloc] init];
            [downloadBuLZon setImage:[UIImage imageNamed:@"picture_download_icon"] forState:UIControlStateNormal];
            [downloadBuLZon setImage:[[UIImage imageNamed:@"picture_download_icon"]imageWithTintColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
            [downloadBuLZon setImage:[[UIImage imageNamed:@"picture_download_icon"]imageWithTintColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
            downloadBuLZon.exclusiveTouch = YES;
            [downloadBuLZon addTarget:self action:@selector(downloadImageToSystemBrowser:) forControlEvents:UIControlEventTouchUpInside];
            downloadBuLZon.tag = kDefaultDownloadTag;
            
            [_overlayView addSubview:downloadBuLZon];
        }
    }
    return _overlayView;
}

- (void)setPictures:(NSArray *)pictures
{
    if ([_pictures isEqual:pictures]) {
        return;
    }
    _pictures = pictures;
    for (int i = 0; i<pictures.count; i++) {
        LZPicture *picture = pictures[i];
        picture.index = i;
    }
}

#pragma mark - download to system browser
- (void)downloadImageToSystemBrowser:(UIButton *)sender
{
    LZPicture *picture = (LZPicture*)self.pictures[self.currentIndex];
    if (!picture.isLoaded) {
        return;
    }
    sender.enabled = NO;
    
    UIImageView *tempImageView = [[UIImageView alloc]init];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:picture.url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	// TODO: Leizhen different with original teacher
    //[tempImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"pic_loading_120x120"] success:^(NSURLRequest *request, NSHLZPURLResponse *response, UIImage *image) {
    
    [tempImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge_retained void *)(sender));
    } failure:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIButton *button = (__bridge_transfer UIButton *)contextInfo;
    button.enabled = YES;
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"已保存至相册" ;
    }
    [[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
}


#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mainView.frame = self.view.bounds;
    
    CGRect overlayViewFrame = CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44);
    BOOL isCustomOverlay = NO;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {
        overlayViewFrame = [self.delegate customOverlayViewFrameOfMLPictureBrowser:self];
        isCustomOverlay = YES;
    }
    self.overlayView.frame = overlayViewFrame;
    if (!isCustomOverlay) {
        UILabel *currentIndexLabel = (UILabel *)[self.overlayView viewWithTag:kDefaultCurrentIndexLabelTag];
        currentIndexLabel.frame = self.overlayView.bounds;
        
        UIButton *downloadBuLZon = (UIButton*)[self.overlayView viewWithTag:kDefaultDownloadTag];
        downloadBuLZon.frame = CGRectMake(self.overlayView.bounds.size.width-50.0f, 0, 40.0f, 40.0f);
    }
}

#pragma mark - show and destory
- (void)showWithPictureURLs:(NSArray *)pictureURLs atIndex:(NSUInteger)index
{
    NSMutableArray *pictures = [NSMutableArray arrayWithCapacity:pictureURLs.count];
    for (int i = 0; i<pictureURLs.count; i++) {
        LZPicture *picture = [[LZPicture alloc] init];
        if ([pictureURLs[i] isKindOfClass:[NSString class]]) {
            picture.url = [NSURL URLWithString:pictureURLs[i]];
        }else if ([pictureURLs[i] isKindOfClass:[NSURL class]]) {
            picture.url = pictureURLs[i];
        }else{
//            NSAssert(NO, @"图片的URL类型异常");
//            return;
            picture.image = pictureURLs[i];
        }
        [pictures addObject:picture];
    }
    self.pictures = pictures;
    
    [self.mainView reloadData];
    
    [self.mainView scrollToPageIndex:index animated:NO];
    
    [self showWithAnimated:YES];
}

- (void)showWithPictureWithImage:(UIImage*)image
{
    
}

- (void)showWithAnimated:(BOOL)animated
{
    if (!self.pictures||self.pictures.count<=0) {
        return;
    }
    for (NSUInteger i=0; i<self.pictures.count; i++) {
        if (![self.pictures[i] isKindOfClass:[LZPicture class]]) {
            NSAssert(NO, @"传递的图片类型非LZPicture");
            return;
        }
    }
    
    if (animated) {
        self.actionWindow.layer.opacity = .01f;
        [UIView animateWithDuration:kShowAndDisappearAnimationDuration animations:^{
            self.actionWindow.layer.opacity = 1.0f;
        }];
    }
}

- (void)disappear
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [UIView animateWithDuration:kShowAndDisappearAnimationDuration animations:^{
        self.actionWindow.layer.opacity = .01f;
    } completion:^(BOOL finished) {
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didDisappearOfMLPictureBrowser:)]) {
            [self.delegate didDisappearOfMLPictureBrowser:self];
        }
        
        [_actionWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _actionWindow.rootViewController = nil;
        _actionWindow.hidden = YES;
        [_actionWindow resignKeyWindow];
        [_actionWindow removeFromSuperview];
        
        [[[UIApplication sharedApplication].delegate window] resignKeyWindow];
    }];
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
    [self.mainView scrollToPageIndex:index animated:animated];
}

#pragma mark - broadcast datasource
- (NSUInteger)cellCountOfBroadcastView:(LZBroadcastView *)broadcastView
{
    return self.pictures.count;
}

- (LZBroadcastViewCell *)broadcastView:(LZBroadcastView *)broadcastView cellAtPageIndex:(NSUInteger)pageIndex
{
    static NSString *CellIdentifier = @"BroadcastCell";
    LZPictureBrowserCell *cell = [broadcastView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[LZPictureBrowserCell alloc]initWithReuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    cell.picture = self.pictures[pageIndex];
    
    return cell;
}

#pragma mark - broadcast delegate
- (void)didScrollToPageIndex:(NSUInteger)pageIndex ofBroadcastView:(LZBroadcastView *)broadcastView
{
    _currentIndex = pageIndex;
    
    if (!self.delegate||![self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureBrowser:)]||![self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureBrowser:)]) {
        UILabel *currentIndexLabel = (UILabel *)[self.overlayView viewWithTag:kDefaultCurrentIndexLabelTag];
        if (self.pictures.count>1) {
            currentIndexLabel.text = [NSString stringWithFormat:@"%lu/%lu",pageIndex+1,self.pictures.count];
        }else{
            currentIndexLabel.text = @"";
        }
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didScrollToIndex:ofMLPictureBrowser:)]) {
        [self.delegate didScrollToIndex:pageIndex ofMLPictureBrowser:self];
    }
}

- (void)preOperateInBackgroundAtPageIndex:(NSUInteger)pageIndex ofBroadcastView:(LZBroadcastView *)broadcastView
{
    LZPicture *picture = (LZPicture*)self.pictures[pageIndex];
    if (picture.isLoaded) {
        return;
    }
    UIImageView *tempImageView = [[UIImageView alloc]init];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:picture.url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
	// TODO: Leizhen different with original tearcher
    // [tempImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"pic_loading_120x120"] success:^(NSURLRequest *request, NSHLZPURLResponse *response, UIImage *image) {
    [tempImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        picture.isLoaded = YES;
    } failure:nil];
}

#pragma mark - cell delegate
- (void)didTapForMLPictureCell:(LZPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index
{
    [self disappear];
}

- (UIView*)customOverlayViewOfMLPictureCell:(LZPictureBrowserCell *)pictureCell ofIndex:(NSUInteger)index
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureCell:ofIndex:)]) {
        return [self.delegate customOverlayViewOfMLPictureCell:pictureCell ofIndex:index];
    }
    return nil;
}

- (CGRect)customOverlayViewFrameOfMLPictureCell:(LZPictureBrowserCell*)pictureCell ofIndex:(NSUInteger)index
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureCell:ofIndex:)]) {
        return [self.delegate customOverlayViewFrameOfMLPictureCell:pictureCell ofIndex:index];
    }
    return CGRectZero;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - status bar
#if kIsShowStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
#endif

@end
