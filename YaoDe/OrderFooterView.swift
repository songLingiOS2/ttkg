//
//  OrderFooterView.swift
//  YaoDe
//
//  Created by iosnull on 15/9/12.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

@objc protocol OrderFooterViewDelegate{
    func footerViewBtnClk(#actionName:String,whichSection:Int)
}

import UIKit

class OrderFooterView: UIView {

    weak var delegate:OrderFooterViewDelegate?
    
    @IBOutlet var nums: UILabel!
    @IBOutlet var allPrice: UILabel!
    @IBOutlet var actualPrice: UILabel!
    
    @IBOutlet var rightBtn: UIButton!
    @IBOutlet var midBtn: UIButton!
    @IBOutlet var leftBtn: UIButton!
    
    @IBOutlet var confirmBtn: UIButton!
    
    
    
    @IBAction func leftBtnClk(sender: UIButton) {
        
        delegate?.footerViewBtnClk(actionName: sender.currentTitle!, whichSection: self.tag)
        
    }
    @IBAction func midBtnClk(sender: UIButton) {
       
        delegate?.footerViewBtnClk(actionName: sender.currentTitle!, whichSection: self.tag)
        
    }
    @IBAction func rightBtnClk(sender: UIButton) {
        
        delegate?.footerViewBtnClk(actionName: sender.currentTitle!, whichSection: self.tag)
    }
    
    
    @IBAction func confirmBtnClk(sender: UIButton) {
        delegate?.footerViewBtnClk(actionName: sender.currentTitle!, whichSection: self.tag)
    }

    
    //订单简介
    var orderInfo = OrderInfo()
    //订单下所有商品详情
    var orderDetail = [OrderDetail]()

    var setOrderDetail:[OrderDetail]{
        set{
            nums.text = "共" + newValue.count.description  + "件商品"

            setBtnPara(rightBtn)
            setBtnPara(midBtn)
            setBtnPara(leftBtn)
            setBtnPara(confirmBtn)
        }
        get{
            return orderDetail
        }
            
    }
    

    
    func setBtnPara(btn:UIButton){
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor(red: 38/255, green: 168/255, blue: 231/255, alpha: 1 ).CGColor
    }

    
    var orderStatus = "" {//订单状态
        didSet{
            
            hiddinButton()//隐藏按钮显示
            
            setParaFromOrderState(orderStatus: orderStatus)
        }
    }
    var allProductPrice = "" {
        didSet{
            allPrice.text = "总计" + allProductPrice + "元"
        }
    }
    
    var actualProductsPrice = "" {
        didSet{
            actualPrice.text = "   ￥" + actualProductsPrice + "元"
        }
    }
        
    
    //通过订单状态改变view的显示
    func setParaFromOrderState(#orderStatus:String){
        switch(orderStatus){
//        case "已支付":
//            rightBtn.setTitle("删除订单", forState: UIControlState.Normal)
//            rightBtn.hidden = false
        case "未支付":
            rightBtn.setTitle("付款", forState: UIControlState.Normal)
            midBtn.setTitle("取消订单", forState: UIControlState.Normal)
            rightBtn.hidden = false
            midBtn.hidden = false
            
        case "交易关闭":
            rightBtn.setTitle("删除订单", forState: UIControlState.Normal)
            rightBtn.hidden = false

        case "赊呗付款(配送中)":
            confirmBtn.setTitle("签收", forState: UIControlState.Normal)
            confirmBtn.hidden = false
            
        default:
            break
        }
    }
    
    //查看是否有赠送的商品
    func havePresent(yesOrNo:Bool){
        leftBtn.setTitle("查看赠品", forState: UIControlState.Normal)
        if yesOrNo == true {
            leftBtn.hidden = false
        }else{
            leftBtn.hidden = true
        }
    }
    
    //查看是否有赠送的商品
    func havePresent(yesOrNo:Bool,remark:String){
        if yesOrNo == true {
            leftBtn.setTitle("留言信息", forState: UIControlState.Normal)
            leftBtn.hidden = false
        }else{
            leftBtn.hidden = true
        }
    }
    
    func hiddinButton(){
        rightBtn.hidden = true
        midBtn.hidden = true
        //leftBtn.hidden = true
        confirmBtn.hidden = true
    }
    
    
    
}
