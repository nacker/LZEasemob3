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

#import <MapKit/MapKit.h>
#import "EaseViewController.h"

@protocol EMLocationViewDelegate <NSObject>

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
@end

@interface EaseLocationViewController : EaseViewController

@property (nonatomic, assign) id<EMLocationViewDelegate> delegate;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;

@end
