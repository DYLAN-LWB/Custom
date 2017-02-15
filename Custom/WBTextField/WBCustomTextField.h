//
//  WBCustomTextField.H
//  ProgressBar
//
//  Created by 李伟宾 on 2017/2/15.
//  Copyright © 2017年 liweibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBCustomTextField : UITextField
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholderText;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
