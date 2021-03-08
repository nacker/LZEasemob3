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


#import <UIKit/UIKit.h>

#import "EaseFaceView.h"
#import "EaseTextView.h"
#import "EaseRecordView.h"
#import "EaseChatBarMoreView.h"
#import "EaseChatToolbarItem.h"

#define kTouchToRecord NSEaseLocalizedString(@"message.toolBar.record.touch", @"hold down to talk")
#define kTouchToFinish NSEaseLocalizedString(@"message.toolBar.record.send", @"loosen to send")



@protocol EMChatToolbarDelegate;
@interface EaseChatToolbar : UIView

@property (weak, nonatomic) id<EMChatToolbarDelegate> delegate;

@property (nonatomic) UIImage *backgroundImage;

@property (nonatomic, readonly) EMChatToolbarType chatBarType;

@property (nonatomic, readonly) CGFloat inputViewMaxHeight;

@property (nonatomic, readonly) CGFloat inputViewMinHeight;

@property (nonatomic, readonly) CGFloat horizontalPadding;

@property (nonatomic, readonly) CGFloat verticalPadding;

@property (strong, nonatomic) NSArray *inputViewLeftItems;

@property (strong, nonatomic) NSArray *inputViewRightItems;

@property (strong, nonatomic) EaseTextView *inputTextView;

@property (strong, nonatomic) UIView *moreView;

@property (strong, nonatomic) UIView *faceView;

@property (strong, nonatomic) UIView *recordView;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(EMChatToolbarType)type;

/**
 *  Initializa chat bar
 * @param horizontalPadding  default 8
 * @param verticalPadding    default 5
 * @param inputViewMinHeight default 36
 * @param inputViewMaxHeight default 150
 * @param type               default EMChatToolbarTypeGroup
 */
- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(EMChatToolbarType)type;

+ (CGFloat)defaultHeight;

- (void)cancelTouchRecord;

- (void)willShowBottomView:(UIView *)bottomView;

@end

@protocol EMChatToolbarDelegate <NSObject>

@optional

- (void)inputTextViewDidBeginEditing:(EaseTextView *)inputTextView;

- (void)inputTextViewWillBeginEditing:(EaseTextView *)inputTextView;

- (void)didSendText:(NSString *)text;

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext;

- (BOOL)didInputAtInLocation:(NSUInteger)location;

- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location;

- (void)didSendFace:(NSString *)faceLocalPath;

- (void)didStartRecordingVoiceAction:(UIView *)recordView;

- (void)didCancelRecordingVoiceAction:(UIView *)recordView;

- (void)didFinishRecoingVoiceAction:(UIView *)recordView;

- (void)didDragOutsideAction:(UIView *)recordView;

- (void)didDragInsideAction:(UIView *)recordView;

@required

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight;

@end
