//
//  LimitBuyProductInfoVC.swift
//  YaoDe
//
//  Created by iosnull on 16/1/11.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftDate
import SDWebImage
import SwiftyJSON
import Alamofire



struct Date{
    var year = 2000
    var month = 1
    var day = 1
    var hour = 1
    var minutes = 1
    var sec = 0
}

func returnTime(time:String)->Date{
    //"2016-01-11 21:57:04";
    var date = Date()
    var year=(time as NSString).substringWithRange(NSMakeRange(0, 4))
    var month=(time as NSString).substringWithRange(NSMakeRange(5, 2))
    var day=(time as NSString).substringWithRange(NSMakeRange(8, 2))
    var hours=(time as NSString).substringWithRange(NSMakeRange(11, 2))
    var minutes=(time as NSString).substringWithRange(NSMakeRange(14, 2))
    
    
    
    NSLog("time.length = \(time.length)")
    
    var second = "00"
    if time.length == 16 {
        second = "00"
    }else{
       second = (time as NSString).substringWithRange(NSMakeRange(17, 2))
        NSLog("second = \(second)")
    }

    
    date.year = NSNumberFormatter().numberFromString(year)!.integerValue
    date.month =   NSNumberFormatter().numberFromString(month)!.integerValue
    date.day =   NSNumberFormatter().numberFromString(day)!.integerValue
    date.hour =   NSNumberFormatter().numberFromString(hours)!.integerValue
    date.minutes =   NSNumberFormatter().numberFromString(minutes)!.integerValue
    date.sec = NSNumberFormatter().numberFromString(second)!.integerValue
    
    print(date.year)
    print(date.month)
    print(date.day)
    print(date.hour)
    print(date.minutes)
    println(date.sec)
    
    return date
}


class LimitBuyProductInfoVC: UIViewController {
    
    var pushFlag = false //用于标记定时器释放条件 false可以释放定时器
    
    weak var timer:NSTimer!
    var newValues :Int = 0
    
    var productName = ""
    var productPrice = ""
    var imageURL = ""
    var pd_keyid = ""
    var p_adminid = ""
    var pd_pid = ""
    
    var http = ShoppingHttpReq.sharedInstance
    //单个产品订单信息拼接
    func SingleProductOrder(payWay:String,remark:String) ->[JSON]{
        var orderBuyInfo = OrderBuyInfo()
        orderBuyInfo.pdid = pd_keyid  //接口获取
        NSLog("pd_keyid = \(pd_keyid)")
        orderBuyInfo.pname = productName//product.p_title
        orderBuyInfo.price = productPrice
        orderBuyInfo.quantity = "1"
        
        var orderBuyInfoArry:[OrderBuyInfo] = [OrderBuyInfo]()
        orderBuyInfoArry.append(orderBuyInfo) //添加订单下的产品（在此处只有一个商品）
        

        
        var productOrder = ProductOrder()
        productOrder.shopid = p_adminid //商家ID
        productOrder.address = usrAddress //收货人地址
        productOrder.contacttel =  usrTel//收货人电话
        productOrder.deduct = "0"
        productOrder.integral = "0"
        productOrder.odsdata = orderBuyInfoArry
        productOrder.otmoney = productPrice
        productOrder.postcode = "127948169"
        productOrder.pway = "1" //在线支付"1",货到付款“2”
        productOrder.remark = remark
        productOrder.uid = currentRoleInfomation.keyid
        productOrder.uname = usrName //收货人
        
        if currentRoleInfomation.usertype == "30001" {
            productOrder.utype = "2"
        }else{
            productOrder.utype = "1"
        }
        
        
        NSLog("productOrder = \(productOrder)")
        var productOrderArry = [ProductOrder]()
        productOrderArry.append(productOrder) //生成订单数据（此处只有一个商家的产品）
        
        //将订单拼接成JSON数据
        return orderToJson(productOrderArry: productOrderArry)
    }
    
    //订单数据处理
    func orderToJson(#productOrderArry:[ProductOrder])->[JSON]{
        
        /*****************************************************/
        //单个订单
        var myorder:[ JSON ] =  [ JSON ]()
        for (var i = 0 ; i < productOrderArry.count ; i++ ){
            var productOrder = productOrderArry[i]
            
            var jsonTemp:JSON = ["shopid":productOrder.shopid,
                "address":productOrder.address,"utype":productOrder.utype,"uid":productOrder.uid,"uname":productOrder.uname,"pway":productOrder.pway,"otmoney":productOrder.otmoney,"integral":productOrder.integral,"deduct":productOrder.deduct,"contacttel":productOrder.contacttel,"postcode":productOrder.postcode,"remark":productOrder.remark
            ]
            
            //odsdata添加
            var odsdata = [OrderBuyInfo]()
            var dataArry:[AnyObject] = [AnyObject]()
            
            odsdata = productOrder.odsdata //获取该商家下的所有商品
            
            for(var cnt = 0 ; cnt < odsdata.count ; cnt++ ){
                var orderBuyInfo = odsdata[cnt]
                var data =  [ "pdid":orderBuyInfo.pdid,"pname":orderBuyInfo.pname,"price":orderBuyInfo.price,"quantity":orderBuyInfo.quantity ]
                dataArry.append(data)
            }
            var myjson = JSON(dataArry)
            jsonTemp["odsdata"] = myjson
            NSLog("jsonTemp = \(jsonTemp)")
            myorder.append(jsonTemp)
        }
        
        
        
        return myorder
        
    }
    
    func getLinitProductOrder(){
        var order:[JSON] = SingleProductOrder("1",remark:"这是抢购商品")
        
        
        
        let parameters = [ "format": "normal" ,"order": order.description]
        let usrOrderUrl:String = serversBaseURL + "/fpactf/a_order/adddsporder?"
        if netIsavalaible {
        Alamofire.request(.POST,usrOrderUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("request == \(request)")
            
            NSLog("data == \(data)")
            NSLog("error == \(error)")
            if let dataTemp: AnyObject = data {
                var dataTemp = JSON(data!)
                if "100" == dataTemp["result"].description {
                    NSLog("抢购到商品了")
                    var orderNum = dataTemp["data"].description

                    self.orderPay(self.productName, orderNum: orderNum, amount: self.productPrice)
                    
                }else if "703" == dataTemp["result"].description {
                    var alart = UIAlertView(title: "提示", message: "下次速度放快点吧", delegate: nil, cancelButtonTitle: "确定")
                    alart.show()
                }else if "10019" == dataTemp["result"].description {
                    var alart = UIAlertView(title: "提示", message: "今天没有机会抢了，等明天吧！", delegate: nil, cancelButtonTitle: "确定")
                    alart.show()
                }
            }else{
                var alart = UIAlertView(title: "提示", message: "网络响应慢，请重试！！！", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    
    @IBAction func buyBtnClk(sender: AnyObject) {
        NSLog("进行抢购")
        //第一步 判断用户是否填写了收货信息
        if  usrName.length == 0 || usrName.length == 0 || usrName.length == 0{
            var alart = UIAlertView(title: "提示", message: "您必须填写用户收货信息后才能进行抢购，否则商品无法寄出", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        

        
        getLinitProductOrder()
    }
    @IBOutlet var buyBtn: UIButton!

    @IBOutlet var price: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var date: UILabel!
    
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var imgHeight: NSLayoutConstraint!//图片高度约束
    
    @IBOutlet var imgWeight: NSLayoutConstraint!
    
    @IBOutlet var usrAndTel: UILabel!
    @IBOutlet var address: UILabel!
    //用户信息
    var usrName = ""
    var usrTel = ""
    var usrAddress = ""
    @IBAction func selectAddressBtnClk(sender: AnyObject) {
        NSLog("去选择地址")
        
        self.pushFlag = true //标记定时器当前还在有效状态
        
        var selectPalceOfReceiptVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectPalceOfReceiptVC") as! SelectPalceOfReceiptVC
        
        self.navigationController?.pushViewController(selectPalceOfReceiptVC, animated: true)
    }
    
    
    var currentTime :NSDate!
    var startTime : NSDate!
    var endTime : NSDate!
    
    var currentTimeStr = ""
    var startTimeStr = ""
    var endTimeStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.sd_setImageWithURL(NSURL(string: imageURL))
        price.text = "抢购价格：￥" + productPrice
        name.text = "商品名字：" + productName
        
//        NSLog("currentTimeStr = \(currentTimeStr)")
//        NSLog("startTimeStr = \(startTimeStr)")
//        NSLog("endTimeStr = \(endTimeStr)")
        
        
        imgHeight.constant = 1*screenWith/3.0
        imgWeight.constant = 1*screenWith/3.0
        date!.textAlignment = NSTextAlignment.Center
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
        
        
        //接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("weixinPayResultReqOrderConfirmVCProcess:"), name: "weixinPayResultReqLimitBuyProductInfoVC", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("aliPayResultReqOrderProcess:"), name: "aliPayResultReqLimitBuyProductInfoVC", object: nil)
        
        
        //usrOrderReq 订单提交监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("usrOrderReqProcess:"), name: "LimitBuyProductInfoVCWeixin", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("usrOrderReqProcess:"), name: "LimitBuyProductInfoVCAlipay", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("usrHaveSelectedAddressProcess:"), name: "usrHaveSelectedAddress", object: nil)
        
        
        var alart = UIAlertView(title: "提示", message: "为了能将产品送达到您手中，在抢购前务必填写用户收货信息", delegate: nil, cancelButtonTitle: "确定")
        alart.show()
        
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
            
            self.usrName = placeOfReceiptTemp.name
            self.usrTel = placeOfReceiptTemp.phone
            self.usrAddress = placeOfReceiptTemp.address
            
            usrAndTel.text = self.usrName + "     电话:" + self.usrTel
            address.text = "地址:" + self.usrAddress
        }
        
    }
    
    //取消通知订阅
    deinit{
        NSLog("页面释放")
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func shiJianCha(timeA:NSDate,timeB:NSDate)->Int{
        var secondsInterval = NSTimeInterval()
        secondsInterval = timeB.timeIntervalSinceDate(timeA)
        //        NSTimeInterval secondsInterval= [date timeIntervalSinceDate:tomorrow];
        NSLog("secondsInterval=  \(secondsInterval)")
        return Int(secondsInterval)
    }
    
    func updateTimer(sender: NSTimer) {
        currentTime = currentTime + 1.seconds
        
        
        let secondOfHour = 60*60
        let hour = Int(newValues / secondOfHour)
        let min = Int((newValues - hour*3600) / 60)
        let seconds = Int(newValues % 60)
        
        newValues -= 1
        
        NSLog("min == \(min) seconds == \(seconds) ")
        
        if currentTime < startTime {
            NSLog("抢购还没开始,距抢购时间还有")
           newValues =  shiJianCha(currentTime, timeB: startTime)
            date!.text = NSString(format: "距抢购时间还有 %02d:%02d:%02d",hour, min, seconds) as String
            buyBtn.enabled = false
            buyBtn.backgroundColor = UIColor.grayColor()
        }else if currentTime > endTime{
            NSLog("抢购结束了")
            newValues = shiJianCha(endTime, timeB: currentTime)
            date!.text = NSString(format: "抢购结束了") as String
            buyBtn.enabled = false
            buyBtn.backgroundColor = UIColor.grayColor()
            timer.invalidate()
        }else{
            NSLog("正在抢购")
            newValues = shiJianCha(currentTime, timeB: endTime)
            date!.text = NSString(format: "距结束还有 %02d:%02d:%02d",hour, min, seconds) as String
            buyBtn.enabled = true
            buyBtn.backgroundColor = UIColor.redColor()
        }
        
        
        
        
        
        NSLog("newValues1 == \(newValues)")
        
        
        
    }
    
    /**
    支付调起
    
    - parameter pname:    商品名称
    - parameter orderNum: 订单号
    - parameter amount:   价格（元）
    */
    func orderPay(pname:String,orderNum:String,amount:String){
        var alertController = UIAlertController(title: "恭喜您抢购到该商品", message: "请选择支付方式进行支付吧", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //var productName:[OrderDetail] = orderDetailDic[self.orderInfoArry[whichSection].orderno]!
        var pname = pname//商品名称
        var orderNum = orderNum//抢购到商品的订单号
        var amount = amount//商品价格
        var cancelAction = UIAlertAction(title: "放弃这个商品", style: UIAlertActionStyle.Cancel, handler:nil)
        var deleteAction = UIAlertAction(title: "支付宝支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("支付宝支付")
            //调起支付宝进行支付
            let clientType = "&clientdevicetype=iOS"
            
            var  notifyUrl = serversBaseURL + "/fpactf/a_order/paycallback?op=\(orderNum)&scid=-1" + clientType
            
            
            payforUseAlipay(tradeNO: orderNum, productName: pname, productDescription: pname, amount:amount , notifyURL: notifyUrl, whoAreYou: "LimitBuyProductInfoVC")
            
        } )
        var archiveAction = UIAlertAction(title: "微信支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("微信支付")
            
            var  notifyUrl = serversBaseURL + "/fpactf/a_order/wxpaycallback?params={\"op\":\"\(orderNum)\",\"scid\":\"-1\",\"clientdevicetype\"=\"iOS\"}"
            
            
            NSLog("notifyUrl = \(notifyUrl)")
            //价格：单位（分）
            var price =  NSNumberFormatter().numberFromString(amount)!.doubleValue * 100
            NSLog("price = \(price)")
            
            weiXinPay(tradeNO:orderNum , productName:pname, productDescription:pname, amount: Int(price).description, notifyURL: notifyUrl, whoAreYou: "LimitBuyProductInfoVC")
            
        } )
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    override func viewWillDisappear(animated: Bool) {
        if self.pushFlag == false {//可以将定时器释放了
            self.timer.invalidate()
        }else{
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.pushFlag = false //定时器有效标记
        
        let getWaitToDeliverOrderInfoUrl = serversBaseURL + "/fpactf/a_pro/getadstpl?"
        let parameters = ["format": "normal","atype":"all"]
        
        if netIsavalaible {
        Alamofire.request(.GET,getWaitToDeliverOrderInfoUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("data == \(data)")
            if let dataTemp: AnyObject = data {
                
                var dataTemp = JSON(data!)
                if "100" == dataTemp["result"] {
                    self.currentTimeStr = dataTemp["currenttime"].stringValue//服务器当前时间
                    self.startTimeStr = dataTemp["starttime"].stringValue//活动开始时间
                    self.endTimeStr = dataTemp["endtime"].stringValue//活动计算时间
                    
                    NSLog("self.currentTimeStr == \(self.currentTimeStr)")
                    NSLog("self.startTimeStr == \(self.startTimeStr)")
                    NSLog("self.endTimeStr == \(self.endTimeStr)")
                    
                    var currenttimeStr = returnTime(self.currentTimeStr)
                    self.currentTime = NSDate().set(year: currenttimeStr.year, month: currenttimeStr.month, day: currenttimeStr.day  , hour: currenttimeStr.hour, minute: currenttimeStr.minutes, second: currenttimeStr.sec, tz: "UTC")
                    NSLog("currentTime == \(self.currentTime)")
                    
                    var starttimeStr = returnTime(self.startTimeStr)
                    self.startTime = NSDate().set(year: starttimeStr.year, month: starttimeStr.month, day: starttimeStr.day  , hour: starttimeStr.hour, minute: starttimeStr.minutes, second: 00, tz: "UTC")
                    NSLog("startTime == \(self.startTime)")
                    
                    
                    var endtimeStr = returnTime(self.endTimeStr)
                    self.endTime = NSDate().set(year: endtimeStr.year, month: endtimeStr.month, day: endtimeStr.day  , hour: endtimeStr.hour, minute: endtimeStr.minutes, second: 00, tz: "UTC")
                    NSLog("endTime == \(self.endTime)")
                    
                    self.timer.fire()//开始计时
                }
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
    
    ////支付宝状态标记（支付结果显示）
    func aliPayResultReqOrderProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            var resultStatus = dataTemp["resultStatus"].stringValue
            if resultStatus == "9000" {
                var alart = UIAlertView(title: "提示", message: "该订单支付成功,请到我的订单里查看", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
                //self.navigationController?.popViewControllerAnimated(false)
            }else if resultStatus == "6001" {
                var alart = UIAlertView(title: "提示", message: "该订单未支付成功", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            
        }
        
    }

    
    ////微信支付状态标记（支付结果显示）
    func weixinPayResultReqOrderConfirmVCProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        if  let senderTemp:AnyObject = sender.object {
            
            var orderState = 0
            
            NSLog("dataTemp = \(senderTemp)")
            var resultStatus = senderTemp.description
            if resultStatus == "0" {
                orderState = 2
                //ProgressHUD.showSuccess("支付成功")
                var alart = UIAlertView(title: "提示", message: "该订单支付成功,请到我的订单里查看", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
                
            }else if resultStatus == "-1" {
                orderState = 0
                ProgressHUD.showError("支付失败")
                
            }else{
                orderState = 1
                ProgressHUD.showError("你中途取消了该笔订单")
                
            }
  
        }else{
            //self.navigationController?.popViewControllerAnimated(false)
        }
        
    }




}



