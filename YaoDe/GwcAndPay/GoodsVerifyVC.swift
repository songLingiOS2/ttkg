//
//  GoodsVerifyVC.swift
//  YaoDe
//
//  Created by iosnull on 16/3/22.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

/**
*  用户地址模型
*/
struct AddressModel {
    var address = [Address](){
        didSet{
            NSLog("给控制器发通知，我是模型")
            NSNotificationCenter.defaultCenter().postNotificationName("addressModelChanged", object: nil, userInfo: nil)
        }
    }
    
    /**
    用户默认收货地址，没有就返回第一个接收到的地址
    
    - returns: return value description
    */
    func getDefaultAddress()->(name:String,tel:String,address:String){
        var receiveAddress = ""
        var tel = ""
        var name = ""
        
        var dontHaveDefaultAddress = true
        
        for var i = 0 ; i < address.count ; i++ {
            if address[i].IsDefault == "1" {
                receiveAddress = address[i].ReceiverAddress
                tel = address[i].ReceiverPhoneNo
                name = address[i].ReceiverName
                dontHaveDefaultAddress = false//有默认收货地址
                break
            }
        }
        
        //有收货地址，但是没有设置默认地址
        if (address.count > 0)  && (dontHaveDefaultAddress == true){
            for var i = 0 ; i < address.count ; i++ {
                if i == 0 {
                    receiveAddress = address[i].ReceiverAddress
                    tel = address[i].ReceiverPhoneNo
                    name = address[i].ReceiverName
                }
            }
        }
        
        
        return (name,tel,receiveAddress)
    }
}

/**
*  用户收货地址
*/
struct Address {
    var KeyID = "" //收货地址ID
    var ReceiverName = ""//收货人姓名
    var ReceiverPhoneNo = ""//收货人电话
    var ReceiverAddress  = ""//收货人地址
    var PostCode =  "" //邮编
    var Remark = ""//备注
    var StandbyPhoneNo = "" //其他电话
    var UserType = ""//用户类型(1:商家，2：普通消费者)
    var UserID = ""//用户ID
    var ReceiverArea = "" //收货人区域
    var IsDefault = ""//是否是默认收货地址（1为默认收货地址，0不是默认地址）
    var IsAuditStatus = "" //审核状态
}



/**
支付方式

- weixin:       weixin description
- alipay:       alipay description
- huodaofukuan: huodaofukuan description
- shebei:       shebei description
*/
enum GoodsPayWay {
    case weixin
    case alipay
    case huodaofukuan
    case shebei
    case other
}

/**
*  用户信息确认
*/
struct VerifyInfo {
    
    var creditStatus  = ""//当前用户的爽购状态（true：开启  false：关闭）
    var creditAvailable = ""{ //爽购余额
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("creditAvailableChanged", object: nil, userInfo: nil)
        }
    }
    
    var goodsInfo = GouWuCheModel()
    
    /**
    用户下单需要的参数
    */
    func orderInfo(Remark:String)->String{
        
        var payWayTemp = ""
        var payType = ""
        switch (payWay) {
            
        case  GoodsPayWay.shebei:
            payType = "0"
            payWayTemp = "3"
        case  GoodsPayWay.huodaofukuan:
            payType = "0"
            payWayTemp = "2"
        case  GoodsPayWay.alipay:
            payType = "1"
            payWayTemp = "1"
        case  GoodsPayWay.weixin:
            payType = "2"
            payWayTemp = "1"
        default :
            break
        }
        
        
        
        /// 获取商品id
        var cartKeyID = ""
        
        var idSerial = [String]()
        for var i = 0 ; i < goodsInfo.shopGoodsInfo.count;i++ {
            for var j = 0 ; j < goodsInfo.shopGoodsInfo[i].lists.count ; j++ {
                idSerial.append(goodsInfo.shopGoodsInfo[i].lists[j].cartid)
            }
        }
        
        /// 添加分号
        for var k = 0 ; k < idSerial.count ; k++ {
            
            //检测是否是最后一个元素
            if k != (idSerial.count - 1) {
                cartKeyID += idSerial[k] + ","
            }else{
                cartKeyID += idSerial[k]
            }
        }
        
        
        
        var order = ["UserType": userType,  //用户类型（1：商家 2：普通消费者）
            "UserId": userId,  //用户KeyID
            "UserName": userName, //用户姓名
            "PayWay": "-1",  //支付方式（1，在线支付；2，货到付款；3，爽购付款）注意：创建订单的时候传为 -1
            "Address": address,  //收货地址
            "ContactTel": contactTel,  //收货电话
            "PostCode": postCode,  //邮编（可以为空）
            "Remark": Remark,  //备注信息
            "PayType": payType,  //支付类型（1：支付宝  2：微信）
            "ClientType": clientType,  //客户端类型（1：安卓 2：IOS  3：PC）
            "CartKeyID": cartKeyID//用户选中的购物车的每项的购物车的KeyID链接的字符串，以 , 分割
        ]
        
        var jsonString = JSON(order).description
        NSLog("jsonString = \(jsonString)")
        return jsonString
    }
    
    var userType = "1"              //, //用户类型（1：商家 2：普通消费者）
    var userId = currentRoleInfomation.keyid             //15", //用户KeyID
    var userName = ""      //张三", //用户姓名
    var payWay = GoodsPayWay.other {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("virifyModelChanged", object: nil, userInfo: nil)
        }
    }
    //1", //支付方式（1，在线支付；2，货到付款；3，爽购付款）注意：创建订单的时候传为 -1
    var address = "" {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("virifyModelChanged", object: nil, userInfo: nil)
        }
    }
    //贵州省贵阳市", //收货地址
    var contactTel = ""             //18786712371", //收货电话
    var postCode = ""               //562413", //邮编（可以为空）
    var remark = ""                 //备注信息", //备注信息
    var payType = ""               //, //支付类型（1：支付宝  2：微信）
    var clientType = "2"             //2", //客户端类型（1：安卓 2：IOS  3：PC）
    var cartKeyID = ""              //33,34,35,36,37"//用户选中的购物车的每项的购物车的KeyID链接的字符串，以 , 分割
}

class GoodsVerifyVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ZhengPingShowDelegate{
    
    var payMethord_FromNet = [String:String]()//支付方式网络支付方式获取
    
    var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWith, height: screenHeight - 132))
    
    /// 模型数据初始化
    var verifyInfo = VerifyInfo()
    var addressModel = AddressModel()
    
    
    /// 底部容器
    var bottomContainerView = UIView(frame: CGRect(x: 0, y: screenHeight - 44, width: screenWith, height: 44))
    var allPrice = UILabel(frame: CGRect(x: 0, y: 0, width: screenWith/2, height: 44))
    var rightNowBtn = UIButton(frame: CGRect(x: screenWith/2, y: 0, width: screenWith/2, height: 44))
    
    
    
    func captureImage()->UIImage{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    
    
    func gateDate(cartid:String) {
        var zengPingModel = ZengpinInfoModel()
        let getMerchantListUrl = serversBaseURL + "/activity/give"
        let parameters = ["userid":currentRoleInfomation.keyid,"usertype":"1","cartid":cartid]
        
        if netIsavalaible {
            Alamofire.request(.POST,getMerchantListUrl,parameters: parameters).responseString{ (request, response, data, error) in
                if error != nil {
                    serverIsAvalaible()
                }
                
                
                NSLog("data==\(data)")
                
                var dataTemp = StringToJSON(data!)
                
                zengPingModel.getData(dataTemp)
                if zengPingModel.data.count != 0 {
                    //确认商品赠送信息
                    var zhengPingShowVC = ZhengPingShowVC()
                    
                    zhengPingShowVC.backGroundImg.image = self.captureImage()
                    
                    zhengPingShowVC.zengPingModel = zengPingModel
                    zhengPingShowVC.delegate = self
                    self.presentViewController(zhengPingShowVC, animated: true) { () -> Void in
                        
                    }
                }else{
                    self.afirmOrder()
                }
//                self.tableView.reloadData()
            }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    func afirmOrder(){
                var alert = UIAlertView(title: "提示", message: "", delegate: nil, cancelButtonTitle: "确定")
        
                var buyCondition = true
                //1、支付方式检查
                if self.verifyInfo.payWay == .other {
                    buyCondition = false
                    alert.message = "请选择支付方式!"
                    alert.show()
                }
        
                if self.verifyInfo.payWay == .weixin {
                    buyCondition = false
                    alert.message = "请耐心等待，我们即将开通微信支付"
                    alert.show()
                }
        
                //2、用户信息检查
                if self.verifyInfo.contactTel == "" {
                    alert.message = "收货人联系方式需要您填写!"
                    alert.show()
                }
        
                if self.verifyInfo.address == "" {
                    alert.message = "收货地址需要您填写!"
                    alert.show()
                }
        
                if self.verifyInfo.userName == "" {
                    alert.message = "收货人姓名需要您填写!"
                    alert.show()
                }
        
                if buyCondition {//信息不完整，不能够买
                    NSLog("必要信息满足，可以进行购买操作")
                    let configUrl = serversBaseURL + "/config/get"
        
                    if netIsavalaible {
                    Alamofire.request(.GET,configUrl,parameters: nil).responseString { (request, response, data, error) in
        
                        var datatemp = JSON(data!)
                        let result = datatemp.description
        
                        var resultTemp = StringToJSON(result)
                        NSLog("resultTemp = \(resultTemp)")
        
                        var message = resultTemp["message"].stringValue
                        if "true" == resultTemp["success"].stringValue {
                            var data = resultTemp["data"]
                            var  IsDelivery = data["IsDelivery"].stringValue
                            var IsCredit = data["IsCredit"].stringValue
                            var IsOnlinepay = data["IsOnlinepay"].stringValue
        
        
        
                            self.payMethord_FromNet["IsDelivery"] = IsDelivery
                            self.payMethord_FromNet["IsCredit"] = IsCredit
                            self.payMethord_FromNet["IsOnlinepay"] = IsOnlinepay
        
                            for item in self.payMethord_FromNet {
                                NSLog("item \(item)")
                            }
        
        
                            var canPayFlag = false
                            switch(self.verifyInfo.payWay){
                            case .weixin:
                                if IsOnlinepay == "true" {
                                    canPayFlag = true
                                }
        
                            case .alipay:
                                if IsOnlinepay == "true" {
                                    canPayFlag = true
                                }
                            case .huodaofukuan:
                                if IsDelivery == "true" {
                                    canPayFlag = true
                                }
                            case .shebei:
                                if IsCredit == "true" {
                                    canPayFlag = true
                                }
        
                            default:
                                canPayFlag = false
                                break
                            }
        
                            if canPayFlag {//开通了该支付方式，可以进行正常支付
                                var remark =  ""
                                if self.bottomView.content.text == "" {
                                    remark = "无"
                                }else{
                                    remark = self.bottomView.content.text
                                }
        
                                var orderinfo =  self.verifyInfo.orderInfo(remark)
                                //去告诉服务器，给我返回订单来
                                self.creatOrder(orderinfo)
                            }else{
                                var alertView = UIAlertView(title: "提示", message: "不支持您所选的支付方式,请重选", delegate: nil, cancelButtonTitle: "确认")
                                alertView.show()
                            }
                            
                            self.tableView.reloadData()
                        }else{
                            ProgressHUD.showError(message)
                        }
                    }
                    }else{
                        netIsEnable("网络不可用")
                    }
                    
                    
                    
                    
                    
                }else{
                    NSLog("不能购买，信息不完整")
                }
    }
    
    func rightNowBtnClk(){
        NSLog("立即购买")
        
        
        var ids = self.verifyInfo.goodsInfo.allShopCarID()
        
        gateDate(ids)
   
    }
    
    

    
    /**
    向服务器请求订单
    */
    func creatOrder(orderinfo:String){
        let url = serversBaseURL + "/orders/create"
        
        let para = ["orderinfro":orderinfo]
        NSLog("para = \(para.description)")
        if netIsavalaible {
        Alamofire.request(.POST,url,parameters: para).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            NSLog("request = \(request)")
            NSLog("data = \(data)")
            
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            NSLog("********")
            
            if json["success"].stringValue == "true" {
                ProgressHUD.showSuccess(json["message"].stringValue)
                var PayPrice = json["data"]["PayPrice"].stringValue
                var PayNumber = json["data"]["PayNumber"].stringValue
                
                
                var totalPriceFromService =  NSNumberFormatter().numberFromString(PayPrice)!.doubleValue
                
                /**
                *  判断一下用户购买的商品总价和当前计算的价格是否一致
                */
                if totalPriceFromService != self.verifyInfo.goodsInfo.allGoodsPrice(){
                    ProgressHUD.showError("价格不匹配")
                }else{
                    NSLog("本地价格和网络价格一至，可以进行支付")
                    
                    self.payForThisOrder(PayNumber, payprice: PayPrice, payWay: self.verifyInfo.payWay, usertype: "1")
                }
                
                
            }else{
//                ProgressHUD.showError(json["message"].stringValue)
                
                showMessageAnimate123(self.navigationController!.view, json["message"].stringValue)
                
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    /**
    对订单号进行支付
    
    - parameter order: order description
    */
    func payForThisOrder(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        /**
        *  根据相应的支付方式进行支付调用
        */
        NSLog("order = \(order),payprice = \(payprice),payWay= \(payWay),usertype = \(usertype)")
        
        switch verifyInfo.payWay {
        case  GoodsPayWay.shebei:
            payWithSheBei(order, payprice: payprice, payWay: payWay, usertype: usertype)
        case  GoodsPayWay.huodaofukuan:
            payWithHuoDaoFuKuan(order, payprice: payprice, payWay: payWay, usertype: usertype)
        case  GoodsPayWay.alipay:
            payWithAlipay(order, payprice: payprice, payWay: payWay, usertype: usertype)
        case  GoodsPayWay.weixin:
            payWithWeiXin(order, payprice: payprice, payWay: payWay, usertype: usertype)
        default :
            break
        }
        
    }
    
    
    
    var bottomView =  VirifyFooterView(frame: CGRect(x: 0, y: screenHeight - 132, width: screenWith, height: 88))
    var virifyHeaderView = VirifyHeaderView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 90))
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.separatorInset = UIEdgeInsetsZero //设置分割线没有内容边距
        self.tableView.layoutMargins = UIEdgeInsetsZero //清空默认布局边距
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //用户地址选择回调
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("usrHaveSelectedAddressProcess:"), name: "usrHaveSelectedAddress", object: nil)
        
        //订阅用户爽购额度通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("useUsrCreditPay"), name: "creditAvailableChanged", object: nil)
        
        //订阅模型通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("modelChanged"), name: "virifyModelChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addressModelChanged"), name: "addressModelChanged", object: nil)
        
        self.tableView.tableHeaderView = virifyHeaderView
        virifyHeaderView.initMyClouse(selectProcess)
        
        self.tableView.registerClass(VirifyInfoCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        bottomContainerView.backgroundColor = UIColor.redColor()
        allPrice.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        allPrice.text = "总计: ￥" + String(format: "%.2f",verifyInfo.goodsInfo.allGoodsPrice() )
        allPrice.textAlignment = NSTextAlignment.Center
        bottomContainerView.addSubview(allPrice)
        bottomContainerView.addSubview(rightNowBtn)
        rightNowBtn.addTarget(self, action: Selector("rightNowBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        rightNowBtn.setTitle("提交订单", forState: UIControlState.Normal)
        
        self.view.addSubview(bottomContainerView)
        
        self.view.addSubview(bottomView)
        bottomView.initMyClouse(selectPayWay)
        
        //获取用户收货地址
        getUserAddressWithUsrType("1", userid: currentRoleInfomation.keyid)
        
        
        //self.tabBarController?.tabBar.hidden = true
        self.navigationItem.title = "我的订单确认"
        //selectProcess(0)
        
        self.verifyInfo.payWay = GoodsPayWay.shebei
        getPayWayFromNet()
    }
    
    
    //获取用户收货信息数据
    func getUserAddressWithUsrType(usrType:String,userid:String){
        let url = serversBaseURL + "/address/get"
        
        let parameters = ["usertype":usrType,"userid":userid]
        
        
        let data = JSON(parameters)
        let para = ["filter":data.description]
        
        if netIsavalaible {
            ProgressHUD.show("数据加载中")
        Alamofire.request(.GET,url,parameters: para).responseString{ (request, response, data, error) in
            
            ProgressHUD.dismiss()
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            if json["success"].stringValue ==  "false" {
                ProgressHUD.showError(json["message"].stringValue)
            }else{
                
                var model = AddressModel()
                
                var usrAddress = [Address]()
                var data = json["data"]
                for var i = 0 ; i < data.count ; i++ {
                    var temp = data[i]
                    NSLog("temp = \(temp.description)")
                    var addressTemp = self.usrAddressFromJSON(temp)
                    NSLog("addressTemp = \(addressTemp)")
                    usrAddress.append(addressTemp)
                }
                
                model.address = usrAddress
                
                /**
                用户地址获取到
                */
                self.addressModel.address = usrAddress
            }
            
            
        }
        }else{
            ProgressHUD.dismiss()
            netIsEnable("网络不可用")
        }
    }
    
    
    func usrAddressFromJSON(json:JSON)->Address{
        var address = Address()
        
        address.ReceiverName = json["ReceiverName"].stringValue
        address.Remark = json["Remark"].stringValue
        address.UserID = json["UserID"].stringValue
        address.KeyID = json["KeyID"].stringValue
        address.UserType = json["UserType"].stringValue
        address.ReceiverPhoneNo = json["ReceiverPhoneNo"].stringValue
        address.PostCode = json["PostCode"].stringValue
        address.ReceiverArea = json["ReceiverArea"].stringValue
        address.StandbyPhoneNo = json["StandbyPhoneNo"].stringValue
        address.IsDefault = json["IsDefault"].stringValue
        address.ReceiverAddress = json["ReceiverAddress"].stringValue
        address.IsAuditStatus = json["IsAuditStatus"].stringValue
        return address
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return verifyInfo.goodsInfo.shopname().count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return verifyInfo.goodsInfo.listCntOfShop(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! VirifyInfoCell
        var imgUrl = verifyInfo.goodsInfo.shopGoodsInfo[indexPath.section].lists[indexPath.row].imgurl
        cell.img.sd_setImageWithURL(NSURL(string:serversBaseUrlForPicture + imgUrl))
        
        cell.name.text = verifyInfo.goodsInfo.shopGoodsInfo[indexPath.section].lists[indexPath.row].productname
        
        cell.nums.text = "X" + verifyInfo.goodsInfo.shopGoodsInfo[indexPath.section].lists[indexPath.row].nums
        
        cell.allPrice.text = "小计: ￥" + String(format: "%.2f",verifyInfo.goodsInfo.goodsPriceAtSection(indexPath) )
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UILabel(frame: CGRect(x: 0, y: 0, width: screenWith, height: 44))
        headerView.text =  "  " + verifyInfo.goodsInfo.shopname()[section]
        headerView.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screenWith/3 + 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
//        //self.tabBarController?.tabBar.hidden = true
//        self.navigationItem.title = "我的订单确认"
//        //selectProcess(0)
//        
//        self.verifyInfo.payWay = GoodsPayWay.shebei
//        getPayWayFromNet()
    }
    
    func getPayWayFromNet(){
        NSLog("必要信息满足，可以进行购买操作")
        let configUrl = serversBaseURL + "/config/get"
        
        if netIsavalaible {
            Alamofire.request(.GET,configUrl,parameters: nil).responseString { (request, response, data, error) in
                
                var datatemp = JSON(data!)
                let result = datatemp.description
                
                var resultTemp = StringToJSON(result)
                NSLog("resultTemp = \(resultTemp)")
                
                var message = resultTemp["message"].stringValue
                if "true" == resultTemp["success"].stringValue {
                    var data = resultTemp["data"]
                    var  IsDelivery = data["IsDelivery"].stringValue
                    var IsCredit = data["IsCredit"].stringValue
                    var IsOnlinepay = data["IsOnlinepay"].stringValue
                    
                    
                    
                    self.payMethord_FromNet["IsDelivery"] = IsDelivery
                    self.payMethord_FromNet["IsCredit"] = IsCredit
                    self.payMethord_FromNet["IsOnlinepay"] = IsOnlinepay
                    
                    for item in self.payMethord_FromNet {
                        NSLog("item \(item)")
                    }
                    
                    
                    
                }else{
                    //ProgressHUD.showError(message)
                }
            }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    func selectPayWay(tag:Int){
       
        if tag == 1000 {
            NSLog("支方式选择 \(tag)")
            
            var alertController = UIAlertController(title: "提示", message: "请选中支付方式", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
            
            
            var shuangGouAction = UIAlertAction(title: "爽购支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("赊呗支付")
                
                self.verifyInfo.payWay = GoodsPayWay.shebei
                self.bottomView.payMethord.text = "爽购支付"
                
                
            } )
            
            
            var aliPayAction = UIAlertAction(title: "支付宝支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("支付宝支付")
                self.verifyInfo.payWay = GoodsPayWay.alipay
                self.bottomView.payMethord.text = "支付宝支付"
            } )
            var weiXinAction = UIAlertAction(title: "微信支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("微信支付")
                self.verifyInfo.payWay = GoodsPayWay.weixin
                self.bottomView.payMethord.text = "微信支付"
            } )
            var huoDaoAction = UIAlertAction(title: "货到付款", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("货到付款")
                self.verifyInfo.payWay = GoodsPayWay.huodaofukuan
                self.bottomView.payMethord.text = "货到付款"
                
            } )
            
            alertController.addAction(cancelAction)
            
            if self.payMethord_FromNet["IsCredit"] == "true" {
                alertController.addAction(shuangGouAction)
            }
            
            if self.payMethord_FromNet["IsOnlinepay"] == "true" {
                alertController.addAction(aliPayAction)
                alertController.addAction(weiXinAction)
            }
            if self.payMethord_FromNet["IsDelivery"] == "true" {
                alertController.addAction(huoDaoAction)
            }
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    /**
    闭包回调
    - parameter tag: tag description
    */
    func selectProcess(tag:Int){
        NSLog("闭包回调后的tag是 \(tag)")
        setHeaderView(self.virifyHeaderView,tag: tag)
    }
    
    func setHeaderView(view:UIView,tag:Int){
        switch tag{
        case 0 ://赊支付
            self.verifyInfo.payWay = GoodsPayWay.shebei
        case 1 ://货到付款
            self.verifyInfo.payWay = GoodsPayWay.huodaofukuan
        case 2 ://支付宝
            self.verifyInfo.payWay = GoodsPayWay.alipay
        case 3 ://微信
            self.verifyInfo.payWay = GoodsPayWay.weixin
        case 5 ://地址选择
            selectAddress()
        default :
            break
        }
        
    }
    
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    /**
    地址数据模型改变，调用该方法进行处理
    */
    func addressModelChanged(){
        //NSLog("地址模型数据改变了")
        let (name:String,tel:String,address:String) =   self.addressModel.getDefaultAddress()
        NSLog("获取到了用户收货信息 。。。。。\(name)  \(tel)  \(address)")
        
        verifyInfo.contactTel = tel
        verifyInfo.userName = name
        verifyInfo.address = address
    }
    
    /**
    模型数据有变化,调用该函数进行处理
    */
    func modelChanged(){
        refreshHeaderView(self.virifyHeaderView)
        self.tableView.reloadData()
    }
    
    /**
    刷新头部显示信息
    */
    func refreshHeaderView(headerView:VirifyHeaderView){
        
        /**
        *  判断用户是否填写了地址
        */
        if verifyInfo.address.length != 0 {
            //headerView.gotoSelectAddressInfo.hidden = true
            //headerView.gotoSelectAddressInfo.setTitle("          →_→", forState: UIControlState.Normal)
        }else{
            //headerView.gotoSelectAddressInfo.hidden = false
            //headerView.gotoSelectAddressInfo.setTitle("          →_→", forState: UIControlState.Normal)
        }
        
        if verifyInfo.address == "" {
            headerView.gotoSelectAddressInfo.setTitle("您还没有添加收货地址,点我去添加", forState: UIControlState.Normal)
            headerView.address.text = ""
            headerView.tel.text = ""
            headerView.name.text = ""
            headerView.img.hidden = true
        }else{
        
            headerView.gotoSelectAddressInfo.setTitle("", forState: UIControlState.Normal)
        
            headerView.address.text = "收货地址:" + verifyInfo.address
            headerView.tel.text = "电话:" + verifyInfo.contactTel
            headerView.name.text = "收货人:" + verifyInfo.userName
            headerView.img.hidden = false
        }
        
//        //先不选中支付方式
//        headerView.selectShebeiImg.image = UIImage(named: "che_nor")
//        headerView.selectHuoDaoImg.image = UIImage(named: "che_nor")
//        headerView.selectAliPayImg.image = UIImage(named: "che_nor")
//        headerView.selectWeixinPayImg.image = UIImage(named: "che_nor")
        
//        switch self.verifyInfo.payWay{
//        case GoodsPayWay.shebei ://赊支付
//            headerView.selectShebeiImg.image = UIImage(named: "che_sel")
//        case GoodsPayWay.huodaofukuan ://货到付款
//            headerView.selectHuoDaoImg.image = UIImage(named: "che_sel")
//        case GoodsPayWay.alipay ://支付宝
//            headerView.selectAliPayImg.image = UIImage(named: "che_sel")
//        case GoodsPayWay.weixin ://微信
//            headerView.selectWeixinPayImg.image = UIImage(named: "che_sel")
//        default :
//            break
//        }
        
        
        
    }
    
    /**
    选择地址
    */
    func selectAddress(){
        NSLog("重新去选择地址")
        
        var selectPalceOfReceiptVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectPalceOfReceiptVC") as! SelectPalceOfReceiptVC
        selectPalceOfReceiptVC.selectedFlag = false
        self.navigationController?.pushViewController(selectPalceOfReceiptVC, animated: true)
        
    }
    
    //地址选择回调
    func usrHaveSelectedAddressProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            var selectedAddress = dataTemp["selectedAddress"]
            var placeOfReceiptTemp = PlaceOfReceipt()
            placeOfReceiptTemp.remark = selectedAddress["remark"].stringValue
            placeOfReceiptTemp.address = selectedAddress["address"].stringValue
            placeOfReceiptTemp.isdefault = selectedAddress["isdef"].stringValue
            placeOfReceiptTemp.sphone = selectedAddress["sphone"].stringValue
            placeOfReceiptTemp.userid = selectedAddress["userid"].stringValue
            placeOfReceiptTemp.phone = selectedAddress["phone"].stringValue
            placeOfReceiptTemp.usertype = selectedAddress["usertype"].stringValue
            placeOfReceiptTemp.postcode = selectedAddress["postcode"].stringValue
            placeOfReceiptTemp.keyid = selectedAddress["keyid"].stringValue
            placeOfReceiptTemp.area = selectedAddress["area"].stringValue
            placeOfReceiptTemp.name = selectedAddress["name"].stringValue
            
            
            verifyInfo.contactTel = placeOfReceiptTemp.phone
            verifyInfo.userName = placeOfReceiptTemp.name
            verifyInfo.address = placeOfReceiptTemp.address
        }
        
    }
    
}

////宏定义闭包
typealias VirifyGoodsClosure=(cnt:Int)->Void


class VirifyFooterView: UIView {
    var message = UILabel()
    var content = UITextField()
    var payMethord = UILabel()
    var payMethodName = UILabel()
    var payBtn = UIButton()
    var img = UIImageView()
    
    var line1 = UIView()
    var line2 = UIView()
    
    
    
    /// 闭包定义
    private var myClouse:VirifyGoodsClosure?
    
    func initMyClouse(clouse:VirifyGoodsClosure){
        myClouse = clouse
    }
    /**
    按钮点击
    */
    func payBtnClk(){
        
        if myClouse != nil {
            myClouse!(cnt: 1000)
        }else{
            NSLog("闭包没有初始化")
        }
        
        NSLog("支付方式选择")

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(message)
        self.addSubview(content)
        self.addSubview(payMethord)
        self.addSubview(payMethodName)
        self.addSubview(payBtn)
        self.addSubview(img)
        self.addSubview(line1)
        self.addSubview(line2)
        
        payBtn.addTarget(self, action: Selector("payBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        message.text = "买家留言:"
        content.placeholder = "选填,可填写您与卖家达成一致的要求"
        content.font = UIFont.systemFontOfSize(13)
        
        payMethord.text = "爽购支付"
        payMethord.textAlignment = NSTextAlignment.Right
        payMethord.font = UIFont.systemFontOfSize(16)
        
        
        payMethodName.text = "支付方式"
        payMethodName.textAlignment = NSTextAlignment.Left
        payMethodName.font = UIFont.systemFontOfSize(16)
        
        
        img.image = UIImage(named: "arrow001")
        
        line1.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        line2.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        message.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(8)
            make.width.equalTo(80)
            make.top.equalTo(10)
        }
        
        content.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(message.snp_right).offset(4)
            make.right.equalTo(self.snp_right).offset(-8)
            make.top.equalTo(13)
            
        }
        
        
        line1.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(message.snp_bottom).offset(3)
            make.height.equalTo(1)
        }
        
        
        payMethodName.snp_makeConstraints { (make) -> Void in
            //make.left.equalTo(message.snp_right).offset(4)
            make.left.equalTo(8)
            make.top.equalTo(message.snp_bottom).offset(1)
            make.width.equalTo(100)
            make.height.equalTo(30)
            
        }
        
        payMethord.snp_makeConstraints { (make) -> Void in
            //make.left.equalTo(message.snp_right).offset(4)
            make.right.equalTo(self.snp_right).offset(-30)
            make.top.equalTo(message.snp_bottom).offset(1)
            make.width.equalTo(80)
            make.height.equalTo(30)
            
        }
        
        
        payBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(content.snp_bottom).offset(4)
            make.height.equalTo(30)
        }
        
        
        line2.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(payBtn.snp_bottom)
                make.height.equalTo(1)
        }
        
        img.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(payMethord.snp_right).offset(1)
            make.top.equalTo(message.snp_bottom).offset(2)
            make.right.equalTo(self.snp_right).offset(-2)
            make.height.equalTo(27)
            make.width.equalTo(27)
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VirifyHeaderView: UIView {
    
    /// 闭包定义
    private var myClouse:VirifyGoodsClosure?
    
    func initMyClouse(clouse:VirifyGoodsClosure){
        myClouse = clouse
    }
    
    var name:UILabel
    var tel:UILabel
    var address:UILabel
    var img:UIImageView
    
    //选择支付方式
    var shebeiPay:UIButton
    var huoDaoPay:UIButton
    var aliPay:UIButton
    var weixinPay:UIButton
    
    var shebeiImg:UIImageView
    var huoDaoImg:UIImageView
    var aliPayImg:UIImageView
    var weixinPayImg:UIImageView
    
    var selectShebeiImg:UIImageView
    var selectHuoDaoImg:UIImageView
    var selectAliPayImg:UIImageView
    var selectWeixinPayImg:UIImageView
    
    
    /**
    闭包回调
    
    - parameter sender: sender description
    */
    func selectPayWay(sender:UIButton){
        NSLog("按钮点击了,tag是\(sender.tag)")
        if myClouse != nil {
            myClouse!(cnt: sender.tag)
        }else{
            NSLog("闭包没有初始化")
        }
    }
    
    var gotoSelectAddressInfo:UIButton
    override init(frame: CGRect) {
        gotoSelectAddressInfo = UIButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 90))
        gotoSelectAddressInfo.setBackgroundImage(UIImage(named: "grayArrow"), forState: UIControlState.Normal)
        gotoSelectAddressInfo.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        gotoSelectAddressInfo.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).CGColor
        gotoSelectAddressInfo.layer.borderWidth = 0.5
        
        name = UILabel(frame: CGRect(x: 8, y: 0, width: screenWith, height: 30))
        tel = UILabel(frame: CGRect(x: 8, y: name.frame.maxY, width: screenWith - 10, height: 30))
        address = UILabel(frame: CGRect(x: 8, y: tel.frame.maxY, width: screenWith - 10, height: 30))
        
        img = UIImageView(frame: CGRect(x: screenWith - 50, y: 30, width: 32, height: 32))
        
        
        shebeiImg = UIImageView(frame: CGRect(x: 8, y: address.frame.maxY + 5, width: 32, height: 32))
        shebeiImg.image = UIImage(named: "sheBeiPay")
        selectShebeiImg  = UIImageView(frame: CGRect(x: screenWith - 50, y: address.frame.maxY + 5, width: 32, height: 32))
        selectShebeiImg.image = UIImage(named: "che_nor")
        
        huoDaoImg = UIImageView(frame: CGRect(x: 8, y: shebeiImg.frame.maxY + 5, width: 32, height: 32))
        huoDaoImg.image = UIImage(named: "address")
        selectHuoDaoImg = UIImageView(frame: CGRect(x: screenWith - 50, y: shebeiImg.frame.maxY + 5, width: 32, height: 32))
        selectHuoDaoImg.image = UIImage(named: "che_nor")
        
        aliPayImg = UIImageView(frame: CGRect(x: 8, y: huoDaoImg.frame.maxY + 5, width: 32, height: 32))
        aliPayImg.image = UIImage(named: "icon_pay")
        selectAliPayImg = UIImageView(frame: CGRect(x: screenWith - 50, y: huoDaoImg.frame.maxY + 5, width: 32, height: 32))
        selectAliPayImg.image = UIImage(named: "che_nor")
        
        weixinPayImg = UIImageView(frame: CGRect(x: 8, y: aliPayImg.frame.maxY + 5, width: 32, height: 32))
        weixinPayImg.image = UIImage(named: "icon_wechat")
        selectWeixinPayImg = UIImageView(frame: CGRect(x: screenWith - 50, y: aliPayImg.frame.maxY + 5, width: 32, height: 32))
        selectWeixinPayImg.image = UIImage(named: "che_nor")
        
        
        shebeiPay = UIButton(frame: CGRect(x: 0, y: address.frame.maxY + 5, width: screenWith, height: 32))
        shebeiPay.setTitle("爽购", forState: UIControlState.Normal)
        shebeiPay.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        
        huoDaoPay = UIButton(frame: CGRect(x: 0, y: shebeiPay.frame.maxY + 5, width: screenWith , height: 32))
        huoDaoPay.setTitle("货到付款", forState: UIControlState.Normal)
        huoDaoPay.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        
        
        aliPay = UIButton(frame: CGRect(x: 0, y: huoDaoPay.frame.maxY + 5, width: screenWith, height: 32))
        aliPay.setTitle("支付宝", forState: UIControlState.Normal)
        aliPay.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        
        weixinPay = UIButton(frame: CGRect(x: 0, y: aliPay.frame.maxY + 5, width: screenWith , height: 32))
        weixinPay.setTitle("微信", forState: UIControlState.Normal)
        weixinPay.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        
        
        super.init(frame: frame)
        
        aliPay.addTarget(self, action: Selector("selectPayWay:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        huoDaoPay.addTarget(self, action: Selector("selectPayWay:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        weixinPay.addTarget(self, action: Selector("selectPayWay:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        shebeiPay.addTarget(self, action: Selector("selectPayWay:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        name.text = ""
        tel.text = ""
        address.text = ""
        
        self.addSubview(name)
        self.addSubview(tel)
        self.addSubview(address)
        self.addSubview(img)
        
//        self.addSubview(shebeiImg)
//        self.addSubview(huoDaoImg)
//        self.addSubview(aliPayImg)
//        self.addSubview(weixinPayImg)
//        
//        self.addSubview(selectShebeiImg)
//        self.addSubview(selectHuoDaoImg)
//        self.addSubview(selectAliPayImg)
//        self.addSubview(selectWeixinPayImg)
//        
//        
//        self.addSubview(shebeiPay)
//        shebeiPay.tag = 0
//        self.addSubview(huoDaoPay)
//        huoDaoPay.tag = 1
//        self.addSubview(aliPay)
//        aliPay.tag = 2
//        self.addSubview(weixinPay)
//        weixinPay.tag = 3
        
        name.font = UIFont.systemFontOfSize(18)
        tel.font = UIFont.systemFontOfSize(18)
        address.font = UIFont.systemFontOfSize(14)
        
        gotoSelectAddressInfo.tag = 5
        gotoSelectAddressInfo.addTarget(self, action: Selector("selectPayWay:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        img.image = UIImage(named: "dingw")
        
        //self.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        self.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).CGColor
        
        self.layer.borderWidth = 0.5
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(gotoSelectAddressInfo)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VirifyInfoCell: UITableViewCell {
    var img:UIImageView
    var nums:UILabel
    var allPrice:UILabel
    var name:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        img = UIImageView(frame: CGRect(x: 8, y: 5, width: screenWith/3, height: screenWith/3 ))
        
        name = UILabel(frame: CGRect(x: img.frame.maxX + 8, y: 5, width: screenWith - img.frame.maxX - 8 , height: 40))
        nums = UILabel(frame: CGRect(x: screenWith/2 - 50, y: name.frame.maxY, width: 110 , height: 30))
        allPrice = UILabel(frame: CGRect(x: img.frame.maxX  , y: nums.frame.maxY , width: screenWith - img.frame.maxX , height: 30))
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(img)
        self.addSubview(nums)
        self.addSubview(name)
        self.addSubview(allPrice)
        
        nums.textAlignment = NSTextAlignment.Center
        allPrice.textAlignment = NSTextAlignment.Left
        
        name.font = UIFont.systemFontOfSize(15)
        nums.font = UIFont.systemFontOfSize(13)
        allPrice.font = UIFont.systemFontOfSize(13)
        
        name.textColor = UIColor.grayColor()//(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        allPrice.textColor = UIColor.redColor()
        nums.textColor = UIColor.redColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}









extension GoodsVerifyVC {
    
    func goToMyOrderVC(){
        /**
        *  跳转到我的订单页面
        */
        var myOrderShow = MyOrderInfoShowVC()
        self.navigationController?.pushViewController(myOrderShow, animated: false)
    }
    
    /**
    支付宝支付
    */
    func payWithAlipay(myorder:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var productName = myorder
        var productDescription = myorder
        var amount = payprice
        var userid = currentRoleInfomation.keyid
        
        var notifyURL = serversBaseURL + "/notify/notify_url.aspx"
        
        //支付宝支付调用
        NSLog("notifyURL = \(notifyURL)")
        
        
        
        var order = Order()
        order.partner = PARTNER;
        order.seller = SELLER;
        order.tradeNO = myorder                                //订单ID（由商家自行制定）
        order.productName = productName             //商品标题
        order.productDescription = productDescription    //商品描述
        order.amount = amount   //商品价格
        //NSLog("order.amount = \(order.amount)")
        
        order.notifyURL =  notifyURL //回调URL
        order.service = "mobile.securitypay.pay";
        order.paymentType = "1";
        order.inputCharset = "utf-8";
        order.itBPay = "30m";
        order.showUrl = "m.alipay.com";
        
        //将商品信息拼接成字符串
        var orderSpec = order.description
        var signer = CreateRSADataSigner(RSA_PRIVATE)
        var signedString = signer.signString(orderSpec)//[signer signString:orderSpec];
        
        var rsa = "RSA"
        var orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"\(rsa)\""
        NSLog("orderString = \(orderString)")
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: "wxc81564befb45171c") { (result) -> Void in
            NSLog("zhifubao = \(result)")
            NSLog("支付宝处理结果")
            //支付宝发出通知
            
            self.goToMyOrderVC()
        }
    }
    /**
    微信支付
    */
    func payWithWeiXin(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        
        var tradeNO = order
        var productName = "商品名称"
        var productDescription = "商品描述"
        
        var allprice = NSNumberFormatter().numberFromString(payprice)!.doubleValue
        
        var amount = String(stringInterpolationSegment: allprice*100) //考虑微信支付价格以分为单位
        
        var userid = currentRoleInfomation.keyid
        
        var notifyURL = serversBaseURL + "/pay/notify?" + "orderno=\(order)" + "&userid=\(userid)" + "&usertype=\(usertype)" + "&payprice=\(payprice)" + "&paytype=2"
        
        if !WXApi.isWXAppInstalled() {
            ProgressHUD.dismiss()
            
            var alart = UIAlertView(title: "提示", message: "请先安装微信后再进行支付", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            
            
            /**
            发通知给tabbarcontroller,叫他帮我跳转到我的页面
            */
            NSNotificationCenter.defaultCenter().postNotificationName("pleaseJumpToMyOrderPage", object: nil)
            /**
            *  pop到根视图
            */
            self.navigationController?.popToRootViewControllerAnimated(false)
            
            return
        }
        
        NSLog("tradeNO = \(tradeNO)  productName = \(productName)  productDescription = \(productDescription) amount = \(amount)  notifyURL = \(notifyURL) ")
        
        var req = payRequsestHandler()
        
        req.initq(APP_ID, mch_id: MCH_ID)
        req.setKey(PARTNER_ID)
        
        var dict:NSMutableDictionary? = req.sendPay_demo(currentRoleInfomation.tel, order_name: productName, order_price: amount, orderno: tradeNO,notify_URL:notifyURL)
        
        
        if let result = dict {//获取签名成功
            NSLog("dict = %@\n\n",dict!);
            //var debug =  req.getDebugifo
            //NSLog("debug = \(debug)")
            var stamp  =  dict!.objectForKey("timestamp") as! String
            //NSLog("stamp = \(stamp)")
            //调起微信支付
            var req :PayReq            = PayReq()
            req.openID              = dict!.objectForKey("appid") as! String
            req.partnerId           = dict!.objectForKey("partnerid") as! String//[dict objectForKey:@"partnerid"];
            req.prepayId            = dict!.objectForKey("prepayid") as! String//[dict objectForKey:@"prepayid"];
            req.nonceStr            = dict!.objectForKey("noncestr") as! String//[dict objectForKey:@"noncestr"];
            
            req.package             = dict!.objectForKey("package") as! String //[dict objectForKey:@"package"];
            req.sign                = dict!.objectForKey("sign") as! String //[dict objectForKey:@"sign"];
            
            var sec = NSNumberFormatter().numberFromString(stamp)!.integerValue
            req.timeStamp           = UInt32(sec)
            WXApi.sendReq(req)
            
            //NSLog("appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,req.timeStamp,req.package,req.sign );
            
            
        }else{
            //错误提示
            NSLog("获取失败")
            //var debug =  req.getDebugifo
            //NSLog("\(debug)")
            ProgressHUD.showError("支付失败")
            
        }
        
        
        
    }
    
    /**
    货到付款
    */
    func payWithHuoDaoFuKuan(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var url = serversBaseURL + "/pay/delivery"
        var userid = currentRoleInfomation.keyid
        
        let parameters = ["userid":userid,"usertype":usertype,"orderno":order,"payway":"2"]
        if netIsavalaible {
        Alamofire.request(.POST,url,parameters: parameters).responseString{ (request, response, data, error) in
            //            NSLog("error = \(error)")
            NSLog("request = \(request)")
            //            NSLog("data = \(data)")
            //self.tableView.mj_header.endRefreshing()
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            if json["success"].stringValue ==  "false" {
                ProgressHUD.showError(json["message"].stringValue)
            }else{
                ProgressHUD.showSuccess(json["message"].stringValue)
            }
            
            self.goToMyOrderVC()
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    /**
    爽购支付
    */
    
    
    /**
    用户的爽购功能开启、额度剩余
    */
    func payWithSheBei(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var url = serversBaseURL + "/member/credit"
        
        let parameters = ["adminkeyid":currentRoleInfomation.keyid]
        if netIsavalaible {
        Alamofire.request(.GET,url,parameters: parameters).responseString{ (request, response, data, error) in
            
            NSLog("request = \(request)")
            
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            if json["success"].stringValue ==  "false" {
                
            }else{
                
                /// 信用额度
                var creditAvailable =  json["data"]["creditAvailable"].stringValue
                
                /**
                *  检测额度是否够用
                */
                var usrCredit = NSNumberFormatter().numberFromString(creditAvailable)!.doubleValue //用户额度
                var currentGoodsPrice = NSNumberFormatter().numberFromString(payprice)!.doubleValue  //当前商品总价
                
                var yourCredit = String(format: "%.2f",usrCredit )
                var shouldPay = String(format: "%.2f",currentGoodsPrice )
                
                if json["data"]["creditStatus"].stringValue == "true" {//有额度且开通且额度购用情况下，可以进行支付
                    if usrCredit >= currentGoodsPrice {//额度购支付
                        
                        
                        self.usePayWithSheBei(order, payprice: payprice, payWay: payWay, usertype: usertype)
                        
                        var p = usrCredit - currentGoodsPrice
                        var temp = String(format: "%.2f",p )
                        var alert = UIAlertView(title: "提示", message: "使用\(shouldPay)爽购金额支付了该笔订单\n当前爽购余额为￥\(temp)", delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                        
                    }else{
                        var alert = UIAlertView(title: "提示", message: "你的爽购额度不够支付该笔订单，请多多消费以便提升额度\n当前余额为￥\(yourCredit)\n该笔订单需要使用￥\(shouldPay)", delegate: nil, cancelButtonTitle: "确定")
                        
                        alert.show()
                        self.goToMyOrderVC()
                    }
                    
                    
                    
                }else{//还没有开通
                    var alert = UIAlertView(title: "提示", message: "打我们的客服电话去开通爽购吧", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                    self.goToMyOrderVC()
                }
            }
            
            
        }
        }else{
            netIsEnable("网络不可用")
        }
        
        
    }
    
    func usePayWithSheBei(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var url = serversBaseURL + "/pay/creditr"
        var username = currentRoleInfomation.adminid
        
        
        let parameters = ["username":username,"orderno":order,"payprice":payprice]
        
        NSLog("parameters = \(parameters.description)")
        if netIsavalaible {
        Alamofire.request(.POST,url,parameters: parameters).responseString{ (request, response, data, error) in
            
            NSLog("request = \(request)")
            
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            if json["success"].stringValue ==  "false" {
                ProgressHUD.showError(json["message"].stringValue)
            }else{
                ProgressHUD.showSuccess(json["message"].stringValue)
            }
            
            self.goToMyOrderVC()
            }
        }else{
            netIsEnable("无可用网络")
        }
    }
    
    
}




