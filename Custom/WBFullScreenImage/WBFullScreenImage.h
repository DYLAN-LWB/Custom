//
//  WBFullScreenImage.h
//  Dealer
//
//  Created by 李伟宾 on 2016/10/21.
//  Copyright © 2016年 Dealer_lwb. All rights reserved.
//
//  点击查看大图,长按大图保存到相册

#import <UIKit/UIKit.h>

@interface WBFullScreenImage : UIView 

/** 
 初始化显示带url的大图
 */
- (instancetype)initWithImageUrl:(NSString *)urlString;

/** 
 初始化直接显示imageview的image
 */
- (instancetype)initWithImage:(UIImage *)image;

/** 
 显示大图
 */
- (void)show;

@end
