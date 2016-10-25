//
//  RedpacketViewControl.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RedpacketMessageModel.h"

//  抢红包成功回调
typedef void(^RedpacketGrabBlock)(RedpacketMessageModel *messageModel);
//  环信接口发送红包消息回调
typedef void(^RedpacketSendBlock)(RedpacketMessageModel *model);

/**
 *  发红包的控制器
 */
@interface RedpacketViewControl : NSObject

/**
 *  当前窗口的会话信息，个人或者群组
 */
@property (nonatomic, strong) RedpacketUserInfo *converstationInfo;

/**
 *  当前的聊天窗口
 */
@property (nonatomic, weak) UIViewController *conversationController;

/**
 *  用户单击了聊天窗口中的红包Cell后触发
 *
 *  @param messageModel 消息Model
 */
- (void)redpacketCellTouchedWithMessageModel:(RedpacketMessageModel *)messageModel;

/**
 *  设置发送红包，抢红包成功回调
 *
 *  @param grabTouch 抢红包回调
 *  @param sendBlock 发红包回调
 */
- (void)setRedpacketGrabBlock:(RedpacketGrabBlock)grabTouch andRedpacketBlock:(RedpacketSendBlock)sendBlock;

#pragma mark - Controllers

/**
 *  点对点红包控制器
 *
 *  @return 返回红包控制器
 */
- (UIViewController *)redpacketViewController;

/**
 *  多人红包控制器
 *
 *  @param changeMoneyController 聊天室或者群人数
 *
 *  @return 返回多人红包控制器
 */
- (UIViewController *)mulityRedpacketViewController:(int)peopleCount;

/**
 *  零钱页面
 *
 *  @return 零钱页面，App可以放在需要的位置
 */
+ (UIViewController *)changeMoneyController;

/**
 *  零钱明细页面
 *
 *  @return 零钱明细页面，App可以放在需要的位置
 */
+ (UIViewController *)changeMoneyListController;

#pragma mark - ShowViewControllers

/**
 *  显示群红包页面
 */
- (void)presentRedPacketMoreViewControllerWithCount:(int)count;

/**
 *  显示点对点红包页面
 */
- (void)presentRedPacketViewController;

/**
 *  显示零钱页面
 */
- (void)presentChangeMoneyViewController;


@end
