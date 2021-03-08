//
//  LZMomentsCellCommentBgView.m
//  LZEasemob
//
//  Created by nacker on 16/4/8.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsCellCommentBgView.h"
#import "LZMomentsCellCommentTableView.h"
#import "LZMomentsViewModel.h"
#import "MLLinkLabel.h"

@implementation LZMomentsCellCommentBgView
{
    LZMomentsCellCommentTableView *_tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.image = [UIImage resizedImage:@"LikeCmtBg"];
        
        _tableView = [[LZMomentsCellCommentTableView alloc] init];
        [self addSubview:_tableView];
        
    }
    return self;
}

- (void)setViewModel:(LZMomentsViewModel *)viewModel
{
    _viewModel = viewModel;
    
    _tableView.viewModel = viewModel;
    
    CGSize commentViewSize = [viewModel getCommentViewSize];
    
    _tableView.size = CGSizeMake(commentViewSize.width, commentViewSize.height + 5);
}
@end
