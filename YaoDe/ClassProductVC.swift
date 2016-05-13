//
//  ClassProductVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/11.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit


struct ClassProductInfo {
    var refreshFlag = FefreshFlag.pullDown
    var pagesize = ""
    var currentpage = ""
    var list = [ProductDetailInfo]()
}

struct ProductDetailInfo {
    var AdminKeyID = ""
    var ProductKeyID = ""
    var title = ""
    var shopname = ""
    var salesvolume = ""
    var pictureURL = ""
    var originalPrice = ""
    var IsGivestate = ""
}


class ClassProductVC: UITableViewController{
    
    var open = false
    var KeyID = ""
    var MerchantPush = false
    var MerchantKeyID = ""
    
    
    var classProductInfo = ClassProductInfo(){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    func setNavigationBarItems(){
        var rightBtn = UIBarButtonItem(title: "分类", style: UIBarButtonItemStyle.Done, target: self, action: Selector("classBtnClk"))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
    }
    
    
    
    //分类类别数据
    var classProduct = ClassProduct()
    
    var http = ShoppingHttpReq.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //注册cell
        tableView.registerNib(UINib(nibName: "HomePageProductCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("pullUpRefresh"))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getClassProducDataReqProcess:"), name: "getClassProducDataReq", object: nil)
        
        
        
        //从商家进入到分类
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getClassProducDataReqProcess:"), name: "getPeiSongShoppingProductsReq", object: nil)
        
        
        selectSubClass(classProduct: classProduct)
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        tableView.tableFooterView = UIView()
    }
    
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //下拉刷新
    func pullDownRefresh(){
        if netIsavalaible {
        classProductInfo.refreshFlag = .pullDown //标记为下拉刷新
        if MerchantPush {
            http.getPeiSongShoppingProducts(adminkeyid: MerchantKeyID, pagesize: "10", currentpage: "1", categoryid: classProduct.keyid)
        }else {
            
            http.getClassProducData(roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: "1", categoryid: KeyID, areaid: currentRoleInfomation.areaid)
        }
        }else{
            netIsEnable("网络不可用")
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    //获取更多
    func pullUpRefresh(){
        if netIsavalaible {
        classProductInfo.refreshFlag = .pullUp //标记为下拉刷新
        
        var Flag = false
        //1、判断当前页面有数据，且是10的倍数
        if ((classProductInfo.list.count) != 0) && (classProductInfo.list.count%10 == 0) {
            Flag = true
        }else{
            Flag = false
        }
        
        //2、确认请求页面是第几页
        if Flag{
            var pageNum = classProductInfo.list.count/10
            
            if MerchantPush {
                http.getPeiSongShoppingProducts(adminkeyid: MerchantKeyID, pagesize: "10", currentpage: (pageNum + 1).description, categoryid: classProduct.keyid)
            }else {
                
                http.getClassProducData(roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: (pageNum + 1).description, categoryid: KeyID, areaid: currentRoleInfomation.areaid)
            }
            
        }else{
            ProgressHUD.showError("没有更多数据了")
            self.tableView.mj_footer.endRefreshing()
        }
        
        }else{
                netIsEnable("网络不可用")
            self.tableView.mj_footer.endRefreshing()
            }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.separatorInset = UIEdgeInsetsZero //设置分割线没有内容边距
        tableView.layoutMargins = UIEdgeInsetsZero //清空默认布局边距
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
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
        return self.classProductInfo.list.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomePageProductCell
        
        cell.tag = indexPath.row
        
        cell.price.text = "￥:" + self.classProductInfo.list[indexPath.row].originalPrice
        cell.shopName.text = self.classProductInfo.list[indexPath.row].shopname
        cell.productName.text = self.classProductInfo.list[indexPath.row].title
        cell.saleNum.text = "销量:" + self.classProductInfo.list[indexPath.row].salesvolume
        cell.saleNum.textColor = UIColor.grayColor()
        cell.imageIcon.sd_setImageWithURL(NSURL(string: serversBaseUrlForPicture + self.classProductInfo.list[indexPath.row].pictureURL))
        
        if self.classProductInfo.list[indexPath.row].IsGivestate == "0" {
            cell.huodongImage.hidden = false
        }else{
            cell.huodongImage.hidden = true
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var shopDetailVC = ShopingDetailVC()
        shopDetailVC.adminkeyid = self.classProductInfo.list[indexPath.row].AdminKeyID
        shopDetailVC.productkeyid = self.classProductInfo.list[indexPath.row].ProductKeyID
        
        shopDetailVC.usertype = currentRoleInfomation.sptypeid
        shopDetailVC.userid = currentRoleInfomation.roleid
        self.navigationController?.pushViewController(shopDetailVC, animated: true)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //清理图片内存
        SDImageCache.sharedImageCache().clearMemory()
    }
    
    
    //商品展示
    func getClassProducDataReqProcess(sender:NSNotification){
        
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            
            
            NSLog("dataTemp = \(dataTemp)")
            var message = dataTemp["message"].stringValue
            if "true" == dataTemp["success"].stringValue{
                NSLog("dataTemp = \(dataTemp)")
                
                
                
                if "2" == dataTemp["status"].stringValue {
                    showMessageAnimate(self.navigationController!.view, message)
                }
                
                
                
                
                var classProductTemp = ClassProductInfo()
                classProductTemp.currentpage = dataTemp["data"]["currentpage"].stringValue
                classProductTemp.pagesize = dataTemp["data"]["pagesize"].stringValue
                var dataArry = dataTemp["data"]["list"]
                
                var lists = [ProductDetailInfo]()
                for(var i = 0 ; i < dataArry.count ; i++) {
                    
                    var dataA = dataArry[i]
                    var product = ProductDetailInfo()
                    
                    //NSLog("dataA = \(dataA)")
                    product.pictureURL = dataA["pictureURL"].stringValue
                    product.originalPrice = dataA["MinPrice"].doubleValue.description
                    product.title = dataA["title"].stringValue
                    product.salesvolume = dataA["salesvolume"].stringValue
                    product.ProductKeyID = dataA["ProductKeyID"].stringValue
                    product.AdminKeyID = dataA["AdminKeyID"].stringValue
                    product.shopname = dataA["shopname"].stringValue
                    product.IsGivestate = dataA["IsGivestate"].stringValue
                    NSLog("product.IsGivestate=\(product.IsGivestate)")
                    NSLog("product.shopname=\(product.shopname)")
                    NSLog("product.ProductKeyID=\(product.ProductKeyID)")
                    NSLog("product.AdminKeyID=\(product.AdminKeyID)")
                    lists.append(product)
                }
                
                
                if self.classProductInfo.refreshFlag == .pullDown {
                    classProductTemp.list = lists
                    self.classProductInfo = classProductTemp
                }else{
                    classProductTemp.list = lists
                    self.classProductInfo.list += lists
                }
                
                
                
            }
            
            
            
        }else{
            ProgressHUD.showError("获取数据失败!!!")
        }
        
    }
    
    
}


extension ClassProductVC{
    
    
    
    
    
    
    
    
    func selectSubClass(#classProduct: ClassProduct) {
        NSLog("classProduct.keyid = \(classProduct.keyid)")
        NSLog("classProduct.keyid = \(KeyID)")
        
        if MerchantPush {
            http.getPeiSongShoppingProducts(adminkeyid: MerchantKeyID, pagesize: "200", currentpage: "1", categoryid: classProduct.keyid)
            
            
            
        }else {
            
            http.getClassProducData(roleid: currentRoleInfomation.roleid, pagesize: "50", currentpage: "1", categoryid: KeyID, areaid: currentRoleInfomation.areaid)
        }
        
    }
    
    
}