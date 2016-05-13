//
//  MerchantCell.swift
//  YaoDe
//
//  Created by iosnull on 15/9/11.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage

class MerchantFooterView: UIView {
    var text = UILabel()
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(text)
        
        text.backgroundColor = UIColor.whiteColor()
        text.textColor = UIColor.redColor()
        text.textAlignment = NSTextAlignment.Center
        text.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.top.equalTo(self.snp_top)
            make.height.equalTo(30)
            
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MerchantCell: UITableViewCell {

    
    @IBOutlet var merchantImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var tel: UILabel!
    @IBOutlet var condition: UILabel!
    @IBOutlet var shopImage: UIImageView!
    @IBOutlet var shopName: UILabel!
    
    @IBOutlet var bottomColor: UIView!
    
    var merchantInfo = MerchantInfo()
    var setSubViewPara:MerchantInfo{
        set{
            merchantInfo = newValue
            
//            bottomColor.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            bottomColor.backgroundColor = UIColor.whiteColor()

            shopName.text = newValue.shopname
            
            
            //merchantImage.sd_setImageWithURL(NSURL(string: serversBaseUrlForPicture + newValue.pic))
            NSLog("newValue.pic ==\(newValue.pic)")
            var ImageUrl = serversBaseUrlForPicture + newValue.pic
            NSLog("ImageUrl ==\(ImageUrl)")
            merchantImage.sd_setImageWithURL(NSURL(string: ImageUrl), placeholderImage: UIImage(named: "logo320x320"))
            name.text = newValue.shopname
            tel.text = "联系电话:" + newValue.tel
            address.text = "地址:" + newValue.address
            condition.text = "起配金额:(￥" + "\(newValue.carryingamount)" + "起配送)"
            
            
            
        }
        get{
            return merchantInfo
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
