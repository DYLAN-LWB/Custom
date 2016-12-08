//
//  WBBlockViewController.m
//  Custom
//
//  Created by 李伟宾 on 2016/11/7.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "WBBlockViewController.h"
#import "WBBlockView.h"

@interface WBBlockViewController ()

@end

@implementation WBBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    WBBlockView *view = [[WBBlockView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 200)];
    [self.view addSubview:view];
    
    
    view.type1 = ^() {
    
        NSLog(@"type1");
    };
    
    
    __weak typeof (view)weakView = view;

    view.type2 = ^(NSString *string, NSDictionary *dict) {
    
        NSLog(@"%@", string);
        NSLog(@"%@", dict[@"id"]);
        
        weakView.backgroundColor = [UIColor lightGrayColor];
        self.view.backgroundColor = [UIColor greenColor];
    };

    view.IsParameterNoReturned2 = ^(NSString *string) {
        NSLog(@"%@", string);
    };
    
  


}


@end
