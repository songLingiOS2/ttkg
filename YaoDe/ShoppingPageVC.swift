//
//  ShoppingPageVC.swift
//  YaoDe
//
//  Created by iosnull on 15/8/31.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//
//  YaoDe
//
//  Created by iosnull on 15/8/28.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit



class ShoppingPageVC: UIViewController,SDCycleScrollViewDelegate ,UITableViewDataSource,UITableViewDelegate,HomePageProductCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NavigationLeftViewDelegate,SelectAreaVCDelegate{
    
    
    
    
    
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
    var canAddToCart = true //是否能再加入购物车
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
        
        
        let cell = FPtableView.cellForRowAtIndexPath(whichRowProductAdd) as! HomePageProductCell
        
        
        
        
        
        
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
        
        path?.addQuadCurveToPoint(CGPoint(x: SCREEN_WIDTH - 60, y: pointY ), controlPoint: CGPointMake(SCREEN_WIDTH / 2  + 100 , SCREEN_HEIGHT / 2 - 100 ))
    }
    
     /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
    
    //刷新过程标记
    var tableViewRefreshFlag = false
    var advertiseViewRefreshFlag = false
    var collectionViewRefreshFlag = false
    //刷新计数器（每一个控件刷新完成后加1）
    var refreshCnt = 0
    
    //分类按钮数据源
    var classProductArry:[ClassProduct] =  [ClassProduct]()
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    //advertisement
    var shoppingAdArry:[ShoppingAD] = [ShoppingAD]()
    
    let http = ShoppingHttpReq.sharedInstance
    
    @IBOutlet var FPtableView: UITableView!
    //下拉刷新控件
    var refreshControl : ODRefreshControl!
    //滚动广告
    var sdCycleScrollView : SDCycleScrollView!
    
    //首页商品显示
    var productShow:[Product] = [Product]()
    
    
    @IBOutlet var advertisementBackground: UIView!
    @IBOutlet var classBtns: UICollectionView!
    
    
    @IBOutlet var addMoreBtn: UIButton!
    var productWillReqNumStartRange = 10
    //var currentProductNumRange = 0
    @IBAction func addMoreBtnClk(sender: AnyObject) {
        //判断当前商品数量是不是10的整数倍
        productWillReqNumStartRange += 10
        http.userProductList(areaid: currentRoleInfomation.areaid, currentpage: "1", pagesize: "20", roleid: currentRoleInfomation.roleid)
        
        ProgressHUD.show("加载数据中...")
    }
    
    
    var navigationLeftView = NavigationLeftView.loadFromNib()
    var currentLocation:UIBarButtonItem!
    func setNavigation(){

        navigationLeftView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 30)
        
        navigationLeftView.delegate = self
        
        navigationLeftView.backgroundColor = UIColor.clearColor()
        
        navigationLeftView.searchBtn.layer.masksToBounds = true
        navigationLeftView.searchBtn.layer.borderWidth = 1
        navigationLeftView.searchBtn.layer.cornerRadius = 10
        navigationLeftView.searchBtn.layer.borderColor = UIColor(red: 38/255, green: 168/255, blue: 231/255, alpha: 1 ).CGColor
        
        //currentLocation = UIBarButtonItem(customView: navigationLeftView)
        //self.navigationItem.leftBarButtonItems = [currentLocation]
        self.navigationItem.titleView = navigationLeftView
        
        
        
        
        setNavigationBar()
    }
    
    
    func setNavigationBar(){
        //        navigationBar常用属性
        //        一. 对navigationBar直接配置,所以该操作对每一界面navigationBar上显示的内容都会有影响(效果是一样的)
        //        1.修改navigationBar颜色
        //        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
        //
        //        2.关闭navigationBar的毛玻璃效果
        //        self.navigationController.navigationBar.translucent = NO;
        //        3.将navigationBar隐藏掉
        //
        //        self.navigationController.navigationBarHidden = YES;
        //
        //        4.给navigationBar设置图片
        //        不同尺寸的图片效果不同:
        //        1.320 * 44,只会给navigationBar附上图片
        //
        //        2.高度小于44,以及大于44且小于64:会平铺navigationBar以及状态条上显示
        //
        //        3.高度等于64:整个图片在navigationBar以及状态条上显示
        
        //1、返回标签
        //let item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        //self.navigationItem.backBarButtonItem = item
        //2、颜色（UINavigationBar）
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
         self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //隐藏毛玻璃效果
        //self.navigationController?.navigationBar.translucent = false
        
    }
    
    /**
    区域切换只针对普通消费者有效
    */
    func locationBtnClk(){
       
        if currentRoleInfomation.usertype == "30001"{//普通用户
            NSLog("区域切换")
            var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
            selectAreaVC.delegate = self
            
            self.navigationController?.pushViewController(selectAreaVC, animated: true)
            
        }else{
            
        }
        
    }
    
    /**
    区域选择实现
    
    - parameter name: 地址没错
    - parameter area: 区域ID
    */
    func selectCountryIs(name: String, area: String) {
        currentRoleInfomation.areaid = area
        currentAreaID = currentRoleInfomation.areaid //当前区域ID设置
        navigationLeftView.location.text = name
        
        NSLog("区域选择代理实现")
        
    }
    
    func searchBtnClk(){
        NSLog("搜索按钮点击")
        var searchVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SearchVC") as! SearchVC
        //classProductVC.navigationItem.title = classProductArry[indexPath.row].title
        
        //classProductVC.classProduct = classProductArry[indexPath.row]
        //NSLog("分类号是 \(classProductArry[indexPath.row])")
        
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setSubViewPara()
        
        //区域ID设置
        proAreaID = currentRoleInfomation.areaid
        currentAreaID = proAreaID
        
        setTableViewPara()
        setCollectionViewPara()
        
        //manageRoleRegistReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userProductListReqProcess:"), name: "userProductListReqtt", object: nil)
        //getShoppingAdvertisementReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getShoppingAdvertisementReqProcess:"), name: "getShoppingAdvertisementReq", object: nil)
        
        
        
        
        setNavigation()
        
        
 
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //清理图片内存
        SDImageCache.sharedImageCache().clearMemory()
        sdCycleScrollView.clearCache()
    }
    
    
    
}

extension ShoppingPageVC{
    func setSubViewPara(){
//        searchBtn.layer.masksToBounds = true
//        searchBtn.layer.borderWidth = 1
//        searchBtn.layer.cornerRadius = 7
//        searchBtn.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
        
        refreshControl = ODRefreshControl(inScrollView: FPtableView)
        refreshControl.addTarget(self, action: Selector("dropViewDidBeginRefreshing:"), forControlEvents: UIControlEvents.ValueChanged)
        
        
        //滚动广告轮播
        sdCycleScrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: advertisementBackground.frame.height), imageURLStringsGroup: nil)
        
        sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        sdCycleScrollView.delegate = self
        
        sdCycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        sdCycleScrollView.placeholderImage = UIImage(named: "logo")
        advertisementBackground.addSubview(sdCycleScrollView)
        

        
    }
    
    func setTableViewPara(){
        
        //背景容器的边框
        backGroundView.layer.masksToBounds = true
        backGroundView.layer.borderWidth = 1
        //collectionView.layer.cornerRadius = 5
        backGroundView.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
        FPtableView.delegate = self
        FPtableView.dataSource = self
        
        FPtableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        //去掉间距
        self.automaticallyAdjustsScrollViewInsets = false
        
        //注册cell
        FPtableView.registerNib(UINib(nibName: "HomePageProductCell", bundle: nil), forCellReuseIdentifier: "cell")
        //通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userProductListProcess:"), name: "userProductListReq", object: nil)
    }
    
    
    //MARK clollectionView
    func setCollectionViewPara(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.layer.masksToBounds = true
        collectionView.layer.borderWidth = 1
        //collectionView.layer.cornerRadius = 5
        collectionView.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
        //注册cell
        collectionView.registerNib(UINib(nibName: "ClassProductCell", bundle: nil), forCellWithReuseIdentifier: "Collectioncell")
        //通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getClassProductReqProcess:"), name: "getClassProductReqShoppingPageVC", object: nil)
        
        //addToShoppingCartUrlReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addToShoppingCartUrlReqProcess:"), name: "addToShoppingCartUrlReqShoppingPageVC", object: nil)
    }
    
    //分类按钮展示
    func getClassProductReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            
            if 100 == dataTemp["result"]{
                
                NSLog("获取到分类产品展示数据")
                if true == collectionViewRefreshFlag{//如果是更新控件，清空数据
                    classProductArry = []
                    refreshCnt++
                    collectionViewRefreshFlag = false
                }
                
                var classProductData = dataTemp["data"]
                var classProductTemp = ClassProduct()
                for(var cnt = 0 ; cnt < classProductData.count ; cnt++ ){
                    var data  = classProductData[cnt]
                    classProductTemp.picurl = data["picurl"].stringValue
                    classProductTemp.setfid = data["setfid"].stringValue
                    classProductTemp.display = data["display"].stringValue
                    classProductTemp.level = data["level"].stringValue
                    classProductTemp.title = data["title"].stringValue
                    classProductTemp.keyid = data["keyid"].stringValue
                    classProductTemp.fid = data["fid"].stringValue
                    NSLog("classProductTemp = \(classProductTemp)")
                    classProductArry.append(classProductTemp)
                }
                if !classProductArry.isEmpty{
                   collectionView.reloadData()
                }
                
                
            }
        }
        allRefreshEnding()
    }
    
    //广告数据获取处理
    func getShoppingAdvertisementReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            
            if 100 == dataTemp["result"]{

                NSLog("广告获取成功")
                
                if true == advertiseViewRefreshFlag {//如果是更新控件，清空数据
                    shoppingAdArry = []
                    refreshCnt++
                    advertiseViewRefreshFlag = false
                }
                
                
                var data = dataTemp["data"]
                var shopAdTemp = ShoppingAD()
                for(var cnt = 0 ; cnt < data.count ; cnt++ ){
                    var ad = data[cnt]
                    shopAdTemp.adminid = ad["adminid"].stringValue
                    //shopAdTemp.enable = ad["enable"].stringValue
                    shopAdTemp.picurl = ad["picurl"].stringValue
                    shopAdTemp.keyid = ad["keyid"].stringValue
                    //shopAdTemp.display = ad["display"].stringValue
                    //shopAdTemp.endtime = ad["endtime"].stringValue
                    //shopAdTemp.starttime = ad["starttime"].stringValue
                    //shopAdTemp.creattime = ad["creattime"].stringValue
                    //shopAdTemp.limit = ad["limit"].stringValue
                    //shopAdTemp.title = ad["title"].stringValue
                    //shopAdTemp.face = ad["face"].stringValue
                    
                    shoppingAdArry.append(shopAdTemp)
                }
                
                var imagesURLStrings:[String] = [String]()
                for (var cnt = 0 ; cnt < shoppingAdArry.count ; cnt++ ){
                    var imageUrl = serversBaseUrlForPicture + shoppingAdArry[cnt].picurl
                    NSLog("imageUrl = \(imageUrl)")
                    imagesURLStrings.append(imageUrl)
                }
                if !imagesURLStrings.isEmpty {
                    self.sdCycleScrollView.imageURLStringsGroup = imagesURLStrings
                }
                
                
            }
        }
        allRefreshEnding()
    }

    //商品展示
    func userProductListReqProcess(sender:NSNotification){
        
        ProgressHUD.dismiss()
        
        if currentAreaID != proAreaID{//清空数组缓存
            productShow = []
           proAreaID = currentAreaID
        }
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            
            if "100" == dataTemp["result"].stringValue{
                NSLog("dataTemp = \(dataTemp)")
                var productArry: [Product] = []
                var dataArry = dataTemp["data"]
                for(var i = 0 ; i < dataArry.count ; i++) {
                    var product = Product()
                    var dataA = dataArry[i]
                    
                    //NSLog("dataA = \(dataA)")
                    product.img_url = dataA["img_url"].stringValue
                    product.pd_price = dataA["pd_price"].stringValue
                    product.pd_ptprice = dataA["pd_ptprice"].stringValue
                    product.pd_stock = dataA["pd_stock"].stringValue
                    product.p_title = dataA["p_title"].stringValue
                    product.pd_salesvolume = dataA["pd_salesvolume"].stringValue
                    product.pd_keyid = dataA["pd_keyid"].stringValue
                    
                    product.shop_name = dataA["shop_name"].stringValue
                    product.shop_contact = dataA["shop_contact"].stringValue
                    
                    product.pd_pid = dataA["pd_pid"].stringValue
                    product.pd_discript = dataA["pd_discript"].stringValue
                    product.pd_spec = dataA["pd_spec"].stringValue
                    product.p_adminid = dataA["p_adminid"].stringValue
                    product.p_promotion = dataA["p_promotion"].stringValue
                    
                    //限购产品
                    product.pd_ispurchase = dataA["pd_ispurchase"].stringValue
                    product.pd_purchasenum = dataA["pd_purchasenum"].stringValue
                    
                    //买满什么多少件送什么
                    product.pd_conditionnums = dataA["pd_conditionnums"].stringValue
                    product.pd_givingnums = dataA["pd_givingnums"].stringValue
                    product.pd_givingproduct = dataA["pd_givingproduct"].stringValue
                    
                    
                    productArry.append(product)
                }
                
                
                NSLog("productArry = \(productArry)")
                if tableViewRefreshFlag == true {
                    refreshCnt++
                    productShow  = productArry
                    tableViewRefreshFlag = false
                }else{
                    productShow += productArry
                    
                }
                
                NSLog("\(productShow.count)")
                if !productShow.isEmpty{
                    
                        self.FPtableView.reloadData()
                    
                    
                }
                
                
            }
            if "10011" == dataTemp["result"].stringValue{
                
                self.FPtableView.reloadData()
                addMoreBtn.setTitle("没有更多数据了!!!", forState: UIControlState.Normal)
                //NSLog("没有更多数据了")
                ProgressHUD.showError("没有更多数据了")
            }
            
            allRefreshEnding()
        }
        
    }
    
    //所有刷新完成后设置
    func allRefreshEnding(){
        refreshControl.endRefreshing() //修改
        if  refreshCnt > 2 {
            NSLog("#######################################################################\(refreshCnt)")
            //停止旋转
            refreshControl.endRefreshing()
            refreshCnt = 0
            addMoreBtn.setTitle("点击添加更多...", forState: UIControlState.Normal)
            productWillReqNumStartRange = 10
        }
    }
    
    //滚动广告点击
    /**
    暂时不开放该功能，因为没有数据
    
    - parameter cycleScrollView: cycleScrollView description
    - parameter index:           index description
    */
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        NSLog("你点击了第\(shoppingAdArry[index].adminid)商家的广告")
        /*
        var discountProductVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("DiscountProductVC") as! DiscountProductVC
        discountProductVC.shoppingAD = shoppingAdArry[index]
        discountProductVC.navigationItem.title = "促销商品"
        self.navigationController?.pushViewController(discountProductVC, animated: true)
        */
        

    }
    
    
    
    //下拉刷新处理
    func dropViewDidBeginRefreshing(refreshControl:ODRefreshControl){
        NSLog("下拉刷新了")
        ProgressHUD.show("数据请求中...")
        
        //重新加载所有网络数据
         //刷新状态标记
         tableViewRefreshFlag = true
         advertiseViewRefreshFlag = true
         collectionViewRefreshFlag = true
        http.userProductList(areaid: currentRoleInfomation.areaid, currentpage: "1", pagesize: "20", roleid: currentRoleInfomation.roleid)
        http.getShoppingAdvertisement(currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid)
        http.getClassProduct("0", whoAreYou: "ShoppingPageVC")
    }
    
    func resetDate(){
        NSLog("currentRoleInfomation.roleid= \(currentRoleInfomation.roleid),currentRoleInfomation.areaid = \(currentRoleInfomation.areaid)")
        ProgressHUD.show("数据请求中...")
        
        //重新加载所有网络数据
        //刷新状态标记
        tableViewRefreshFlag = true
        advertiseViewRefreshFlag = true
        collectionViewRefreshFlag = true
        http.userProductList(areaid: currentRoleInfomation.areaid, currentpage: "1", pagesize: "20", roleid: currentRoleInfomation.roleid)
        http.getShoppingAdvertisement(currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid)
        http.getClassProduct("0", whoAreYou: "ShoppingPageVC")
    }
    
    
    //MARK TableView Datasource and Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        NSLog("productShow.count = \(productShow.count)")
        return productShow.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = FPtableView.dequeueReusableCellWithIdentifier("cell") as! HomePageProductCell
        cell.delegate = self
        cell.tag = indexPath.row
        cell.setProductView = productShow[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 89
    }
    
    //加入购物车 Delegate
    func productAddToShoppingCat(#row: Int) {
        var usertypeTemp = ""
        if currentRoleInfomation.usertype == "30001" {
            usertypeTemp = "2"//商户
        }else{
            usertypeTemp = "1"//普通会员
        }
        
        
        /**
        *  检测是否动画完成，可以再次提交到购物车
        */
        if canAddToCart == false {
            
            return
            
        }
        canAddToCart = false
        
        
        
        http.addToShoppingCart(usertype: usertypeTemp, userid: currentRoleInfomation.keyid, shopid:productShow[row].p_adminid, pdid: productShow[row].pd_keyid, price: productShow[row].pd_price, nums: "1", imgurl: productShow[row].img_url, pdname: productShow[row].p_title,whoAreYou:"ShoppingPageVC")
        
        
        NSLog("\(productShow[row].p_title) 被加入购物车")
        
        productShow[row].haveBeenClk = true
        
        
        FPtableView.reloadData()
        
        
        
        //添加动画
        //开始动画，设置起始坐标
        //CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
        //CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
        
        var indexPath = NSIndexPath(forRow: row, inSection: 0)
        whichRowProductAdd = indexPath

        var rectInTableView:CGRect = FPtableView.rectForRowAtIndexPath(indexPath)
        var rect = FPtableView.convertRect(rectInTableView, toView: FPtableView.superview)
        
        NSLog("rect = \(rect)")
        
        var startY = Int(rect.origin.y)  + 50
        NSLog("startY = \(startY)")
        
        setShoppingCartAnimation(45, startY: startY)
        
        let cell = FPtableView.cellForRowAtIndexPath(indexPath) as! HomePageProductCell
        
        
        var productImage:UIImage!
        if let img = cell.imageIcon.image {
            productImage = cell.imageIcon.image
        }else{
            productImage = UIImage(named: "园logo-01")
        }
        
        
        
        startAnimation(productImage!)
        
    }
    //加入购物车处理结果
    func addToShoppingCartUrlReqProcess(sender:NSNotification){
        
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
        }

        
    }
    
    //MARK CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return classProductArry.count
    }
    

    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Collectioncell", forIndexPath: indexPath) as! ClassProductCell
        cell.setClassProductShow = classProductArry[indexPath.row]
        
        //tableViewHeaderView的frame
        resetTableViewHeaderViewFrame(row: indexPath.row, cellMaxY: cell.frame.minY)
        
        NSLog("cell.frame = \(cell.frame)")
        return cell
        
    }
    
    //更新tableViewHeaderView的frame
    func resetTableViewHeaderViewFrame(#row:Int,cellMaxY:CGFloat){
        if (row + 1) == classProductArry.count {
            backGroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 300)
            if cellMaxY > 10 {//第二排
                collectionView.snp_remakeConstraints { (make) -> Void in
                    make.top.equalTo(backGroundView).offset(130)
                    make.left.equalTo(self.view).offset(0)
                    make.bottom.equalTo(backGroundView).offset(-33)
                    make.right.equalTo(self.view).offset(0)
                    
                }
                self.FPtableView.tableHeaderView = backGroundView
            }
            else{
                backGroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 235)
                collectionView.snp_remakeConstraints { (make) -> Void in
                    make.top.equalTo(self.backGroundView).offset(130)
                    make.left.equalTo(self.view).offset(0)
                    make.bottom.equalTo(self.backGroundView).offset(-33)
                    make.right.equalTo(self.view).offset(0)
                }
                self.FPtableView.tableHeaderView = backGroundView
            }
        }

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //定义大小
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(62, 62)
    }
    
    //定义每个UICollectionView 的 margin
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(5, 5, 5,5)
    }
    
    //是否可以选择
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //选中时调用
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("你选择了 \(classProductArry[indexPath.row].title)")
        
        
        var classSelectVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ClassSelectVC") as! ClassSelectVC
        classSelectVC.navigationItem.title = classProductArry[indexPath.row].title
        
        classSelectVC.classProduct = classProductArry[indexPath.row]
        NSLog("分类号是 \(classProductArry[indexPath.row])")
        self.navigationController?.pushViewController(classSelectVC, animated: true)
    }
    

    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = false
        
        if serverIsAvalaible() {

            resetDate()
            
            if currentRoleInfomation.roleid != "-1"{
                navigationLeftView.location.text = "贵阳市"
            }
            
            
        }
        
        

        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        ProgressHUD.dismiss()
    }
    
    
    
    func scanBtnClk() {

        
        
//        var scannerVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ScannerVC") as! ScannerVC
//        
//        self.navigationController?.pushViewController(scannerVC, animated: false)
        var scanBarCodeVC = ScanBarCodeVC()
        scanBarCodeVC.hidesBottomBarWhenPushed = true //隐藏tabbar
        self.navigationController?.pushViewController(scanBarCodeVC, animated: true)
    }
    
    
    
    

    

    
    
    
    
}
