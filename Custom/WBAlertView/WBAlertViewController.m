//
//  WBAlertViewController.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/13.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "WBAlertViewController.h"
#import "WBAlertView.h"

@interface WBAlertViewController () <UITableViewDelegate, UITableViewDataSource, WBAlertViewDelegate>
{
    WBAlertView *customAlert;
}
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WBAlertViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.typeArray = @[@"普通的弹窗", @"动画进度", @"toast提醒", @"自定义视图", @"页面没有数据时的占位图"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.typeArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        WBAlertView *alert = [[WBAlertView alloc] initWithTitle:@"提示"
                                                        message:@"可以设置1或者2个按钮,自适应高度,UI修改方便"
                                              cancelButtonTitle:@"取消"
                                             confirmButtonTitle:@"确定"];
        alert.delegate = self;
        [alert show];
        
    } else if (indexPath.row == 1) {
        
        WBAlertView *alert = [[WBAlertView alloc] initWithProgressOfTitle:@"换图片时修改数组个数"];
        [alert show];
        
    } else if (indexPath.row == 2) {
        
        [WBAlertView showMessageToast:@"可以修改toast位置"
                               toView:self.view];
        
    } else if (indexPath.row == 3) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 222, 222)];
        button.backgroundColor = [UIColor redColor];
        button.titleLabel.numberOfLines = 0;
        [button setTitle:@"可以自定义视图,并且可以选择显示或者隐藏确定/取消按钮(这是个按钮,点击关闭)" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        customAlert = [[WBAlertView alloc] init];
        customAlert.contentView = button;
        customAlert.hideButton = YES;
        [customAlert show];
        
    } else if (indexPath.row == 4) {
        
        [WBAlertView showNoDataImageToastToView:self.view];
    }
}

- (void)cancelButtonClickedOnAlertView:(WBAlertView *)alertView {
    NSLog(@"cancelButtonClickedOnAlertView");
}

- (void)confirmButtonClickedOnAlertView:(WBAlertView *)alertView {
    NSLog(@"confirmButtonClickedOnAlertView");
}

- (void)buttonClick:(UIButton *)button {
    [customAlert dismiss];
}


@end
