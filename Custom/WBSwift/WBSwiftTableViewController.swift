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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        self.dataArray.addObjects(from: ["Copyright", "2016", "liweibin", "All", "rights", "reserved"])
        
        setupTableView()
    
    }


    func setupTableView() {
        
        self.myTableView = UITableView(frame: self.view.frame, style:UITableViewStyle.plain)
        self.myTableView.backgroundColor = UIColor.blue
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.view.addSubview(self.myTableView)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =  UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = self.dataArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let controller = WBSwiftViewController()
        controller.title = self.dataArray[indexPath.row] as? String
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
