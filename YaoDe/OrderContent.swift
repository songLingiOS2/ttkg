//
//  OrderContent.swift
//  YaoDe
//
//  Created by iosnull on 15/9/16.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class OrderContent: UITableViewCell {

    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    
    @IBOutlet var nums: UILabel!
    
    
    var detailProductValue = ShoppingCartProduct()
    var detailProduct:ShoppingCartProduct{
        set{
            detailProductValue = newValue
            productImage.sd_setImageWithURL(NSURL(string:serversBaseUrlForPicture + newValue.imgurl ))
            name.text = newValue.pdname
            price.text = "￥:" + newValue.price
            nums.text = "x" + newValue.nums
        }
        get{
            return detailProductValue
    
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
