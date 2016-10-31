//
//  Common.h
//  Custom
//
//  Created by 李伟宾 on 2016/10/13.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define WBDefaultColor      [UIColor colorWithRed:0.784 green:0.149 blue:0.157 alpha:1.000] // 默认主题颜色


#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#define WBString(str)   [NSString stringWithFormat:@"%@",str]
#define WBInteger(str)  [WBString(str) integerValue]
#define WBFloat(str)    [WBString(str) floatValue]


#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ProgressHUD.h"

#endif /* Common_h */
