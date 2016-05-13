//
//  FirstBuyDiscountCell.swift
//  YaoDe
//
//  Created by iosnull on 16/1/19.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit

class FirstBuyDiscountCell: UITableViewCell {
    


    @IBOutlet var info: UILabel!

    @IBOutlet var price: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    
    var productParam = Product()
    var setProductView:Product{
        
        set{
            NSLog("newValue = \(newValue)")
            info.text = newValue.p_title
            price.text = "￥:" + newValue.pd_ptprice
            img.sd_setImageWithURL(NSURL(string:newValue.img_url ))
        }
        get{
            return productParam
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
