//
//  LZMomentsCellCommentViewCell.m
//  LZEasemob
//
//  Created by nacker on 16/4/5.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#define SHOW_SIMPLE_TIPS(m) [[[UIAlertView alloc] initWithTitle:@"" message:(m) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];

#import "LZMomentsCellCommentViewCell.h"
#import "MLLabel.h"
#import "MLLinkLabel.h"
#import "LZMoments.h"

@interface LZMomentsCellCommentViewCell()<MLLinkLabelDelegate>

@end

@implementation LZMomentsCellCommentViewCell 
{
    MLLinkLabel *_likeLabel;
//    YYLabel *_likeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _likeLabel = [MLLinkLabel new];
        UIColor *highLightColor = [UIColor blueColor];
        _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        _likeLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSBackgroundColorAttributeName:kDefaultActiveLinkBackgroundColorForMLLinkLabel};
        _likeLabel.font = [UIFont systemFontOfSize:14];
        _likeLabel.delegate = self;
        _likeLabel.numberOfLines = 0;
        _likeLabel.lineHeightMultiple = 1.1f;
//        _likeLabel.textInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [self.contentView addSubview:_likeLabel];
        
        
        [_likeLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
            SHOW_SIMPLE_TIPS(tips);
        }];
        
        [_likeLabel setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"LongPress\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
            SHOW_SIMPLE_TIPS(tips);
        }];
        
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        tapG.delegate = self;
        [self.contentView addGestureRecognizer:tapG];
        
        [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)tap
{
    SHOW_SIMPLE_TIPS(@"tapped");
}

- (void)setStatus:(LZMomentsCellCommentItemModel *)status
{
    _status = status;
    
    _likeLabel.attributedText = [self generateAttributedStringWithCommentItemModel:status];
    [_likeLabel sizeToFit];
}

#pragma mark - private actions
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

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
}
@end
