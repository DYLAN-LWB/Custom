//
//  WBTableViewCell.swift
//  Custom
//
//  Created by 李伟宾 on 2016/12/1.
//  Copyright © 2016年 liweibin. All rights reserved.
//

import UIKit

let CellHeight = 66.0

class WBTableViewCell: UITableViewCell {

    var iconImageView = UIImageView()
    var nameLabel = UILabel()
    
    public var dict : NSDictionary? {
        didSet {
            if (dict != nil) {

                self.nameLabel.text = dict!["title"] as? String
                self.iconImageView.setImageWith(NSURL(string :(dict!["titleimg"] as? String)!) as URL!, placeholderImage: UIImage(named:"placeholder.png"))
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
        
        self.iconImageView.frame = CGRect(x: 15, y: 10, width: CellHeight-20, height: CellHeight-20)
        self.addSubview(self.iconImageView)
        
        self.nameLabel.frame = CGRect(x: 88, y: 15, width: 222, height: CellHeight-30)
        self.addSubview(self.nameLabel)

        
    }
}
