//
//  ListViewController.m
//  Custom
//
//  Created by 李伟宾 on 2016/10/28.
//  Copyright © 2016年 liweibin. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView     *_tableView;
    NSMutableArray  *_listAM;
    NSInteger       _pageNumber;
}

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupTableView];

    [self setupRefresh];
}

- (void)setupRefresh {
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableView.mj_footer endRefreshing];
        _pageNumber = 1;
        [self getDataWithPageNumber:_pageNumber];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.mj_header endRefreshing];
        [self getDataWithPageNumber:++_pageNumber];
    }];
}

- (void)getDataWithPageNumber:(NSInteger)page {
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"type"]  = @"2";
    dictM[@"p"]     = WBIntegerString(page);
    
    [RequestManager requestWithURLString:TEST1
                              parameters:dictM
                                    type:HttpRequestTypeGet
                                 success:^(id response) {
                                     
                                     if (WBInteger(response[@"code"]) == 0) {
                                         [_listAM addObjectsFromArray:[ListModel mj_objectArrayWithKeyValuesArray:response[@"data"]]];
                                         [_tableView reloadData];
                                     } else {
                                         WBShowToastMessage(response[@"msg"]);
                                     }
                                     
                                     [_tableView.mj_header endRefreshing];
                                     [_tableView.mj_footer endRefreshing];
                                 }
                                 failure:^(NSError *error) {
                                     WBShowToastMessage(ErrorMsg);
                                     [_tableView.mj_header endRefreshing];
                                     [_tableView.mj_footer endRefreshing];
                                 }];
}

#pragma mark - tableview

- (void)setupTableView {
    _listAM = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 66;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listAM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.listModelData = _listAM[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
