//
//  OrderAddressCell.swift
//  YaoDe
//
//  Created by iosnull on 15/9/16.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class OrderAddressCell: UITableViewCell {

    @IBOutlet var address: UILabel!
    @IBOutlet var tel: UILabel!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
