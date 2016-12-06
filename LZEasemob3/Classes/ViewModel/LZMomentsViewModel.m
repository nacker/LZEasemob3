//
//  LZMomentsViewModel.m
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsViewModel.h"
#import "MLLinkLabel.h"

extern CGFloat maxContentLabelHeight;

@implementation LZMomentsViewModel
{
    CGFloat _lastContentWidth;
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
    CGFloat commentViewWidth = cellW - 70;
    
    CGFloat iconViewX = margin;
    CGFloat iconViewY = margin;
    CGFloat iconViewWH = 45;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    
    CGFloat nameLableX = CGRectGetMaxX(_iconViewF) + margin;
    CGFloat nameLableY = margin;
    
    
    _nameLableF = CGRectMake(nameLableX, nameLableY, commentViewWidth, 20);
    
    if (self.msgContent.length) {  // 有文字
        CGFloat contentLabelX = nameLableX;
        CGFloat contentLabelY = CGRectGetMaxY(_nameLableF) + margin * 0.5;
        CGSize msgContentSize = [self.msgContent sizeWithFont:[UIFont systemFontOfSize:15] maxW:commentViewWidth];
        if (self.shouldShowMoreButton) { // 如果文字高度超过60

            if (self.isOpening) { // 如果需要展开
                _contentLabelF = CGRectMake(contentLabelX, contentLabelY, msgContentSize.width, 60);
            } else {
                _contentLabelF = CGRectMake(contentLabelX, contentLabelY, msgContentSize.width, msgContentSize.height);
            }
            _moreButtonF = CGRectMake(nameLableX, CGRectGetMaxY(_contentLabelF) + margin * 0.2, 30, 15);
            
            cellHeight = CGRectGetMaxY(_moreButtonF) + margin * 0.5;
        }else {  // 没有超过60
            _contentLabelF = CGRectMake(contentLabelX, contentLabelY, msgContentSize.width, msgContentSize.height);
            cellHeight = CGRectGetMaxY(_contentLabelF) + margin * 0.5;
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
    
    _originalViewF = CGRectMake(0, 0, cellW, cellHeight);
    
    CGSize timeLabelSize = [self.time sizeWithFont:[UIFont systemFontOfSize:13] maxW:cellW - nameLableX - margin];
    CGFloat timeLabelY = CGRectGetMaxY(_originalViewF) + margin * 0.5;
    _timeLabelF = CGRectMake(nameLableX, timeLabelY, timeLabelSize.width, timeLabelSize.height);
    
    
    CGFloat operationButtonWH = 25;
    CGFloat operationButtonX = cellW - operationButtonWH - margin;
    CGFloat operationButtonY = timeLabelY - margin * 0.5;
    _operationButtonF = CGRectMake(operationButtonX, operationButtonY, operationButtonWH, operationButtonWH);
    

    if (!self.status.commentItemsArray.count && !self.status.likeItemsArray.count) {
        cellHeight = CGRectGetMaxY(_timeLabelF) + margin * 0.5;
    }else {
        CGSize commentViewSize = [self getCommentViewSize];
        _commentBgViewF = CGRectMake(nameLableX, cellHeight, commentViewSize.width, commentViewSize.height);
        cellHeight = CGRectGetMaxY(_commentBgViewF) + margin * 0.5;
    }
    _dividerF = CGRectMake(0, cellHeight, cellW, 1);
    
    cellHeight = CGRectGetMaxY(_dividerF) + margin;
    
    return cellHeight;
    
}

- (CGSize)getCommentViewSize
{
    CGFloat tableViewHeight = 0;
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    
    if (self.status.likeItemsArray.count) {
        
        CGFloat h = [UILabel heightForExpressionText:self.status.likesStr width:contentW];
        
        tableViewHeight = h + 2;
    }
    if (self.status.commentItemsArray.count) {
        for (int i = 0; i < self.status.commentItemsArray.count; i++) {
            LZMomentsCellCommentItemModel *model = self.status.commentItemsArray[i];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:[self generateAttributedStringWithCommentItemModel:model]];
            
            
            MLLinkLabel *label = [MLLinkLabel new];
            label.attributedText = text;
            label.numberOfLines = 0;
            label.lineHeightMultiple = 1.1f;
            label.font = [UIFont systemFontOfSize:14];
            UIColor *highLightColor = [UIColor blueColor];
            label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
            label.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
            CGFloat h = [label preferredSizeWithMaxWidth:contentW].height;
            label = nil;
//            CGFloat h = [UILabel heightForExpressionText:text width:contentW];
            
            tableViewHeight += h;
        }
    }
    return CGSizeMake(contentW, tableViewHeight);
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(LZMomentsCellCommentItemModel *)model
{
    NSString *text = model.firstUserName;
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.commentString]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.firstUserId} range:[text rangeOfString:model.firstUserName]];
    if (model.secondUserName) {
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
    }
    return attString;
}
@end
