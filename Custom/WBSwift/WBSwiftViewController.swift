//
//  WBSwiftViewController.swift
//  Custom
//
//  Created by 李伟宾 on 2016/11/22.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit

class WBSwiftViewController: UIViewController, testDelegate {

    let testView = WBSwiftView.init()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        setupViews()
    }
    
    func setupViews () {
    
        testView.frame = CGRect(x:10, y:111, width:300, height: 222)
        testView.name = "小名";
        testView.userId = 11;
        testView.myDelegate = self
        self.view.addSubview(testView)
    }
    
    func testButtonClick(a: String, b: NSInteger, c:UIButton) {
        print(a)
        print(b)
        print(c.tag);
        
        let subVC = WBSwiftTableViewController()
        self.navigationController?.pushViewController(subVC, animated: true)
        
    }
    
    
    
    
}
