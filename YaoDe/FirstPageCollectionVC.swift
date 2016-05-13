//
//  FirstPageCollectionVC.swift
//  YaoDe
//
//  Created by iosnull on 15/12/3.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit

let reuseIdentifier = "FirstPageProductInfo"

class FirstPageCollectionVC: UICollectionViewController,UICollectionViewDelegateFlowLayout ,NavigationLeftViewDelegate,SelectAreaVCDelegate,FirstPageProductInfoDelegate,RecipeCollectionHeaderViewDelegate{
    
    var currentPages = 1
    var pagesize = 3
    
    
    
    
    
    
    
    
    
    var http = ShoppingHttpReq.sharedInstance
    //首页商品显示
    var productShow:[Product] = [Product]()
    var classProductArry = [ClassProduct]()
    //广告
    var shoppingAdArry = [ShoppingAD]()
    var moreBtnClassModel = NSMutableArray()
    
    
    var titleView = NavigationLeftView.loadFromNib()
    var currentLocation:UIBarButtonItem!
    func setNavigation(){
        
        titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 30)
        
        titleView.delegate = self
        
        titleView.backgroundColor = UIColor.clearColor()
        
        titleView.searchBtn.layer.masksToBounds = true
        titleView.searchBtn.layer.borderWidth = 0.5
        titleView.searchBtn.layer.cornerRadius = 3
        titleView.searchBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.navigationItem.titleView = titleView
        
        //右边条形码扫描
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "saoma"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("scanBtnClk"))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "zuobiao"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("selectAddress"))
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        setNavigationBar()
    }
    
    func selectAddress(){
        NSLog("地址选择")
        //用户名称是苏老板的手机号 18302567589
        if currentRoleInfomation.adminid == "18302567589" ||  currentRoleInfomation.adminid == "18908502495" || currentRoleInfomation.adminid == "18798812521"{
            var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
            selectAreaVC.delegate = self
            self.navigationController?.pushViewController(selectAreaVC, animated: true)
            
        }
        
    }
    
    func selectCountryIs(name: String, area: String) {
        currentRoleInfomation.areaid = area
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: name, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("selectAddress"))
        
        http.getShoppingAdvertisement(currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid)
        http.getClassProduct("0", whoAreYou: "FirstPageCollectionVC")
        http.userProductList(areaid: currentRoleInfomation.areaid, currentpage: "", pagesize: "", roleid: currentRoleInfomation.roleid)
        
    }
    
    func setNavigationBar(){
       
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
         self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //隐藏毛玻璃效果
        //self.navigationController?.navigationBar.translucent = false
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        setNavigation()
        
        self.view.backgroundColor = UIColor.grayColor()
        
        //注册cell
        self.collectionView!.registerNib(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userProductListReqProcess:"), name: "userProductListReqtt", object: nil)
        
        
        collectionView?.backgroundView = UIView()
        collectionView?.backgroundView?.backgroundColor = UIColor.whiteColor()
        
        
        //注册一个cell
        collectionView?.registerClass(RecipeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        self.collectionView?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("pullUpRefresh"))
        
        //通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getClassProductReqProcess:"), name: "getClassProductReqFirstPageCollectionVC", object: nil)
        
        //广告
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getShoppingAdvertisementReqProcess:"), name: "getShoppingAdvertisementReq", object: nil)
        
        //广告点击通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("firstPageAdvertiseBtnClkProcess:"), name: "FirstPageAdvertiseBtnClk", object: nil)
        
        //添加到购物车
        //addToShoppingCartUrlReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addToShoppingCartUrlReqProcess:"), name: "addToShoppingCartUrlReqFirstPageCollectionVC", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getMoreClassProductFirstGetMoreMessageBtnProcess:"), name: "getMoreClassProductFirstGetMoreMessageBtn", object: nil)
        
        //
        http.getShoppingAdvertisement(currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid)
        http.getClassProduct("0", whoAreYou: "FirstPageCollectionVC")
        NSLog(" areaid = \(currentRoleInfomation.areaid)  roleid =\(currentRoleInfomation.roleid) ")
        http.getMoreClassProduct(whoAreYou: "FirstGetMoreMessageBtn")
        http.userProductList(areaid: currentRoleInfomation.areaid, currentpage: "\(currentPages)", pagesize: "\(pagesize)", roleid: currentRoleInfomation.roleid)
        
    }
    
    func pullDownRefresh(){
        if netIsavalaible {
        pagesize = 10
        http.userProductList(areaid: currentRoleInfomation.areaid, currentpage: "\(currentPages)", pagesize: "\(pagesize)", roleid: currentRoleInfomation.roleid)
        http.getShoppingAdvertisement(currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid)
        
        NSLog("下拉刷新")
        }else{
            netIsEnable("网络不可用")
            self.collectionView?.mj_header.endRefreshing()
        }
    }
    
    func pullUpRefresh(){
        
        if netIsavalaible {
        pagesize += 3
        http.userProductList(areaid: currentRoleInfomation.areaid, currentpage: "\(currentPages)", pagesize: "\(pagesize)", roleid: currentRoleInfomation.roleid)
        
        NSLog("上拉加载 currentPages = \(currentPages)")
            
        }else{
            netIsEnable("网络不可用")
            self.collectionView?.mj_footer.endRefreshing()
            
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    

    //去限时购页面
    func limitTimeAdClk(){
        
        NSLog("去promotion页面")
        var promotionInfoVC = PromotionInfoVC()
        promotionInfoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(promotionInfoVC, animated: false)
    
    }
    
    func goLotteryBtnClk(){//抽奖
        NSLog("goLotteryBtnClk(){//抽奖")
        
    }
    func goNewUsrBuyBtnClk(){//新用户一元买
        NSLog("goNewUsrBuyBtnClk(){//新用户一元买")
        var firstBuyDiscountVC = UIStoryboard(name: "FirstBuyDiscountVC", bundle: nil).instantiateViewControllerWithIdentifier("FirstBuyDiscountVC") as! FirstBuyDiscountVC
        
        firstBuyDiscountVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(firstBuyDiscountVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return productShow.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FirstPageProductInfo
        
        cell.delegate = self
        
        cell.layer.cornerRadius = 1.0;
        cell.layer.borderColor =  UIColor.grayColor().CGColor
        cell.layer.borderWidth = 0.5;
        cell.layer.masksToBounds = true
        
        cell.setProductView = productShow[indexPath.row]
        
        
        return cell
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        NSLog("你点击了\(productShow[indexPath.row].p_title)")

        
        
        var shopDetailVC = ShopingDetailVC()
        shopDetailVC.adminkeyid = productShow[indexPath.row].p_adminid
        shopDetailVC.productkeyid = productShow[indexPath.row].pd_keyid
        
        shopDetailVC.usertype = currentRoleInfomation.sptypeid
        shopDetailVC.userid = currentRoleInfomation.keyid
        shopDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(shopDetailVC, animated:false)
    }
    
    
    //cell宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let screenWith = UIScreen.mainScreen().bounds.width
        
        var cgsize =  CGSize(width: screenWith/2 - 16, height: screenWith/2 + 50 )
        
        return cgsize
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 发生内存警告的时候  清理图片内存
        SDImageCache.sharedImageCache().clearMemory()
        
    }
    
    
    /**
    collection表头
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        /// 获取表头的高
        var cgsize =  CGSize(width: screenWith, height: screenWith*(3/2 ) )
        
        return cgsize
        
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        /// collection 布局间距
        var edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return edge
    }
    
    
    
    var headerView:RecipeCollectionHeaderView!
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
        NSLog("修改collectionview页眉")
        
        headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headView", forIndexPath: indexPath) as! RecipeCollectionHeaderView
        
        headerView.sortArry = classProductArry
        headerView.shoppingAdArry = self.shoppingAdArry
        NSLog("headerView.shoppingAdArry = \(headerView.shoppingAdArry)" )
        headerView.refresh = true
        
        headerView.delegate = self
        
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
        

        
}

    
    //分类按钮展示
    func getClassProductReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("分类按钮展示 dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue{
                
                NSLog("获取到分类产品展示数据")
                
                classProductArry = []
                
                var classProductData = dataTemp["data"]
                var classProductTemp = ClassProduct()
                for(var cnt = 0 ; cnt < classProductData.count ; cnt++ ){
                    var data  = classProductData[cnt]
                    classProductTemp.picurl = data["picurl"].stringValue

                    classProductTemp.title = data["title"].stringValue
                    classProductTemp.keyid = data["KeyID"].stringValue

                    NSLog("classProductTemp = \(classProductTemp)")
                    classProductArry.append(classProductTemp)
                }
               
                self.collectionView?.reloadData()
            }
        }
        
    }
    
    //广告数据获取处理
    func getShoppingAdvertisementReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("广告获取成功dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue {
                
                NSLog("广告获取成功")

                shoppingAdArry = []
                var data = dataTemp["data"]
                var shopAdTemp = ShoppingAD()
                for(var cnt = 0 ; cnt < data.count ; cnt++ ){
                    var ad = data[cnt]
                    shopAdTemp.adminid = ad["adminid"].stringValue
                    //shopAdTemp.enable = ad["enable"].stringValue
                    shopAdTemp.picurl = ad["picurl"].stringValue
                    shopAdTemp.keyid = ad["KeyID"].stringValue
                    //shopAdTemp.display = ad["display"].stringValue
                    shopAdTemp.endtime = ad["endtime"].stringValue
                    shopAdTemp.starttime = ad["starttime"].stringValue
                    //shopAdTemp.creattime = ad["creattime"].stringValue
                    //shopAdTemp.limit = ad["limit"].stringValue
                    shopAdTemp.title = ad["title"].stringValue
                    //shopAdTemp.face = ad["face"].stringValue
                    shopAdTemp.remark = ad["remark"].stringValue
                    shoppingAdArry.append(shopAdTemp)
                    NSLog("shoppingAdArry = \(shoppingAdArry)")
                }
            }
            self.collectionView?.reloadData()
        }
        
    }
    
    /**
    广告点击响应处理
    
    - parameter sender: FirstPageAdvertiseBtnClk
    */
    func firstPageAdvertiseBtnClkProcess(sender:NSNotification){
        NSLog("广告通知收到，马上进行处理")
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = sender.object! as! Int
            NSLog("你点击了第 = \(dataTemp)张广告")
            
            var discountProductVC =  ADProductVC()
            discountProductVC.adShowString = shoppingAdArry
            discountProductVC.adnum = dataTemp
            discountProductVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discountProductVC, animated: true)
            
            
        }
        
    }
    
    //商品展示
    func userProductListReqProcess(sender:NSNotification){
        
        self.collectionView?.mj_header.endRefreshing()
        self.collectionView?.mj_footer.endRefreshing()
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            var message = dataTemp["message"].stringValue
            var productArry: [Product] = []
            
            
            
            
            if "true" == dataTemp["success"].stringValue{
                NSLog("dataTemp = \(dataTemp)")
                
                
                
                var dataArry = dataTemp["data"]["list"]
                NSLog("dataArry = \(dataArry)")
                
                for(var i = 0 ; i < dataArry.count ; i++) {
                    var product = Product()
                    var dataA = dataArry[i]
                    
                    
                    product.img_url = dataA["pictureURL"].stringValue//
                    product.pd_price = dataA["MinPrice"].doubleValue.description
                    product.p_title = dataA["title"].stringValue
                    product.pd_salesvolume = dataA["salesvolume"].stringValue
                    product.pd_keyid = dataA["ProductKeyID"].stringValue
                    product.shop_name = dataA["shopname"].stringValue
                    product.p_adminid = dataA["AdminKeyID"].stringValue
                    product.IsGivestate = dataA["IsGivestate"].stringValue
                    NSLog("dataA = \(product.img_url)")
                    
                    
                    productArry.append(product)
                }
                
                productShow = productArry
                
                
            }

            
            
        }
        
        self.collectionView?.reloadData()
        
    }
    
    func getMoreClassProductFirstGetMoreMessageBtnProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            var message = dataTemp["message"].stringValue
            if "true" == dataTemp["success"].stringValue{
                NSLog("dataTemp = \(dataTemp)")
                
                var dataArry = dataTemp["data"]
                NSLog("dataArry = \(dataArry)")
                
                for(var i = 0 ; i < dataArry.count ; i++) {
                    var product = classModel()
                    var dataA = dataArry[i]
                    product.keyid = dataA["keyid"].stringValue
                    product.picurl = dataA["picurl"].stringValue
                    product.title = dataA["name"].stringValue
                    var list = dataA["list"]
                    var model = NSMutableArray()
                    for(var j = 0 ; j < list.count ; j++){
                        let listProduct = classModel()
                        var listModel = list[j]
                        listProduct.keyid = dataA["keyid"].stringValue
                        listProduct.picurl = dataA["picurl"].stringValue
                        listProduct.title = dataA["name"].stringValue
                        model.addObject(listProduct)
                        
                        NSLog("model** \(model)")
                        product.list = model
                        NSLog("product.list** \(product.list)")
                    }
                    
                    moreBtnClassModel.addObject(product)
                }
                
                
                
            }
            
            
        }
    }

}


extension FirstPageCollectionVC{
    
    func locationBtnClk(){
        
    }
    func searchBtnClk(){
        NSLog("搜索按钮点击")
        var searchVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SearchVC") as! SearchVC
        searchVC.hidesBottomBarWhenPushed = true //隐藏tabbar
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    func scanBtnClk(){
        
        var scanBarCodeVC = ScanBarCodeVC()
        scanBarCodeVC.hidesBottomBarWhenPushed = true //隐藏tabbar
        self.navigationController?.pushViewController(scanBarCodeVC, animated: true)
        
    }
    
    

    
    
    
    func classProductBtnClk(#row: Int) {
        NSLog("你选择了 \(classProductArry[row].title)")
        NSLog("你选择了 \(classProductArry[row].keyid)")
        
        
        
        
        
        if "-1" == classProductArry[row].keyid {
            var classModelInfoVC = ClassGetMoreVC()
            classModelInfoVC.hidesBottomBarWhenPushed = true //隐藏tabbar
            self.navigationController?.pushViewController(classModelInfoVC, animated: true)
      
            
        }else{
            var classProductVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ClassProductVC") as! ClassProductVC
            classProductVC.KeyID = classProductArry[row].keyid
            classProductVC.navigationItem.title = classProductArry[row].title
            classProductVC.hidesBottomBarWhenPushed = true //隐藏tabbar
            NSLog("分类号是 \(classProductArry[row])")
            self.navigationController?.pushViewController(classProductVC, animated: true)
        }
        
        
        
        
    }
    
    
    
}
