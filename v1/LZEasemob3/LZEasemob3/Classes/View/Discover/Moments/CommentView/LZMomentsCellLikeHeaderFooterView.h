//
//  LZMomentsCellLikeViewCell.h
//  LZEasemob
//
//  Created by nacker on 16/4/8.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZMomentsCellLikeHeaderFooterView : UITableViewHeaderFooterView

+ (instancetype)cellWithTable:(UITableView *)tableView;

@property (nonatomic, strong) NSMutableArray *likeItemsArray;

@end
