//
//  WBImageBrowserViewController.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/28.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "WBImageBrowserViewController.h"
#import "WBImageBrowserView.h"

@interface WBImageBrowserViewController () <WBImageBrowserViewDelegate>
{
    NSMutableArray *_imageAM;
    WBImageBrowserView *_imageBrowserView;
}
@end

@implementation WBImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _imageAM = [NSMutableArray array];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(111, 111, 111, 111)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"test"];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [imageView addGestureRecognizer:tap];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"sbid"]  = @"5";
    
    [RequestManager requestWithURLString:TEST2
                              parameters:dictM
                                    type:HttpRequestTypeGet
                                 success:^(id response) {
                                     if ([response[@"code"] integerValue] == 0) {
                                         [_imageAM addObjectsFromArray:response[@"data"][0][@"content"]];
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     WBShowToastMessage(ErrorMsg);
                                 }];
}

- (void)tap {
    [WBImageBrowserView clearImagesCache];
    
    _imageBrowserView= [WBImageBrowserView pictureBrowsweViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                       delegate:self
                                                               browserInfoArray:_imageAM];
    
    _imageBrowserView.orientation = self.preferredInterfaceOrientationForPresentation;
    _imageBrowserView.viewController = self;
    _imageBrowserView.startIndex = 3;  //开始索引
    [_imageBrowserView showInView:[UIApplication sharedApplication].keyWindow];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

// 取消浏览大图时
- (void)WBImageBrowserViewhide {
    
    // 检查屏幕横竖屏 强制竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *num = [[NSNumber alloc] initWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationPortrait ;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat newVcH;
    CGFloat newVcW;
    
    if (UIInterfaceOrientationIsLandscape(self.preferredInterfaceOrientationForPresentation)) {
        // 横屏
        newVcH = self.view.frame.size.width;
        newVcW = self.view.frame.size.height;
    } else { // 竖屏
        newVcH = self.view.frame.size.height;
        newVcW = self.view.frame.size.width ;
    }
    
    self.view.bounds = CGRectMake(0, 0, newVcW, newVcH);
    _imageBrowserView.orientation = self.preferredInterfaceOrientationForPresentation;
    
}
@end
