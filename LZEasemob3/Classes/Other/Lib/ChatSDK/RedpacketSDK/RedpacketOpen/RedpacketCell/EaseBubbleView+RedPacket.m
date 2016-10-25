//
//  EaseBubbleView+RedPacket.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/23.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "EaseBubbleView+RedPacket.h"
#import <objc/runtime.h>
#import "RedpacketOpenConst.h"


static char _redpacketIcon_;
static char _redpacketTitleLabel_;
static char _redpacketSubLabel_;
static char _redpacketCompanyIcon_;
static char _redpacketNameLabel_;

@implementation EaseBubbleView (RedPacket)

- (void)_setupConstraints
{
    //icon view
    NSLayoutConstraint *redPacketIconCenterConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-10];
    
    NSLayoutConstraint *redPacketIconLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketIcon attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20];

    [self.marginConstraints addObject:redPacketIconCenterConstraint];
    [self.marginConstraints addObject:redPacketIconLeadingConstraint];
    
    NSLayoutConstraint *redPacketIconHeightConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:33];

    NSLayoutConstraint *redPacketIconWidthConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:25];
    
    [self.redpacketIcon addConstraint:redPacketIconHeightConstraint];
    [self.redpacketIcon addConstraint:redPacketIconWidthConstraint];
    
    //titlelabel
    NSLayoutConstraint *titleWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];

    NSLayoutConstraint *titleWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketTitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15];
    
    NSLayoutConstraint *titleWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:55];
    
    [self.marginConstraints addObject:titleWithMarginRightConstraint];
    [self.marginConstraints addObject:titleWithMarginTopConstraint];
    [self.marginConstraints addObject:titleWithMarginLeftConstraint];
    
    //subTitleLabel
    NSLayoutConstraint *subtitleWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketSubLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.redpacketTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6];
    
    NSLayoutConstraint *subtitleWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketSubLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.redpacketIcon attribute:NSLayoutAttributeRight multiplier:1.0 constant:10];
    
    [self.marginConstraints addObject:subtitleWithMarginTopConstraint];
    [self.marginConstraints addObject:subtitleWithMarginLeftConstraint];
    
    //  nameLabel
    NSLayoutConstraint *nameLabelLeftConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20];
    
    NSLayoutConstraint *nameLabelBottomConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketNameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-3];
    [self.marginConstraints addObject:nameLabelLeftConstraint];
    [self.marginConstraints addObject:nameLabelBottomConstraint];
    
    // companyIcon
    NSLayoutConstraint *companyIconHeightConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketCompanyIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:14];
    NSLayoutConstraint *companyIconWidthConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketCompanyIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:21];
    
    [self.redpacketCompanyIcon addConstraint:companyIconHeightConstraint];
    [self.redpacketCompanyIcon addConstraint:companyIconWidthConstraint];
    
    NSLayoutConstraint *companyIconRightConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketCompanyIcon attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10];
    
    NSLayoutConstraint *companyIconBottomConstraint = [NSLayoutConstraint constraintWithItem:self.redpacketCompanyIcon attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-3];
    [self.marginConstraints addObject:companyIconRightConstraint];
    [self.marginConstraints addObject:companyIconBottomConstraint];
    
    [self addConstraints:self.marginConstraints];
    
    NSLayoutConstraint *backImageConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:260];
    
    [self.superview addConstraint:backImageConstraint];
    
    /*
    UIView *backImageView = self.backgroundImageView;
    NSArray *backgroundConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[backImageView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backImageView)];
    NSArray *backgroundConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[backImageView(==200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backImageView)];
    
    [self addConstraints:backgroundConstraints];
    [self addConstraints:backgroundConstraints2];
  */
}

#pragma mark - public

- (void)setupRedPacketBubbleView
{
    self.redpacketIcon = [UIImageView new];
    [self.redpacketIcon setImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redPacket_redPacktIcon"]];
    [self.backgroundImageView addSubview:self.redpacketIcon];
    
    self.redpacketTitleLabel = [UILabel new];
    self.redpacketTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.redpacketTitleLabel.textColor = [UIColor whiteColor];
    [self.backgroundImageView addSubview:self.redpacketTitleLabel];
    
    self.redpacketSubLabel = [UILabel new];
    self.redpacketSubLabel.font = [UIFont systemFontOfSize:12.0f];
    self.redpacketSubLabel.textColor = [UIColor whiteColor];
    [self.backgroundImageView addSubview:self.redpacketSubLabel];
    
    self.redpacketNameLabel = [UILabel new];
    self.redpacketNameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.redpacketNameLabel.textColor = rp_hexColor(rp_textColorGray);
    [self.backgroundImageView addSubview:self.redpacketNameLabel];
    
    self.redpacketCompanyIcon = [UIImageView new];
    self.redpacketCompanyIcon.hidden = YES;
    [self.redpacketCompanyIcon setImage:[UIImage imageNamed:@"RedpacketCellResource.bundle/redPacket_yunAccount_icon"]];
    self.redpacketCompanyIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:self.redpacketCompanyIcon];
    
    [self _setupConstraints];
    
}

- (void)updateRedpacketMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupConstraints];
}

#pragma mark - propertys

- (void)setRedpacketIcon:(UIImageView *)redpacketIcon
{
    objc_setAssociatedObject(self, &_redpacketIcon_, redpacketIcon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)redpacketIcon
{
    return objc_getAssociatedObject(self, &_redpacketIcon_);
}

- (void)setRedpacketTitleLabel:(UILabel *)redpacketTitleLabel
{
    objc_setAssociatedObject(self, &_redpacketTitleLabel_, redpacketTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)redpacketTitleLabel
{
    return objc_getAssociatedObject(self, &_redpacketTitleLabel_);
}

- (void)setRedpacketSubLabel:(UILabel *)redpacketSubLabel
{
    objc_setAssociatedObject(self, &_redpacketSubLabel_, redpacketSubLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)redpacketSubLabel
{
    return objc_getAssociatedObject(self, &_redpacketSubLabel_);
}

- (void)setRedpacketCompanyIcon:(UIImageView *)redpacketIcon
{
    objc_setAssociatedObject(self, &_redpacketCompanyIcon_, redpacketIcon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)redpacketCompanyIcon
{
    return objc_getAssociatedObject(self, &_redpacketCompanyIcon_);
}

- (void)setRedpacketNameLabel:(UILabel *)nameLabel
{
    objc_setAssociatedObject(self, &_redpacketNameLabel_, nameLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)redpacketNameLabel
{
    return objc_getAssociatedObject(self, &_redpacketNameLabel_);
}



@end
