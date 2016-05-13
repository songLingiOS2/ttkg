//
//  OrderHeaderView.swift
//  YaoDe
//
//  Created by iosnull on 15/9/12.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
@objc protocol OrderHeaderViewDelegate{
   func selectHeaderBtn(#num:Int)
}

class OrderHeaderView: UIView {

    var delegate:OrderHeaderViewDelegate?
    
    @IBAction func selectCurrentBtnClk(sender: UIButton) {
        NSLog("选中当前第\(self.tag)个商家")
        delegate?.selectHeaderBtn(num: self.tag)
    }
    @IBOutlet var selectCurrentBtn: UIButton!
    @IBOutlet var orderState: UILabel!
    @IBOutlet var name: UILabel!
    
    
    var selectedBtnState = false{
        didSet{
            if selectedBtnState {
                selectCurrentBtn.setImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
            }else{
                selectCurrentBtn.setImage(UIImage(named: "che_nor"), forState: UIControlState.Normal)
            }
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
