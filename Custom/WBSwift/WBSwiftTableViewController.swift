//
//  WBSwiftTableViewController.swift
//  Custom
//
//  Created by 李伟宾 on 2016/11/25.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit

class WBSwiftTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var myTableView = UITableView()
    var dataArray = NSMutableArray()
    var tempArray = NSArray()
    var pageNumber = 1
    
    var refreshControl:ZJRefreshControl!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupTableView()
        setupRefreshAndLoad()
        
        //首次进入页面加载数据
        self.getDataWithPage(page: self.pageNumber)
    }
    
    func setupRefreshAndLoad() {
        
        refreshControl = ZJRefreshControl(scrollView: self.myTableView,refreshBlock: {
            self.pageNumber = 1
            self.getDataWithPage(page: self.pageNumber)
        },loadmoreBlock: {
            self.pageNumber += 1
            self.getDataWithPage(page: self.pageNumber)
        });
        refreshControl.setTopOffset(-64);
    }
    
    func getDataWithPage(page : NSInteger) {
    
        // 参数字典
        let parameters = ["type" : 2, "p" : page]
        
        WBNetwork.shareInstance.request(requestType: .GET, url: port1, params: parameters, success: {(responseObj) in
            
            if responseObj?["code"] as? Int == 0 {
                
                if page == 1 && self.dataArray.count > 0 {
                    self.dataArray.removeAllObjects()
                }
                
                self.tempArray = responseObj!["data"]! as! NSArray
                for ( _ , value) in self.tempArray.enumerated() {
                    self.dataArray.addObjects(from: [value])
                }
                
                self.myTableView.reloadData()
            }
            
        }) {(error) in print(error!) }
        
        self.refreshControl.endRefreshing();
        self.refreshControl.endLoadingmore();
    }
    
    func setupTableView() {
        
        self.myTableView = UITableView(frame: self.view.frame, style:UITableViewStyle.plain)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.view.addSubview(self.myTableView)
        self.myTableView.register(WBTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(CellHeight)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:WBTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? WBTableViewCell)!
        cell.dict = self.dataArray[indexPath.row] as? NSDictionary
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let controller = WBSwiftViewController()
        controller.title = (self.dataArray[indexPath.row] as! NSDictionary)["title"] as? String
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
}
