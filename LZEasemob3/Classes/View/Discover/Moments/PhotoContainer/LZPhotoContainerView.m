//
//  LZPhotoContainerView.m
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#pragma mark - 常量定义
/// 每列图片数量
#define kPicViewColCount 3
/// 图片间距
#define kPicViewItemMargin 5
/// 控件间距
#define kStatusCellMargin 10

NSString *const kStatusPictureCellId = @"StatusPictureCellId";

#import "LZPhotoContainerView.h"
#import "LZMomentsPictureCell.h"
#import "SDPhotoBrowser.h"

@interface LZPhotoContainerView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate,SDPhotoBrowserDelegate>

@end

@implementation LZPhotoContainerView

- (void)setUrls:(NSArray *)urls
{
    _urls = urls;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self calcViewSize]);
    }];
    [self reloadData];
}

/// 计算视图大小
- (CGSize)calcViewSize {
    
    NSInteger count = _urls.count;
    if (count == 0) {
        return CGSizeZero;
    }
    CGFloat itemWH = (([UIScreen mainScreen].bounds.size.width - 70) - (kPicViewColCount - 1) * (kPicViewItemMargin + kStatusCellMargin)) / kPicViewColCount;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    NSInteger col = count == 4 ? 2 : (count >= kPicViewColCount ? kPicViewColCount : count);
    NSInteger row = (count - 1) / kPicViewColCount + 1;
    CGFloat width = ceil(col * itemWH + (col - 1) * kPicViewItemMargin);
    CGFloat height = ceil(row * itemWH + (row - 1) * kPicViewItemMargin);
    return CGSizeMake(width, height);
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:layout]) {
        layout.minimumInteritemSpacing = kPicViewItemMargin;
        layout.minimumLineSpacing = kPicViewItemMargin;
        [self registerClass:[LZMomentsPictureCell class] forCellWithReuseIdentifier:kStatusPictureCellId];
        self.dataSource = self;
        self.delegate = self;
        self.scrollsToTop = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LZMomentsPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStatusPictureCellId forIndexPath:indexPath];
    cell.imageURL = self.urls[indexPath.item];
    cell.imageView.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZMomentsPictureCell * cell = (LZMomentsPictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIView *imageView = cell.imageView;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.urls.count;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.urls[index];
//    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    NSURL *url = [NSURL URLWithString:imageName];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

@end
