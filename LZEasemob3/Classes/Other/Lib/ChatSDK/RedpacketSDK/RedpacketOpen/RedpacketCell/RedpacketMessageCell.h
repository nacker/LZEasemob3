//
//  RedpacketMessageCell.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/28.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  红包消息的显示Cell
 */
@interface RedpacketMessageCell : UITableViewCell

/**
 *  聊天消息Model
 */
@property (nonatomic, assign)   id<IMessageModel> model;
/**
 *  红包Cell被单击了的事件
 */
@property (nonatomic, copy) void(^redpacketMesageCellTaped)(id <IMessageModel> model);


@end
