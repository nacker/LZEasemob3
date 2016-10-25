//
//  LZMomentsOriginalView.h
//  LZEasemob
//
//  Created by nacker on 16/3/14.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZMomentsViewModel;

@interface LZMomentsOriginalView : UIView

@property (nonatomic, strong) LZMomentsViewModel *viewModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@end
