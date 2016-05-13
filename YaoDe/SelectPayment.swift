//
//  SelectPayment.swift
//  YaoDe
//
//  Created by iosnull on 15/9/16.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class SelectPayment: UITableViewCell {

    
    @IBOutlet var SelectPaymentImage: UIImageView!
    
    @IBOutlet var SelectPaymentName: UILabel!
    
    
    @IBOutlet var selectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
