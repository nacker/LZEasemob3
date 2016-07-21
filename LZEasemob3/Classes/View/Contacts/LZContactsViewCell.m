//
//  LZContactsViewCell.m
//  LZEasemob
//
//  Created by nacker on 16/3/8.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZContactsViewCell.h"
#import "LZContactsGrounp.h"

@interface LZContactsViewCell()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *badgeView;
@end

@implementation LZContactsViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = nil;
    if (CellIdentifier == nil) {
        CellIdentifier = [NSString stringWithFormat:@"%@CellIdentifier", NSStringFromClass(self)];
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat margin = 8;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.left.mas_equalTo(self.contentView).with.offset(margin);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        UILabel *nameLabel = [UILabel labelWithTitle:@"" color:[UIColor blackColor] fontSize:13 alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).with.offset(margin);
            make.centerY.mas_equalTo(iconView);
        }];
        
        
        UILabel *badgeView = [[UILabel alloc] init];
        badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        badgeView.textAlignment = NSTextAlignmentCenter;
        badgeView.textColor = [UIColor whiteColor];
        badgeView.backgroundColor = [UIColor redColor];
        badgeView.font = [UIFont systemFontOfSize:11];
        badgeView.hidden = YES;
        badgeView.layer.cornerRadius = 20 / 2;
        badgeView.clipsToBounds = YES;
        [self.contentView addSubview:badgeView];
        self.badgeView = badgeView;
        
        [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.mas_equalTo(iconView.mas_right).with.offset(-margin);
            make.top.mas_equalTo(iconView.mas_top).with.offset(-5);
        }];
    }
    return self;
}

- (void)setStatus:(LZContactsGrounp *)status
{
    _status = status;
    
    [self.iconView getImageWithURL:@"" placeholder:status.icon];
    self.nameLabel.text = status.title;
    self.badgeView.hidden = YES;
}

- (void)setBuddy:(NSString *)buddy
{
    _buddy = buddy;
    
    int randomIndex = arc4random_uniform(23);
    self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",randomIndex]];
//    self.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    self.nameLabel.text = buddy;
    self.badgeView.hidden = YES;
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    
    if (badge > 0) {
        self.badgeView.hidden = NO;
        
        if (badge > 99) {
            self.badgeView.text = @"N+";
        }else{
            self.badgeView.text = [NSString stringWithFormat:@"%ld", (long)_badge];
        }
    }else{
        self.badgeView.hidden = YES;
    }
}
@end
