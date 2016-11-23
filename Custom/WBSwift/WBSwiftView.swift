//
//  WBSwiftView.swift
//  Custom
//
//  Created by 李伟宾 on 2016/11/22.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit

protocol testDelegate: NSObjectProtocol {
    func testButtonClick(a:String, b:NSInteger, c:UIButton)
}

class WBSwiftView: UIView {

    // 普通变量,主要delegate要加weak
    weak var myDelegate : testDelegate?
    let label = UILabel.init()
    let button = UIButton(type:.custom)
    
    // 需要在父类重新赋值的变量
    public var name : String? {
        didSet {
            print("name = " + name!)
        }
    }
    
    public var userId : NSInteger? {
        didSet {
            print("userId = " + String(userId!))
            
            label.text = String(userId!) + name! + "Copyright © 2016年 liweibin. All rights reserved."
        }
    }
       
    
    override init (frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        setupSubViews()
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        label.frame =  CGRect(x: 33, y: 22, width: 222, height: 66)
        label.backgroundColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        self.addSubview(label)
        
        button.frame = CGRect(x: 55, y: 100, width: 166, height: 66)
        button.setTitle("this is a button", for: UIControlState.normal)
        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
        button.backgroundColor = UIColor.darkGray
        button.tag = 9
        button.addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchUpInside)
        self.addSubview(button)
    }

    func buttonClick (sender: UIButton) {
        print("click on the button")
        
        self.myDelegate?.testButtonClick(a:"111", b:333, c:sender)
    }
    
    
}
