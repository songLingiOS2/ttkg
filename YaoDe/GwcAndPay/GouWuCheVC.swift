//
//  GouWuCheVC.swift
//  YaoDe
//
//  Created by iosnull on 16/3/18.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

//单个商家下的所有产品信息
struct ShopAndGoodsInfo {
    var shopid = ""
    var shopname = ""
    var shopImg = ""
    var lists = [List]()
    var carryingamount = ""//起配金额
    
    //商家活动
    var GiveMsg = ""       //赠品信息
    var IsGivestate = ""
    
    var formatter = ""
    var givebase = ""
    var giftQuota = ""
    
    //选中该商家下的所有商品
    var selectThisShop = true
}

struct List {
    var cartid = ""
    var productname = ""
    var price = ""
    var imgurl = ""
    var nums = ""
    
    //商品活动
    var GiveMsg = ""       //赠品信息
    var IsGivestate = ""
    
    
    //选中该商品
    var selectThisGood = true
}

//购物车模型
struct  GouWuCheModel{
    var shopGoodsInfo = [ShopAndGoodsInfo]()
    var success = ""
    var status = ""
    var message = ""
    //对所有商家全选标记
    var selectAllShopsGoods = true
    
    
    func merchantHuodongGift(section:Int,price:Double) -> String{
        
        var shopGoodTemp = shopGoodsInfo[section]
        var formatterTemp = shopGoodTemp.formatter
        var givebaseTemp = NSNumberFormatter().numberFromString(shopGoodTemp.givebase)!.doubleValue
        
        var count = 0
        if shopGoodTemp.IsGivestate == "0" {
            count = Int(price/givebaseTemp)
            
            
            NSLog("count\(count)")
            var priceTemp = String(format: "%.2f", price)
            
            //去掉空格
            formatterTemp = formatterTemp.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            NSLog("formatterTemp = \(formatterTemp)")
            
            formatterTemp = formatterTemp.stringByReplacingOccurrencesOfString("[price]", withString: "\(priceTemp)", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            if count == 1 {
                formatterTemp = formatterTemp.stringByReplacingOccurrencesOfString("[count]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }else{
                formatterTemp = formatterTemp.stringByReplacingOccurrencesOfString("[count]", withString: "\(count)*", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            
            
            
            if count > 0 {
                return formatterTemp
            }else{
                return ""
            }
            
        }else{
            return ""
        }
        
        
    }
    
    /**
    获取所有选中商品的商品价格
    
    - returns: return value description
    */
    func allGoodsPrice()->Double{
        var allPrice = 0.0
        
        for var i = 0 ; i < shopGoodsInfo.count ; i++ {
            allPrice += allSelectedGoodsPriceAtThisShop(i)
        }
        
        return allPrice
    }
    
    
    //购物车里所有商家下选中的商品carid
    func allShopCarID()->String{
        var carId = [String]()
        for var i = 0 ; i < shopGoodsInfo.count ; i++ {
            var ids = selectShopAllCarID(i)
            carId.append(ids)
        }
        
        var returnString = ""
        for var j = 0 ; j < carId.count ; j++ {
            if j == 0 {
                returnString = carId[j]
            }else{
                var t = "," + carId[j]
                returnString += t
            }
            
        }
        
        return returnString
        
    }
    
    //当前商家下选中商品的carid
    func selectShopAllCarID(section:Int)->String{
        var lists:[List] =  shopGoodsInfo[section].lists
        var allCarID = [String]()
        
        for var i = 0 ; i < lists.count ; i++ {
            var temp = ""
            if lists[i].selectThisGood {//被选中的
                allCarID.append(lists[i].cartid)
                
            }
            
        }
        
        var returnString = ""
        for var j = 0 ; j < allCarID.count ; j++ {
            if j == 0 {
                returnString = allCarID[j]
            }else{
                var t = "," + allCarID[j]
                returnString += t
            }
            
        }
        
        return returnString
    }
    
    
    /**
    当前商家下被选中的商品的总价
    
    - parameter section: section description
    
    - returns: return value description
    */
    func allSelectedGoodsPriceAtThisShop(section:Int)->Double{
        var lists:[List] =  shopGoodsInfo[section].lists
        var totalPrice = 0.0
        for var i = 0 ; i < lists.count ; i++ {
            if lists[i].selectThisGood {//被选中的
                var price = NSNumberFormatter().numberFromString(lists[i].price)!.doubleValue //单价
                var num = NSNumberFormatter().numberFromString(lists[i].nums)!.doubleValue //数量
                totalPrice += price*num
            }
            
        }
        
        return totalPrice
    }
    
    /**
    商家下单个商品的价格（单价*数量）
    
    - parameter section: section description
    - parameter Row:     Row description
    
    - returns: return value description
    */
    func goodsPriceAtSection(indexPath:NSIndexPath)->Double{
        
        
        var valueTemp =  shopGoodsInfo[indexPath.section].lists[indexPath.row].price
        var numTemp = shopGoodsInfo[indexPath.section].lists[indexPath.row].nums
        
        var price = NSNumberFormatter().numberFromString(valueTemp)!.doubleValue //单价
        var num = NSNumberFormatter().numberFromString(numTemp)!.doubleValue //数量
        return price*num
    }
    
    /**
    是否选中了所有商家的所有商品
    */
    func  selectAllGoods()->Bool{
        var cnt = 0
        var goodsCntOfAllShop = 0
        for var j = 0 ; j < shopGoodsInfo.count ; j++ {
            goodsCntOfAllShop += shopGoodsInfo[j].lists.count //对应商家下的所有商品
            
            for var i = 0 ; i < shopGoodsInfo[j].lists.count; i++ {
                if shopGoodsInfo[j].lists[i].selectThisGood == true {
                    cnt++  //对应商家下的所有被选中的商品
                }
                
            }
        }
        NSLog("cnt = \(cnt) goodsCntOfAllShop = \(goodsCntOfAllShop) ")
        return cnt == goodsCntOfAllShop
    }
    
    //获取第几个商家下面所有的商品价格并判断是否达到起配金额
    func allPriceAtThisShop(section:Int)->(condition:Double,allPrice:Double,reach:Bool){
        var lists:[List] =  shopGoodsInfo[section].lists
        var totalPrice = 0.0
        var reachFlag = true
        var condition = NSNumberFormatter().numberFromString(shopGoodsInfo[section].carryingamount)!.doubleValue
        
        NSNumberFormatter().numberFromString(shopGoodsInfo[section].carryingamount)!.doubleValue
        for var i = 0 ; i < lists.count ; i++ {
            var price = NSNumberFormatter().numberFromString(lists[i].price)!.doubleValue //单价
            var num = NSNumberFormatter().numberFromString(lists[i].nums)!.doubleValue //数量
            totalPrice += price*num
        }
        
        if totalPrice >= condition {
            reachFlag = true
        }else{
            reachFlag = false
        }
        
        return (condition,totalPrice,reachFlag)
    }
    
    //获取第几个商家的第几个商品的图片
    func goodImgOfSection(section:Int,row:Int)->String{
        var imgURL = self.shopGoodsInfo[section].lists[row].imgurl
        return imgURL
    }
    
    //获取商家名称
    func shopname()->[String]{
        var shopnames = [String]()
        for var  i = 0 ;  i < shopGoodsInfo.count ; i++ {
            var shopname = shopGoodsInfo[i].shopname
            NSLog("有商家名字叫：\(shopname)")
            shopnames.append(shopname)
        }
        return shopnames
    }
    
    //获取对应商家下的商品
    func listArry(name:String)->[List]{
        var lists = [List]()
        var shopnames:[String] = shopname()
        for var i = 0 ; i < shopnames.count ; i++ {
            if name == shopnames[i] {
                lists = shopGoodsInfo[i].lists//获取到对应商家下的list数组
                //NSLog("lists.cnt = \(lists.count)")
                for item in lists{
                    NSLog("item = \(name)")
                }
                
            }
        }
        return lists
    }
    
    func listCntOfShop(cnt:Int)->Int{
        var shopsName:[String] = shopname()
        var list:[List] = listArry(shopsName[cnt])
        return list.count
    }
    
    //获取所有商家起配信息
    func shopsStartingInfoAtSection(section:Int)->String{
        return self.shopGoodsInfo[section].carryingamount
    }
    
}
//字符串转JSON
func StringToJSON(sender:String)->JSON{
    
    var resultData = sender as! NSString
    
    if let dataFromString = resultData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
        let json = JSON(data:dataFromString)
        
        return json
    }else{
        return nil
    }
    
}



class GouWuCheVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var pushed = false //被push过来？
    //底部去结算视图
    var bottomContainerView = UIView()
    var selectAllShopsGoodsBtn = UIButton()
    var totalPrice = UILabel()
    
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        var img = UIImage(named: "empty")
        return img
    }
    
    
    /**
    全选所有商家的所有商品
    */
    func selectAllShopsGoodsBtnClk(){
        //全选就让全部选中
        var selectCnt = 0
        for var j = 0 ; j < gouWuCheModel.shopGoodsInfo.count ; j++ {
            gouWuCheModel.shopGoodsInfo[j].selectThisShop = true
            for var i = 0 ; i < gouWuCheModel.shopGoodsInfo[j].lists.count; i++ {
                gouWuCheModel.shopGoodsInfo[j].lists[i].selectThisGood = true
                NSLog("**********")
            }
        }
        selectAllShopsGoodsBtn.setImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        self.tableView.reloadData()
    }
    
    /**
    是否所有商品被选中了
    */
    func checkSelectAllGoods(){
        if gouWuCheModel.selectAllGoods(){
            selectAllShopsGoodsBtn.setImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        }else{
            selectAllShopsGoodsBtn.setImage(UIImage(named: "che_nor"), forState: UIControlState.Normal)
        }
    }
    
    //购物车模型
    var gouWuCheModel = GouWuCheModel(){
        didSet{
            showAllGoodsPrice()
            self.tableView.reloadData()
        }
    }
    
    func JSON_ToModel(json:JSON) ->GouWuCheModel{
        var gouWuCheModel = GouWuCheModel()
        gouWuCheModel.status = json["status"].stringValue
        gouWuCheModel.success = json["success"].stringValue
        gouWuCheModel.message = json["message"].stringValue
        
        var shopAndGoodsInfos = [ShopAndGoodsInfo]()
        
        if gouWuCheModel.success == "true" {
            
            var dataTemp = json["data"]
            
            NSLog("dataTemp = \(dataTemp.description)")
            
            for var i = 0 ; i < dataTemp.count ; i++ {
                var shopAndGoodsInfo = ShopAndGoodsInfo()
                var shopAndGoodsInfoTemp = dataTemp[i]
                
                shopAndGoodsInfo.shopid = shopAndGoodsInfoTemp["shopid"].stringValue
                NSLog("shopAndGoodsInfo.shopid = \(shopAndGoodsInfo.shopid)")
                shopAndGoodsInfo.shopname = shopAndGoodsInfoTemp["shopname"].stringValue
                shopAndGoodsInfo.carryingamount = shopAndGoodsInfoTemp["carryingamount"].stringValue
                shopAndGoodsInfo.lists = getList(shopAndGoodsInfoTemp["list"])
                shopAndGoodsInfo.shopImg = shopAndGoodsInfoTemp["pic"].stringValue
                
                //商家活动
                shopAndGoodsInfo.GiveMsg = shopAndGoodsInfoTemp["GiveMsg"].stringValue       //赠品信息
                shopAndGoodsInfo.IsGivestate = shopAndGoodsInfoTemp["IsGivestate"].stringValue
                
                
                
                shopAndGoodsInfo.formatter = shopAndGoodsInfoTemp["formatter"].stringValue
                shopAndGoodsInfo.givebase = shopAndGoodsInfoTemp["givebase"].doubleValue.description
                shopAndGoodsInfo.giftQuota = shopAndGoodsInfoTemp["giftQuota"].stringValue
                
                shopAndGoodsInfos.append(shopAndGoodsInfo)
            }
            
        }
        NSLog("shopAndGoodsInfos = \(shopAndGoodsInfos.description)")
        gouWuCheModel.shopGoodsInfo = shopAndGoodsInfos
        NSLog("gouWuCheModel = \(gouWuCheModel)")
        return gouWuCheModel
    }
    
    func getList(json:JSON)->[List]{
        var lists = [List]()
        var listsTemp = json//json["list"]
        
        NSLog("listsTemp = \(listsTemp)")
        
        for var i = 0 ;  i < listsTemp.count ; i++ {
            var listTemp = listsTemp[i]
            var list = List()
            list.cartid = listTemp["cartid"].stringValue
            list.productname = listTemp["productname"].stringValue
            list.price = listTemp["price"].doubleValue.description
            list.imgurl = listTemp["imgurl"].stringValue
            list.nums = listTemp["nums"].stringValue
            
            //商品活动
            list.GiveMsg = listTemp["GiveMsg"].stringValue
            list.IsGivestate = listTemp["IsGivestate"].stringValue
            
            lists.append(list)
        }
        return lists
    }
    
    //获取数据
    func getDataUsertype(usrType:String,userid:String){
        let url = serversBaseURL + "/shoppingcart/cartlist"
        //filter={"adminkeyid":"11","productkeyid":"8"}
        
        let parameters = ["usertype":usrType,"userid":userid]
        
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
            
            Alamofire.request(.GET,url,parameters: para).responseString{ (request, response, data, error) in
                
                self.tableView.mj_header.endRefreshing()
                ProgressHUD.dismiss()
                var json = StringToJSON(data!)
                NSLog("json = \(json)")
                var message = json["message"].stringValue
                if json["success"].stringValue == "true" {//有数据
                    self.gouWuCheModel = self.JSON_ToModel(json)
                    
                    ProgressHUD.showSuccess(message)
                    
                    
                    
                }else{//无数据
                    //ProgressHUD.showError(message)
                    ProgressHUD.dismiss()
                    var temp  = GouWuCheModel()
                    self.gouWuCheModel = temp
                    
                }
                
                
                
            }
        }else{
            self.tableView.mj_header.endRefreshing()
            netIsEnable("网络不可用")
        }
        
    }
    //无数据时显示背景
    //    var emptyView:UIView?
    //无数据时添加该按钮
    var emptyButton:UIButton?
    
    var tableView = UITableView()
    
    func pullDownRefresh(){
        if netIsavalaible {
            getDataUsertype("1", userid: currentRoleInfomation.keyid)
        }else{
            netIsEnable("网络不可用")
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.separatorInset = UIEdgeInsetsZero //设置分割线没有内容边距
        self.tableView.layoutMargins = UIEdgeInsetsZero //清空默认布局边距
        
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        self.edgesForExtendedLayout = UIRectEdge.Top
        tableView.frame = CGRect(x: 0, y: 64, width: screenWith , height: screenHeight - 152)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.tableFooterView = UIView() //去除多余的分割线显示
        
        self.tableView.registerClass(GouWuCheCell.self, forCellReuseIdentifier: "cell")
        
        
        
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        
        self.view.addSubview(tableView)
        self.automaticallyAdjustsScrollViewInsets = false
        
        bottomContainerView.frame = CGRect(x: 0, y: self.view.frame.maxY - 88, width: screenWith, height: 44)
        
        self.bottomContainerView.addSubview(selectAllShopsGoodsBtn)
        
        bottomContainerView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        selectAllShopsGoodsBtn.frame = CGRect(x: 10, y: 0, width: 100, height: 44)
        
        selectAllShopsGoodsBtn.setImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        self.selectAllShopsGoodsBtn.addTarget(self, action: Selector("selectAllShopsGoodsBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        var selectAllShow = UILabel(frame: CGRect(x: 8, y: 0, width: 50, height: 44))
        selectAllShow.text = "全选"
        totalPrice.frame = CGRect(x: 80, y: 0, width: 120, height: 44)
        totalPrice.text = ""
        totalPrice.font = UIFont.systemFontOfSize(13)
        
        var rightBuy = UIButton(frame: CGRect(x: screenWith - 120, y: 0, width: 120, height: 44))
        rightBuy.backgroundColor = UIColor.redColor()
        rightBuy.setTitle("立即购买", forState: UIControlState.Normal)
        rightBuy.addTarget(self, action: Selector("rightBuyBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        self.bottomContainerView.addSubview(totalPrice)
        self.bottomContainerView.addSubview(selectAllShow)
        self.bottomContainerView.addSubview(rightBuy)
        self.view.addSubview(bottomContainerView)
        
        self.title = "我的进货单"
        
    }
    
    func rightBuyBtnClk(){
        NSLog("立即购买按钮点击了，赶紧判断")
        //判断是否所有商家的配送条件都达到
        var  canBuy = true
        var say = ""
        //判断用户选择需要进行购买的商品，查看选中商品是否满足
        for var i = 0 ; i < gouWuCheModel.shopGoodsInfo.count ; i++ {
            //1、有选中  buyAtThisShopFlag:在该商家买东西了吗
            var buyAtThisShopFlag = false
            for var j = 0 ; j < gouWuCheModel.shopGoodsInfo[i].lists.count ; j++ {
                buyAtThisShopFlag = gouWuCheModel.shopGoodsInfo[i].lists[j].selectThisGood //确实有买了该商家的商品
                if buyAtThisShopFlag {
                    break //退出本次循环
                }
                
            }
            
            if buyAtThisShopFlag {
                let (condition:Double,allPrice:Double,reach:Bool) = gouWuCheModel.allPriceAtThisShop(i)
                if !reach {
                    canBuy = false
                    say = "【" + gouWuCheModel.shopGoodsInfo[i].shopname + "】下的商品不满足该商家的起配条件，请增加数量或去商家下进行凑单"
                    break
                }
            }
            
            
        }
        
        //查看用户选中的商品价格和数量应该大于0
        if gouWuCheModel.allGoodsPrice() == 0.0 {
            canBuy = false
            say = "你还没有可以支付的商品，赶紧去购买吧"
        }
        
        if canBuy{//所有商家下的商品都满足商家的配送条件
            var goodsVerifyVC = GoodsVerifyVC()
            var selectGoodsModel = GouWuCheModel()
            selectGoodsModel = gouWuCheModel
            //去除商家zhong没有被选中的商品
            
            for var j = 0 ; j < selectGoodsModel.shopGoodsInfo.count ; j++ {
                var lists = [List]()
                for var i = 0 ; i < selectGoodsModel.shopGoodsInfo[j].lists.count ; i++ {
                    if selectGoodsModel.shopGoodsInfo[j].lists[i].selectThisGood {
                        lists.append(selectGoodsModel.shopGoodsInfo[j].lists[i])
                    }
                }
                selectGoodsModel.shopGoodsInfo[j].lists = lists
            }
            
            goodsVerifyVC.verifyInfo.goodsInfo = selectGoodsModel
            goodsVerifyVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(goodsVerifyVC, animated: false)
        }else{//某些商家配送条件不满足
            var alert = UIAlertView(title: "温馨提示", message: say, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        ProgressHUD.show("数据加载中...")
        
        
        if pushed {
            self.bottomContainerView.frame =  CGRect(x: 0, y: screenHeight - 44, width: screenWith, height: 44)
            self.tableView.frame = CGRect(x: 0, y: 64, width: screenWith, height: screenHeight - 108)
            //self.tabBarController?.tabBar.hidden = true
        }else{
            //self.tabBarController?.tabBar.hidden = false
        }
        
        getDataUsertype("1", userid: currentRoleInfomation.keyid)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        ProgressHUD.dismiss()
    }
    
    
    func setNavigationBar(){
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        NSLog("self.tableView.frame = \(self.tableView.frame)")
        NSLog("self.view = \(self.view)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        
        
        
        NSLog("shopCnt = \(gouWuCheModel.shopname().count)")
        
        let cnt = gouWuCheModel.shopname().count
        
        //移除
        if let v = self.emptyButton{
            self.emptyButton?.removeFromSuperview()
        }
        
        if cnt == 0 {
            emptyButton = UIButton(frame: CGRectMake(0, 64, screenWith, screenHeight - 64))
            self.view.addSubview(emptyButton!)
            
            self.emptyButton?.addTarget(self, action: Selector("tabbarVCChangedToFirstVC"), forControlEvents: UIControlEvents.TouchUpInside)
            self.emptyButton?.setImage(UIImage(named: "emptyImg"), forState: UIControlState.Normal)
            
            bottomContainerView.hidden = true
        }else{
            bottomContainerView.hidden = false
        }
        
        
        
        refreshGouWuCheBadgeValue(self.tabBarController!)
        
        return gouWuCheModel.shopname().count
    }
    
    func tabbarVCChangedToFirstVC(){
        NSLog("去购物")
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.tabBarController?.selectedIndex = 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        NSLog("listCntOfShop( \(section)  )  = \(gouWuCheModel.listCntOfShop(section))")
        return gouWuCheModel.listCntOfShop(section)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GouWuCheCell
        //商品图片
        var imgUrl = gouWuCheModel.goodImgOfSection(indexPath.section, row: indexPath.row)
        NSLog("imgUrl = \(imgUrl)")
        cell.img!.sd_setImageWithURL(NSURL(string:serversBaseUrlForPicture + imgUrl))
        //商品名称
        cell.goodsTitle?.text = gouWuCheModel.shopGoodsInfo[indexPath.section].lists[indexPath.row].productname
        cell.nowPrice?.text = "￥: " + gouWuCheModel.shopGoodsInfo[indexPath.section].lists[indexPath.row].price
        
        //商品活动
        if gouWuCheModel.shopGoodsInfo[indexPath.section].lists[indexPath.row].IsGivestate == "0" {
            cell.huoDong.text = "[" + gouWuCheModel.shopGoodsInfo[indexPath.section].lists[indexPath.row].GiveMsg + "]"
        }else{
            cell.huoDong.text = ""
        }
        
        cell.numTextField.text = gouWuCheModel.shopGoodsInfo[indexPath.section].lists[indexPath.row].nums
        cell.currentCnt = gouWuCheModel.shopGoodsInfo[indexPath.section].lists[indexPath.row].nums
        cell.actionOBJ = indexPath
        cell.selectedFlag = gouWuCheModel.shopGoodsInfo[indexPath.section].lists[indexPath.row].selectThisGood
        
        //闭包添加
        cell.initWithClosure(GoodsViewActionAtSection)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screenWith/3 + 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var gouWuCheHeaderView = GouWuCheHeaderView(frame: CGRect(x: 0, y: 0, width: screenWith, height: headerHeigth))
        
        gouWuCheHeaderView.shopName.text = gouWuCheModel.shopname()[section]
        gouWuCheHeaderView.actionOBJ = NSIndexPath(forRow: 0, inSection: section)
        gouWuCheHeaderView.selectedAllGoodsFlag = gouWuCheModel.shopGoodsInfo[section].selectThisShop
        gouWuCheHeaderView.initWithClosure(GoodsViewActionAtSection)
        
        //商家活动
        gouWuCheHeaderView.shangJiaHuoDong.text = gouWuCheModel.shopGoodsInfo[section].GiveMsg
        
        //隐藏小喇叭
        if gouWuCheModel.shopGoodsInfo[section].IsGivestate == "0" {
            gouWuCheHeaderView.shangJiaHuoDong.hidden = false
            gouWuCheHeaderView.xiaoLaBaImg.hidden = false
        }else{
            gouWuCheHeaderView.shangJiaHuoDong.hidden = true
            gouWuCheHeaderView.xiaoLaBaImg.hidden = true
        }
        
        return gouWuCheHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if gouWuCheModel.shopGoodsInfo[section].IsGivestate == "0" {
            return headerHeigth + 30
        }else{
            return headerHeigth
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var gouWuCheFooterView = GouWuCheFooterView(frame: CGRect(x: 0, y: 0, width: screenWith, height: headerHeigth))
        
        gouWuCheFooterView.initWithClosure(GoodsViewActionAtSection)
        gouWuCheFooterView.actionOBJ = NSIndexPath(forRow: 0, inSection: section)
        
        var (condition,totalPrice,reachFlag) = gouWuCheModel.allPriceAtThisShop(section)
        let conditionTemp = String(format: "%.2f", condition)
        let totalPriceTemp = String(format: "%.2f", condition - totalPrice)
        
        
        
        if reachFlag{//满足该商家的起配条件
            gouWuCheFooterView.shopWantToSay.text = ""//
            gouWuCheFooterView.shouldGotoThisShop = false
        }else{
            gouWuCheFooterView.shouldGotoThisShop = true
            //gouWuCheFooterView.shopWantToSay.text = "在我们家买满\(conditionTemp)起送 ,你还差\(totalPriceTemp),点我去凑"
            
            gouWuCheFooterView.setTextContenty("配送条件:\(conditionTemp)元起配送 ,你还差\(totalPriceTemp),点我去凑")
            
        }
        
        var msg = gouWuCheModel.merchantHuodongGift(section, price: totalPrice)
        gouWuCheFooterView.setHuoDongInfo(msg)
        
        
        return gouWuCheFooterView
    }
    
    
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let (condition,totalPrice,reachFlag) = gouWuCheModel.allPriceAtThisShop(section)
        
        let conditionTemp = String(format: "%.2f", condition)
        let totalPriceTemp = String(format: "%.2f", condition - totalPrice)
        
        var size = CGSize(width: screenWith, height: 500)
        
        var say =  "配送条件:\(conditionTemp)元起配送 ,你还差\(totalPriceTemp),点我去凑"
        
        var rect1 = getTextRectSize(say, font: UIFont.systemFontOfSize(14), size:size )
        
        var msg = gouWuCheModel.merchantHuodongGift(section, price: totalPrice)
        var rect2 = getTextRectSize(msg, font: UIFont.systemFontOfSize(14), size:size )
        
        var tempGivebase = NSNumberFormatter().numberFromString(gouWuCheModel.shopGoodsInfo[section].givebase)!.doubleValue
        
        var shangJiaHuoDongHeight = rect1.height + 10
        var shangPingHuoDongHeight = rect2.height + 10
        var allHeight = CGFloat(0)
        if reachFlag{//满足该商家的起配条件
            
            if gouWuCheModel.shopGoodsInfo[section].IsGivestate == "0" {
                if totalPrice > tempGivebase {//有赠送
                    allHeight = shangPingHuoDongHeight
                }else{//无赠送
                    allHeight = CGFloat(0)
                }
                return CGFloat(allHeight)
            }else{
                return allHeight
            }
            
            
        }else{//不满足起配条件
            allHeight = shangJiaHuoDongHeight
            
            if gouWuCheModel.shopGoodsInfo[section].IsGivestate == "0"{
                
                if totalPrice > tempGivebase {
                    allHeight += shangPingHuoDongHeight
                }else{
                    allHeight = shangJiaHuoDongHeight
                }
                
            }else{
                allHeight = shangJiaHuoDongHeight
            }
            
            return CGFloat(allHeight)
        }
        
        
    }
    
    func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        var attributes = [NSFontAttributeName: font]
        var option = NSStringDrawingOptions.UsesLineFragmentOrigin
        var rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        //        println("rect:\(rect)");
        return rect;
    }
    
}
