//
//  LZMomentsDefaultsCell.m
//  LZEasemob
//
//  Created by nacker on 16/4/6.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZMomentsDefaultsCell.h"

@implementation LZMomentsDefaultsCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = nil;
    if (ID == nil) {
        ID = [NSString stringWithFormat:@"%@ID", NSStringFromClass(self)];
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}

@end
