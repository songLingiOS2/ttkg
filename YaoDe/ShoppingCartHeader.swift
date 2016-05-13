//
//  ForShoppingCartHeader.swift
//  YaoDe
//
//  Created by iosnull on 15/9/6.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

@objc protocol ShoppingCartHeaderDelegate{
    func selectShoppingAllProducts(#section:Int)
}

class ShoppingCartHeader: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate:ShoppingCartHeaderDelegate?
    
    @IBAction func selectBtnClk(sender: UIButton) {
        NSLog("选中了该商家所有添加在购物车中的商品 当前是第\(self.tag)section")
        self.delegate?.selectShoppingAllProducts(section: self.tag)
    }
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var merchantBrief: UILabel!
    class func loadFromNib()->ShoppingCartHeader {
        
        return NSBundle.mainBundle().loadNibNamed("ShoppingCartHeader", owner: nil, options:nil).last as! ShoppingCartHeader
    }

    deinit{
        NSLog("ShoppingCartHeader deinit")
    }

}
