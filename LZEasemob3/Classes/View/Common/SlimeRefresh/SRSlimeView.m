//
//  SRAnimationView.m
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "SRSlimeView.h"
#import "SRDefine.h"
#import <QuartzCore/QuartzCore.h>



NS_INLINE CGPoint pointLineToArc(CGPoint center, CGPoint p2, float angle, CGFloat radius) {
    float angleS = atan2f(p2.y - center.y, p2.x - center.x);
    float angleT = angleS + angle;
    float x = radius * cosf(angleT);
    float y = radius * sinf(angleT);
    return CGPointMake(x + center.x, y + center.y);
}

@implementation SRSlimeView {
    __unsafe_unretained id  _target;
    SEL     _action;
}

@synthesize viscous = _viscous, toPoint = _toPoint;
@synthesize startPoint = _startPoint, skinColor = _skinColor;
@synthesize bodyColor = _bodyColor, radius = _radius;
@synthesize missWhenApart = _missWhenApart, state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _toPoint = _startPoint = CGPointMake(frame.size.width / 2,
                                             frame.size.height / 2);
        _viscous = 55.0f;
        _radius = 13.0f;
        _bodyColor = [UIColor blackColor];
        _skinColor = [UIColor colorWithWhite:0.8f alpha:0.9f];
        
        _missWhenApart = YES;
        _lineWith = 2;
        
    }
    return self;
}

// ==== not need
//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    _toPoint = _startPoint = CGPointMake(frame.size.width / 2,
//                                         frame.size.height / 2);
//    [self setNeedsDisplay];
//}

- (void)setLineWith:(CGFloat)lineWith
{
    _lineWith = lineWith;
    [self setNeedsDisplay];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    if (CGPointEqualToPoint(_startPoint, startPoint))return;
    if (_state == SRSlimeStateNormal) {
        _startPoint = startPoint;
        [self setNeedsDisplay];
    }
}

- (void)setToPoint:(CGPoint)toPoint
{
    if (CGPointEqualToPoint(_toPoint, toPoint))return;
    if (_state == SRSlimeStateNormal) {
        _toPoint = toPoint;
        [self setNeedsDisplay];
    }
}

- (UIBezierPath*)bodyPath:(CGFloat)startRadius end:(CGFloat)endRadius percent:(float)percent
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    float angle1 = M_PI/3 + (M_PI / 6 /*M_PI/2 - M_PI/3*/) * percent;
    
    CGPoint sp1 = pointLineToArc(_startPoint, _toPoint,
                                 angle1, startRadius),
            sp2 = pointLineToArc(_startPoint, _toPoint,
                                 -angle1, startRadius),
            ep1 = pointLineToArc(_toPoint, _startPoint,
                                 M_PI/2, endRadius),
            ep2 = pointLineToArc(_toPoint, _startPoint,
                                 -M_PI/2, endRadius);
    
#define kMiddleP    0.6
    CGPoint mp1 = CGPointMake(sp2.x*kMiddleP + ep1.x*(1-kMiddleP), sp2.y*kMiddleP + ep1.y*(1-kMiddleP)),
            mp2 = CGPointMake(sp1.x*kMiddleP + ep2.x*(1-kMiddleP), sp1.y*kMiddleP + ep2.y*(1-kMiddleP)),
            mm = CGPointMake((mp1.x + mp2.x)/2, (mp1.y + mp2.y)/2);
    float p = distansBetween(mp1, mp2) / 2 / endRadius * (0.9 + percent/10);
    mp1 = CGPointMake((mp1.x - mm.x)/p + mm.x, (mp1.y - mm.y)/p + mm.y);
    mp2 = CGPointMake((mp2.x - mm.x)/p + mm.x, (mp2.y - mm.y)/p + mm.y);
    
    [path moveToPoint:sp1];
    float angleS = atan2f(_toPoint.y - _startPoint.y,
                          _toPoint.x - _startPoint.x);
    [path addArcWithCenter:_startPoint
                    radius:startRadius
                startAngle:angleS + angle1
                  endAngle:angleS + M_PI*2 - angle1
                 clockwise:YES];
    [path addQuadCurveToPoint:ep1
                 controlPoint:mp1];
    angleS = atan2f(_startPoint.y - _toPoint.y,
                    _startPoint.x - _toPoint.x);
    [path addArcWithCenter:_toPoint
                    radius:endRadius
                startAngle:angleS + M_PI/2
                  endAngle:angleS + M_PI*3/2 
                 clockwise:YES];
    [path addQuadCurveToPoint:sp1
                 controlPoint:mp2];
    
    return path;
}

- (void)drawRect:(CGRect)rect
{
    switch (_state) {
        case SRSlimeStateNormal:
        {
            float percent = 1 - distansBetween(_startPoint , _toPoint) / _viscous;
            if (percent == 1) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_startPoint.x - _radius, _startPoint.y - _radius, 2*_radius, 2*_radius)
                                                                cornerRadius:_radius];
                

                [self setContext:context path:path];
                CGContextDrawPath(context, kCGPathFillStroke);
            }else {
                CGFloat startRadius = _radius * (kStartTo + (1-kStartTo)*percent);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGFloat endRadius = _radius * (kEndTo + (1-kEndTo)*percent);
                UIBezierPath *path = [self bodyPath:startRadius
                                                end:endRadius
                                            percent:percent];
                [self setContext:context path:path];
                CGContextDrawPath(context, kCGPathFillStroke);
                if (percent <= 0) {
                    _state = SRSlimeStateShortening;
                    
                    // pragma mark to suppress the warning
                    // "performSelector may cause a leak because its selector is unknown"
                    // applies only to the enclosed line
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [_target performSelector:_action
                                  withObject:self];
#pragma clang diagnostic pop
                    
                    [self performSelector:@selector(scaling)
                               withObject:nil
                               afterDelay:kAnimationInterval
                                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                }
            }
        }
            break;
        case SRSlimeStateShortening:
        {
            _toPoint = CGPointMake((_toPoint.x - _startPoint.x)*0.8 + _startPoint.x,
                                       (_toPoint.y - _startPoint.y)*0.8 + _startPoint.y);
            float p = distansBetween(_startPoint, _toPoint) / _viscous;
            float percent =1 -p;
            float r = _radius * p;
            
            if (p > 0.01) {
                CGFloat startRadius = r * (kStartTo + (1-kStartTo)*percent);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGFloat endRadius = r * (kEndTo + (1-kEndTo)*percent) * (1+percent / 2);
                UIBezierPath *path = [self bodyPath:startRadius
                                                end:endRadius
                                            percent:percent];
                [self setContext:context path:path];
                CGContextDrawPath(context, kCGPathFillStroke);
            }else {
                self.hidden = YES;
                _state = SRSlimeStateMiss;
            }
        }
            break;
        default:
            break;
    }
}

- (void)setContext:(CGContextRef)context path:(UIBezierPath *)path {
    if (self.shadowColor) {
        switch (self.shadowType) {
            case SRSlimeBlurShadow:
                CGContextSetShadowWithColor(context, CGSizeZero, self.shadowBlur, self.shadowColor.CGColor);
                break;
            case SRSlimeFillShadow:
                CGContextAddPath(context, path.CGPath);
                CGContextSetLineWidth(context, self.shadowBlur);
                CGContextSetStrokeColorWithColor(context, self.shadowColor.CGColor);
                CGContextDrawPath(context, kCGPathStroke);
                break;
                
            default:
                break;
        }
    }
    CGContextSetFillColorWithColor(context, self.bodyColor.CGColor);
    CGContextSetLineWidth(context, self.lineWith);
    CGContextSetStrokeColorWithColor(context, self.skinColor.CGColor);
    CGContextAddPath(context, path.CGPath);
}

- (void)scaling
{
    if (_state == SRSlimeStateShortening) {
//        self.toPoint = CGPointMake((_toPoint.x - _startPoint.x)*0.9 + _startPoint.x,
//                                   (_toPoint.y - _startPoint.y)*0.9 + _startPoint.y);
//        float p = distansBetween(_startPoint, _toPoint) / _viscous;
//        self.layer.transform = CATransform3DMakeScale(p, p, 1);
//        
//        if (p > 0.01) {
//            [self performSelector:@selector(scaling)
//                       withObject:nil
//                       afterDelay:kAnimationInterval
//                          inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
//        }else {
//            self.hidden = YES;
//            _state = SRSlimeStateMiss;
//        }
        [self setNeedsDisplay];
        [self performSelector:@selector(scaling)
                       withObject:nil
                       afterDelay:kAnimationInterval
                          inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)setPullApartTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (!hidden) {
        self.layer.transform = CATransform3DIdentity;
        [self setNeedsDisplay];
    }
}

- (void)setState:(SRSlimeState)state
{
    _state = state;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(scaling)
                                               object:nil];
}

@end
