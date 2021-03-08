//
//  GettingMoreFooterView.h
//  ChatDemo-UI3.0
//
//  Created by jiangwei on 2016/10/31.
//  Copyright © 2016年 jiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GettingMoreFooterViewState){
    eGettingMoreFooterViewStateInitial,
    eGettingMoreFooterViewStateIdle,
    eGettingMoreFooterViewStateGetting,
    eGettingMoreFooterViewStateComplete,
    eGettingMoreFooterViewStateFailed
};

@interface GettingMoreFooterView : UIView
@property (nonatomic) GettingMoreFooterViewState state;
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (strong, nonatomic) UILabel *label;
@end
