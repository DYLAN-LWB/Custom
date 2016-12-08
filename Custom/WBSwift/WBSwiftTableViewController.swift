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
    
    let kUrl = "http://shop.51titi.net/showbooks/booklist/uid/3/key/de7f1f42282da6c604a882350909fd94"
    let parameters = [
        "type": 2,
        "p" : 1,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        
        setupTableView()
        
        WBNetwork.shareInstance.request(requestType: .GET, url: kUrl, params: parameters, success: {(responseObj) in
            
            print(responseObj!["code"]!)
            print(responseObj!["msg"]!)

            if responseObj?["code"] as? Int == 0 {
                
                print(responseObj!["data"]!)

                self.dataArray.addObjects(from: [responseObj!["data"]!])
                

                self.myTableView.reloadData()
                
                print(self.dataArray)

            }
            
            
        }) {(error) in
            print(error!)
        }
    }

    

    
    func setupTableView() {
        
        self.myTableView = UITableView(frame: self.view.frame, style:UITableViewStyle.plain)
        self.myTableView.backgroundColor = UIColor.blue
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.dict = self.dataArray[indexPath.row] as? NSDictionary
//        cell.textLabel?.text = "dfaf"
//        print(self.dataArray[indexPath.row])

        print(indexPath.row)

        
//        print(cell.dict!)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let controller = WBSwiftViewController()
//        controller.title = self.dataArray[indexPath.row]["title"] as? String
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
