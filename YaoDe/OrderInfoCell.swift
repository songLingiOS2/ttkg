//
//  OrderInfoCell.swift
//  YaoDe
//
//  Created by iosnull on 15/9/12.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class OrderInfoCell: UITableViewCell {

    @IBOutlet var productImage: UIImageView!
    @IBOutlet var nums: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var name: UILabel!
    
    @IBOutlet var freeProductInfo: UILabel!
    
    var orderInfo = OrderDetail()
    var setOrderInfo:OrderDetail{
        set{
            orderInfo = newValue
            var imageUrl = serversBaseUrlForPicture + newValue.imgurl
            productImage.sd_setImageWithURL(NSURL(string:imageUrl ))
            nums.text = "x" + newValue.num
            
            
            
            price.text = "￥:" + newValue.price
            name.text = newValue.pname
            if newValue.detail_remark != "" {
                freeProductInfo.text = newValue.detail_remark
            }else{
                freeProductInfo.text = ""
            }
                
                
            
        }
        get{
            return orderInfo
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
