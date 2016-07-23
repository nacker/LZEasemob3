//
//  LZConversationCell.m
//  HXClient
//
//  Created by nacker on 16/6/3.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZConversationCell.h"
#import "LZBadgeView.h"

@interface LZConversationCell()
{
    UIImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_messageLabel;
    LZBadgeView *_badgeView;
    UIImageView *_divider;
}
@end

@implementation LZConversationCell

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
     
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 50 * 0.5;
        _iconView.clipsToBounds = YES;
        

        _badgeView = [[LZBadgeView alloc] init];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor lightGrayColor];
        
        _divider = [[UIImageView alloc] init];
        _divider.backgroundColor = [UIColor grayColor];
        _divider.alpha = 0.3;
        
        [self.contentView addSubview:_iconView];
        [self.contentView addSubview:_badgeView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_divider];
        
        CGFloat margin = 10;
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(margin);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(- 1.5 * margin);
            make.top.equalTo(_iconView);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_timeLabel.mas_left).offset(-margin * 0.5);
            make.left.equalTo(_iconView.mas_right).offset(margin);
            make.top.equalTo(self.contentView.mas_top).offset(margin);
        }];
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(0.5 * margin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-1.5 * margin);
            make.right.equalTo(self.contentView.mas_right).offset(-margin);
        }];
        
        [_divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1.5);
            make.height.equalTo(@1);
            make.left.right.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)setConversaion:(EMConversation *)conversaion
{
    _conversaion = conversaion;
    
    int randomIndex = arc4random_uniform(23);
    _iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",randomIndex]];
    
    KLog(@"%d",[conversaion unreadMessagesCount]);
    _badgeView.badgeValue = [NSString stringWithFormat:@"%d",[conversaion unreadMessagesCount]];
    
    _nameLabel.text = conversaion.conversationId;
    
    if (conversaion.latestMessage) {
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSDate dateFromLongLong:conversaion.latestMessage.timestamp].dateDescription;
    }else {
        _timeLabel.hidden = YES;
    }
    
//    [NSString stringWithFormat:@"%@  %d   %@",conversaion.latestMessage.from,[conversaion unreadMessagesCount],[LZTool timeStr:conversaion.latestMessage.timestamp]];
    
    // 获取消息体
    id body = conversaion.latestMessage.body;

    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        _messageLabel.text = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        _messageLabel.text = @"[语音]";
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        _messageLabel.text = @"[图片]";
    }else{
        _messageLabel.text = @"";
    }
    _messageLabel.textColor = [UIColor grayColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _badgeView.x = 45;
    _badgeView.y = 5;
    
}
@end
