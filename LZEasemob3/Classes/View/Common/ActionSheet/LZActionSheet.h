//
//  LZActionSheet.h
//  HXClient
//
//  Created by nacker on 16/2/29.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZActionSheet;

typedef void(^LZActionSheetBlock)(NSInteger buttonIndex);

@protocol LZActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(LZActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface LZActionSheet : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger redButtonIndex;

@property (nonatomic, copy) LZActionSheetBlock clickedBlock;

@property (nonatomic, strong) NSString *cancelText;
@property (nonatomic, strong) UIColor *cancelTextColor;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, assign) CGFloat backgroundOpacity;
#pragma mark - Delegate Way

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title          提示标题
 *  @param buttonTitles   所有按钮的标题
 *  @param redButtonIndex 红色按钮的 index
 *  @param delegate       代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                     delegate:(id<LZActionSheetDelegate>)delegate;

#pragma mark - Block Way
/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title          提示标题
 *  @param buttonTitles   所有按钮的标题
 *  @param redButtonIndex 红色按钮的 index
 *  @param clicked        点击按钮的 block 回调
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                      clicked:(LZActionSheetBlock)clicked;

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
              cancelTextColor:(UIColor *)cancelTextColor
                      clicked:(LZActionSheetBlock)clicked;

#pragma mark - Custom Way
/**
 *  Add a button with callback block
 *
 *  @param button
 *  @param block
 */
- (void)addButtonTitle:(NSString *)button;

#pragma mark - Show
/**
 *  显示 ActionSheet
 */
- (void)show;

@property (nonatomic, weak) id<LZActionSheetDelegate> delegate;

@end
