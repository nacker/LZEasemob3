//
//  LZMomentsOriginalView.m
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsOriginalView.h"
#import "LZPhotoContainerView.h"
#import "LZMomentsViewModel.h"
#import "LZMomentsCellCommentTableView.h"

// 根据具体font而定
CGFloat maxContentLabelHeight = 60;

@implementation LZMomentsOriginalView
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    UIButton *_moreButton;
    
    LZPhotoContainerView *_photoContainerView;
    
    BOOL _shouldOpenContentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _shouldOpenContentLabel = NO;
    
    // 头像
    _iconView = [UIImageView new];
    
    // 名字
    _nameLable = [UILabel labelWithTitle:@"" color:KColor(54, 71, 121) fontSize:14 alignment:NSTextAlignmentLeft];
    
    // 正文
    _contentLabel = [UILabel labelWithTitle:@"" color:KColor(54, 71, 121) fontSize:15 alignment:NSTextAlignmentLeft];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3 - 10;
    }
    
    // 更多
    _moreButton = [UIButton buttonWithTitle:@"全文" imageName:nil target:self action:@selector(moreButtonClick)];
    [_moreButton setTitleColor:KColor(92, 140, 193) forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];

    // 图片
    _photoContainerView = [[LZPhotoContainerView alloc] init];
    
    [self addSubview:_iconView];
    [self addSubview:_nameLable];
    [self addSubview:_contentLabel];
    [self addSubview:_moreButton];
    [self addSubview:_photoContainerView];
}

- (void)setViewModel:(LZMomentsViewModel *)viewModel
{
    _viewModel = viewModel;
    
    _iconView.image = [UIImage imageNamed:viewModel.status.iconName];
    _iconView.frame = viewModel.iconViewF;
    _iconView.backgroundColor = KRandomColor;
    
    _nameLable.text = viewModel.status.name;
    _nameLable.frame = viewModel.nameLableF;

    _shouldOpenContentLabel = NO;
    
    [self setupContentViewWithContent:viewModel.msgContent];
    
    [self setupPictureViewWithURLs:viewModel.picNamesArray];
}

- (void)setupContentViewWithContent:(NSString *)content
{
    BOOL hasContent = content.length > 0;
    _contentLabel.hidden = _moreButton.hidden = !hasContent;
    
    if (content.length) {  // 有文字
        _contentLabel.text = content;
        
        if (self.viewModel.shouldShowMoreButton) { // 如果文字高度超过60
            _moreButton.hidden = NO;
            
            if (self.viewModel.isOpening) { // 如果需要展开
                [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
                _contentLabel.frame = self.viewModel.contentLabelF;
            } else {
                
                [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
                _contentLabel.frame = self.viewModel.contentLabelF;
            }
            _moreButton.frame = self.viewModel.moreButtonF;
            
        }else {  // 没有超过60
            _moreButton.hidden = YES;
            _contentLabel.frame = self.viewModel.contentLabelF;
        }
    }
}

- (void)setupPictureViewWithURLs:(NSArray *)urls
{
    // 1. 设置配图视图数据
    _photoContainerView.urls = urls;
    
    // 2. 是否隐藏视图
    BOOL hasPicture = urls.count > 0;
    _photoContainerView.hidden = !hasPicture;
    
    // 3. 判断是否有配图
    if (hasPicture) {
        _photoContainerView.frame = self.viewModel.photoContainerViewF;
    }
}

// 展开文字高度超过的按钮
- (void)moreButtonClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LZMoreButtonClickedNotification object:self userInfo:@{LZMoreButtonClickedNotificationKey : self.indexPath}];
    
//    if (self.moreButtonClickedBlock) {
//        self.moreButtonClickedBlock(self.indexPath);
//    }
}
@end
