//
//  WBSwiftTableViewController.swift
//  Custom
//
//  Created by 李伟宾 on 2016/11/25.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit

class WBSwiftTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    var dataArray = NSMutableArray()
    var tempArray = NSArray()
    var pageNumber = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupTableView()
        
        setupRefreshAndLoad()
    }
    
    func setupRefreshAndLoad() {

        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.tableView.mj_footer.endRefreshing()
            self.pageNumber = 1
            self.getDataWithPage(page: self.pageNumber)
        })
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.tableView.mj_header.endRefreshing()
            self.pageNumber += 1
            self.getDataWithPage(page: self.pageNumber)
        })
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    func getDataWithPage(page : NSInteger) {
    
        // 参数字典
        let parameters = ["type" : 2, "p" : page]
        
        WBNetwork.shareInstance.request(requestType: .GET, url: port1, params: parameters, success: {(responseObj) in
            print(responseObj!)
            
            if responseObj?["code"] as? Int == 0 {
                
                if page == 1 && self.dataArray.count > 0 {
                    self.dataArray.removeAllObjects()
                }
                
                self.tempArray = responseObj!["data"]! as! NSArray
                for ( _ , value) in self.tempArray.enumerated() {
                    self.dataArray.addObjects(from: [value])
                }
                
                self.tableView.reloadData()
            }
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
        }) {(error) in
            print(error!)
        }
   
    }
    
    func setupTableView() {
        
        self.tableView = UITableView(frame: self.view.frame, style:UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.register(WBTableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        
        //        for view in (cell?.contentView.subviews)! as [UIView] {
        //            if view.tag == 8989 {
        //                for subView in view.subviews {
        //                    if let textField = subView as? UITextField {
        //                        textField.text = String(NSInteger(textField.text!)! + (type == 1 ? 1 : -1))
        //                        self.numValueChanged(textField: textField)
        //                    }
        //                }
        //            }
        //        }
    }

    
}
