//
//  LZApplyFriendCell.m
//  LZEasemob3
//
//  Created by nacker on 16/7/18.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZApplyFriendCell.h"
#import "LZApplyUserModel.h"

@interface LZApplyFriendCell()

@property (strong, nonatomic) UIImageView *headerImageView;//头像
@property (strong, nonatomic) UILabel *titleLabel;//标题
@property (strong, nonatomic) UILabel *contentLabel;//详情
@property (strong, nonatomic) UIButton *addButton;//接受按钮
@property (strong, nonatomic) UIButton *refuseButton;//拒绝按钮
@property (strong, nonatomic) UIView *bottomLineView;

@end

@implementation LZApplyFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _headerImageView.backgroundColor = [UIColor clearColor];
        _headerImageView.clipsToBounds = YES;
        _headerImageView.layer.cornerRadius = 5.0;
        [self.contentView addSubview:_headerImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_contentLabel];
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 50, 30)];
        [_addButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
        [_addButton setTitle:NSLocalizedString(@"accept", @"Accept") forState:UIControlStateNormal];
        _addButton.clipsToBounds = YES;
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addButton];
        
        _refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 120, 0, 50, 30)];
        [_refuseButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
        [_refuseButton setTitle:NSLocalizedString(@"reject", @"Reject") forState:UIControlStateNormal];
        _refuseButton.clipsToBounds = YES;
        [_refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refuseButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_refuseButton addTarget:self action:@selector(refuseFriend) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_refuseButton];
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:210 /255.0 blue:213 / 255.0 alpha:0.7];
        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _addButton.frame = CGRectMake(self.contentView.frame.size.width - 60, (self.contentView.frame.size.height - 30) / 2, 50, 30);
    _refuseButton.frame = CGRectMake(self.contentView.frame.size.width - 120, (self.contentView.frame.size.height - 30) / 2, 50, 30);
    _bottomLineView.frame = CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
    if (_contentLabel.text.length > 0) {
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 10, self.contentView.frame.size.width - 120 - (CGRectGetMaxX(_headerImageView.frame) + 10), 20);
        _contentLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), _titleLabel.frame.size.width, self.contentView.frame.size.height - 20 - _titleLabel.frame.size.height);
    }
    else{
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 10, self.contentView.frame.size.width - 120 - (CGRectGetMaxX(_headerImageView.frame) + 10), self.contentView.frame.size.height - 20);
        _contentLabel.frame = CGRectZero;
    }
}

- (void)addFriend
{
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellAddFriendAtIndexPath:)])
    {
        [_delegate applyCellAddFriendAtIndexPath:self.indexPath];
    }
}

- (void)refuseFriend
{
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellRefuseFriendAtIndexPath:)])
    {
        [_delegate applyCellRefuseFriendAtIndexPath:self.indexPath];
    }
}

- (void)setStatus:(LZApplyUserModel *)status
{
    _status = status;
    
    self.titleLabel.text = status.name;
    int randomIndex = arc4random_uniform(23);
    self.headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",randomIndex]];
    
    if (status.apply == 0) {
        self.addButton.hidden = NO;
        self.refuseButton.hidden = NO;
    }else {
        self.addButton.hidden = YES;
        self.refuseButton.hidden = YES;
    }
}

@end
