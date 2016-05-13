//
//  MerchantDetailCell.swift
//
//
//  Created by yd on 16/3/22.
//
//

import UIKit


class PromotionCell:UITableViewCell {
    var img = UIImageView()
    var name = UILabel()
    var nowPrice = UILabel()
    var oldPrice = UILabel()
    var sellCnt = UILabel()
    var shopName = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(img)
        self.addSubview(name)
        self.addSubview(nowPrice)
        self.addSubview(oldPrice)
        self.addSubview(sellCnt)
        self.addSubview(shopName)
        
        
        img.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.width.equalTo(screenWith/3)
            make.height.equalTo(screenWith/3)
            make.top.equalTo(5)
        }
        
        name.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(img.snp_right).offset(10)
            make.right.equalTo(self.snp_right).offset(-10)
            make.height.equalTo(35)
            make.top.equalTo(6)
        }
        
        nowPrice.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(img.snp_right).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(img.snp_centerY)
            
        }
        
        oldPrice.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nowPrice.snp_right).offset(2)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(img.snp_centerY)
        }
        
        sellCnt.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(img.snp_right).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.bottom.equalTo(img.snp_bottom).offset(-5)
        }
        
        shopName.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(sellCnt.snp_right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(img.snp_bottom).offset(-5)
        }
        
        
        nowPrice.textColor = UIColor.redColor()
        oldPrice.textColor = UIColor.grayColor()
        oldPrice.font = UIFont.systemFontOfSize(13)
        shopName.textColor = UIColor.grayColor()
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class MerchantDetailCell: UITableViewCell {
    
    
    var img : UIImageView!
    var goodsPrice = UILabel()
    var discountPrice = UILabel()
    var goodsName = UILabel()
    var shopName = UILabel()
    var goodsSaleNum = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        img = UIImageView(frame: CGRect(x:0,y:5,width:SCREEN_WIDTH/3 ,height:SCREEN_WIDTH/3))
        self.addSubview(img!)
        
        
        goodsName = UILabel(frame: CGRect(x:img!.frame.maxX,y:5 ,width:SCREEN_WIDTH - SCREEN_WIDTH/3,height:40))
        goodsName.textAlignment = NSTextAlignment.Left
        self.addSubview(goodsName)
        
        
        goodsPrice = UILabel(frame: CGRect(x:img.frame.maxX+10,y:goodsName.frame.maxY+10,width:100,height:40))
        self.addSubview(goodsPrice)
        
        discountPrice = UILabel(frame: CGRect(x:goodsPrice.frame.maxX,y:goodsName.frame.maxY + 10,width:100,height:40))
        
        discountPrice.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        self.addSubview(discountPrice)
        
        goodsSaleNum = UILabel(frame: CGRect(x:discountPrice.frame.maxX+10,y:goodsName.frame.maxY+10,width:100 ,height:40))
        self.addSubview(goodsSaleNum)
        
        shopName = UILabel(frame: CGRect(x:img.frame.maxX+10,y:goodsPrice.frame.maxY+10,width:100,height:40))
        shopName.textColor = UIColor.grayColor()
        self.addSubview(shopName)
        
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
