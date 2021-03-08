//
//  Color.h
//  TTCF
//
//  Created by nacker on 2020/9/1.
//  Copyright © 2020 nacker. All rights reserved.
//

#ifndef Color_h
#define Color_h

///适配暗黑模式   lightColor：白天模式颜色  darkColor：暗黑模式颜色
//#define KCustomAdjustColor(lightColor, darkColor) [UIColor colorWithLightColor:lightColor DarkColor:darkColor]

#define KCustomAdjustColor(lightColor, darkColor) [UIColor colorWithLightColorStr:lightColor DarkColor:darkColor]

// 背景色
#define KBgWhiteColor KCustomAdjustColor(@"#FFFFFF",@"#FFFFFF")


// 灰色背景
#define KBgGrayColor KCustomAdjustColor(@"#F3F3F3",@"#F3F3F3")





///测试颜色
#define KTestColor [UIColor colorWithLightColorStr:@"000000" DarkColor:@"FFFFFF"]




#endif /* Color_h */
