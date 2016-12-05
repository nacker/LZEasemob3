//
//  TransferCell.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yan on 16/8/25.
//  Copyright © 2016年 Mr.Yan. All rights reserved.
//

#import "TransferCell.h"
#import "EaseBubbleView+RedPacket.h"
#import "RedpacketOpenConst.h"

@implementation TransferCell

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
        self.bubbleView.redpacketIcon.frame = CGRectMake(13, 19, 34, 34);
        self.bubbleView.redpacketTitleLabel.frame = CGRectMake(52, 19, 156, 15);
        self.bubbleView.redpacketSubLabel.frame = CGRectMake(52, 41, 51, 12);
        self.bubbleView.redpacketNameLabel.frame = CGRectMake(13, 73, 200, 20);
        self.bubbleView.redpacketMemberLable.frame = CGRectMake(145, 73, 80, 20);
    }else{
        _bubbleView.frame = CGRectMake(55, 2, 213, 94);
        self.bubbleView.redpacketIcon.frame = CGRectMake(20, 19, 34, 34);
        self.bubbleView.redpacketTitleLabel.frame = CGRectMake(59, 19, 156, 15);
        self.bubbleView.redpacketSubLabel.frame = CGRectMake(59, 41, 51, 12);
        self.bubbleView.redpacketNameLabel.frame = CGRectMake(20, 73, 200, 20);
        self.bubbleView.redpacketMemberLable.frame = CGRectMake(152, 73, 80, 20);
        
    }
    [self.bubbleView.redpacketIcon  setImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redPacket_transferIcon"]];
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return model.isSender ? @"__redPacketTransferCellSendIdentifier__" : @"__redPacketTransferCellReceiveIdentifier__";
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return 120;
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    NSDictionary *dict = model.message.ext;
    NSString *str;
    if (model.isSender) {
        str = @"对方已收到转账";
    }else
    {
        str = @"已收到对方转账";
    }
    self.bubbleView.redpacketTitleLabel.text = str;
   
    self.bubbleView.redpacketSubLabel.text = [NSString stringWithFormat:@"%@元",dict[@"money_transfer_amount"]];
    self.bubbleView.redpacketNameLabel.text = @"环信转账";
    _hasRead.hidden = YES;//红包消息不显示已读
    _nameLabel = nil;// 不显示姓名
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *imageName = self.model.isSender ? @"RedpacketCellResource.bundle/transfer_sender_bg" : @"RedpacketCellResource.bundle/transfer_receiver_bg";
    UIImage *image = self.model.isSender ? [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:30 topCapHeight:35] :
    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
    
    self.bubbleView.backgroundImageView.image = image;
}


@end
