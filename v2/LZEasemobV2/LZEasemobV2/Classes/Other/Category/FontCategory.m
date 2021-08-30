//
//  FontCategory.m
//  YSWS-iOS
//
//  Created by nacker on 2020/7/3.
//  Copyright © 2020 nacker. All rights reserved.
//

#import "FontCategory.h"

@implementation FontCategory

@end

@implementation UIButton (MyFont)

//+ (void)load{
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//
//- (id)myInitWithCoder:(NSCoder*)aDecode{
//    [self myInitWithCoder:aDecode];
//    if (self) {
//
//        //部分不想改变字体的 把tag值设置成333跳过
//        if(self.titleLabel.tag != 333){
//            CGFloat fontSize = self.titleLabel.font.pointSize;
//            self.titleLabel.font = [UIFont systemFontOfSize:fontSize * SizeScale];
//        }
//    }
//    return self;
//}
//@end
//
//@implementation UILabel (MyFont)
//
//+ (void)load{
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//
//- (id)myInitWithCoder:(NSCoder*)aDecode{
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不想改变字体的 把tag值设置成333跳过
//        if(self.tag != 333){
//            CGFloat fontSize = self.font.pointSize;
//            self.font = [UIFont systemFontOfSize:fontSize * SizeScale];
//        }
//    }
//    return self;
//}
//@end
//
//@implementation UITextField (MyFont)
//
//+ (void)load{
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//
//- (id)myInitWithCoder:(NSCoder*)aDecode{
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不想改变字体的 把tag值设置成333跳过
//        if(self.tag != 333){
//            CGFloat fontSize = self.font.pointSize;
//            self.font = [UIFont systemFontOfSize:fontSize * SizeScale];
//        }
//    }
//    return self;
//}
//@end
//
//@implementation UITextView (MyFont)
//
//+ (void)load{
//    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(imp, myImp);
//}
//- (id)myInitWithCoder:(NSCoder*)aDecode{
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不想改变字体的 把tag值设置成333跳过
//        if(self.tag != 333){
//            CGFloat fontSize = self.font.pointSize;
//            self.font = [UIFont systemFontOfSize:fontSize * SizeScale];
//        }
//    }
//    return self;
//}

@end
