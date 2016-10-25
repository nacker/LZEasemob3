//
//  LZContactsViewCell.h
//  LZEasemob
//
//  Created by nacker on 16/3/8.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZContactsGrounp;

@interface LZContactsViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) LZContactsGrounp *status;

@property (nonatomic, strong) NSString *buddy;

@property (nonatomic) NSInteger badge;
@end
