//
//  LZMomentsViewModel.m
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsViewModel.h"

extern CGFloat maxContentLabelHeight;

@implementation LZMomentsViewModel
{
    CGFloat _lastContentWidth;
    CGFloat _y;
}

+ (instancetype)viewModelWithStatus:(LZMoments *)status {
    LZMomentsViewModel *obj = [[self alloc] init];
    
    obj.status = status;
    
    return obj;
}

- (NSString *)description {
    return self.status.description;
}

- (NSString *)name
{
    return self.status.name;
}

- (NSString *)iconName
{
    return self.status.iconName;
}

- (NSString *)time
{
    return self.status.time;
}

- (NSArray *)picNamesArray
{
    return self.status.picNamesArray;
}

- (NSString *)msgContent
{
    CGFloat margin = 10;
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    CGFloat iconViewWH = 45;
    CGFloat contentW = cellW - (margin + iconViewWH + margin) - margin;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGSize textSize = [self.status.msgContent sizeWithFont:[UIFont systemFontOfSize:15] maxW:contentW];
        if (textSize.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }

    return self.status.msgContent;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

/// 每列图片数量
#define kPicViewColCount 3
/// 图片间距
#define kPicViewItemMargin 5
/// 控件间距
#define kStatusCellMargin 10

- (CGFloat)cellHeight
{
    CGFloat margin = 10;
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellHeight;
    CGFloat contentW = cellW;
    
    CGFloat iconViewX = margin;
    CGFloat iconViewY = margin;
    CGFloat iconViewWH = 45;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    
    CGFloat nameLableX = CGRectGetMaxX(_iconViewF) + margin;
    CGFloat nameLableY = margin;
    _nameLableF = CGRectMake(nameLableX, nameLableY, cellW - nameLableX - margin, 20);
    
    
    if (self.msgContent.length) {  // 有文字
        CGFloat contentLabelX = nameLableX;
        CGFloat contentLabelY = CGRectGetMaxY(_nameLableF) + margin * 0.5;
        CGSize msgContentSize = [self.msgContent sizeWithFont:[UIFont systemFontOfSize:15] maxW:cellW - nameLableX - margin];
        if (self.shouldShowMoreButton) { // 如果文字高度超过60

            if (self.isOpening) { // 如果需要展开
                _contentLabelF = CGRectMake(contentLabelX, contentLabelY, msgContentSize.width, 60);
            } else {
                _contentLabelF = CGRectMake(contentLabelX, contentLabelY, msgContentSize.width, msgContentSize.height);
            }
            _moreButtonF = CGRectMake(nameLableX, CGRectGetMaxY(_contentLabelF) + margin * 0.2, 30, 15);
            
            cellHeight = CGRectGetMaxY(_moreButtonF) + margin * 0.5;
            
//            [_photoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                _topConstraint = make.top.equalTo(_moreButton.mas_bottom).offset(margin);
//            }];
        }else {  // 没有超过60
            _contentLabelF = CGRectMake(contentLabelX, contentLabelY, msgContentSize.width, msgContentSize.height);
            
            cellHeight = CGRectGetMaxY(_contentLabelF) + margin * 0.5;
            
//            [_photoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                _topConstraint = make.top.equalTo(_contentLabel.mas_bottom).offset(margin);
//            }];
        }
    }else {
        cellHeight = CGRectGetMaxY(_nameLableF) + margin * 0.5;
    }
    
    // 有图
    NSInteger count = self.picNamesArray.count;
    if (count) {
        CGFloat itemWH = (([UIScreen mainScreen].bounds.size.width - 70) - (kPicViewColCount - 1) * (kPicViewItemMargin + kStatusCellMargin)) / kPicViewColCount;

        NSInteger col = count == 4 ? 2 : (count >= kPicViewColCount ? kPicViewColCount : count);
        NSInteger row = (count - 1) / kPicViewColCount + 1;
        CGFloat width = ceil(col * itemWH + (col - 1) * kPicViewItemMargin);
        CGFloat height = ceil(row * itemWH + (row - 1) * kPicViewItemMargin);
        
        _photoContainerViewF = CGRectMake(nameLableX, cellHeight, width, height);
        cellHeight = CGRectGetMaxY(_photoContainerViewF) + margin * 0.5;
    }
    
    _originalViewF = CGRectMake(0, 0, contentW, cellHeight);
    
//    //    _answerViewF = CGRectMake(margin, cellHeight, cellW - 2 * margin, 30);
//    
//    
//    if (self.replies.count) {
//        CGFloat commentBgViewX = margin;
//        CGFloat commentBgViewY = cellHeight;
//        CGFloat commentBgViewW = cellW - 2 * margin;
//        CGFloat commentBgViewH = [self getCommentViewHeight];
//        _commentBgViewF = CGRectMake(commentBgViewX, commentBgViewY, commentBgViewW, commentBgViewH);
//        cellHeight = CGRectGetMaxY(_commentBgViewF) + 0.5 * margin;
//    }
//    
//    NSString *comment = NSLocalizedString(@"home.Comment", @"评论");
//    CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:11]];
//    _answerViewF = CGRectMake(cellW - 2 * margin - size.width, cellHeight, size.width, 30);
//    
//    _bgViewF = CGRectMake(0, 15, cellW , CGRectGetMaxY(_answerViewF));
//    
//    cellHeight = CGRectGetMaxY(_bgViewF) + margin;
    
    cellHeight = CGRectGetMaxY(_originalViewF) + margin;
    
    return cellHeight;
    
}
@end
