/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "LZAddFriendCell.h"

@interface LZAddFriendCell()

@property (nonatomic, weak) UIImageView *avatarView;

@end

@implementation LZAddFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // 添加
        _addLabel = [[UILabel alloc] init];
        _addLabel.backgroundColor = KRGBACOLOR(10, 82, 104, 1.0);
        _addLabel.textAlignment = NSTextAlignmentCenter;
        _addLabel.text = NSLocalizedString(@"add", @"Add");
        _addLabel.textColor = [UIColor whiteColor];
        _addLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_addLabel];

        UIImageView *avatarView = [[UIImageView alloc] init];
        avatarView.image = [UIImage imageNamed:@"chatListCellHead.png"];
        [self.contentView addSubview:avatarView];
        self.avatarView = avatarView;
        
    
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = KRGBACOLOR(207, 210, 213, 0.7);
        [self.contentView addSubview:_bottomLineView];
        
        
        _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:_headerLongPress];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(34, 34));
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.top.equalTo(self.contentView.mas_top).with.offset(8);
        }];
        
        [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.equalTo(self.addLabel.mas_left).with.offset(-10);
            make.left.equalTo(self.avatarView.mas_right).with.offset(10);
            make.height.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)])
        {
            [_delegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    
    self.nameLabel.text = username;
    [self.avatarView getImageWithURL:_username placeholder:@"Shake_icon_people"];
}
@end
