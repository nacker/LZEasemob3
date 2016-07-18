/*!
 *  \~chinese
 *  @header EMSDK.h
 *  @abstract SDK的头文件
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMSDK.h
 *  @abstract Headers of SDK
 *  @author Hyphenate
 *  @version 3.00
 */

#ifndef EMSDK_h
#define EMSDK_h

#if TARGET_OS_IPHONE

#import "EMClient.h"
#import "EMClientDelegate.h"

#else

#import <HyphenateSDK/EMClient.h>
#import <HyphenateSDK/EMClientDelegate.h>

#endif


#endif /* EMSDK_h */
