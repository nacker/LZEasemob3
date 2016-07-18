//
//  LZBaseRefreshView.h
//  LZEasemob
//
//  Created by nacker on 16/3/11.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kSDBaseRefreshViewObserveKeyPath;

typedef enum {
    KRefreshViewStateNormal,
    KRefreshViewStateWillRefresh,
    KRefreshViewStateRefreshing,
} KRefreshViewState;

@interface LZBaseRefreshView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)endRefreshing;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInsets;
@property (nonatomic, assign) KRefreshViewState refreshState;


@end
