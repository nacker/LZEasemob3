//
//  DFPlainGridImageView.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFPlainGridImageView.h"
#import "UIImageView+WebCache.h"
#import "DFImageUnitView.h"
//#import "MJPhotoBrowser.h"
//#import "MJPhoto.h"

#define Padding 5


@interface DFPlainGridImageView()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end


@implementation DFPlainGridImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViews = [NSMutableArray array];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    CGFloat x, y, width, height;
    
    width = (self.frame.size.width - 2*Padding)/3;
    height = width;
    
    for (int row=0; row<3; row++) {
        for (int column=0; column<3; column++) {
            
            x = (width+Padding)*column;
            y = (height+Padding)*row;
            DFImageUnitView *imageUnitView = [[DFImageUnitView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [self addSubview:imageUnitView];
            
            UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
            [imageUnitView addGestureRecognizer:longPressRecognizer];
            
            imageUnitView.hidden = YES;
            imageUnitView.imageButton.tag = row*3+column;
            //imageUnitView.imageView.backgroundColor =[UIColor darkGrayColor];
            [imageUnitView.imageButton addTarget:self action:@selector(onClickImage:) forControlEvents:UIControlEventTouchUpInside];
            [_imageViews addObject:imageUnitView];
        }
    }

}

-(void)layoutSubviews
{
    CGFloat x, y, width, height;
    
    width = (self.frame.size.width - 2*Padding)/3;
    height = width;
    
    for (int row=0; row<3; row++) {
        for (int column=0; column<3; column++) {
            
            x = (width+Padding)*column;
            y = (height+Padding)*row;
            DFImageUnitView *imageUnitView = [_imageViews objectAtIndex:(row*3+column)];
            imageUnitView.frame = CGRectMake(x, y, width, height);
            imageUnitView.imageButton.frame = imageUnitView.bounds;
            imageUnitView.imageView.frame = imageUnitView.bounds;
        }
    }

}


-(void)updateWithImages:(NSMutableArray *)images
{

    for (int i=0; i< _imageViews.count; i++) {
        DFImageUnitView *imageUnitView = [_imageViews objectAtIndex:i];
        
        if (i<images.count) {
            imageUnitView.hidden = NO;
            imageUnitView.imageView.image = [images objectAtIndex:i];
        }else{
            imageUnitView.hidden = YES;
        }
    }
}


-(void)onClickImage:(UIView *) sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClick:)]) {
        [_delegate onClick:sender.tag];
    }
}

-(void)onLongPress:(UILongPressGestureRecognizer *) recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        DFImageUnitView *view = (DFImageUnitView *)recognizer.view;
        if (_delegate && [_delegate respondsToSelector:@selector(onLongPress:)]) {
            [_delegate onLongPress:view.imageButton.tag];
        }
    }
}


+(CGFloat)getHeight:(NSMutableArray *)images maxWidth:(CGFloat)maxWidth
{
    CGFloat height= (maxWidth - 2*Padding)/3;
    
    if (images == nil || images.count == 0) {
        return 0.0;
    }
    
    if (images.count <=3 ) {
        return height;
    }
    
    if (images.count >3 && images.count <=6 ) {
        return height*2+Padding;
    }
    
    return height*3+Padding*2;
    
}

@end
