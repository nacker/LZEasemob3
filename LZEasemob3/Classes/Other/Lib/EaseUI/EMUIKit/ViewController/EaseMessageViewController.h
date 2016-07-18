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

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EaseRefreshTableViewController.h"

#import "IMessageModel.h"
#import "EaseMessageModel.h"
#import "EaseBaseMessageCell.h"
#import "EaseMessageTimeCell.h"
#import "EaseChatToolbar.h"
#import "EaseLocationViewController.h"
#import "EMCDDeviceManager+Media.h"
#import "EMCDDeviceManager+ProximitySensor.h"
#import "UIViewController+HUD.h"
#import "EaseSDKHelper.h"

@interface EaseAtTarget : NSObject
@property (nonatomic, copy) NSString    *userId;
@property (nonatomic, copy) NSString    *nickname;

- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname;
@end

typedef void(^EaseSelectAtTargetCallback)(EaseAtTarget*);

@class EaseMessageViewController;

@protocol EaseMessageViewControllerDelegate <NSObject>

@optional

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel;

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth;

- (void)messageViewController:(EaseMessageViewController *)viewController
          didSendMessageModel:(id<IMessageModel>)messageModel;

- (void)messageViewController:(EaseMessageViewController *)viewController
   didFailSendingMessageModel:(id<IMessageModel>)messageModel
                        error:(EMError *)error;

- (void)messageViewController:(EaseMessageViewController *)viewController
 didReceiveHasReadAckForModel:(id<IMessageModel>)messageModel;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
        didSelectMessageModel:(id<IMessageModel>)messageModel;

- (void)messageViewController:(EaseMessageViewController *)viewController
    didSelectAvatarMessageModel:(id<IMessageModel>)messageModel;

- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index;

- (void)messageViewController:(EaseMessageViewController *)viewController
              didSelectRecordView:(UIView *)recordView
                withEvenType:(EaseRecordViewType)type;

/*!
 @method
 @brief 获取要@的对象
 @discussion 用户输入了@，选择要@的对象
 @param selectedCallback 用于回调要@的对象的block
 @result
 */
- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback;

@end


@protocol EaseMessageViewControllerDataSource <NSObject>

@optional

- (id)messageViewController:(EaseMessageViewController *)viewController
                  progressDelegateForMessageBodyType:(EMMessageBodyType)messageBodyType;

- (void)messageViewController:(EaseMessageViewController *)viewController
               updateProgress:(float)progress
                 messageModel:(id<IMessageModel>)messageModel
                  messageBody:(EMMessageBody*)messageBody;

- (NSString *)messageViewController:(EaseMessageViewController *)viewController
                      stringForDate:(NSDate *)date;

- (NSArray *)messageViewController:(EaseMessageViewController *)viewController
          loadMessageFromTimestamp:(long long)timestamp
                             count:(NSInteger)count;

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)messageViewControllerShouldMarkMessagesAsRead:(EaseMessageViewController *)viewController;

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
shouldSendHasReadAckForMessage:(EMMessage *)message
                         read:(BOOL)read;

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel;

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                   messageModel:(id<IMessageModel>)messageModel;

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController;

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion;

@end

@interface EaseMessageViewController : EaseRefreshTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, EMChatManagerDelegate, EMCDDeviceManagerDelegate, EMChatToolbarDelegate, EaseChatBarMoreViewDelegate, EMLocationViewDelegate,EMChatroomManagerDelegate, EaseMessageCellDelegate>

@property (weak, nonatomic) id<EaseMessageViewControllerDelegate> delegate;

@property (weak, nonatomic) id<EaseMessageViewControllerDataSource> dataSource;

@property (strong, nonatomic) EMConversation *conversation;

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;

@property (nonatomic) BOOL deleteConversationIfNull; //default YES;

@property (nonatomic) BOOL scrollToBottomWhenAppear; //default YES;

@property (nonatomic) BOOL isViewDidAppear;

@property (nonatomic) NSInteger messageCountOfPage; //default 50

@property (nonatomic) CGFloat timeCellHeight;

@property (strong, nonatomic) NSMutableArray *messsagesSource;

@property (strong, nonatomic) UIView *chatToolbar;

@property(strong, nonatomic) EaseChatBarMoreView *chatBarMoreView;

@property(strong, nonatomic) EaseFaceView *faceView;

@property(strong, nonatomic) EaseRecordView *recordView;

@property (strong, nonatomic) UIMenuController *menuController;

@property (strong, nonatomic) NSIndexPath *menuIndexPath;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (nonatomic) BOOL isJoinedChatroom;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;

- (void)tableViewDidTriggerHeaderRefresh;

- (void)sendTextMessage:(NSString *)text;

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext;

- (void)sendImageMessage:(UIImage *)image;

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration;

- (void)sendVideoMessageWithURL:(NSURL *)url;

-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress;

-(void)showMenuViewController:(UIView *)showInView
                 andIndexPath:(NSIndexPath *)indexPath
                  messageType:(EMMessageBodyType)messageType;

-(BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message
                                 read:(BOOL)read;

@end
