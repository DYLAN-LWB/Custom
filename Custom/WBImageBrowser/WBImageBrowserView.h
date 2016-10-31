//
//  WBImageBrowserView.h
//  Custom
//
//  Created by 李伟宾 on 2016/10/28.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HeightForTopView 45

@protocol WBImageBrowserViewDelegate <NSObject>

- (void)WBImageBrowserViewhide;

@end

@interface WBImageBrowserView : UIView


/** 图片开始的索引 */
@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, assign) id<WBImageBrowserViewDelegate> delegate;


/** 屏幕方向 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;

/** 用到的 */
@property (nonatomic, strong) UIViewController *viewController;


/**
 *  网络图片初始化方式
 */
+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<WBImageBrowserViewDelegate>)delegate browserInfoArray:(NSArray *)browserInfoArray;


/**
 *  清除图片缓存
 */
+ (void)clearImagesCache;

/**
 *  显示在父视图
 */
- (void)showInView:(UIView *)view;

@end
