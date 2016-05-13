//
//  NavigationLeftView.swift
//  YaoDe
//
//  Created by iosnull on 15/9/1.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

protocol NavigationLeftViewDelegate{
    func locationBtnClk()
    func searchBtnClk()
    func scanBtnClk()
}

class NavigationLeftView: UIView {
    var delegate:NavigationLeftViewDelegate?
    
    
    @IBAction func scanBtnClk(sender: UIButton) {
        NSLog("扫一扫")
        delegate?.scanBtnClk()
    }
    
    
    @IBOutlet var location: UILabel!
    @IBAction func locationBtnClk(sender: AnyObject) {
        
        delegate?.locationBtnClk()
    }

    @IBAction func searchBtnClk(sender: AnyObject) {
        
        delegate?.searchBtnClk()
    }
    @IBOutlet var searchBtn: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    class func loadFromNib()->NavigationLeftView {
        
        return NSBundle.mainBundle().loadNibNamed("NavigationLeftView", owner: nil, options:nil).last as! NavigationLeftView
    }
    
    deinit{
        NSLog("NavigationLeftView deinit")
    }
}
