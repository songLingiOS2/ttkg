//
//  MenuView.swift
//  DZMenu
//
//  Created by duzhe on 15/10/8.
//  Copyright © 2015年 duzhe. All rights reserved.
//

import UIKit
let kSCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let kSCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height


protocol MenuViewDelegate{
    func clickButton(index:Int)
}

class MenuView: UIScrollView {
    
    var titleArray = [String]() {
        didSet{
            addSubViewFrame(self.frame)
        }
    }
    let padding:CGFloat = 15
    var buttonWidth:CGFloat = 0
    //var buttonWidth =
    var blueLine : UIView?
    var menudDelegate:MenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        //addSubViewFrame(frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func addSubViewFrame(frame: CGRect) {
        //定义按钮宽度
        buttonWidth = frame.width/4
        //确定scrollview内容宽度
        self.contentSize = CGSizeMake(CGFloat(titleArray.count)*buttonWidth, frame.height)
        //添加按钮
        for i in 0..<titleArray.count {
            let button = UIButton(frame: CGRectMake((CGFloat(Float(i)))*buttonWidth, 0, buttonWidth, frame.height))
            button.titleLabel?.font = UIFont.systemFontOfSize(16)
            button.setTitle(titleArray[i], forState: UIControlState.Normal)
            button.tag = 100 + i
            button.setTitleColor(UIColor(red: 52/255, green: 61/255, blue: 0x6B/255, alpha: 1.0) , forState: UIControlState.Normal)
            
            if i == 0{
                button.setTitleColor(UIColor(red: 0xF5/255, green: 91/255, blue: 59/255, alpha: 1.0) , forState: UIControlState.Normal)
            }
            button.addTarget(self, action: "clickButton:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
        }
        
        //底部下划线背景
        let lineView = UIView(frame: CGRectMake(0, frame.height - 0.5, self.contentSize.width, 0.5))
        lineView.backgroundColor = UIColor(red: 0xC6/255, green: 0xC5/255, blue: 0xB3/255, alpha: 1.0)
        self.addSubview(lineView)
        
        //底部下划线
        let blueView = UIView(frame: CGRectMake(5, frame.height - 1, buttonWidth - 10, 1))
        blueView.backgroundColor = UIColor(red: 0xF5/255, green: 91/255, blue: 59/255, alpha: 1.0)
        self.blueLine = blueView
        self.addSubview(blueView)
    }
    
    //按钮点击事件
    func clickButton(sender: UIButton) {
        
        
        
        NSLog("sender.tag ==\(sender.tag)")
        let index = sender.tag - 100
        //1、设置所有按钮的标题颜色
        for subView in (self.subviews) {
            if subView.isKindOfClass(UIButton) {//子视图判断
                let button : UIButton = (subView as? UIButton)!
                button.setTitleColor(UIColor(red: 52/255, green: 61/255, blue: 0x6B/255, alpha: 1.0) , forState: UIControlState.Normal)
            }
        }
        
        
        UIView.animateWithDuration(0.2) { () -> Void in
            //下划线滚动的对应的被点击按钮下方
            self.blueLine?.frame = CGRectMake(5 + ((self.blueLine?.frame.width)! + 10) * CGFloat(Float(index)), (self.blueLine?.frame.origin.y)!, (self.blueLine?.frame.width)!, (self.blueLine?.frame.height)!)
            //设置被点击按钮的标题颜色
            sender.setTitleColor(UIColor(red: 0xF5/255, green: 91/255, blue: 59/255, alpha: 1.0) , forState: UIControlState.Normal)
        }
        self.menudDelegate?.clickButton(index)
        
        setScrollViewOffset(sender, view: superview!)
    }
    
    
    func setScrollViewOffset(button:UIButton,view:UIView){
        let index : CGFloat = CGFloat(button.tag - 100)
        
        if true{//可选解包
            //将像素menuView.blueLine?.frame.origin在menuView视图转换到当前view中，返回在当前view中的像素值
            var p = self.convertPoint((self.blueLine?.frame.origin)!, toView: view)
            
            if index<CGFloat(self.titleArray.count-2) && p.x > view.bounds.width/2 + 15{
                p.x = self.buttonWidth
                var p2 =  view.convertPoint(p, toView: self)
                p2.y = 0
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.contentOffset = p2
                }
            }else if index>CGFloat(2) && p.x < view.bounds.width/2 - 40{
                p.x = -self.buttonWidth
                var p2 =  view.convertPoint(p, toView: self)
                p2.y = 0
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.contentOffset = p2
                }
            }
            
            if index <= 2 {
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.contentOffset = CGPoint(x: 0, y: 0)
                }
            }
            if index>=CGFloat(self.titleArray.count-2) {
                UIView.animateWithDuration(0.2) { () -> Void in
                    self.contentOffset = CGPoint(x: self.contentSize.width-kSCREEN_WIDTH , y: 0)
                }
            }
        }
    }
}







