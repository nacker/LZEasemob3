//
//  LZMoments.m
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMoments.h"

@implementation LZMoments

- (NSString *)time
{
    return @"1分钟之前";
}

- (NSMutableAttributedString *)likesStr
{
//    NSString *result = @"";
//    for (int i = 0; i < self.likeItemsArray.count; i++) {
//        
//        LZMomentsCellLikeItemModel *like = self.likeItemsArray[i];
//        if (i == 0) {
//            result = [NSString stringWithFormat:@"%@",like.userName];
//        }else {
//            result = [NSString stringWithFormat:@"%@, %@", result, like.userName];
//        }
//        
//    }
//    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
//    NSUInteger position = 0;
//    for (int i = 0; i < self.likeItemsArray.count; i++) {
//        LZMomentsCellLikeItemModel *like = self.likeItemsArray[i];
//        [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)like.userId] range:NSMakeRange(position, like.userName.length)];
//        position += like.userName.length + 2;
//    }
//    return attrStr;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < self.likeItemsArray.count; i++) {
        LZMomentsCellLikeItemModel *model = self.likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        [attributedText appendAttributedString:[self generateAttributedStringWithLikeItemModel:model]];
        ;
    }
    
    return attributedText;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(LZMomentsCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}

@end

@implementation LZMomentsCellLikeItemModel

@end

@implementation LZMomentsCellCommentItemModel


@end