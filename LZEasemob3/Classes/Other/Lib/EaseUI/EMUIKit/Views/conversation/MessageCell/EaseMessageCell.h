/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>

#import "IModelChatCell.h"
#import "IMessageModel.h"

#import "EaseBubbleView.h"

#define kEMMessageImageSizeWidth 120
#define kEMMessageImageSizeHeight 120
#define kEMMessageLocationHeight 95
#define kEMMessageVoiceHeight 23

extern CGFloat const EaseMessageCellPadding;

typedef enum{
    EaseMessageCellEvenVideoBubbleTap,
    EaseMessageCellEventLocationBubbleTap,
    EaseMessageCellEventImageBubbleTap,
    EaseMessageCellEventAudioBubbleTap,
    EaseMessageCellEventFileBubbleTap,
    EaseMessageCellEventCustomBubbleTap,
}EaseMessageCellTapEventType;

@protocol EaseMessageCellDelegate;
@interface EaseMessageCell : UITableViewCell<IModelChatCell>
{
    UIButton *_statusButton;
    UILabel *_hasRead;
    EaseBubbleView *_bubbleView;
    UIActivityIndicatorView *_activity;

    
    NSLayoutConstraint *_statusWidthConstraint;
}

@property (weak, nonatomic) id<EaseMessageCellDelegate> delegate;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (strong, nonatomic) UIImageView *avatarView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIButton *statusButton;

@property (strong, nonatomic) UILabel *hasRead;

@property (strong, nonatomic) EaseBubbleView *bubbleView;

@property (strong, nonatomic) id<IMessageModel> model;

@property (nonatomic) CGFloat statusSize UI_APPEARANCE_SELECTOR; //default 20;

@property (nonatomic) CGFloat activitySize UI_APPEARANCE_SELECTOR; //default 20;

@property (nonatomic) CGFloat bubbleMaxWidth UI_APPEARANCE_SELECTOR; //default 200;

@property (nonatomic) UIEdgeInsets bubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 0, 8, 0);

@property (nonatomic) UIEdgeInsets leftBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 15, 8, 10);

@property (nonatomic) UIEdgeInsets rightBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 10, 8, 15);

@property (strong, nonatomic) UIImage *sendBubbleBackgroundImage UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIImage *recvBubbleBackgroundImage UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIFont *messageTextFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:15];

@property (nonatomic) UIColor *messageTextColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

@property (nonatomic) UIFont *messageLocationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];

@property (nonatomic) UIColor *messageLocationColor UI_APPEARANCE_SELECTOR; //default [UIColor whiteColor];

@property (nonatomic) NSArray *sendMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) NSArray *recvMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *messageVoiceDurationColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

@property (nonatomic) UIFont *messageVoiceDurationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];

@property (nonatomic) UIFont *messageFileNameFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:13];

@property (nonatomic) UIColor *messageFileNameColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];

@property (nonatomic) UIFont *messageFileSizeFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:11];

@property (nonatomic) UIColor *messageFileSizeColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<IMessageModel>)model;

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;

@end

@protocol EaseMessageCellDelegate <NSObject>

@optional

- (void)messageCellSelected:(id<IMessageModel>)model;

- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(EaseMessageCell*)messageCell;

- (void)avatarViewSelcted:(id<IMessageModel>)model;

@end

