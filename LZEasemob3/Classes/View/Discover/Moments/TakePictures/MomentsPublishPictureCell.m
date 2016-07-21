//
//  MomentsPublishPictureCell.m
//  Moments
//
//  Created by Thomson on 16/2/18.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import "MomentsPublishPictureCell.h"
#import "LZMomentsSendViewModel.h"

//#import "PhotoAssets.h"

@interface MomentsPublishPictureCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation MomentsPublishPictureCell
{
    UICollectionView *_collectionView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = nil;
    if (ID == nil) {
        ID = [NSString stringWithFormat:@"%@ID", NSStringFromClass(self)];
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        _collectionView = [[UICollectionView alloc] init];
//        [self.contentView addSubview:_collectionView];
        
        
        @weakify(self);
        [[RACObserve(self, viewModel.assets)
          filter:^BOOL(id value) {
              
              return value != nil;
          }]
         subscribeNext:^(id x) {
             
             @strongify(self);
             [_collectionView reloadData];
         }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel.assets count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"pictureCell";

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];

    if (indexPath.item == self.viewModel.assets.count)
    {
        imageView.image = [UIImage imageNamed:@"momemts_publish_add"];
    }
    else
    {
//        PhotoAssets *assets = self.viewModel.assets[indexPath.item];
//        imageView.image = assets.originImage;
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.viewModel.assets.count)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAddItem)])
        {
            [self.delegate didSelectAddItem];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = (KScreenW - 75.0) / 4;

    return CGSizeMake(size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0;
}

+ (CGFloat)estimatedHeightWithViewModel:(LZMomentsSendViewModel *)viewModel
{
    NSInteger count = [viewModel.assets count] + 1;
    NSInteger line = (count + 4 - 1) / 4;

    CGFloat size = (KScreenW - 75.0) / 4;
    CGFloat height = line * size + (line + 1) * 15.0;

    return height;
}

@end
