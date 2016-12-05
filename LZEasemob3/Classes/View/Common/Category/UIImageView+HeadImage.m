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


#import "UIImageView+HeadImage.h"

#import "UserProfileManager.h"

@implementation UIImageView (HeadImage)

- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
    }
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:username];
    if (profileEntity) {
        [self sd_setImageWithURL:[NSURL URLWithString:profileEntity.imageUrl] placeholderImage:placeholderImage];
    } else {
        [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
    }
}

@end

@implementation UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username
{
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:username];
    if (profileEntity) {
        if (profileEntity.nickname && profileEntity.nickname.length > 0) {
            [self setText:profileEntity.nickname];
            [self setNeedsLayout];
        } else {
            [self setText:username];
        }
    } else {
        [self setText:username];
    }
    
}

@end
