//
//  WBTableViewCell.swift
//  Custom
//
//  Created by 李伟宾 on 2016/12/1.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit

class WBTableViewCell: UITableViewCell {

    public var dict : NSDictionary? {
        didSet {
            if (dict != nil) {
                self.textLabel?.text = dict!["title"] as? String
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        setUpviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpviews() {
        
        
    }
}
