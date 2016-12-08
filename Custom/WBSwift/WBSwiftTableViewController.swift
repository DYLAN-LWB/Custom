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
    var dataArray = NSMutableArray ()
    var tempArray = NSArray ()
    
    let kUrl = "http://shop.51titi.net/showbooks/booklist/uid/3/key/de7f1f42282da6c604a882350909fd94"
    let parameters = [
        "type": 2,
        "p" : 1,
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupTableView()
        
        WBNetwork.shareInstance.request(requestType: .GET, url: kUrl, params: parameters, success: {(responseObj) in
            
            if responseObj?["code"] as? Int == 0 {
                
                self.tempArray = responseObj!["data"]! as! NSArray
                
                for ( _ , value) in self.tempArray.enumerated() {
                    
                    self.dataArray.addObjects(from: [value])
                }
                
                self.myTableView.reloadData()
                
                print("数组个数为:\(self.dataArray.count)")
            }
            
        }) {(error) in
            print(error!)
        }
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
