//
//  FontCategory.h
//  YSWS-iOS
//
//  Created by nacker on 2020/7/3.
//  Copyright © 2020 nacker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#define SizeScale 1.2

@interface FontCategory : NSObject
@end

/**
 *  button
 */
@interface UIButton (MyFont)
@end

/**
 *  Label
 */
@interface UILabel (MyFont)
@end

/**
 *  TextField
 */
@interface UITextField (MyFont)
@end

/**
 *  TextView
 */
@interface UITextView (MyFont)

@end

NS_ASSUME_NONNULL_END
