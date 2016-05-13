//
//  MyOrderInfoCell.swift
//  
//
//  Created by yd on 16/3/24.
//
//

import UIKit
import SnapKit

class MyOrderInfoCell: UIView {

    var shopName :UILabel!
    var goodsStatus : UILabel!
    var orderNum : UILabel!
    override init (frame:CGRect){
        shopName = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2 - 40, height: 30))
        shopName.text = ""
        goodsStatus = UILabel(frame: CGRect(x: CGRectGetMaxX(shopName.frame) + 10 , y: 0, width: SCREEN_WIDTH/2, height: 30))
        
        orderNum = UILabel(frame: CGRect(x:0 , y: CGRectGetMaxY(shopName.frame) - 5 , width: SCREEN_WIDTH, height: 30))
        orderNum.font = UIFont.systemFontOfSize(13)
        super.init(frame:frame)
        self.addSubview(shopName)
        self.addSubview(goodsStatus)
        self.addSubview(orderNum)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class MyOrderCell : UITableViewCell {
    var img : UIImageView!
    var goodsPrice = UILabel()
    var goodsName = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        img = UIImageView(frame: CGRect(x:0,y:5,width:SCREEN_WIDTH/3 ,height:SCREEN_WIDTH/3))
        self.addSubview(img!)
        
        
        goodsName = UILabel(frame: CGRect(x:img!.frame.maxX,y:5 ,width:SCREEN_WIDTH - SCREEN_WIDTH/3,height:40))
        goodsName.textAlignment = NSTextAlignment.Left
        self.addSubview(goodsName)
        
        
        goodsPrice = UILabel(frame: CGRect(x:img.frame.maxX+10,y:goodsName.frame.maxY+10,width:100,height:40))
        self.addSubview(goodsPrice)
        
        
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyOrderCellFooter : UIView {
    
    var  Pricetext : UILabel!
    var payWayAndNums : UILabel!
    var confirmBtn : UIButton!
    var payMentBtn : UIButton!
    var deleteBtn: UIButton!
    var lookGiftBtn : UIButton!
    
    override init (frame:CGRect){
        
        super.init(frame:frame)
        
        
        
        
        Pricetext = UILabel(frame: CGRect(x: 10, y: 0, width: SCREEN_WIDTH/3, height: 40))
        Pricetext.text = ""
        
        payWayAndNums = UILabel(frame: CGRect(x: CGRectGetMaxX(Pricetext.frame), y: 0, width: SCREEN_WIDTH*(2/3) - 20 , height: 40))
        
        
        deleteBtn = UIButton(frame: CGRect(x:  10 , y: CGRectGetMaxY(Pricetext.frame) + 5, width: SCREEN_WIDTH/3 - 10, height: 30))
        deleteBtn.setTitle("删除", forState: UIControlState.Normal)
        deleteBtn.setTitleColor(UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1), forState: UIControlState.Normal)
        deleteBtn.layer.masksToBounds  = true
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.layer.borderWidth = 0.5
        deleteBtn.layer.borderColor = UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1).CGColor
        //deleteBtn.addTarget(nil, action: Selector("deleteBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        confirmBtn = UIButton(frame: CGRect(x: CGRectGetMaxX(deleteBtn.frame) + 10 , y: CGRectGetMaxY(Pricetext.frame) + 5, width: SCREEN_WIDTH/3 - 10, height: 30))
        confirmBtn.setTitle("签收", forState: UIControlState.Normal)
        confirmBtn.setTitleColor(UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1), forState: UIControlState.Normal)
        confirmBtn.layer.masksToBounds  = true
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.layer.borderWidth = 0.5
        confirmBtn.layer.borderColor = UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1).CGColor
        //confirmBtn.addTarget(nil, action: Selector("confirmBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        payMentBtn = UIButton(frame: CGRect(x: CGRectGetMaxX(confirmBtn.frame) + 10 , y: CGRectGetMaxY(Pricetext.frame) + 5, width: SCREEN_WIDTH/3 - 20, height: 30))
        payMentBtn.setTitle("支付", forState: UIControlState.Normal)
        payMentBtn.setTitleColor(UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1), forState: UIControlState.Normal)
        payMentBtn.layer.masksToBounds  = true
        payMentBtn.layer.cornerRadius = 5
        payMentBtn.layer.borderWidth = 0.5
        payMentBtn.layer.borderColor = UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1).CGColor
        //payMentBtn.addTarget(nil, action: Selector("payMentBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        lookGiftBtn = UIButton()
        lookGiftBtn.setTitle("查看赠品", forState: UIControlState.Normal)
        lookGiftBtn.setTitleColor(UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1), forState: UIControlState.Normal)
        lookGiftBtn.layer.masksToBounds  = true
        lookGiftBtn.layer.cornerRadius = 5
        lookGiftBtn.layer.borderWidth = 0.5
        lookGiftBtn.layer.borderColor = UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1).CGColor
        
        self.addSubview(Pricetext)
        self.addSubview(confirmBtn)
        self.addSubview(payMentBtn)
        self.addSubview(deleteBtn)
        self.addSubview(payWayAndNums)
        self.addSubview(lookGiftBtn)
        
        
        lookGiftBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(10)
            make.right.equalTo(self.snp_right).offset(-10)
            make.top.equalTo(payMentBtn.snp_bottom).offset(5)
            make.height.equalTo(30)
        }
        
        
        
        
        
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
//    //删除订单
//    func deleteBtnClick(sender:UIButton){
//        
//    }
//    
//    //确认收货
//    func confirmBtnClick(sender:UIButton){
//        NSLog("confirmBtnClick")
//    }
//    
//    //支付按钮
//    func payMentBtnClick(sender:UIButton){
//        NSLog("payMentBtnClick")
//    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class segmentClass:UISegmentedControl {
    
    
    
    override init (frame:CGRect){
        
        
        
        
        super.init(frame:frame)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




