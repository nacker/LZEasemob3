//
//  EaseRedBagCell.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/23.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "EaseRedBagCell.h"
#import "EaseBubbleView+RedPacket.h"
#import "UIImageView+EMWebCache.h"
#import "RedpacketOpenConst.h"


@implementation EaseRedBagCell

#pragma mark - IModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    
    if (self) {
        self.hasRead.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    return YES;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
    UIImage *image = model.image;
    if (!image) {
        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
    } else {
        _bubbleView.imageView.image = image;
    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
    [_bubbleView setupRedPacketBubbleView];
    
    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    [_bubbleView updateRedpacketMargin:bubbleMargin];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    if (model.isSender) {
        _bubbleView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 273.5, 2, 213, 94);
        self.bubbleView.redpacketIcon.frame = CGRectMake(13, 19, 26, 34);
        self.bubbleView.redpacketTitleLabel.frame = CGRectMake(48, 19, 156, 15);
        self.bubbleView.redpacketSubLabel.frame = CGRectMake(48, 41, 49, 12);
        self.bubbleView.redpacketNameLabel.frame = CGRectMake(13, 73, 200, 20);
    }else{
        _bubbleView.frame = CGRectMake(55, 2, 213, 94);
        self.bubbleView.redpacketIcon.frame = CGRectMake(20, 19, 26, 34);
        self.bubbleView.redpacketTitleLabel.frame = CGRectMake(55, 19, 156, 15);
        self.bubbleView.redpacketSubLabel.frame = CGRectMake(55, 41, 49, 12);
        self.bubbleView.redpacketNameLabel.frame = CGRectMake(20, 73, 200, 20);
    }

}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return model.isSender ? @"__redPacketCellSendIdentifier__" : @"__redPacketCellReceiveIdentifier__";
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return 120;
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    NSDictionary *dict = model.message.ext;
    
    NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:RedpacketKeyRedpacketGreeting]];
    if (str.length > 10) {
        str = [str substringToIndex:8];
        str = [str stringByAppendingString:@"..."];
        self.bubbleView.redpacketTitleLabel.text = str;
    }else
    {
        self.bubbleView.redpacketTitleLabel.text = [dict valueForKey:RedpacketKeyRedpacketGreeting];
    }
    
    self.bubbleView.redpacketSubLabel.text = @"查看红包";
    self.bubbleView.redpacketNameLabel.text = [dict valueForKey:RedpacketKeyRedpacketOrgName];
    _hasRead.hidden = YES;//红包消息不显示已读
    _nameLabel = nil;// 不显示姓名
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *imageName = self.model.isSender ? @"RedpacketCellResource.bundle/redpacket_sender_bg" : @"RedpacketCellResource.bundle/redpacket_receiver_bg";
    UIImage *image = self.model.isSender ? [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:30 topCapHeight:35] :
    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
    
    self.bubbleView.backgroundImageView.image = image;
}


@end
