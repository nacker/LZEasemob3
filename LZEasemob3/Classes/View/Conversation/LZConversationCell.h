//
//  LZConversationCell.h
//  HXClient
//
//  Created by nacker on 16/6/3.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMConversation;

@interface LZConversationCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) EMConversation *conversaion;

@end
