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

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@interface ApplyViewController : UITableViewController
{
    NSMutableArray *_dataSource;
}

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)loadDataSourceFromLocalDB;

- (void)clear;

@end
