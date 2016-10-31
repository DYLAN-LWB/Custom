//
//  WBImageBrowserView.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/28.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "WBImageBrowserView.h"
#import "WBImageBrowserCell.h"
#import "UIImageView+WebCache.h"


@interface WBImageBrowserView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) NSArray           *browserArray;      // 数据源

@property (nonatomic, strong) UIScrollView      *currentScrollView; // 当前scrollview
@property (nonatomic, strong) UIImage           *currentImage;      // 当前图片
@property (nonatomic, assign) NSInteger         currentIndex;       // 当前选中的index

@property (nonatomic, strong) UIView    *topBgView;          // 顶部背景视图
@property (nonatomic, strong) UIButton  *downloadButton;     // 下载按钮
@property (nonatomic, strong) UIButton  *shareButton;        // 分享按钮
@property (nonatomic, strong) UIButton  *backButton;         // 返回
@property (nonatomic, strong) UILabel   *pageLabel;          // 页码
@property (nonatomic, strong) UILabel   *bottomTitleLabel;   // 标题

//@property (nonatomic, strong) ShareView *shareView;          // 分享视图

@end

@implementation WBImageBrowserView



#pragma mark - Instant Methods

+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<WBImageBrowserViewDelegate>)delegate browserInfoArray:(NSArray *)browserInfoArray {
    WBImageBrowserView *imageBrowserView = [[self alloc] initWithFrame:frame];
    imageBrowserView.delegate = delegate;
    imageBrowserView.browserArray = browserInfoArray;
    
    return imageBrowserView;
}

+ (void)clearImagesCache {
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        
        [self addSubview:self.topBgView];
        [self.topBgView addSubview:self.pageLabel];
        [self.topBgView addSubview:self.downloadButton];
        [self.topBgView addSubview:self.shareButton];
        [self.topBgView addSubview:self.backButton];
        
    }
    return self;
}

#pragma mark - 横竖屏时重设frame

- (void)setOrientation:(UIInterfaceOrientation)orientation {

    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.topBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeightForTopView);
    self.pageLabel.frame = CGRectMake(0, 2, SCREEN_WIDTH, HeightForTopView);
    self.backButton.frame = CGRectMake(10, 0, HeightForTopView, HeightForTopView);
    self.downloadButton.frame = CGRectMake(SCREEN_WIDTH - 100, 0, HeightForTopView, HeightForTopView);
    self.shareButton.frame = CGRectMake(SCREEN_WIDTH - 50, 0, HeightForTopView, HeightForTopView);
    
    self.collectionView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(self.currentIndex * SCREEN_WIDTH, 0)];
    
    self.topBgView.hidden = NO;
    self.bottomTitleLabel.hidden = NO;
}

// 横竖屏时需重新设置尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.browserArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WBImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WBImageBrowserCell" forIndexPath:indexPath];
    
    cell.scrollView.delegate = self;
    cell.scrollView.maximumZoomScale = 3.0;
    cell.scrollView.minimumZoomScale = 1;
    cell.scrollView.showsHorizontalScrollIndicator = NO;
    cell.scrollView.showsVerticalScrollIndicator = NO;

    cell.imageView.frame = cell.scrollView.frame;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView setImageWithURL:[NSURL URLWithString:WBString(self.browserArray[indexPath.row][@"img"])]
                   placeholderImage:[UIImage imageNamed:@""]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              self.currentImage = image;
                          }];
    
    // 底部标题
    if (self.bottomTitleLabel) {
        [self.bottomTitleLabel removeFromSuperview];
        self.bottomTitleLabel = nil;
    }
    self.bottomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 35, SCREEN_WIDTH, 35)];
    self.bottomTitleLabel.text = WBString(self.browserArray[indexPath.row][@"subtitle"]);
    
    if([self.bottomTitleLabel.text rangeOfString:@"null"].location != NSNotFound) {
    self.bottomTitleLabel.text = @"这个没写标题";
    }
    self.bottomTitleLabel.textColor = [UIColor whiteColor];
    self.bottomTitleLabel.font = [UIFont systemFontOfSize:14];
    self.bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomTitleLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3];
    self.bottomTitleLabel.hidden = self.topBgView.hidden;
    [cell.contentView addSubview:self.bottomTitleLabel];
    
    // 添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [cell.scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [cell.scrollView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    self.shareButton.enabled = YES;
//    if (self.shareView) {
//        [self.shareView dismissShareView];
//    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    WBImageBrowserCell *cell1 = (WBImageBrowserCell *)cell;
    cell1.scrollView.zoomScale = 1;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 当前显示页数
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.frame.size.width * 0.5) / self.collectionView.frame.size.width;
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu", itemIndex + 1, self.browserArray.count];
    self.currentIndex = itemIndex;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews[0];
}

#pragma mark - 图片缩放相关方法

// 单击手势
- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    
    self.topBgView.hidden = !self.topBgView.hidden;
    self.bottomTitleLabel.hidden = !self.bottomTitleLabel.hidden;
    
//    if (self.shareView) {
//        [self.shareView dismissShareView];
//    }
    self.shareButton.enabled = YES;
}

// 双击手势
- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    
    self.currentScrollView = (UIScrollView *)tap.view;
    CGFloat scale = self.currentScrollView.zoomScale == 1 ? 3 : 1;
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [self.currentScrollView zoomToRect:zoomRect animated:YES];
    
//    if (self.shareView) {
//        [self.shareView dismissShareView];
//    }
    self.shareButton.enabled = YES;
}

// 双击时的中心点
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = self.currentScrollView.frame.size.height / scale;
    zoomRect.size.width  = self.currentScrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark - Setter

- (void)setbrowserArray:(NSArray *)browserArray {
    _browserArray = browserArray;
    self.pageLabel.text = [NSString stringWithFormat:@"1/%lu",browserArray.count];
}

- (void)setStartIndex:(NSInteger)startIndex {
    _currentIndex = startIndex - 1;
    self.pageLabel.text = [NSString stringWithFormat:@"%lu/%lu",startIndex,self.browserArray.count];
    [self.collectionView setContentOffset:CGPointMake((startIndex - 1) * SCREEN_WIDTH, 0)];
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;   // item横向间距
        layout.minimumLineSpacing      = 0;   // item竖向间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"WBImageBrowserCell" bundle:nil] forCellWithReuseIdentifier:@"WBImageBrowserCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightForTopView)];
        _topBgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3];
    }
    return _topBgView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeightForTopView)];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.font = [UIFont systemFontOfSize:14];
    }
    return _pageLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, HeightForTopView, HeightForTopView)];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.frame = CGRectMake(SCREEN_WIDTH - 100, 0, HeightForTopView, HeightForTopView);
        [_downloadButton setImage:[UIImage imageNamed:@"photo_down_btn"] forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(downloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(SCREEN_WIDTH - 50, 0, HeightForTopView, HeightForTopView);
        [_shareButton setImage:[UIImage imageNamed:@"photo_share_btn"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

#pragma mark - 按钮事件

- (void)shareButtonButtonClick {
    self.shareButton.enabled = NO;
//    self.shareView = [[ShareView alloc] initWithTitle:nil content:nil url:nil image:_currentImage viewController:self.viewController];
//    self.shareView.isOnlyImage = YES;
//    self.shareView.delegate = self;
}

- (void)downloadButtonClick {
    UIImageWriteToSavedPhotosAlbum(_currentImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    error ? [ProgressHUD showError:[error description]] : [ProgressHUD showSuccess:@"成功保存到相册"];;
}

- (void)backButtonClick {

    self.alpha = 1.0;
    
//    if (self.shareView) {
//        [self.shareView dismissShareView];
//    }
    self.shareButton.enabled = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        
        // 检查屏幕横竖屏 强制竖屏
        if ([self.delegate respondsToSelector:@selector(WBImageBrowserViewhide)]) {
            [self.delegate WBImageBrowserViewhide];
        }
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
