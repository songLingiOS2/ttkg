//
//  SelectView.swift
//  YaoDe
//
//  Created by iosnull on 16/4/1.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit

protocol SelectViewDelegate{
    func numofBtnClk(title:String)
}


class SelectView: UIView {

    var delegate:SelectViewDelegate?
    
    var showFlag = false {
        didSet{
            if showFlag{
                bottomLine.backgroundColor = UIColor(red: 255/255, green: 74/255, blue: 101/255, alpha: 1)
                title.textColor = UIColor(red: 255/255, green: 74/255, blue: 101/255, alpha: 1)
            }else{
                bottomLine.backgroundColor = UIColor.clearColor()
                title.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
            }
        }
    }
    
    var titleName:String = ""{
        didSet{
            title.text = titleName
        }
    }
    
    private var btn = UIButton()
    private var title = UILabel()
    private var bottomLine = UIView()
    override  init(frame:CGRect){
        super.init(frame:frame)
        
        
        title.frame = CGRect(x: 0, y: 0, width: 60, height: 34)
        bottomLine.frame = CGRect(x: 0, y: 34, width: 60, height: 2)
        btn.frame = title.frame
        
        self.addSubview(btn)
        self.addSubview(title)
        self.addSubview(bottomLine)
        
        btn.addTarget(self, action: Selector("btnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        title.textColor = UIColor.redColor()
        title.textAlignment = NSTextAlignment.Center
        
        
    }

    //按钮点击
    func btnClk(){
        
        self.delegate?.numofBtnClk(title.text!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



protocol SelectContainerViewDelegate{
    func selectName(name:String,num:Int)
}
class SelectContainerView: UIScrollView,SelectViewDelegate {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    var selectDelegate:SelectContainerViewDelegate?
    
    var selectViewArry = [SelectView]()
    
    func creatSelectBtn(title:[String]){
        if title.count != 0 {
            let width = 80
            self.contentSize = CGSize(width: width*title.count, height: 44)
            selectViewArry = []
            
            for var i = 0 ; i < title.count ;i++ {
                var selectView = SelectView()
                var num = CGFloat(i)
                selectView.frame = CGRect(x: 80*i, y: 0, width: 60, height: 44)
                
                selectView.titleName = title[i]
                NSLog("titleName = \(title[i])")
                selectView.delegate = self
                
                if i == 0 {
                    selectView.showFlag = true //默认选中第一个
                }else{
                    selectView.showFlag = false
                }
                
                selectViewArry.append(selectView)
                
                self.addSubview(selectView)
            }
            
            
        }else{
            NSLog("creatSelectBtnFalse")
        }
        
    }
    
    
    func numofBtnClk(title:String){
        
        for var i = 0 ; i < selectViewArry.count; i++  {
            if title == selectViewArry[i].titleName {
                NSLog("selectViewArry[\(i)].frame = \(selectViewArry[i].frame.origin.x)")
                
                
                selectViewArry[i].showFlag = true
                selectDelegate?.selectName(title, num: i)
            }else{
                selectViewArry[i].showFlag = false
            }
        }
        
        
    }
}






