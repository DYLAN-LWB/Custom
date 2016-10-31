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

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"菜单";
    self.view.backgroundColor = [UIColor whiteColor];

    

     self.menuArray = @[@"WBAlertView",  @"WBFullScreenImage", @"WBDropDownMenu", @"WBImageBrowser", @"WBPickerView", @"WBShareView",@"WBModel"];
     
     self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
     self.tableView.delegate = self;
     self.tableView.dataSource = self;
     [self.view addSubview:self.tableView];

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
    
    UIViewController *subViewController;
    
    switch (indexPath.row) {
        case 0: {
            subViewController = [[WBAlertViewController alloc] init];
        }
            break;
        case 1: {
            subViewController = [[WBFullScreenImageViewController alloc] init];
        }
            break;
        case 2: {
            subViewController = [[WBDropDownMenuViewController alloc] init];
        }
            break;
        case 3: {
            subViewController = [[WBImageBrowserViewController alloc] init];
        }
            break;
        case 4: {

        }
            break;
        case 5: {

        }
            break;
        case 6: {
            subViewController = [[ListViewController alloc] init];
        }
            break;
        default:
            break;
    }
    
    subViewController.title = self.menuArray[indexPath.row];
    [self.navigationController pushViewController:subViewController animated:YES];
    
}




@end
