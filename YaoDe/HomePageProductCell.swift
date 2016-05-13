//
//  PersonFirstPageProductCell.swift
//  kuaixiaopin
//
//  Created by iosnull on 15/8/12.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

@objc protocol HomePageProductCellDelegate{
    func productAddToShoppingCat(#row:Int)
}

class HomePageProductCell: UITableViewCell {
    
    weak var delegate : HomePageProductCellDelegate?
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var saleNum: UILabel!
    
    
    @IBOutlet weak var huodongImage: UIImageView!
    
    
    var productParam = Product()
    var setProductView:Product{
        set{
            productParam = newValue
            //1.原价或者促销价
            
            price.text = "￥" + newValue.pd_price
            
            
            
            //2.图片
            imageIcon.sd_setImageWithURL(NSURL(string: serversBaseUrlForPicture + "\(newValue.img_url)"))
            shopName.text = "[\(newValue.shop_name)]"
            
            NSLog("newValue.shop_name=\(newValue.shop_name)")
            //3.商品销量
            saleNum.text = "销量：" + newValue.pd_salesvolume
            //4.商品名称
            productName.text = newValue.p_title
            
            
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //
    class func loadFromNib()->HomePageProductCell {
        
        return NSBundle.mainBundle().loadNibNamed("HomePageProductCell", owner: nil, options:nil).last as! HomePageProductCell
    }
    
    deinit{
        NSLog("HomePageProductCell deinit")
    }
    
}
