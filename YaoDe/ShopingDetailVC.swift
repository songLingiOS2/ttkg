//
//  ShopingDetailVC.swift
//  ProductInfo
//
//  Created by iosnull on 16/3/16.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//


////字符串转JSON
//func StringToJSON(sender:String)->JSON{
//    
//    var resultData = sender as NSString
//    
//    if let dataFromString = resultData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//        let json = JSON(data:dataFromString)
//        
//        return json
//    }else{
//        return nil
//    }
//    
//}

func refreshGouWuCheBadgeValue(tabBarController:UITabBarController){
    //购物车右上角标签显示
    let url =  serversBaseURL + "/shoppingcart/get"
    
    
    let parameters = ["userid":currentRoleInfomation.keyid,"usertype":"1"]
    
    NSLog("parameters = \(parameters.description)")
    
    let data = JSON(parameters)
    let dataString = data.description
    let para = ["filter":dataString]
    
    if netIsavalaible {
    Alamofire.request(.GET,url,parameters: para).responseString{ (request, response, data, error) in
        
        var json = StringToJSON(data!)
        
        NSLog("json = \(json)")
        
        var message = json["message"].stringValue
        if json["success"].stringValue == "true" {
            let count = json["data"].stringValue
            var childVC:[UIViewController] = tabBarController.viewControllers  as! [UIViewController]
            var shoppingCartVC = childVC[2]
            NSLog("count = \(count)")
            
            // 应用程序右上角数字
            var t = UIUserNotificationType.Badge
            var setting = UIUserNotificationSettings(forTypes: t, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(setting)
            var app = UIApplication.sharedApplication()
            
            
            
            if count == "0" {
               shoppingCartVC.tabBarItem.badgeValue = nil
               app.applicationIconBadgeNumber = 0
            }else{
               shoppingCartVC.tabBarItem.badgeValue = count
               app.applicationIconBadgeNumber =  NSNumberFormatter().numberFromString(count)!.integerValue //单价
            }
            
        }
        
    }
    }else{
        netIsEnable("网络不可用")
    }
    
    
}


import UIKit
import Alamofire
import SwiftyJSON

let width = UIScreen.mainScreen().bounds.size.width//获取屏幕宽
let height = UIScreen.mainScreen().bounds.size.height//获取屏幕宽


/**
*  添加购物车的模型
*/
struct AddToShoppingCartModel {
    //var ProductPropertyOptionKeyID = ""//propertys属性，如颜色，包装方式等
    var merchantKeyID = "" //商家-商品ID
    var adminKeyID = ""//卖家ID
    
    
    
    //var usrID = ""//买家ID
    //var usrType = ""//买家类别
    
    var goodsTitle =  "" //商品名称
    //var img = ""//封面图
    
    //界面显示用
    var nums = "1" //购买数量
    var promotionPrice = "" //现价价
    var oldPrice = ""//原价
    var isPromotion = ""//是否显示促销价
    var option = "" //当前选中的商品规格
    var imgs = [String]() //对应规格下的商品图片
    var speciOptionsTitle = ""//该产品是按什么规格分类的
    
    //该商品单价是？
    var shouldPay = "0"
    
    var pictureURL = ""
}


/**
*产品详情模型A
*/
struct Data {
    var synopsis = ""
    var brandTitle = ""
    var title = ""
    var shopname = ""
    var address = ""
    var productKeyid = ""
    var categoryTitle = ""
    var adminKeyID = ""
    var Isnew = ""
    var categoryUrl = ""
    var BrandLogo = ""
    var speciOptions = [SpeciOptions]()
    
    var propertys = [Propertys]()
    
    var tel = ""
    var details = ""
    var Ishot = ""
    var pictureURL = ""
    var priceRang = ""
    var TotalSales = ""//所有规格的总销量
    
    //商家活动
    var IsGivestate = ""//赠送状态（0：开启，1：关闭）
    var GiveMsg = "" //买满 50 元 送 5 瓶红酒",//赠送活动消息显示信息
}

struct Propertys {//属性
    var propertyTitle = ""
    var propertyOptions = [PropertyOptions]()
}

struct PropertyOptions {
    var title = ""
    var productPropertyOptionKeyID = ""
    var selectedFlag = false //选中标记
}

//产品详情模型A
struct GoodsDetailInfomation {
    var success = "" {//发通知
        didSet{
            /**
            发通知给tabbarcontroller,叫他帮我跳转到我的页面
            */
            NSNotificationCenter.defaultCenter().postNotificationName("getGoodsDetailInfo", object: nil)
        }
    }
    var message = ""
    var status = ""
    
    var data = Data()
    
    //商家活动信息
    func shangJiaHuoDong()->(Bool,String){
        var huoDongFlag = false
        var content = data.GiveMsg
        if data.IsGivestate == "0" {
            huoDongFlag = true
        }
        
        return (huoDongFlag,content)
    }
    
    //用户选择的属性
    func selectShuXing()->(haveshuXing:Bool,selectedAll:Bool,shuXing:[String],noSelectTitle:String){
        var selectedAll = false //全选标记
        var cnt = 0
        var shuXing = [String]()
        
        var noSelectTitle = ""
        
        //1、遍历所有属性选项
        for var i = 0 ; i < data.propertys.count ; i++ {
            
            var property = data.propertys[i]
            
            var k = 0
            for var j = 0 ; j < property.propertyOptions.count;j++ {
                
                if property.propertyOptions[j].selectedFlag {//有被选中
                    cnt++
                    shuXing.append(property.propertyOptions[j].title)
                    break;//退出该层循环
                }else{
                    k++ ;//该属性分类标题计数标记
                }
            }
            
            //记录没有选择商品的位置
            if k == property.propertyOptions.count {
                noSelectTitle = property.propertyTitle
                break;
            }
        }
        
        if cnt != data.propertys.count {
            selectedAll = false
        }else{
           selectedAll = true
        }
        var haveshuXing = false
        
        if data.propertys.count > 0 {
            haveshuXing = true
        }else{
            haveshuXing = false
        }
        return (haveshuXing,selectedAll,shuXing,noSelectTitle)
    }
    
    //根据属性设置选中标记的位置
    func positionOfShuXingFlagByShuXing(shuXing:String)->(shuXingNO:Int,row:Int){
        
        var shuXingNO = 0
        var row = 0
        for var  i = 0 ; i < data.propertys.count ; i++ {
            
            var propertysTemp:Propertys = data.propertys[i]
            
            for var  j = 0 ; j < propertysTemp.propertyOptions.count ; j++ {
                
                if shuXing == propertysTemp.propertyOptions[j].title {//找到属性标题
                    shuXingNO = i
                    row = j
                }
            }
            
        }
        
        return(shuXingNO,row)
    }
    
    //返回多少个section(规格+属性)
    func numberOfSections()->Int{
        var numSection = 1 //规格必须有
        numSection += data.propertys.count //加上属性
        return numSection
    }
    
    //规格选中标记
    var selectGuiGeFlag = false
    var selectGuiGeName = ""
    var goodsNums = "1"
    
    //根据规格返回该商品的活动
    func getGoodHuoDongFromGuiGe(selectGuiGeName:String)->(Bool,String){
        var huoDongInfo = ""
        var huoDongFlag = false
        for var i = 0 ;i < data.speciOptions[0].options.count ;i++ {
            if selectGuiGeName == data.speciOptions[0].options[i].title {
                if data.speciOptions[0].options[i].IsGivestate == "0" {
                   huoDongInfo = data.speciOptions[0].options[i].GiveMsg
                    huoDongFlag = true
                }
                break
            }
        }
        return (huoDongFlag,huoDongInfo)
    }
    //根据规格返回该规格对应的库存
    func getStockFromGuiGe(selectGuiGeName:String)->String{
        var stock = "0"
        for var i = 0 ;i < data.speciOptions[0].options.count ;i++ {
            if selectGuiGeName == data.speciOptions[0].options[i].title {
                stock = data.speciOptions[0].options[i].stock
                break
            }
        }
        return stock
    }
    
    func getNessaryInfoForBuy(selectGuiGeName:String)->(MerchantPriceID:String,Productname:String,nums:String,imgurl:String){
        var MerchantPriceID = ""
        var Productname = ""
        var nums = ""
        var imgurl = ""
        for var i = 0 ;i < data.speciOptions[0].options.count ;i++ {
            if selectGuiGeName == data.speciOptions[0].options[i].title {
                MerchantPriceID = data.speciOptions[0].options[i].merchantKeyID
                break
            }
        }
        Productname = data.title
        imgurl = data.pictureURL
        nums = goodsNums
        return (MerchantPriceID,Productname,nums,imgurl)
    }
    
    //获取商品详情信息（HTML字符串）
    func getGoodsDetailInfo()->String{
        return data.details
    }
    //返回区间价格和封面图
    func getPriceRange()->(priceRange:String ,pictureURL:String){
        NSLog("data.priceRang = \(data.priceRang), data.pictureURL = \(data.pictureURL)")
        return (data.priceRang, serversBaseUrlForPicture + data.pictureURL)
    }
    
    //返回商家信息
    func shopNameAddressTel()->(shopName:String,address:String,tel:String){
        var shopName = ""
        var address = ""
        var tel = ""
        
        shopName =  data.shopname
        address =  data.address
        tel =  data.tel
        
        return (shopName,address,tel)
    }
    
    //根据规格返回第几个cell
    func numCellAccordingToGuiGe(guiGeSelectName:String)->(Int){
        var num = 100
        for var j = 0 ; j < data.speciOptions.count ; j++ {
            for var i = 0 ; i < data.speciOptions[j].options.count ; i++ {
                if guiGeSelectName == data.speciOptions[j].options[i].title {
                    num = i //标记对应的选中cell的位置
                    break
                }
            }
        }
        return num
    }
    
    //返回商品所有规格
    func getGuiGe()->[String]{
        var guiGe = [String]()
        
        if  data.speciOptions.count != 0  {//现阶段只有一维规格
            var j = 0
            for var i = 0 ; i < data.speciOptions[j].options.count ; i++ {
                guiGe.append(data.speciOptions[j].options[i].title)
            }
        }
        return guiGe
    }
    
    //规格选项对应的销量、价格、图片数组
    func getSellCntAndPrice(guiGeSelectName:String)->(sellCnt:String,price:String,imgs:[String]){
        var sellCnt = ""
        var price = ""
        var imgs = [String]()
        for var j = 0 ; j < data.speciOptions.count ; j++ {
            for var i = 0 ; i < data.speciOptions[j].options.count ; i++ {
                if guiGeSelectName == data.speciOptions[j].options[i].title {
                    
                    //销量
                    sellCnt = data.speciOptions[j].options[i].salesvolume
                    
                    //图片
                    for var k = 0 ; k < data.speciOptions[j].options[i].ProductAltes_imgs.count; k++ {
                        var img = serversBaseUrlForPicture + data.speciOptions[j].options[i].ProductAltes_imgs[k]
                        imgs.append(img)
                    }
                    
                    //价格
                    var originalPrice = data.speciOptions[j].options[i].originalPrice //原价
                    var promotionalPrice = data.speciOptions[j].options[i].promotionalPrice //促销价
                    if data.speciOptions[j].options[i].IsPromotional == "0" {//促销
                        price = promotionalPrice
                    }else{//不促销
                        price = originalPrice
                    }
                    break
                }
            }
        }
        return (sellCnt,price,imgs)
    }
}

struct SpeciOptions {
    var title = ""//按该title进行规格分类
    var options = [Options]()
}

//商品规格Options
struct Options {
    var stock  = ""
    var salesvolume = ""
    var merchantKeyID = ""
    var IsPromotional = ""
    var promotionalPrice = ""
    var originalPrice = ""
    var ProductAltes_imgs = [String]()
    var title = ""
    
    //单个商品促销活动
    var IsGivestate = ""//赠送状态（0：开启，1：关闭）
    var GiveMsg = "" //"买满 1 件 送 5 瓶红酒",//赠送活动消息显示信息
}

class ShopingDetailVC:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var usertype = ""
    var adminkeyid = ""
    var productkeyid = ""
    var userid = ""
    
    //商品数据模型
    var goodsDetailInfomation = GoodsDetailInfomation()
    
    
    var addToShoppingCartBtn:UIButton!
    
    func subViewInit(){
        addToShoppingCartBtn = UIButton(frame: CGRect(x: 0, y: height - 50, width: width, height: 50))
        addToShoppingCartBtn.backgroundColor = UIColor(red: 202/255, green: 42/255, blue: 45/255, alpha: 1)
        addToShoppingCartBtn.tintColor = UIColor.whiteColor()
        addToShoppingCartBtn.setTitle("加入进货单", forState: UIControlState.Normal)
        addToShoppingCartBtn.addTarget(self, action: Selector("addToShoppingCartBtnClk"), forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(addToShoppingCartBtn)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    
    deinit{
        ProgressHUD.dismiss()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func processGoodsDetailInfo(){
        NSLog("去刷新页面吧")
        
        self.colltionView.reloadData()
        //setBackGroundBlurEffect(self.colltionView.backgroundView!, url: NSURL(string: goodsDetailInfomation.getPriceRange().pictureURL)!)
    }
    
    
    //设置高斯模糊效果
    func setBackGroundBlurEffect(backgroundView:UIView,url:NSURL){
        
        
        var blurEffect = UIBlurEffect(style:UIBlurEffectStyle.Dark)
        
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.view.bounds
        
        var backgroundImageView = UIImageView(frame: backgroundView.frame)
        backgroundImageView.addSubview(blurEffectView)
        
        backgroundImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "logo320x320"))
        
        
        backgroundImageView.alpha = 1
        
        backgroundView.addSubview(backgroundImageView)
    }
    
    var colltionView:UICollectionView!
    override func viewDidLoad() {
        
        //数据获取到了
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("processGoodsDetailInfo"), name: "getGoodsDetailInfo", object: nil)
        
        super.viewDidLoad()
        self.getData(adminkeyid,productkeyid: productkeyid)
        
        
        var layout = UICollectionViewFlowLayout()
        colltionView = UICollectionView(frame: CGRectMake(0, 0, width, height - 44), collectionViewLayout: layout)
        //注册一个cell
        colltionView! .registerClass(Home_Cell.self, forCellWithReuseIdentifier:"cell")
        colltionView! .registerClass(GoodsSuXingCell.self, forCellWithReuseIdentifier:"suXingCell")
        //注册一个headView
        colltionView! .registerClass(GoodsHeaderView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        //商品属性
        colltionView! .registerClass(GoodsPropertysSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "propertys")
        
        //注册一个Home_FooterView
        colltionView! .registerClass(Home_FooterView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        
        colltionView! .registerClass(GoodsPropertysSectionViewFooter.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        colltionView?.delegate = self;
        colltionView?.dataSource = self;
        
        colltionView.backgroundView = UIView()
        
        colltionView?.backgroundColor = UIColor.whiteColor()
        colltionView.autoresizesSubviews = false
        
        //设置每一个cell的宽高
        layout.itemSize = CGSizeMake((width-30)/4, 40)
        layout.headerReferenceSize = CGSize(width: width, height: 3*width)
        
        self.view .addSubview(colltionView!)
        
        
        subViewInit()
        
        //self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named: "guide_cart_nm"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("goGouWuCheBtnClk"))
    }
    
    //去购物车页面
    func goGouWuCheBtnClk(){
        NSLog("去购物车页面")
        var gouWuCheVC = GouWuCheVC()
        self.hidesBottomBarWhenPushed = true
        gouWuCheVC.pushed = true
        self.navigationController?.pushViewController(gouWuCheVC, animated: false)
    }
    
    //字符串转JSON
    func stringToJSON(sender:String)->JSON{
        
        var resultData = sender as NSString
        
        if let dataFromString = resultData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data:dataFromString)
            
            return json
        }else{
            return nil
        }
        
    }
    
    func JSON_ToModel(json:JSON) ->GoodsDetailInfomation{
        var goodsDetailInfomation = GoodsDetailInfomation()
        goodsDetailInfomation.status = json["status"].stringValue
        goodsDetailInfomation.success = json["success"].stringValue
        goodsDetailInfomation.message = json["message"].stringValue
        
        if goodsDetailInfomation.success == "true" {
            var dataTemp = json["data"]
            //NSLog("dataTemp = \(dataTemp) ")
            var data  = Data()
            data.synopsis = dataTemp["synopsis"].stringValue
            data.brandTitle = dataTemp["BrandTitle"].stringValue
            data.title = dataTemp["title"].stringValue
            data.shopname = dataTemp["shopname"].stringValue
            data.address = dataTemp["address"].stringValue
            data.productKeyid = dataTemp["ProductKeyid"].stringValue
            data.categoryTitle = dataTemp["CategoryTitle"].stringValue
            data.adminKeyID = dataTemp["AdminKeyID"].stringValue
            data.Isnew = dataTemp["Isnew"].stringValue
            data.categoryUrl = dataTemp["CategoryUrl"].stringValue
            data.BrandLogo = dataTemp["BrandLogo"].stringValue
            data.tel = dataTemp["tel"].stringValue
            data.details = dataTemp["details"].stringValue
            data.pictureURL = dataTemp["pictureURL"].stringValue
            NSLog("data.pictureURL = \(data.pictureURL)")
            data.priceRang =  dataTemp["PriceRang"].stringValue
            
            data.TotalSales =  dataTemp["TotalSales"].stringValue
            
            //商家活动
            data.IsGivestate =  dataTemp["IsGivestate"].stringValue
            data.GiveMsg =  dataTemp["GiveMsg"].stringValue
            
            data.speciOptions = getSpeciOptions(dataTemp["SpeciOptions"])
            data.propertys = getPropertys(dataTemp["propertys"])
            
            goodsDetailInfomation.data = data
        }else{
            NSLog("goodsDetailInfomation.message = \(goodsDetailInfomation.message)")
        }
        
        NSLog("goodsDetailInfomation = \(goodsDetailInfomation)")
        
        return goodsDetailInfomation
    }
    //获取SpeciOptions
    func getSpeciOptions(json:JSON)->[SpeciOptions]{
        //NSLog("getSpeciOptions(json:JSON) = \(json.description)")
        NSLog("json=\(json.count)")
        var speciOptionsArry = [SpeciOptions]()
        
        for var i = 0 ; i < json.count ; i++ {
            var speciOptionTemp = json[i]
            //NSLog("speciOption = \(speciOptionTemp)")
            var speciOption = SpeciOptions()
            speciOption.title = speciOptionTemp["title"].stringValue
            speciOption.options = getOptions(speciOptionTemp["options"])
            
            speciOptionsArry.append(speciOption)
        }
        
        //NSLog("speciOptionsArry = \(speciOptionsArry.description)")
        return speciOptionsArry
    }
    //获取Options
    func getOptions(json:JSON)->[Options]{
        NSLog("json = \(json)")
        var options = [Options]()
        
        for var i = 0 ; i < json.count ; i++ {
            var optionTemp  = json[i]
            var option = Options()
            option.stock = optionTemp["stock"].stringValue
            option.salesvolume = optionTemp["salesvolume"].stringValue
            option.merchantKeyID = optionTemp["MerchantKeyID"].stringValue
            option.IsPromotional = optionTemp["IsPromotional"].stringValue
            option.promotionalPrice = optionTemp["promotionalPrice"].doubleValue.description
            option.originalPrice = optionTemp["originalPrice"].doubleValue.description
            option.title = optionTemp["title"].stringValue
            
            //单个商品活动
            option.IsGivestate = optionTemp["IsGivestate"].stringValue
            option.GiveMsg = optionTemp["GiveMsg"].stringValue
            
            //取出imgURL
            var imgUrlJSON = optionTemp["ProductAltes"]
            for var j = 0 ; j < imgUrlJSON.count ; j++ {
                var imgUrlTemp = imgUrlJSON[j]
                option.ProductAltes_imgs.append(imgUrlTemp["url"].stringValue)
            }
            
            options.append(option)
        }
        
        NSLog("options = \(options)")
        return options
    }
    //获取propertys
    func getPropertys(json:JSON)->[Propertys]{
        var propertysArry = [Propertys]()
        
        for var i = 0 ; i < json.count ; i++ {
            var propertyTemp = json[i]
            var property = Propertys()
            property.propertyTitle = propertyTemp["PropertyTitle"].stringValue
            
            var propertyOptionsJSON =  propertyTemp["PropertyOptions"]
            NSLog("propertyOptionsJSON = \(propertyOptionsJSON.description)")
            
            var propertyOptionsArry = [PropertyOptions]()
            for var j = 0 ; j < propertyOptionsJSON.count ; j++ {
                var propertyOptionsTemp = propertyOptionsJSON[j]
                var propertyOption = PropertyOptions()
                propertyOption.title = propertyOptionsTemp["title"].stringValue
                propertyOption.productPropertyOptionKeyID = propertyOptionsTemp["ProductPropertyOptionKeyID"].stringValue
                propertyOptionsArry.append(propertyOption)
            }
            property.propertyOptions = propertyOptionsArry
            
            propertysArry.append(property)
        }
        NSLog("propertysArry = \(propertysArry.description)")
        return propertysArry
    }
    //获取数据
    func getData(adminkeyid:String,productkeyid:String){
        
        let getShoppingAdvertisementUrl = serversBaseURL + "/product/detail"
        //filter={"adminkeyid":"11","productkeyid":"8"}
        
        let parameters = ["adminkeyid":self.adminkeyid,"productkeyid":productkeyid]
        
        NSLog("parameters = \(parameters.description)")
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
        ProgressHUD.show("数据获取中...")
        Alamofire.request(.GET,getShoppingAdvertisementUrl,parameters: para).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            
            
            ProgressHUD.dismiss()
            
            var json = self.stringToJSON(data!)
            
            
            
            NSLog("json = \(json)")
            
            var message = json["message"].stringValue
            if json["success"].stringValue == "true" {
                ProgressHUD.showSuccess(message)
                self.goodsDetailInfomation = self.JSON_ToModel(json)
                
                self.goodsDetailInfomation.success = "success"
            }else{
                ProgressHUD.showError(message)
            }
            
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //返回多少个组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var cnt = goodsDetailInfomation.numberOfSections()
        NSLog("numberOfSections = \(cnt)")
        return cnt
    }
    //返回多少个cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cnt = 0
        
        if section == 0 {//1、规格
            if self.goodsDetailInfomation.data.speciOptions.count != 0 {
                cnt = self.goodsDetailInfomation.data.speciOptions[section].options.count
            }
        }else{//2、属性
            
            if  self.goodsDetailInfomation.data.propertys.count != 0  {
                cnt = self.goodsDetailInfomation.data.propertys[section - 1].propertyOptions.count
            }
        }
        
        NSLog("cell cnt = \(cnt)")
        
        return cnt
    }
    //返回自定义的cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //
        
        NSLog("设置Cell内容")
        if indexPath.section == 0 {//规格
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! Home_Cell
            
            var title = self.goodsDetailInfomation.getGuiGe()[indexPath.row] //self.goodsDetailInfomation.data.speciOptions[0].options[indexPath.row].title
            NSLog("规格名称是：\(title)")
            cell.goodsSpecification.text = title
            
            var row = self.goodsDetailInfomation.numCellAccordingToGuiGe(self.goodsDetailInfomation.selectGuiGeName)
            NSLog("cell row is：\(row)")
            if row == indexPath.row {
                cell.selectFlag = true
            }else{
                cell.selectFlag = false
            }
            
            cell.initWithClosure(goodsOption)
            return cell
        }else{//属性
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("suXingCell", forIndexPath: indexPath) as! GoodsSuXingCell
            //cell.suXing.text = self.goodsDetailInfomation.data.propertys[indexPath.section - 1].propertyOptions[indexPath.row].title
//            if self.goodsDetailInfomation.data.propertys[indexPath.section - 1].propertyOptions[indexPath.row].selectedFlag {
//                cell.selectFlag = true
//            }else{
//                cell.selectFlag = false
//            }
            cell.initWithClosure(suXingOption)
            
            return cell
        }
        
    }
    //返回HeadView的宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        if section == 0 {
            return CGSize(width: width, height: width + 125 )
                
            }else{
                return CGSize(width: width, height: 40 )
            }
    }
    //返回FooterView的宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var cnt = goodsDetailInfomation.numberOfSections()
        if (cnt - 1) == section {//最后一个
            return CGSize(width: width, height: 250)
        }else{
            return CGSize(width: width, height: 20 )
        }
    }
    
    //单元格横向间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 5
    }
    
    //纵向间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    
    func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        var attributes = [NSFontAttributeName: font]
        var option = NSStringDrawingOptions.UsesLineFragmentOrigin
        var rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        //        println("rect:\(rect)");
        return rect;
    }
    
    //cell 宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            //定义宽,高
            
//            var w = Int((screenWith-14)/2)
//            
//            var title = self.goodsDetailInfomation.getGuiGe()[indexPath.row]
//            
//            var size = getTextRectSize(title, font: UIFont.systemFontOfSize(14), size: CGSize(width:w, height: 200) )
//            
//            NSLog("size = \(size)")
//            
//            
//            return CGSize(width:CGFloat(w) , height: size.height + 10)
//            
//            return CGSize(width: size.width, height: size.height + 10)
//            return size.size
            
            var w = screenWith/8
            return CGSize(width:screenWith , height: 30)
        }else{
            return CGSize(width:screenWith , height: 1)
        }
    }
    
    //返回自定义HeadView或者FootView
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        var reusableview:UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader{
            if indexPath.section == 0 {
                var headerView = GoodsHeaderView()
                headerView = colltionView!.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headView", forIndexPath: indexPath) as! GoodsHeaderView
                headerView.title.text = goodsDetailInfomation.data.title
                if goodsDetailInfomation.data.speciOptions.count != 0 {
                    headerView.guiGe.text = goodsDetailInfomation.data.speciOptions[0].title
                    
                    
                    
                }else{
                    headerView.guiGe.text = ""
                    
                    
                }
                
                
                if goodsDetailInfomation.selectGuiGeFlag {//显示选择规格的商品
                    headerView.price.text = "￥" + goodsDetailInfomation.getSellCntAndPrice(goodsDetailInfomation.selectGuiGeName).price
                    if goodsDetailInfomation.getSellCntAndPrice(goodsDetailInfomation.selectGuiGeName).imgs.count != 0 {
                    headerView.scrollViewImg.imageURLStringsGroup = goodsDetailInfomation.getSellCntAndPrice(goodsDetailInfomation.selectGuiGeName).imgs
                    }else{
                        headerView.scrollViewImg.imageURLStringsGroup = [goodsDetailInfomation.getPriceRange().pictureURL]
                    }
                    headerView.sellCnt.text = "已售:" + goodsDetailInfomation.getSellCntAndPrice(goodsDetailInfomation.selectGuiGeName).sellCnt
                    
                    headerView.stock = "库存:" + goodsDetailInfomation.getStockFromGuiGe(goodsDetailInfomation.selectGuiGeName)
                    
                    var (flag,content) = goodsDetailInfomation.getGoodHuoDongFromGuiGe(goodsDetailInfomation.selectGuiGeName)
                    if flag {
                        headerView.huoDongInfo.text = content
                    }else{
                        headerView.huoDongInfo.text = ""
                    }
                    
                }else{//只显示区间价格
                    headerView.sellCnt.text = "已售:" + goodsDetailInfomation.data.TotalSales//显示总销量
                    headerView.price.text = "￥" + goodsDetailInfomation.getPriceRange().priceRange
                    headerView.scrollViewImg.imageURLStringsGroup = [ goodsDetailInfomation.getPriceRange().pictureURL]
                    var imgUrl = goodsDetailInfomation.getPriceRange().pictureURL
                    NSLog("imgUrl = \(imgUrl)")
                    
                    headerView.stock = ""
                }
                
                reusableview = headerView
            }else{
                var headerView = GoodsPropertysSectionView()
                headerView = colltionView!.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "propertys", forIndexPath: indexPath) as! GoodsPropertysSectionView
                
                var shuXing = self.goodsDetailInfomation.data.propertys[indexPath.section - 1].propertyOptions[indexPath.row].title
                
                headerView.shuXingName.text = goodsDetailInfomation.data.propertys[indexPath.section - 1].propertyTitle +  ":" + shuXing
                
                
                
                reusableview = headerView
            }
            
        }
        
        if UICollectionElementKindSectionFooter == kind{
            var cnt = goodsDetailInfomation.numberOfSections()
            if indexPath.section == (cnt - 1) {
            var footerView = Home_FooterView()
            footerView = colltionView!.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footerView", forIndexPath: indexPath) as! Home_FooterView
            
            footerView.shopName.text = goodsDetailInfomation.shopNameAddressTel().shopName
            footerView.shopTel.text = goodsDetailInfomation.shopNameAddressTel().tel
            footerView.shopAddress.text = goodsDetailInfomation.shopNameAddressTel().address
            
            var (flag,content) = goodsDetailInfomation.shangJiaHuoDong()
                if flag {
                    footerView.shangJiaHuoDong.text = content
                    footerView.huoDongImg.hidden = false
                }else{
                    footerView.shangJiaHuoDong.text = ""
                    footerView.huoDongImg.hidden = true
                }
            
                
            footerView.initWithClosure(goodsCount)
            
            if goodsDetailInfomation.selectGuiGeName != "" {
                
                footerView.stock = goodsDetailInfomation.getStockFromGuiGe(goodsDetailInfomation.selectGuiGeName)
            }
            
            reusableview = footerView
            }else{
                var footer = GoodsPropertysSectionViewFooter()
                footer = colltionView!.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footer", forIndexPath: indexPath) as! GoodsPropertysSectionViewFooter
                reusableview = footer
            }
        }
        return reusableview
    }
    //返回cell 上下左右的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        var w = screenWith/8
        return UIEdgeInsetsMake(2, 5, 2, 5)
    }
    
    
    
    //闭包回调函数(选中了几个商品)
    func goodsCount(price:String,count:String) ->Void {
        NSLog("闭包回调函数(选中了几个商品) = \(count)")
        if price == "加载html" {
            loadHTML()
        }else{
            goodsDetailInfomation.goodsNums = count
        }
    }
    
    //加载HTML文件
    func loadHTML(){
        var goodsHtml = GoodsHTML()
        goodsHtml.content = goodsDetailInfomation.data.details
        self.navigationController?.pushViewController(goodsHtml, animated: false)
    }
    
    
    
    /**
    捕获当前页面
    
    - returns: return value description
    */
    func captureImage()->UIImage{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    
    //闭包回调函数(选中的商品规格)
    func goodsOption(option:String) ->Void {
        NSLog("选择的商品的规格是：\(option)")
        goodsDetailInfomation.selectGuiGeFlag = true
        goodsDetailInfomation.selectGuiGeName = option
        self.colltionView.reloadData()
    }
    
    
    //闭包回调函数(选中的商品规格)
    func suXingOption(option:String) ->Void {
        NSLog("选择的商品的属性是：\(option)")
        //属性暂时不需要选择
        //var (no,row) = goodsDetailInfomation.positionOfShuXingFlagByShuXing(option)
        //setShuXingSelectedFlag(no, row: row)//修改选中标记
        //self.colltionView.reloadData()
    }
    
    /**
    修改选中属性标记
    
    - parameter no:  属性名称的位置
    - parameter row: 对应属性名称下的信息属性序号
    */
    func setShuXingSelectedFlag(no:Int,row:Int){
        for var i = 0 ; i < goodsDetailInfomation.data.propertys[no].propertyOptions.count ; i++ {
            goodsDetailInfomation.data.propertys[no].propertyOptions[i].selectedFlag = false
        }
        goodsDetailInfomation.data.propertys[no].propertyOptions[row].selectedFlag = true
    }
    
    //添加到购物车
    func addToShoppingCartBtnClk(){
        NSLog("添加商品到购物车")
        //1、根据规格找出价格
        
        NSLog("userid = \(currentRoleInfomation.keyid)")
        
        
        if goodsDetailInfomation.selectGuiGeName != "" {//规格选中了
            var (MerchantPriceID:String,Productname:String,nums:String,imgurl:String) = goodsDetailInfomation.getNessaryInfoForBuy(goodsDetailInfomation.selectGuiGeName)
            
            let parameters = [
                
                "usertype":"1",//买家类别(1:商家;2:普通消费者)
                "userid":currentRoleInfomation.keyid,//买家编号
                "shopID":goodsDetailInfomation.data.adminKeyID,//卖家编号
                "MerchantPriceID": MerchantPriceID,//卖家-产品价格 ID
                "Productname":Productname,//产品名称
                "nums":nums,//数量
                "imgurl": imgurl, //产品图片
                "PropertyNames":goodsDetailInfomation.selectGuiGeName //商品规格名称
            ]
            let data = JSON(parameters)
            let dataString = data.description
            let para = ["cartinfo":dataString]
            var url  = serversBaseURL + "/shoppingcart/addcart"
            NSLog("para = \(para.description)")
            
            if netIsavalaible {
            ProgressHUD.show("")
            Alamofire.request(.POST,url,parameters: para).responseString{ (request, response, data, error) in
                NSLog("data = \(data)")
                
                ProgressHUD.dismiss()
                var json = StringToJSON(data!)
                var message = json["message"].stringValue
                if json["success"].stringValue ==  "false" {
                    
                    var alert = UIAlertView(title: "提示", message:message , delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }else{
                    //ProgressHUD.showSuccess(message)
                    showMessageAnimate(self.navigationController!.view, message)
                }
                
                refreshGouWuCheBadgeValue(self.tabBarController!)
            }
            }else{
                netIsEnable("网络不可用")
            }
            
        }else{
            var alert = UIAlertView(title: "提示", message:"请选择商品规格" , delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
        
        
        
        
        
        
    }
    
    
}


//宏定义闭包
typealias sendValueClosure=(price:String,count:String)->Void


//宏定义闭包（规格）
typealias optionsClosure=(option:String)->Void

//宏定义闭包（属性）
typealias suXingClosure=(option:String)->Void

//商品属性头
class GoodsPropertysSectionView: UICollectionReusableView {
    var shuXingName = UILabel()
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        
        var spareLine1 = UIView()
        spareLine1.frame = CGRect(x: 0, y: 0, width: screenWith, height: 1 )
        spareLine1.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        shuXingName.frame = CGRect(x: 2, y: spareLine1.frame.maxY + 10, width: 240, height: 30 )
        
        self.addSubview(shuXingName)
        
        self.addSubview(spareLine1)
    }
}
//商品属性尾
class GoodsPropertysSectionViewFooter: UICollectionReusableView {
    var title = ""
}

//商品详情头部
class GoodsHeaderView:UICollectionReusableView{
    
    //针对单个商品的活动信息
    var huoDongInfo = UILabel()
    
    var title = UILabel()       //商品名称
    var sellCnt = UILabel()     //销量
    var price = UILabel()       //价格
    //滚动广告轮播视图
    var guiGe = UILabel()       //商品规格
    
    var spareLine0 = UIView()
    var spareLine1 = UIView()
    
    var stock = "" {//库存数量
        didSet{
            stockShow.text =  stock
        }
    }
    
    
    var stockShow = UILabel() //商品库存显示
    
    var scrollViewImg : SDCycleScrollView! = SDCycleScrollView(frame:CGRect(x: 0, y: 0, width: Int(width), height: Int(width)), imageURLStringsGroup: nil)
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!){
        self.addSubview(title)
        self.addSubview(sellCnt)
        self.addSubview(stockShow)
        self.addSubview(price)
        self.addSubview(guiGe)
        self.addSubview(scrollViewImg)
        self.addSubview(spareLine0)
        self.addSubview(spareLine1)
        self.addSubview(huoDongInfo)
        
        /**
        *  设置滚动视图的背景颜色
        *
        *  @param .redColor 
        *
        *  @return 小圆点图片
        */
        scrollViewImg.backgroundColor = UIColor.whiteColor()
        scrollViewImg.dotColor = UIColor.redColor()
        
        scrollViewImg.showPageControl = false
        
        title.frame = CGRect(x: 2, y: scrollViewImg.frame.maxY + 5, width: screenWith - 5, height: 30 )
        sellCnt.frame = CGRect(x: 5, y: title.frame.maxY + 10, width: 100, height: 30 )
        sellCnt.font  = UIFont.systemFontOfSize(14)
        sellCnt.textColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1)
        
        stockShow.frame = CGRect(x: sellCnt.frame.maxX + 10, y: title.frame.maxY + 10, width: 240, height: 30 )
        stockShow.font  = UIFont.systemFontOfSize(14)
        stockShow.textColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1)
        
        price.frame = CGRect(x: screenWith - 200, y: title.frame.maxY + 10, width: 195, height: 30 )
        price.font = UIFont.systemFontOfSize(18)
        price.textAlignment = NSTextAlignment.Right
        price.textColor = UIColor.redColor()
        
        spareLine0.frame = CGRect(x: 0, y: scrollViewImg.frame.maxY , width: screenWith, height: 1 )
        spareLine0.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        
        spareLine1.frame = CGRect(x: 0, y: sellCnt.frame.maxY + 10, width: screenWith, height: 1 )
        spareLine1.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        guiGe.frame = CGRect(x: 2, y: spareLine1.frame.maxY + 10, width: 240, height: 30 )
        
        
        huoDongInfo.textAlignment = NSTextAlignment.Left
        huoDongInfo.backgroundColor = UIColor.clearColor()
        huoDongInfo.font = UIFont.systemFontOfSize(14)
        huoDongInfo.textColor = UIColor.redColor()
        huoDongInfo.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(scrollViewImg.snp_left).offset(10)
            make.right.equalTo(scrollViewImg.snp_right).offset(-10)
            make.bottom.equalTo(scrollViewImg.snp_bottom)
            make.height.equalTo(30)
        }
        
    }
    
    
}



//Home_FooterView
class Home_FooterView: UICollectionReusableView,UITextFieldDelegate {
    
    //声明一个闭包
    private var myClosure:sendValueClosure!
    //下面这个方法需要传入上个界面的postMessage函数指针
    func initWithClosure(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了postMessage函数中的局部变量等的引用
        myClosure = closure
    }
    
    var erroCharaterCnt = 0
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        NSLog("string = \(string)")
        switch(string){
            case "0","1","2","3","4","5","6","7","8","9","":
                break;
            default:
                NSLog("character = \(string)")
                erroCharaterCnt++
                //numTextField.text = "1"
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        NSLog("输入完成了")
        if erroCharaterCnt == 0 {
        if stock != "" {
            if numTextField.text.length != 0 {
                var cnt = NSNumberFormatter().numberFromString(numTextField.text)!.integerValue
                if cnt == 0 {
                    cnt = 1
                    
                }else{
                    
                }
                
                
                
                //库存检测
                if cnt > NSNumberFormatter().numberFromString(stock)!.integerValue {
                    cnt = NSNumberFormatter().numberFromString(stock)!.integerValue
                    var alert = UIAlertView(title: "提示", message: "该商品最大库存为\(stock)", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }else{
                    
                }
                
                numTextField.text = cnt.description
                
                if myClosure != nil {
                    myClosure!(price: "", count: cnt.description)
                }else{
                    NSLog("传值有错误")
                }
            }else{
                if myClosure != nil {
                    myClosure!(price: "", count: "1")
                }
                numTextField.text = "1"
                
            }
        }else{
            numTextField.text = "1"
            var alert = UIAlertView(title: "提示", message: "请先选中规格", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        }else{
            var alert = UIAlertView(title: "提示", message: "请输入数字量", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            numTextField.text = "1"
            erroCharaterCnt = 0
        }
    }
    
    
    /**
    修改了商品数量
    */
    
    //减少数量
    func subNum(){
        NSLog("减数量")
        if stock != "" {
            if numTextField.text.length != 0 {
                var cnt = NSNumberFormatter().numberFromString(numTextField.text)!.integerValue
                cnt--
                if cnt == 0 {
                    cnt = 1
                    
                }else{
                    
                }
                
                
                
                //库存检测
                if cnt > NSNumberFormatter().numberFromString(stock)!.integerValue {
                    cnt = NSNumberFormatter().numberFromString(stock)!.integerValue
                    
                }else{
                    
                }
                
                numTextField.text = cnt.description
                
                if myClosure != nil {
                    myClosure!(price: "", count: cnt.description)
                }else{
                    NSLog("传值有错误")
                }
            }else{
                if myClosure != nil {
                    myClosure!(price: "", count: "1")
                }
                numTextField.text = "1"
            }
        }else{
            var alert = UIAlertView(title: "提示", message: "请先选中规格", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
    }
    //增加数量
    func addNum(){
        NSLog("加数量")
        if stock != "" {
            if numTextField.text.length != 0 {
                var cnt = NSNumberFormatter().numberFromString(numTextField.text)!.integerValue
                cnt++
                
                if cnt == 0 {
                    cnt = 1
                    
                }else{
                    
                }
                
                
                //库存检测
                if cnt > NSNumberFormatter().numberFromString(stock)!.integerValue {
                    cnt = NSNumberFormatter().numberFromString(stock)!.integerValue
                    
                }else{
                    
                }
                
                numTextField.text = cnt.description
                
                if myClosure != nil {
                    myClosure!(price: "", count: cnt.description)
                }else{
                    NSLog("传值有错误")
                }
                
            }else{
                if myClosure != nil {
                    myClosure!(price: "", count: "1")
                }
                numTextField.text = "1"
            }
        }else{
            var alert = UIAlertView(title: "提示", message: "请先选中规格", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    var spareLine0 = UIView()
    var spareLine02 = UIView()
    var spareLine03 = UIView()
    
    var spareLine04 = UIView()
    
    
    var stock = ""//库存数量
    
    
    //    //打电话功能
    //    func callBtnClk(){
    //        var url1 = NSURL(string: "tel://\(tel.text)")
    //        //UIApplication.sharedApplication().openURL(url1!)
    //    }
    
    
    var buyTitle = UILabel()
    var numTextField = UITextField()
    var btnContainerView = UIView()
    
    var shopInfo = UILabel()
    var shopName = UILabel()
    var shopTel = UILabel()
    var shopAddress = UILabel()
    //商家活动内容显示
    var shangJiaHuoDong = UILabel()
    //商家活动小喇叭图片
    var huoDongImg = UIImageView()
    var dianPuImg = UIImageView()
    var telImg = UIImageView()
    var addressImg = UIImageView()
    
    var seeMoreBtn = UIButton()
    
    var leftBtn = UIButton()
    var rightBtn = UIButton()
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!){
        
        
        spareLine0.frame = CGRect(x: 0, y: 10 , width: screenWith, height: 1 )
        spareLine0.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        self.addSubview(spareLine0)
        
        
        buyTitle.frame = CGRect(x: 0, y: spareLine0.frame.maxY + 10, width: 100, height: 30 )
        buyTitle.text = "购买数量:"
        buyTitle.font = UIFont.systemFontOfSize(14)
        buyTitle.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        buyTitle.textAlignment = NSTextAlignment.Center
        self.addSubview(buyTitle)
        
        /**************************************************/
        //替代stepperView
        btnContainerView = UIView(frame: CGRect(x: buyTitle.frame.maxX , y: 22, width: 110, height: 30))
        leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        
        rightBtn = UIButton(frame: CGRect(x: 70, y: 0, width: 40, height: 30))
        
        
        numTextField  = UITextField(frame: CGRect(x: 35, y: 0, width: 40, height: 30))
        numTextField.delegate = self
        numTextField.text = "1"
        numTextField.keyboardType = UIKeyboardType.NumberPad
        numTextField.textAlignment = NSTextAlignment.Center
        numTextField.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        
        var leftImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        leftImg.image = UIImage(named: "3213213213")
        var rightImg = UIImageView(frame: CGRect(x: 75, y: 0, width: 35, height: 30))
        rightImg.image = UIImage(named: "321321321")
        
        btnContainerView.addSubview(leftBtn)
        btnContainerView.addSubview(rightBtn)
        btnContainerView.addSubview(numTextField)
        
        btnContainerView.addSubview(leftImg)
        btnContainerView.addSubview(rightImg)
        
        btnContainerView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 243/255, alpha: 1)
        
        //数量减
        leftBtn.addTarget(self, action: Selector("subNum"), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.addTarget(self, action: Selector("addNum"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btnContainerView)
        /**************************************************/
        
        
        spareLine02.frame = CGRect(x: 0, y: rightBtn.frame.maxY + 38 , width: screenWith, height: 1 )
        spareLine02.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        self.addSubview(spareLine02)
        
        
        shopInfo.frame = CGRect(x: 2, y: spareLine02.frame.maxY + 5, width: 100, height: 30 )
        shopInfo.text = "商家介绍"
        //shopInfo.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        shopInfo.textAlignment = NSTextAlignment.Left
        self.addSubview(shopInfo)
        
        spareLine03.frame = CGRect(x: 0, y: shopInfo.frame.maxY , width: screenWith, height: 1 )
        spareLine03.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        self.addSubview(spareLine03)
        
        
        /********************************/
        shopName.frame = CGRect(x: 18, y: spareLine03.frame.maxY + 5 , width: screenWith, height: 21 )
        shopName.textAlignment = NSTextAlignment.Left
        shopTel.frame = CGRect(x: 18, y: shopName.frame.maxY , width: screenWith, height: 21 )
        shopTel.textAlignment = NSTextAlignment.Left
        shopAddress.frame = CGRect(x: 18, y: shopTel.frame.maxY , width: screenWith, height: 21 )
        shopAddress.textAlignment = NSTextAlignment.Left
        self.addSubview(shopName)
        self.addSubview(shopTel)
        self.addSubview(shopAddress)
        shopName.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        shopTel.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        shopAddress.textColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        
        shopName.font = UIFont.systemFontOfSize(14)
        shopTel.font = UIFont.systemFontOfSize(14)
        shopAddress.font = UIFont.systemFontOfSize(14)
        
        
//        spareLine04.frame = CGRect(x: 0, y: shopAddress.frame.maxY + 20 , width: screenWith, height: 1 )
//        spareLine04.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
//        self.addSubview(spareLine04)
        
        //添加商家活动显示
        self.addSubview(shangJiaHuoDong)
        shangJiaHuoDong.font = UIFont.systemFontOfSize(14)
        shangJiaHuoDong.textColor = UIColor.redColor()
        
        
        /*************************************************/
        self.addSubview(dianPuImg)
        dianPuImg.image = UIImage(named: "detailPageShop")
        dianPuImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(spareLine03.snp_bottom).offset(10)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        shopName.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(dianPuImg.snp_right).offset(8)
            make.centerY.equalTo(dianPuImg.snp_centerY)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(28)
        }
        
        /*************************************************/
        self.addSubview(telImg)
        telImg.image = UIImage(named: "detailPageTel")
        telImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(dianPuImg.snp_bottom).offset(3)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        shopTel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(telImg.snp_right).offset(8)
            make.centerY.equalTo(telImg.snp_centerY)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(28)
        }
        /*************************************************/
        self.addSubview(addressImg)
        addressImg.image = UIImage(named: "detailPageAddress")
        addressImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(telImg.snp_bottom).offset(3)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        shopAddress.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(addressImg.snp_right).offset(8)
            make.centerY.equalTo(addressImg.snp_centerY)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(28)
        }
        /*************************************************/
        
        
        self.addSubview(huoDongImg)
        huoDongImg.image = UIImage(named: "detailPageShopSay")
        huoDongImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(addressImg.snp_bottom).offset(3)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        shangJiaHuoDong.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(huoDongImg.snp_right).offset(8)
            make.centerY.equalTo(huoDongImg.snp_centerY)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(28)
        }
        /*************************************************/
        
//        seeMoreBtn.frame = CGRect(x: 0, y: spareLine04.frame.maxY + 10, width: screenWith, height: 21 )
//        seeMoreBtn.setTitle("点击查看更多", forState: UIControlState.Normal)
//        seeMoreBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        //seeMoreBtn.backgroundColor = UIColor.redColor()
//        seeMoreBtn.addTarget(self, action: Selector("seeMoreBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
//        self.addSubview(seeMoreBtn)
        
    }
    
    func seeMoreBtnClk(){
        NSLog("加载网络HTML数据")
        
        "加载html"
        
        if myClosure != nil {
            myClosure!(price: "加载html", count: "")
        }else{
            NSLog("传值有错误")
        }
        
    }
    
    
}


//产品属性cell
class GoodsSuXingCell:UICollectionViewCell{
    
    //选中标记
    var selectFlag = false {
        didSet{
            if selectFlag {
                self.layer.borderColor = UIColor(red: 251/255, green: 51/255, blue: 0/255, alpha: 1.0).CGColor
            }else{
                self.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0).CGColor
            }
        }
    }
    
    var suXing = UILabel()
    var button = UIButton()
    //声明一个闭包
    private var myClosure:suXingClosure?
    //下面这个方法需要传入上个界面的postMessage函数指针
    func initWithClosure(closure:suXingClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了postMessage函数中的局部变量等的引用
        myClosure = closure
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //初始控件
        //suXing = UILabel(frame: CGRect(x:0, y: 0, width: self.frame.width, height: 35))
        suXing = UILabel(frame: CGRect(x:0, y: 0, width: self.frame.width, height: 1))
        suXing.numberOfLines = 1
        suXing.textAlignment = NSTextAlignment.Center
        suXing.font = UIFont.systemFontOfSize(14)
        suXing.textColor = UIColor.blackColor()
        self.addSubview(suXing)
        
        //self.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0).CGColor//UIColor(red: 251/255, green: 51/255, blue: 0/255, alpha: 1.0).CGColor
        //self.layer.borderWidth = CGFloat(1)
        self.layer.cornerRadius = 2
        
        
        button.frame = suXing.frame
        button.addTarget(self, action: Selector("btnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        
        //self.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func btnClk(){
        //采用闭包传值
        NSLog("用户选择的属性是： \(suXing.text)")
        //判空
        if ( myClosure != nil){
            NSLog("闭包回调...")
            myClosure!(option: suXing.text!)
            
        }
    }
    
}
//产品规格cell
class Home_Cell: UICollectionViewCell {
    
    func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        var attributes = [NSFontAttributeName: font]
        var option = NSStringDrawingOptions.UsesLineFragmentOrigin
        var rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        //        println("rect:\(rect)");
        return rect;
    }
    
    var goodsSpecification : UILabel!
    
    var button = UIButton()
    
    //选中标记
    var selectFlag = false {
        didSet{
           
                //计算宽度
                var size = getTextRectSize(goodsSpecification.text!, font: UIFont.systemFontOfSize(14), size: CGSize(width:screenWith - 10, height: 60) )
                goodsSpecification.frame.size.width = size.size.width + 20
            
            
            if selectFlag {
                self.goodsSpecification.layer.borderColor = UIColor(red: 251/255, green: 51/255, blue: 0/255, alpha: 1.0).CGColor
                self.goodsSpecification.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
            }else{
                self.goodsSpecification.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0).CGColor
                self.goodsSpecification.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    //声明一个闭包
    private var myClosure:optionsClosure?
    //下面这个方法需要传入上个界面的postMessage函数指针
    func initWithClosure(closure:optionsClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了postMessage函数中的局部变量等的引用
        myClosure = closure
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //初始控件
        goodsSpecification = UILabel(frame: CGRect(x:20, y: 0, width: self.frame.width, height: 30))
        goodsSpecification.numberOfLines = 1
        goodsSpecification.textAlignment = NSTextAlignment.Center
        goodsSpecification.font = UIFont.systemFontOfSize(14)
        goodsSpecification.numberOfLines = 0
        goodsSpecification.textColor = UIColor.blackColor()
        self.addSubview(goodsSpecification!)
        
        self.goodsSpecification.layer.borderColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0).CGColor//UIColor(red: 251/255, green: 51/255, blue: 0/255, alpha: 1.0).CGColor
        self.goodsSpecification.layer.borderWidth = CGFloat(0.5)
        self.goodsSpecification.layer.cornerRadius = 15
        self.goodsSpecification.layer.masksToBounds = true
        
        button.frame = goodsSpecification.frame
        button.addTarget(self, action: Selector("btnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        //self.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        
    }
    
    
    func btnClk(){
        //采用闭包传值
        NSLog("用户选择的规格是： \(goodsSpecification.text)")
        //判空
        if ( myClosure != nil){
            NSLog("闭包回调...")
            myClosure!(option: goodsSpecification.text!)
            
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
