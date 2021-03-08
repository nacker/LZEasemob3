//
//  LZPictureBrowserCell.m
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

#import "LZPictureBrowserCell.h"
#import "LZPicture.h"


#define kMinZoomScale 1.0f
#define kMaxZoomScale 2.5f

#define kIsFullWidthForLandScape NO
@interface LZPictureBrowserCell()<UIScrollViewDelegate>

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *tipsLabel;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *overlayView;

@end

@implementation LZPictureBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.clipsToBounds = YES;
    
    [self resetZoomScale];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];
    
    //其他View
    UILabel *tipsLabel = [[UILabel alloc]init];
    tipsLabel.layer.cornerRadius = 3.0f;
    tipsLabel.font = [UIFont systemFontOfSize:13.0f];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.backgroundColor = [UIColor darkGrayColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.layer.opacity = .0f;
    [self addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:indicator];
    self.indicator = indicator;
    
}


- (UIView*)overlayView
{
    if (!_overlayView) {
        if (self.picture&&self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureCell:ofIndex:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureCell:ofIndex:)]) {
            _overlayView = [self.delegate customOverlayViewOfMLPictureCell:self ofIndex:self.picture.index];
            [self addSubview:_overlayView];
        }
    }
    return _overlayView;
}

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.clipsToBounds = YES;
        _scrollView.delegate = self;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.decelerationRate /= 2;
        _scrollView.bouncesZoom = YES;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView*)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

- (void)setPicture:(LZPicture *)picture
{
    if ([picture isEqual:_picture]) {
        return;
    }
    _picture = picture;
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    
    [self reloadImage];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.scrollView.frame = self.bounds;
    [self resetZoomScale];
    [self adjustFrame];
    
    self.tipsLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.indicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self bringSubviewToFront:self.tipsLabel];
    [self bringSubviewToFront:self.indicator];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)adjustFrame
{
    CGRect frame = self.scrollView.frame;
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        }else{
            if (frame.size.width<=frame.size.height) {
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageView.frame = imageFrame;
        self.scrollView.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollView:self.scrollView];
        
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        
        self.scrollView.minimumZoomScale = kMinZoomScale;
        self.scrollView.maximumZoomScale = maxScale;
        self.scrollView.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        self.scrollView.contentSize = self.imageView.frame.size;
        
        [self resetZoomScale];
    }
    self.scrollView.contentOffset = CGPointZero;
    
    if (self.picture&&self.delegate&&[self.delegate respondsToSelector:@selector(customOverlayViewOfMLPictureCell:ofIndex:)]&&[self.delegate respondsToSelector:@selector(customOverlayViewFrameOfMLPictureCell:ofIndex:)]) {
        self.overlayView.frame = [self.delegate customOverlayViewFrameOfMLPictureCell:self ofIndex:self.picture.index];
        [self bringSubviewToFront:self.overlayView];
    }
}

- (void)resetZoomScale
{
    self.scrollView.minimumZoomScale = 1.0f;;
    self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self resetZoomScale];
}

- (void)reloadImage
{
    [self resetZoomScale];
    self.imageView.image = nil;
    
//    [self.imageView cancelImageRequestOperation];
    
    self.tipsLabel.text = @"加载网络图片失败";
    self.tipsLabel.layer.opacity = .0f;
    self.tipsLabel.frame = CGRectMake((self.bounds.size.width-120)/2, (self.bounds.size.height-30)/2, 120, 30);
    self.indicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self.indicator startAnimating];

    //加载图像
    if (self.picture.url) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.picture.url];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        __weak __typeof(self)weakSelf = self;
        NSURL *recordImageURL =self.picture.url;
        [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (![recordImageURL isEqual:weakSelf.picture.url]) {
                return;
            }
            weakSelf.picture.isLoaded = YES;
            
            [weakSelf.indicator stopAnimating];
            weakSelf.imageView.image = image;
            [weakSelf adjustFrame];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            if (![recordImageURL isEqual:weakSelf.picture.url]) {
                return;
            }
            [weakSelf.indicator stopAnimating];
            
            weakSelf.tipsLabel.layer.opacity = .8f;
        }];
    }else {
        self.imageView.image = self.picture.image;
        self.tipsLabel.layer.opacity = .0f;
        [self.indicator stopAnimating];
    }
    
    [self adjustFrame];
}

- (CGPoint)centerOfScrollView:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    return CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                       scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - tap
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self];
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    if (self.picture&&self.delegate&&[self.delegate respondsToSelector:@selector(didTapForMLPictureCell:ofIndex:)]) {
        [self.delegate didTapForMLPictureCell:self ofIndex:self.picture.index];
    }
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageView.center = [self centerOfScrollView:scrollView];
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [UIView animateWithDuration:0.25f animations:^{
        view.center = [self centerOfScrollView:scrollView];
    }];
}

@end
