//
//  DFPlainGridImageView.h
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFPlainGridImageViewDelegate <NSObject>

@optional

-(void) onClick:(NSUInteger) index;
-(void) onLongPress:(NSUInteger) index;

@end
@interface DFPlainGridImageView : UIView

@property (nonatomic, weak) id<DFPlainGridImageViewDelegate> delegate;

+(CGFloat)getHeight:(NSMutableArray *)images maxWidth:(CGFloat)maxWidth;

-(void)updateWithImages:(NSMutableArray *)images;

@end
