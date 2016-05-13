//
//  SearchVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/9.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class SearchVC: UITableViewController,HomePageProductCellDelegate,UITextFieldDelegate {

    func textFieldDidEndEditing(textField: UITextField) {
        searchBtnClk()
    }
    
    //商家内搜索
    var shopID = ""//商家ID
    var shopInternal = false
    //商品显示
    var shopPush = false
    var productShow:[Product] = [Product]()
    var http = ShoppingHttpReq.sharedInstance
    
    var pagesize = 100
    
  
    
    var searchText =   UITextField()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.separatorInset = UIEdgeInsetsZero //设置分割线没有内容边距
        tableView.layoutMargins = UIEdgeInsetsZero //清空默认布局边距
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 30)
        searchText.placeholder = "请输入要搜索的内容"
        searchText.textAlignment = NSTextAlignment.Center
        searchText.font = UIFont.systemFontOfSize(14)
        searchText.layer.masksToBounds = true
        searchText.layer.borderWidth = 1
        searchText.layer.cornerRadius = 3
        searchText.backgroundColor = UIColor.clearColor()
        //searchText.backgroundColor = UIColor.whiteColor()
        searchText.layer.borderColor = UIColor.whiteColor().CGColor
        searchText.textColor = UIColor.whiteColor()
        
        searchText.delegate = self
        
        self.navigationItem.titleView = searchText
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "搜索", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("searchBtnClk"))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        //注册cell
        tableView.registerNib(UINib(nibName: "HomePageProductCell", bundle: nil), forCellReuseIdentifier: "cell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getProductAccordingToKeyValueReqProcess:"), name: "getProductAccordingToKeyValueReq", object: nil)
        
        //addToShoppingCartUrlReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addToShoppingCartUrlReqProcess:"), name: "addToShoppingCartUrlReqClassProductVC", object: nil)

        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("loadMoreData"))
        
        tableView.tableFooterView = UIView()
    }
    
    /**
    下拉刷新
    */
    func pullDownRefresh(){
        NSLog("下拉刷新100条数据")
        if netIsavalaible {
        if shopInternal{//店内搜索shopID, pagesize: "100", currentpage: "1", keywords: searchText.text)
            http.getProductAccordingToShopIdAndKeyValue(shopID, roleid: currentRoleInfomation.roleid, pagesize: "\(pagesize)", currentpage: "1", keywords: searchText.text)
            
        }else{//全局搜索
            http.getProductAccordingToKeyValue(areaid: currentRoleInfomation.areaid, roleid: currentRoleInfomation.roleid, pagesize: "\(pagesize)", currentpage: "1", keywords: searchText.text)
            
            
        }
        }else{
            netIsEnable("网络不可用")
            tableView.mj_header.endRefreshing()
        }
    }
    /**
    加载更多
    */
    func loadMoreData(){
        if netIsavalaible {
        NSLog("上拉加载更多")
        pagesize += 10
        NSLog("pagesize == \(pagesize)")
        if shopInternal{//店内搜索
            http.getProductAccordingToShopIdAndKeyValue(shopID, roleid: currentRoleInfomation.roleid, pagesize: "\(pagesize)", currentpage: "1", keywords: searchText.text)
            
            
        }else{//全局搜索
            http.getProductAccordingToKeyValue(areaid: currentRoleInfomation.areaid, roleid: currentRoleInfomation.roleid, pagesize: "\(pagesize)", currentpage: "1", keywords: searchText.text)
           
        }
        }else{
            netIsEnable("网络不可用")
            tableView.mj_footer.endRefreshing()
        }
    }
    
    
    func searchBtnClk(){
        NSLog("搜索按钮点击了")
        NSLog("searchText = \(searchText.text)")
        ProgressHUD.show("数据请求中...")
        if shopInternal{//店内搜索
            http.getProductAccordingToShopIdAndKeyValue(shopID, roleid: currentRoleInfomation.roleid, pagesize: "\(pagesize)", currentpage: "1", keywords: searchText.text)
            
        }else{//全局搜索
        http.getProductAccordingToKeyValue(areaid: currentRoleInfomation.areaid, roleid: currentRoleInfomation.roleid, pagesize: "\(pagesize)", currentpage: "1", keywords: searchText.text)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return productShow.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomePageProductCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.delegate = self
        cell.tag = indexPath.row
        cell.setProductView = productShow[indexPath.row]
        if productShow[indexPath.row].IsGivestate == "0" {
            cell.huodongImage.hidden = false
        }else{
            cell.huodongImage.hidden = true
        }
        return cell
    }
    
    
    //添加购物车
    func productAddToShoppingCat(#row: Int) {
        NSLog("你选择的是\(productShow[row].p_title)")
        var usertypeTemp = ""
        if currentRoleInfomation.usertype == "30001" {
            usertypeTemp = "2"//
        }else{
            usertypeTemp = "1"//
        }
        
        //价格判断
        var price = ""
        if productShow[row].p_promotion == "1" {//非促销
            price = productShow[row].pd_price
        }else{
            price = productShow[row].pd_ptprice
        }
        
        
        /**
        *  检测是否动画完成，可以再次提交到购物车
        */
        if canAddToCart == false {
            
            return
            
        }
        canAddToCart = false
        
        http.addToShoppingCart(usertype: usertypeTemp, userid: currentRoleInfomation.keyid, shopid:productShow[row].p_adminid, pdid: productShow[row].pd_keyid, price: price, nums: "1", imgurl: productShow[row].img_url, pdname: productShow[row].p_title,whoAreYou:"ClassProductVC")
        
        productShow[row].haveBeenClk = true
        
        tableView.reloadData()
        
        
        //添加动画
        //开始动画，设置起始坐标
        //CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
        //CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
        
        var indexPath = NSIndexPath(forRow: row, inSection: 0)
        whichRowProductAdd = NSIndexPath(forRow: row, inSection: 0)
        
        NSLog("whichRowProductAdd = \(whichRowProductAdd)")
        
        var rectInTableView:CGRect = tableView.rectForRowAtIndexPath(indexPath)
        var rect = tableView.convertRect(rectInTableView, toView: tableView)
        
        NSLog("rect = \(rect)")
        
        var startY = Int(rect.origin.y)
        NSLog("startY = \(startY)")
        
        setShoppingCartAnimation(45, startY: startY)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! HomePageProductCell
        
        var productImage:UIImage!
        if let img = cell.imageIcon.image {
            productImage = cell.imageIcon.image
        }else{
            productImage = UIImage(named: "园logo-01")
        }
        
        startAnimation(productImage!)

        
    }

    
    /// 动画相关变量和方法
    /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
    var path:UIBezierPath!
    var layer:CALayer!
    
    func groupAnimation(){
        
        var animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.CGPath
        animation.rotationMode = kCAAnimationRotateAuto
        var expandAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        expandAnimation.duration = 0.5
        expandAnimation.fromValue = NSNumber(float: 1.0)
        expandAnimation.toValue = NSNumber(float: 2.0)
        expandAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        var narrowAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        narrowAnimation.beginTime = 0.5
        narrowAnimation.fromValue = NSNumber(float: 2.0)
        narrowAnimation.duration = 0.3
        narrowAnimation.toValue = NSNumber(float: 0.5)
        
        narrowAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        var groups:CAAnimationGroup = CAAnimationGroup()
        groups.animations = [animation,expandAnimation,narrowAnimation]
        groups.duration = 0.8
        groups.removedOnCompletion = false
        groups.fillMode = kCAFillModeForwards
        groups.delegate = self
        layer.addAnimation(groups, forKey: "group")
    }
    
    
    
    
    /// 哪一行商品被点击添加到购物车
    var whichRowProductAdd = NSIndexPath(forRow: 0, inSection: 0)
    var canAddToCart = true //购物车可以再次添加
    //动画停止
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        NSLog("动画停止**************************************")
        
        layer.removeFromSuperlayer()
        canAddToCart = true
        
        var shakeAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        shakeAnimation.duration = 0.25
        shakeAnimation.fromValue = NSNumber(float: -5.0)
        shakeAnimation.toValue = NSNumber(float: 5.0)
        shakeAnimation.autoreverses = true
        
        
        let cell = tableView.cellForRowAtIndexPath(whichRowProductAdd) as! HomePageProductCell
        
        
        
        
        
        
    }
    
    func startAnimation(imageName:UIImage){
        
        layer = CALayer()
        layer!.contents = imageName.CGImage
        layer!.contentsGravity = kCAGravityResizeAspectFill
        layer!.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        layer!.cornerRadius = CGRectGetHeight(layer!.bounds) / 2.0
        layer!.masksToBounds = true
        layer!.position = CGPointMake(20, 150)
        self.view.layer.addSublayer(layer)
        
        
        self.groupAnimation()
        
    }
    
    func setShoppingCartAnimation(startX:Int,startY:Int)
    {
        self.path = UIBezierPath()
        path?.moveToPoint(CGPoint(x: startX, y: startY))  //线段起点
        
        NSLog("动画起点坐标是\(startX), \(startY)")
        //endPoint:曲线的终点  ;controlPoint:画曲线的基准点
        
        var pointX = CGFloat(startX)
        var pointY = CGFloat(startY)
        
        path?.addQuadCurveToPoint(CGPoint(x: SCREEN_WIDTH - 60, y: pointY ), controlPoint: CGPointMake(SCREEN_WIDTH / 2  + 100 , pointY - 200  ))
    }
    
    /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
    
    //加入购物车处理结果
    func addToShoppingCartUrlReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            
            if "100" == dataTemp["result"].stringValue {
                NSLog("加入购物车成功")
                //ProgressHUD.showSuccess("添加成功")
                //更新底部购物车件数显示
                //购物车右上角标签显示
                var usertypeTemp = ""
                if currentRoleInfomation.usertype == "30002" {
                    usertypeTemp = "1"
                }else{
                    usertypeTemp = "2"
                }
                
                http.getShoppingCart(usertype: usertypeTemp, userid: currentRoleInfomation.keyid)
            }
        }else{
            ProgressHUD.showError("添加失败!!!")
        }
    }

    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("你选择是的是\(productShow[indexPath.row].p_title)")
        
        var shopDetailVC = ShopingDetailVC()
        shopDetailVC.adminkeyid = productShow[indexPath.row].p_adminid
        shopDetailVC.productkeyid = productShow[indexPath.row].pd_keyid
        
        shopDetailVC.usertype = currentRoleInfomation.sptypeid
//        shopDetailVC.userid = currentRoleInfomation.roleid
        
        self.navigationController?.pushViewController(shopDetailVC, animated: true)
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //清理图片内存
        SDImageCache.sharedImageCache().clearMemory()
    }

    
    //商品展示
    func getProductAccordingToKeyValueReqProcess(sender:NSNotification){
        
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        ProgressHUD.dismiss()
        productShow = []
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue{
                NSLog("dataTemp = \(dataTemp)")
                
                //var productArry: [Product] = []
                
                var dataArry = dataTemp["data"]["list"]
                productShow = []
                
                for(var i = 0 ; i < dataArry.count ; i++) {
                    var product = Product()
                    var dataA = dataArry[i]
                    
                    //NSLog("dataA = \(dataA)")
                    product.img_url = dataA["pictureURL"].stringValue
                    product.pd_price = dataA["MinPrice"].doubleValue.description
                    product.p_title = dataA["title"].stringValue
                    product.pd_salesvolume = dataA["salesvolume"].stringValue
                    product.pd_keyid = dataA["ProductKeyID"].stringValue
                    product.p_adminid = dataA["AdminKeyID"].stringValue
                    product.shop_name = dataA["shopname"].stringValue
                    product.IsGivestate = dataA["IsGivestate"].stringValue
                    
                    NSLog("product.IsGivestate == \(product.pd_keyid)")
                    NSLog("product.IsGivestate == \(product.IsGivestate)")
                    NSLog("product.IsGivestate == \(product.p_adminid)")
                    
                    
                    productShow.append(product)
                }
                
                
                
                
//                NSLog("\(productShow.count)")
//                if !productShow.isEmpty{
//                    self.tableView.reloadData()
//                    ProgressHUD.showSuccess("数据已经更新!!!")
//                }else{
//                    ProgressHUD.showError("无数据信息!!!")
//                }
                
                
            }else{
                
            }
            showMessageAnimate(self.view, dataTemp["message"].stringValue)
            
        }else{
            //ProgressHUD.showError("获取数据失败!!!")
        }
        self.tableView.reloadData()
    }

}
