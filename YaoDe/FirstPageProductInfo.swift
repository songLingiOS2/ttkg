//
//  FirstPageProductInfo.swift
//  YaoDe
//
//  Created by iosnull on 15/12/7.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit


@objc protocol FirstPageProductInfoDelegate{
    //func productAddToShoppingCat(#row:Int)
    
}

class FirstPageProductInfo: UICollectionViewCell {

    weak var delegate : FirstPageProductInfoDelegate?
    
    @IBOutlet var limitSellCnt: UILabel!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var limitNum: UIImageView!
  
    
    
    @IBOutlet var shopName: UILabel!
    
    
    @IBOutlet var huodongImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var productParam = Product()
    var setProductView:Product{
        set{
            productParam = newValue
            
            price.text = "￥" + newValue.pd_price
            price.font = UIFont.systemFontOfSize(14)
//            //2.图片
            img.sd_setImageWithURL(NSURL(string: serversBaseUrlForPicture + "\(newValue.img_url)"))

            name.text = newValue.p_title

            
            shopName.text = "[" + newValue.shop_name + "]"
            
            
            
            limitSellCnt.text = "已售:" + newValue.pd_salesvolume
            
            
            if newValue.IsGivestate == "0" {
                huodongImage.hidden = false
            }else{
                huodongImage.hidden = true
            }
            
            
            
            
        }
        get{
            return productParam
        }
        
    }

    

}
