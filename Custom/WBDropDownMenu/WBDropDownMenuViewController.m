//
//  WBDropDownMenuViewController.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/26.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "WBDropDownMenuViewController.h"
#import "WBDropDownMenu.h"

@interface WBDropDownMenuViewController () <WBDropDownMenuDelegate>

@property (nonatomic, strong) WBDropDownMenu *dropDownMenu;
@property (nonatomic, strong) NSMutableArray *menuAM;
@property (nonatomic, strong) NSArray *selectedIndexArray;   // 一共5个分类,记录用户选择的每个分类的index

@end

@implementation WBDropDownMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.menuAM = [NSMutableArray arrayWithArray:@[@[],@[],@[],@[],@[]]];
    self.selectedIndexArray = @[@"0", @"0", @"0", @"0", @"0"];  // 默认选择都是0
    
    self.dropDownMenu = [[WBDropDownMenu alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, MENU_HEIGHT)
                                                    menuCount:5
                                                    colorType:1
                                               viewController:self];
    self.dropDownMenu.delegate = self;
    [self.view addSubview:self.dropDownMenu];

}

- (void)getDataWithType:(NSInteger)type {
    NSLog(@"%ld", type);
    
    // 如果有数据就不请求接口
    if ([self.menuAM[type] count] > 0) {
        self.dropDownMenu.dataSource = self.menuAM[type];
        return;
    }
    
    // 根据type判断请求哪个分类接口
    
    // 请求接口,将返回数据添加到数组
    NSArray *array = @[@[@{@"id":@"01", @"name":@"奥数"}, @{@"id":@"02", @"name":@"奥数22"},@{@"id":@"03", @"name":@"奥数333"},
                         @{@"id":@"02", @"name":@"奥数22"},@{@"id":@"03", @"name":@"奥数333"}, @{@"id":@"02", @"name":@"奥数22"},
                         @{@"id":@"03", @"name":@"奥数333"}],
                       @[@{@"id":@"11", @"name":@"奥数"}, @{@"id":@"12", @"name":@"奥数24232"},@{@"id":@"13", @"name":@"奥数3362463"}],
                       @[@{@"id":@"21", @"name":@"奥数"}, @{@"id":@"22", @"name":@"奥22"},@{@"id":@"23", @"name":@"数33"}],
                       @[@{@"id":@"31", @"name":@"奥数"}, @{@"id":@"32", @"name":@"数22"},@{@"id":@"33", @"name":@"奥数33"}],
                       @[@{@"id":@"41", @"name":@"奥数"},@{ @"id":@"42", @"name":@"奥数2"},@{@"id":@"43", @"name":@"奥333"}]];
    
    [self.menuAM replaceObjectAtIndex:type withObject:array[type]];
    
    self.dropDownMenu.dataSource = self.menuAM[type];
}


- (void)didSelectedItemWithValueArray:(NSMutableArray *)valueAM {
    NSLog(@"%@", valueAM);
    
    self.selectedIndexArray = valueAM;
    
    // 请求数据列表接口
}

@end
