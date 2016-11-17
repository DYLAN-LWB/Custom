//
//  WBBlockView.h
//  Custom
//
//  Created by 李伟宾 on 2016/11/7.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBBlockView : UIView

// 无参数 无返回值
typedef void(^NoParameterNoReturned)();

// 有参数 无返回值
typedef void(^IsParameterNoReturned)(NSString *, NSDictionary *);

// 有参数 有返回值
typedef NSString *(^IsParameterIsReturned)(NSString *);

@property (nonatomic, copy) NoParameterNoReturned type1;

@property (nonatomic, copy) IsParameterNoReturned type2;
@property (nonatomic, copy) void(^IsParameterNoReturned2)(NSString *);  // 直接定义

@property (nonatomic, copy) IsParameterIsReturned type3;

@end
