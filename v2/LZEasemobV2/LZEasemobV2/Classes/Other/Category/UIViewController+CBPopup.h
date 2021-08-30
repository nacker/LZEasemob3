//
//  UIViewController+CBPopup.h
//  show
//
//  Created by changcun on 21/12/2017.
//  Copyright © 2017 changba. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CBPopupViewAnimation) {
    CBPopupViewAnimationFade = 0,
    CBPopupViewAnimationSlideFromBottom,
    CBPopupViewAnimationSlideFromTop,
    CBPopupViewAnimationSlideFromLeft,
    CBPopupViewAnimationSlideFromRight
};

typedef NS_ENUM(NSInteger, CBPopupViewAligment) {
    CBPopupViewAligmentCenter = 0,
    CBPopupViewAligmentTop,
    CBPopupViewAligmentBottom
};

@interface UIViewController (CBPopup)

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType
                             aligment:(CBPopupViewAligment)aligment
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType
                             aligment:(CBPopupViewAligment)aligment
                overlayDismissEnabled:(BOOL)overlayDismissEnabled
                     overlayDismissed:(void(^)(void))overlayDismissed;

/**
 Pop up a view controller
 @param popupViewController viewcontroller to popup.
 @param animationType type of animation, default fade.
 @param aligment three aligmen to option,center,left,right.
 @param margin distance to the top or bottom, this param only used when aligment is set CBPopupViewAligmentTop or CBPopupViewAligmentBottom.
 @param overlayDismissEnabled where dismiss when Clicking the background.
 @param overlayDismissed overlay dismiss callback,this param is used when overlayDismissEnabled is set to YES.
 */
- (void)cb_presentPopupViewController:(UIViewController*)popupViewController
                        animationType:(CBPopupViewAnimation)animationType
                             aligment:(CBPopupViewAligment)aligment
                               margin:(CGFloat)margin
                overlayDismissEnabled:(BOOL)overlayDismissEnabled
                     overlayDismissed:(void(^)(void))overlayDismissed;

- (void)cb_dismissPopupViewControllerAnimated:(BOOL)animated
                                   completion:(void(^)(void))completion;

- (void)cb_dismissPopupViewControllerToRootAnimated:(BOOL)animated
                                         completion:(void(^)(void))completion;
@end
