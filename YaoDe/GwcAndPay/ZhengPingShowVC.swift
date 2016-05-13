//
//  ZhengPingShowVC.swift
//  TTKG_
//
//  Created by iosnull on 16/5/11.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class ZhenPingHeader:UIView {
    //商家名称
    var shangJiaName = UILabel()
    //商家活动
    var shangJiaHuoDong = UILabel()
    
    var leftImg = UIView()
    var rightImg = UIView()
    var lineView = UIView()
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(shangJiaName)
        shangJiaName.font = UIFont.systemFontOfSize(13)
        shangJiaName.textAlignment = NSTextAlignment.Center
        shangJiaName.textColor = UIColor.whiteColor()
        shangJiaName.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(2)
            make.width.equalTo(80)
            make.top.equalTo(self.snp_top).offset(3)
            make.height.equalTo(21)
        }
        
        self.addSubview(shangJiaHuoDong)
        shangJiaHuoDong.font = UIFont.systemFontOfSize(13)
        shangJiaHuoDong.textColor = UIColor.whiteColor()
        shangJiaHuoDong.numberOfLines = 0
        shangJiaHuoDong.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(shangJiaName.snp_right).offset(2)
            make.right.equalTo(self.snp_right).offset(-2)
            make.top.equalTo(shangJiaName.snp_top)
            make.height.equalTo(self.snp_height).offset(6)
        }
        
        
        
        
        self.addSubview(leftImg)
        self.addSubview(rightImg)
        
        self.addSubview(lineView)
        lineView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(2)
            make.right.equalTo(self.snp_right).offset(-2)
            make.top.equalTo(self.snp_top)
            make.height.equalTo(2)
        }
        
        lineView.backgroundColor = UIColor.whiteColor()
        
            leftImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(2)
            make.width.equalTo(2)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
            }
        
            rightImg.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp_right).offset(-2)
            make.width.equalTo(2)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
            }
        
            rightImg.backgroundColor = UIColor.whiteColor()
            leftImg.backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

class ZhenPing: UIView {

        var lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(lineView)
        lineView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(2)
            make.right.equalTo(self.snp_right).offset(-2)
            make.top.equalTo(self.snp_top)
            make.height.equalTo(2)
        }
        
        lineView.backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ZhenPingCell: UITableViewCell {
    var zhengPingInfo = UILabel()
    var leftImg = UIView()
    var rightImg = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(zhengPingInfo)
        self.addSubview(leftImg)
        self.addSubview(rightImg)
        zhengPingInfo.numberOfLines = 0
        zhengPingInfo.font = UIFont.systemFontOfSize(13)
        zhengPingInfo.textColor = UIColor.whiteColor()
        zhengPingInfo.textAlignment = NSTextAlignment.Left
        zhengPingInfo.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(8)
            make.right.equalTo(self.snp_right).offset(-8)
            make.top.equalTo(self.snp_top).offset(2)
            make.height.equalTo(self.snp_height).offset(-2)
        }
        
        leftImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(2)
            make.width.equalTo(2)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        rightImg.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.snp_right).offset(-2)
            make.width.equalTo(2)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        rightImg.backgroundColor = UIColor.whiteColor()
        leftImg.backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ZhengPingShowDelegate {
    func afirmOrder()
}

class ZhengPingShowVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var zengPingModel = ZengpinInfoModel()
    
    
    
    
    var delegate:ZhengPingShowDelegate?
    
    //背景图片
    var backGroundImg = UIImageView()
    //半透明
    var backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWith, height: screenHeight))
    //小喇叭
    var xiaoLaBaImg = UIImageView()
    var zhengPingInfo = UILabel()
    //容器view
    var backGroundView = UIView()
    //容器img
    var backGroundViewImg = UIImageView()
    //退出当前页面按钮
    var disMissBtn = UIButton()
    //赠送商品信息tableView
    var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableViewStyle.Grouped)
    //确认提交按钮
    var affirmOrderBtn = UIButton()
    
    
    /****************************************************/
    
    func layoutSubView(){
        backGroundImg.frame = self.view.frame
        //backGroundImg.backgroundColor = UIColor.redColor()
        
        backGroundView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.top.equalTo(self.view.snp_top).offset(120)
            make.bottom.equalTo(self.view.snp_bottom).offset(-80)
        }
        //backGroundView.backgroundColor = UIColor.yellowColor()
        
        backGroundViewImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_left).offset(30)
            make.right.equalTo(self.view.snp_right).offset(-30)
            make.top.equalTo(self.view.snp_top).offset(120)
            make.bottom.equalTo(self.view.snp_bottom).offset(-80)
        }
        
        NSLog("backGroundViewImg = \(backGroundViewImg.frame)")
        backGroundViewImg.image = UIImage(named: "huoDongBackgroundImg")
        backGroundViewImg.layer.cornerRadius = 15
        
        xiaoLaBaImg.image = UIImage(named: "喇叭400*200")
        //xiaoLaBaImg.backgroundColor = UIColor.brownColor()
        
        xiaoLaBaImg.snp_makeConstraints { (make) -> Void in
            
            make.bottom.equalTo(self.backGroundView.snp_top).offset(20)
            make.centerX.equalTo(self.backGroundView.snp_centerX)
            
            make.left.equalTo(self.backGroundView.snp_left).offset(25)
            make.right.equalTo(self.backGroundView.snp_right).offset(-25)
            make.height.equalTo((screenWith - 110 )/2)
            
            
        }
        
        zhengPingInfo.snp_makeConstraints { (make) -> Void in
            
            make.bottom.equalTo(self.xiaoLaBaImg.snp_bottom).offset(-15)

            make.left.equalTo(self.xiaoLaBaImg.snp_left).offset(18)
            make.right.equalTo(self.xiaoLaBaImg.snp_right).offset(-25)
            make.height.equalTo(21)
            
        }
        zhengPingInfo.text = "赠品信息"
        zhengPingInfo.textColor = UIColor.whiteColor()
        zhengPingInfo.font = UIFont.systemFontOfSize(15)
        
        
        
        affirmOrderBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(backGroundView.snp_left).offset(20)
            make.right.equalTo(backGroundView.snp_right).offset(-20)
            make.height.equalTo(32)
            make.bottom.equalTo(backGroundView.snp_bottom).offset(-24)
        }
        
        
        
        NSLog("affirmOrderBtn = \(affirmOrderBtn.frame)")
        
        affirmOrderBtn.setBackgroundImage(UIImage(named: "buttonAfirm"), forState: UIControlState.Normal)
        affirmOrderBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        affirmOrderBtn.setTitle("确认提交", forState: UIControlState.Normal)
        affirmOrderBtn.addTarget(self, action: Selector("affirmOrderBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(affirmOrderBtn.snp_left)
            make.right.equalTo(affirmOrderBtn.snp_right)
            make.top.equalTo(xiaoLaBaImg.snp_bottom)
            make.bottom.equalTo(affirmOrderBtn.snp_top).offset(-8)
            
        }

        
        disMissBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(xiaoLaBaImg.snp_right).offset(10)
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.bottom.equalTo(xiaoLaBaImg.snp_top).offset(60)
        }
        disMissBtn.setImage(UIImage(named: "dismissImg"), forState: UIControlState.Normal)
        //disMissBtn.backgroundColor = UIColor.redColor()
        NSLog("disMissBtn = \(disMissBtn.frame)")
        
        //disMissBtn.setBackgroundImage(UIImage(named: "dismissImg"), forState: UIControlState.Normal)
        disMissBtn.addTarget(self, action: Selector("dismissVC"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setSubView(){
        
        self.view.addSubview(backGroundImg)
        
        self.view.addSubview(backView)
        backView.backgroundColor = UIColor.grayColor()
        backView.alpha = 0.98
        
        self.view.addSubview(backGroundView)
        self.view.addSubview(xiaoLaBaImg)
        xiaoLaBaImg.addSubview(zhengPingInfo)
        
        self.backGroundView.addSubview(backGroundViewImg)
        
        self.view.addSubview(affirmOrderBtn)
        
        self.view.addSubview(disMissBtn)
        self.view.addSubview(tableView)
        

        
    }

    func dismissVC(){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
    }
    
    //
    func affirmOrderBtnClk(){
        NSLog("确认信息")
        self.delegate?.afirmOrder()
        dismissVC()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSubView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.backgroundColor = UIColor.clearColor()
        layoutSubView()
        
        self.tableView.registerClass(ZhenPingCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.scrollEnabled = true
        
        
    }

    override func viewDidAppear(animated: Bool) {
        NSLog("tableView.frame = \(tableView.frame)")
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /***************************************************/
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return zengPingModel.data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return zengPingModel.data[section].cartList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var shangPingHuoDong =  zengPingModel.returnGiftCellInfo(indexPath)
        
        var w = tableView.frame.width - 16
        NSLog("w = \(w)")
        var rect = getTextRectSize(shangPingHuoDong, font: UIFont.systemFontOfSize(13), size: CGSize(width:w , height: 200.0))
        
        NSLog("rect.height = \(rect.height)  say = \(shangPingHuoDong)")
        return rect.height + 8
        
        //return 40
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let zhenPingHeader = ZhenPingHeader()
        zhenPingHeader.shangJiaName.text = zengPingModel.data[section].shopName
        zhenPingHeader.shangJiaHuoDong.text = zengPingModel.data[section].GiveMsg
        return zhenPingHeader
    }
    
    
    func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        var attributes = [NSFontAttributeName: font]
        var option = NSStringDrawingOptions.UsesLineFragmentOrigin
        var rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        //        println("rect:\(rect)");
        return rect;
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var shangjiaHuoDong = zengPingModel.data[section].GiveMsg
        
        var w = tableView.frame.width - 86.0
        NSLog("w = \(w)")
        var rect = getTextRectSize(shangjiaHuoDong, font: UIFont.systemFontOfSize(13), size: CGSize(width:w , height: 200.0))
        
        
        return rect.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ZhenPingCell
        cell.zhengPingInfo.text = zengPingModel.returnGiftCellInfo(indexPath)//"你买了我们家5瓶习酒，我们送你1瓶王老吉"
        //cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lineFooter = ZhenPing()
        return lineFooter
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
