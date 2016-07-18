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

/// 可重用标识符
NSString *const kStatusPictureCellId = @"StatusPictureCellId";

#import "LZPhotoContainerView.h"
#import "LZMomentsPictureCell.h"

@interface LZPhotoContainerView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>

@end

@implementation LZPhotoContainerView

- (void)setUrls:(NSArray *)urls
{
    _urls = urls;
    
    // 更新尺寸约束
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self calcViewSize]);
    }];
    
    // 刷新数据
    [self reloadData];
}

/// 计算视图大小
///
/// @return 配图视图的大小
- (CGSize)calcViewSize {
    
    // 1. 配图数量
    NSInteger count = _urls.count;
    
    // 如果没有图片，直接返回
    if (count == 0) {
        return CGSizeZero;
    }
    
    
    
//    CGFloat itemW = [self itemWidthForPicPathArray:_urls];
//    CGFloat itemH = 0;
//    if (_urls.count == 1) {
//        UIImage *image = [UIImage imageNamed:_urls.firstObject];
//        if (image.size.width) {
//            itemH = image.size.height / image.size.width * itemW;
//        }
//    } else {
//        itemH = itemW;
//    }
//    long perRowItemCount = [self perRowItemCountForPicPathArray:_urls];
//    CGFloat margin = 5;
    
//    [_urls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        long columnIndex = idx % perRowItemCount;
//        long rowIndex = idx / perRowItemCount;
//        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
//        imageView.hidden = NO;
//        imageView.image = [UIImage imageNamed:obj];
//        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
//    }];
    
    
//    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
//    int columnCount = ceilf(_urls.count * 1.0 / perRowItemCount);
//    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
//    return CGSizeMake(w, h);
    
    
    
    
    // 2. 基本数据计算
    // 单个 cell 的宽高
    CGFloat itemWH = (([UIScreen mainScreen].bounds.size.width - 70) - (kPicViewColCount - 1) * (kPicViewItemMargin + kStatusCellMargin)) / kPicViewColCount;
    
    // 设置布局 item 大小
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    // 列数
    NSInteger col = count == 4 ? 2 : (count >= kPicViewColCount ? kPicViewColCount : count);
    // 行数
    NSInteger row = (count - 1) / kPicViewColCount + 1;
    
    // 3. 计算宽高
    CGFloat width = ceil(col * itemWH + (col - 1) * kPicViewItemMargin);
    CGFloat height = ceil(row * itemWH + (row - 1) * kPicViewItemMargin);
    
    return CGSizeMake(width, height);
}

#pragma mark - 构造函数
- (instancetype)init {
    // 设置 layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:layout]) {
        // 设置 layout
        layout.minimumInteritemSpacing = kPicViewItemMargin;
        layout.minimumLineSpacing = kPicViewItemMargin;
        
        // 注册 Cell
        [self registerClass:[LZMomentsPictureCell class] forCellWithReuseIdentifier:kStatusPictureCellId];
        
        // 设置数据源
        self.dataSource = self;
        self.delegate = self;
        
        // *** 禁用滚动到顶部，在一个界面中，只允许最外侧的 scrollsToTop = YES
        // *** 如果内部的 scrollsToTop 如果也为 YES，用户点击状态栏，不会滚动到顶部
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
    cell.imageView.tag = indexPath.row + 100;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    KLog(@"item======%ld",indexPath.item);
//    KLog(@"row=======%ld",indexPath.row);
    
//    NSMutableArray *browseItemArray = [[NSMutableArray alloc] init];
//    for(int i = 0; i < self.urls.count; i++){
//        UIImageView *imageView = [self viewWithTag:i + 100];
//        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
//        browseItem.bigImageUrl = self.urls[i];// 大图url地址
//        browseItem.smallImageView = imageView;// 小图
//        [browseItemArray addObject:browseItem];
//    }
//    LZMomentsPictureCell *cell = (LZMomentsPictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    MSSBrowseViewController *bvc = [[MSSBrowseViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.imageView.tag - 100];
////    MSSBrowseViewController *bvc = [[MSSBrowseViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.item];
//    [bvc showBrowseViewController];
}
@end
