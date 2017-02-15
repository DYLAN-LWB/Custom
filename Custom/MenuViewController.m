//
//  MenuViewController.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/13.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "MenuViewController.h"
#import "WBAlertViewController.h"
#import "WBFullScreenImageViewController.h"
#import "WBDropDownMenuViewController.h"
#import "WBImageBrowserViewController.h"
#import "ListViewController.h"
#import "WBBlockViewController.h"

#import "WBAlertView.h"

#import "WBCustomTextField.h"

#import "Custom-Swift.h"

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"菜单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];

    self.menuArray = @[@"WBAlertView",  @"WBFullScreenImage", @"WBDropDownMenu", @"WBImageBrowser", @"WBPickerView", @"WBShareView",@"WBModel",@"WBBlock",@"WBSwift"];
     
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    NSLog(@"--%@", [self.navigationController class]);
    NSLog(@"333");
    
    
    WBCustomTextField *customTextField = [[WBCustomTextField alloc] initWithFrame:CGRectMake(100, 150, 222, 35)];
    customTextField.tintColor = [UIColor redColor];
    customTextField.placeholderText = @"占位字";
    customTextField.placeholderColor = [UIColor blueColor];
    customTextField.backgroundColor = [UIColor lightGrayColor];
    customTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    customTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:customTextField];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = self.menuArray[indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *sub;
    
    switch (indexPath.row) {
        case 0: {
            WBAlertViewController *subViewController = [[WBAlertViewController alloc] init];
            sub = subViewController;
        }
            break;
        case 1: {
            WBFullScreenImageViewController *subViewController = [[WBFullScreenImageViewController alloc] init];
            sub = subViewController;
        }
            break;
        case 2: {
            WBDropDownMenuViewController *subViewController = [[WBDropDownMenuViewController alloc] init];
            sub = subViewController;
        }
            break;
        case 3: {
            WBImageBrowserViewController *subViewController = [[WBImageBrowserViewController alloc] init];
            sub = subViewController;
        }
            break;
        case 4: {

        }
            break;
        case 5: {

        }
            break;
        case 6: {
            ListViewController *subViewController = [[ListViewController alloc] init];
            sub = subViewController;
        }
            break;
        case 7: {
            WBBlockViewController *subViewController = [[WBBlockViewController alloc] init];
            sub = subViewController;
        }
            break;
        case 8: {

            WBSwiftTableViewController *subViewController = [[WBSwiftTableViewController alloc] init];
            subViewController.title = @"Swift-Test";
            sub = subViewController;

        }
            break;

        default:
            break;
    }
    
    sub.title = self.menuArray[indexPath.row];
    [self.navigationController pushViewController:sub animated:YES];
    
}




@end
