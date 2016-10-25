//
//  RedpacketOpenConst.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/17.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*---------------------------------------
 *  Defines
 ---------------------------------------*/

#define rpWeakSelf __weak typeof(self) weakSelf = self

#ifdef DEBUG
#define RPLog(...) NSLog(__VA_ARGS__)
#else
#define RPLog(...)
#endif


#define rpURL(...) [NSURL URLWithString:__VA_ARGS__]
#define rpString(...) [NSString stringWithFormat:__VA_ARGS__]
#define rpRedpacketBundleResource(__resource__) rpString(@"RedPacketResource.bundle/%@", __resource__)

#define rpImageNamed(__image__)  [UIImage imageNamed:__image__]
#define rpRedpacketBundleImage(__image__) rpImageNamed(rpRedpacketBundleResource(__image__))

#define rpResourceAtBundle(__bundle__, __resource__) rpString(__bundle__ stringByAppendingPathComponent:__resource__)


/*---------------------------------------
 *  Const
 ---------------------------------------*/

/**
 *  红包名称
 */
static NSString *const rp_redpacketName = @"环信红包";
/**
 *  红包归属
 */
static NSString *const rp_redpacketCompay = @"环信";

/**
 *  红包字体颜色
 */
static uint const rp_textColorGray = 0x9e9e9e;

/**
 *  背景颜色
 */
static uint const rp_backGroundColorGray = 0xe3e3e3;



UIKIT_STATIC_INLINE UIColor * rp_hexColor(uint color)
{
    float r = (color&0xFF0000) >> 16;
    float g = (color&0xFF00) >> 8;
    float b = (color&0xFF);
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

UIKIT_STATIC_INLINE BOOL rp_isEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

#pragma mark - Extern

/**
 * 红包的名字（例如：云红包）
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketOrgName;

/**
 *  红包的祝福语
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketGreeting;

/**
 *  红包接收消息的Cell标记
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketSign;

/**
 *  是否是红包的标记
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketTakenMessageSign;

/**
 *  红包的发送方ID
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketSenderId;

/**
 *  红包的发送方
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketSenderNickname;

/**
 *  红包的接收方ID
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketReceiverId;

/**
 *  红包的接收方
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketReceiverNickname;

/**
 *  红包ID
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedpacketID;

/**
 *  提示收到群红包的 cmd
 */
UIKIT_EXTERN NSString *const RedpacketKeyRedapcketCmd;




