//
//  LZMomentsSendViewController.h
//  LZEasemob
//
//  Created by nacker on 16/4/1.
//  Copyright © 2016年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZMomentsSendViewModel;

//@protocol LZMomentsSendViewControllerDelegate <NSObject>
//
//@optional
//
//-(void)onSendTextImage:(NSString *)text images:(NSArray *)images;
//
//@end

@interface LZMomentsSendViewController : UITableViewController

//@property (nonatomic, weak) id<LZMomentsSendViewControllerDelegate> delegate;

- (instancetype)initWithImages:(NSArray *)images;

@property (nonatomic, copy) void (^sendButtonClickedBlock)(NSString *text, NSArray *images);

@property (nonatomic, strong) LZMomentsSendViewModel *viewModel;

@end
