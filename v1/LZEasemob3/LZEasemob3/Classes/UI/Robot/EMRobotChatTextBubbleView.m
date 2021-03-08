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

#import "EMRobotChatTextBubbleView.h"
#import "RobotManager.h"

@implementation EMRobotChatTextBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    if ([[RobotManager sharedInstance] isRobotMenuMessage:self.model.message]) {
        if ([self.model.message.ext objectForKey:kRobot_Message_Type]) {
            NSDictionary *dic = [self.model.message.ext objectForKey:kRobot_Message_Type];
            if ([dic objectForKey:kRobot_Message_Choice]) {
                NSMutableArray *array = [NSMutableArray array];
                NSDictionary *choice = [dic objectForKey:kRobot_Message_Choice];
                NSArray *menu = [choice objectForKey:kRobot_Message_List];
                self.model.content = [[RobotManager sharedInstance] getRobotMenuMessageContent:self.model.message];
                for (NSString *string in menu) {
                    [array addObject:[NSTextCheckingResult replacementCheckingResultWithRange:[self.model.content rangeOfString:string] replacementString:string]];
                }
                _urlMatches = array;
            }
        }
    } else {
        _urlMatches = [_detector matchesInString:self.model.content options:0 range:NSMakeRange(0, self.model.content.length)];
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:self.model.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:[[self class] lineSpacing]];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [self.model.content length])];
    [self.textLabel setAttributedText:attributedString];
    [self highlightLinksWithIndex:NSNotFound];
}
*/

@end
