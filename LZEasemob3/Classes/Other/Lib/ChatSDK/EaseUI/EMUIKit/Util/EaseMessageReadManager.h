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

#import <Foundation/Foundation.h>

#import "MWPhotoBrowser.h"
#import "EaseMessageModel.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, EaseMessageModel *messageModel);

@class EMChatFireBubbleView;
@interface EaseMessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

@property (strong, nonatomic) EaseMessageModel *audioMessageModel;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray;

/**
 *  准备播放语音文件
 *
 *  @param messageModel     要播放的语音文件
 *  @param updateCompletion 需要更新model所在的Cell
 *
 *  @return 若返回NO，则不需要调用播放方法
 *
 */
- (BOOL)prepareMessageAudioModel:(EaseMessageModel *)messageModel
            updateViewCompletion:(void (^)(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel))updateCompletion;

- (EaseMessageModel *)stopMessageAudioModel;

@end
