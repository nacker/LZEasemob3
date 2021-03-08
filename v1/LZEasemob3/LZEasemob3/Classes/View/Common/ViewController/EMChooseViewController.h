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

#import <UIKit/UIKit.h>

@protocol EMChooseViewDelegate;

/**
 *  展示，提供单选多选
 */
@interface EMChooseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    __weak id<EMChooseViewDelegate> _delegate;
    NSMutableArray *_dataSource;
}

@property (weak, nonatomic) id<EMChooseViewDelegate> delegate;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UILocalizedIndexedCollation *indexCollation;//搜索核心


/**
 *  是否多选，默认YES
 *
 *  初始化类之后设置
 */
@property (nonatomic) BOOL mulChoice;

/**
 *  默认是否处于编辑状态，默认NO
 *
 *  初始化类之后设置
 *  YES：点击cell呈选中状态
 *  NO：点击菜单栏“选择”，然后处于编辑状态
 */
@property (nonatomic) BOOL defaultEditing;

/**
 *  是否显示所有索引（A-#），默认NO
 *
 *  初始化类之后设置
 */
@property (nonatomic) BOOL showAllIndex;

/**
 *  获取每个元素比较的字符串，必须在[viewDidLoad]或者[viewDidLoadBlock]或者[viewControllerLoadDataSource:]调用之前设置
 */
@property (copy) NSString *(^objectComparisonStringBlock)(id object);

/**
 *  判读数组中每两个元素大小的方法，必须在[viewDidLoad]或者[viewDidLoadBlock]或者[viewControllerLoadDataSource:]调用之前设置
 */
@property (copy) NSComparisonResult (^comparisonObjectSelector)(id object1, id object2);

/**
 *  页面加载完成的回调
 */
@property (copy) void (^viewDidLoadBlock)(EMChooseViewController *controller);

/**
 *  获取数据源的回调 (也可通过实现代理方法中的[viewControllerLoadDataSource:])
 */
@property (copy) void (^loadDataSourceBlock)(EMChooseViewController *controller);

/**
 *
 */
@property (copy) UITableViewCell * (^cellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);

@property (copy) CGFloat (^heightForRowAtIndexPathCompletion)(id object);

@property (copy) void (^didSelectRowAtIndexPathCompletion)(id object);


#pragma mark - 以下方法可作为继承类重写

/**
 *  加载数据源
 */
- (void)loadDataSource;

/**
 *  给数据源排序
 *
 *  @param recordArray 要排序的数组
 *
 *  @return 排好序的数组
 */
- (NSArray *)sortRecords:(NSArray *)recordArray;

/**
 *  获取分组编号
 *
 *  @param string 排序时比较的字符串
 *
 *  @return 分组编号
 */
- (NSInteger)sectionForString:(NSString *)string;

/**
 *  选择完成
 *
 *  @param sender 点击的按钮
 */
- (void)doneAction:(id)sender;

@end

@protocol EMChooseViewDelegate <NSObject>

@optional

- (NSComparisonResult)comparisonObjectSelector:(id)object1 andObject:(id)object2;

/**
 *  获取数据源
 *
 *  @return 数据源
 */
- (NSArray *)viewControllerLoadDataSource:(EMChooseViewController *)viewController;

/**
 *  选择完成之后代理方法
 *
 *  @param viewController  列表视图
 *  @param selectedSources 选择的联系人信息，每个联系人提供姓名和手机号两个字段，以字典形式返回
 *  @return 是否隐藏页面
 */
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources;

/**
 *  页面返回
 *
 *  @param viewController  列表视图
 */
- (void)viewControllerDidSelectBack:(EMChooseViewController *)viewController;

@end
