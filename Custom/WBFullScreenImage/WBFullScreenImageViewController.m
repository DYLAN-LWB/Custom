//
//  WBFullScreenImageViewController.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/26.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "WBFullScreenImageViewController.h"
#import "WBFullScreenImage.h"

@interface WBFullScreenImageViewController ()

@end

@implementation WBFullScreenImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(111, 111, 111, 111)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"test"];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [imageView addGestureRecognizer:tap];
    
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(111, 333, 111, 111)];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.userInteractionEnabled = YES;
    imageView2.image = [UIImage imageNamed:@"test"];
    [self.view addSubview:imageView2];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    [imageView2 addGestureRecognizer:tap2];
}

- (void)tap {
    
    WBFullScreenImage *fullImage = [[WBFullScreenImage alloc] initWithImage:[UIImage imageNamed:@"test"]];
    [fullImage show];
    
    // 上传图片
//    FileModel *file = [[FileModel alloc] init];
//    file.fileData = UIImageJPEGRepresentation([UIImage imageNamed:@"test"], 0.7);
//    file.name = @"服务器给的图片名称";
//    [RequestManager uploadWithURLString:@"上传图片的接口地址"
//                             parameters:nil
//                               progress:^(NSProgress *progress) {
//                               }
//                            uploadParam:file
//                                success:^(id response) {
//                                }
//                                failure:^(NSError *error) {
//                                }];
}


- (void)tap2 {
    
    WBFullScreenImage *fullImage = [[WBFullScreenImage alloc] initWithImageUrl:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1477445804&di=10f68c4eccafff580f45804d6b09de29&src=http://ent.iyaxin.com/attachement/jpg/site2/20100722/0019667873730db20b262b.jpg"];
    [fullImage show];
}

@end
