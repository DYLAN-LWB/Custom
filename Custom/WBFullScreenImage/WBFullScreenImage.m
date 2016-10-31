//
//  WBFullScreenImage.m
//  Dealer
//
//  Created by 李伟宾 on 2016/10/21.
//  Copyright © 2016年 Dealer_lwb. All rights reserved.
//

#import "WBFullScreenImage.h"

@interface WBFullScreenImage () <UIScrollViewDelegate, UIActionSheetDelegate>
{
    UIScrollView    *_bgScrollView;
    UIImageView     *_showImageView;
    UIActionSheet   *_sheet;
}
@end

@implementation WBFullScreenImage

- (instancetype)initWithImageUrl:(NSString *)urlString {
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self setupWithUrlString:urlString image:nil];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self setupWithUrlString:nil image:image];
    }
    return self;
}

- (void)setupWithUrlString:(NSString *)string image:(UIImage *)image {

    _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgScrollView.backgroundColor = [UIColor blackColor];
    _bgScrollView.maximumZoomScale = 3;;
    _bgScrollView.minimumZoomScale = 1;
    _bgScrollView.alpha = 0;
    _bgScrollView.delegate = self;
    [self addSubview:_bgScrollView];
    
    _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0)];
    _showImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgScrollView addSubview:_showImageView];
    
    if (image) {
        _showImageView.image = image;
    } else if (string) {
        
        [_showImageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    [UIView animateWithDuration:.3f animations:^{
        _bgScrollView.alpha = 1;
        _showImageView.frame = [UIScreen mainScreen].bounds;
    }];
    
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_bgScrollView addGestureRecognizer:click];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    [_bgScrollView addGestureRecognizer:longPress];
}

// 返回想要缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _showImageView;
}

// 显示大图
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

// 单击手势
- (void)tap {
    [UIView animateWithDuration:.3f animations:^{
        _bgScrollView.alpha = 0;
        _showImageView.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 长按手势
- (void)longPress {
    
    _sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
    [_sheet showInView:_bgScrollView];
}

// 选项卡
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        // 保存到相册
        UIImageWriteToSavedPhotosAlbum(_showImageView.image, self, nil, nil);
    } else {
        [_sheet dismissWithClickedButtonIndex:1 animated:NO];
    }
}

@end
