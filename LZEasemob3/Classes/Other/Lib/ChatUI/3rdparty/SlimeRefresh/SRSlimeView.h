//
//  SRAnimationView.h
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_INLINE CGFloat distansBetween(CGPoint p1 , CGPoint p2) {
    return sqrtf((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
}

typedef enum {
    SRSlimeStateNormal,
    SRSlimeStateShortening,
    SRSlimeStateMiss
} SRSlimeState;

typedef enum {
    SRSlimeBlurShadow,
    SRSlimeFillShadow
} SRSlimeShadowType;

@class SRSlimeView;

@interface SRSlimeView : UIView

@property (nonatomic, assign)   CGPoint startPoint, toPoint;
@property (nonatomic, assign)   CGFloat viscous;    //default 55
@property (nonatomic, assign)   CGFloat radius;     //default 13
@property (nonatomic, retain)   UIColor *bodyColor,
                                        *skinColor;

@property (nonatomic, assign)   SRSlimeShadowType   shadowType;
@property (nonatomic, assign)   CGFloat lineWith;
@property (nonatomic, assign)   CGFloat shadowBlur;
@property (nonatomic, strong)   UIColor *shadowColor;

@property (nonatomic, assign)   BOOL    missWhenApart;
@property (nonatomic, assign)   SRSlimeState    state;

- (void)setPullApartTarget:(id)target action:(SEL)action;

@end
