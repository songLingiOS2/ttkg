//
//  GlobleFiles.swift
//  YaoDe
//
//  Created by iosnull on 15/8/28.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

func showMessageAnimate(view:UIView,message:String){
    var HUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
    
    HUD.mode = MBProgressHUDMode.Text
    HUD.label.text = message
    //HUD.offset = CGPointMake(0.0, MBProgressMaxOffset);
    HUD.hideAnimated(true, afterDelay: 1)
    
}


func showMessageAnimate123(view:UIView,message:String){
    var HUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
    
    HUD.mode = MBProgressHUDMode.Text
    HUD.label.text = message
    //HUD.offset = CGPointMake(0.0, MBProgressMaxOffset);
    HUD.hideAnimated(true, afterDelay: 3)
    
    
}

func showJuHuaAnimate(view:UIView,message:String){
    var HUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
    
    HUD.mode = MBProgressHUDMode.Text
    HUD.label.text = message
    //HUD.offset = CGPointMake(0.0, MBProgressMaxOffset);
    HUD.hideAnimated(true, afterDelay: 1)
}

//计算文本高度
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}



let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height


func NSNotificationToJSON(sender:NSNotification)->JSON{
    
    
    var resultData = (sender.object!) as! String
    NSLog("resultData = \(resultData)")
    if let dataFromString = resultData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
        
        let json = JSON(data:dataFromString)
        NSLog("json = \(json.description)")
        return json
    }else{
        return nil
    }
    
}




var newVersionIsAvailable = false //是否有新版本可以使用


/**
有新版本可以更新,直接跳到指定下载页面
*/
func updateYaode100APP(){
    /**
    * 有新版本可以更新
    */
    if newVersionIsAvailable {
        NSLog("————————————————————————————————————————————————有可以使用的版本")
        
        var nowTime = time(nil)
        
        let updateURL = "https:" + "?v=\(nowTime)"
        NSLog("updateURL == \(updateURL)")
        
        UIApplication.sharedApplication().openURL(NSURL(string:updateURL )!)
    }
}


//用户登陆标记
let customerRole =  "customerRole"
let managerRole =  "managerRole"

//当前区域ID与切换后的区域ID状态标记
var currentAreaID = "" //当前
var proAreaID = ""  //前一个时刻


////网络可用标记
var netIsavalaible = true

func netIsEnable(value:String){
    ProgressHUD.showError(value)
    //var alert = UIAlertView(title: "提示", message: value, delegate: nil, cancelButtonTitle: "确定")
    //alert.show()
}

//
var reach = Reachability(hostname: "www.baidu.com")//网络检测
//角色属性
var currentRoleInfomation = CurrentRoleInfomation()

//服务器地址

//let serversBaseURL = "http://192.168.1.141"
let serversBaseURL = "http://appapi.ttkg365.com"
//图片服务器地址
//let serversBaseUrlForPicture = "http://192.168.1.141:81"
let serversBaseUrlForPicture = "http://management.ttkg365.com"


//加密地址
let secretBaseURL =   "http://appapi.ttkg365.com"
//let secretBaseURL =   "http://192.168.1.141"


//免登陆调试用
//let momoname = "18908502495"
//let momopwd = "123456"

let screenWith = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height


/*******************支付宝天天快够begin**********************/
//商户PID
let PARTNER = "2088221301645152"
//商户收款账号
let SELLER = "3134633802@qq.com"
//商户私钥，pkcs8格式
let RSA_PRIVATE = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAN8Bla+QjQs9zhyoomnAxpY8IhnuLGn6aJpL/kYEiifzRV2KU+QJAoFj9wJFBVte7xYmBP55lQYAEynG4VmJCDEOWgxFItMUphSr90SZiv/r2kYlug4CnU86L1kquupLT+jpuPE0EO7aQCwGEzzO5Lyxpy2V2Jov2sic+2slHsTfAgMBAAECgYEA09d9ijmWwocDtNW88xjdjPmyq09FgacOlwR5l6nYU/sUebdd2dF1P9TmYJGQdSvJkxCqzdJRblHD4nu6toMl8y1oUQsCcewtr/hmetkNkH8DnhMdKAG/ACUV02ND8WwIKgMCUpUBKIYTfRCR8CrUpxM3RfvQMPb2UN3YFoArP4ECQQD6jXYb696bJEICX156mpNevvyWULcj5/NwkXpAJn+w8NCa+cMqj6D9mgRiGQ8i/HSaho9lGkvsNTGmlKsMgy5jAkEA49rN37WvRCaVhBCdjaJJ5HZsI7pqi+mGRd/1LsbcOjVsWE1E9/0i72qZcgtpwPD1WzrU2gDFDoWl4WBqmOWKVQJAIS8rPXd3/ERJGddXxBVE/398JMx79R17eKVL88MllmHOvzflSXXMdMo5WmTHRHL7XpwD0fgxpg9FjDKUlQuq0QJBAIaWfNqyX7d6rwBWLCo3/Tuks5WbDEpegwCNHC8oKXd8jOXPpnhxHoyaw854bVwZOGRN6OJoZ/1+9g+dOvnbRA0CQH5li28/8/MJQ8RVcUB8VeUyvITO2U83PT9H1wNmOVIuU76deERXSaO5j9yJ2uMuldqvH6XSI/2s5HZ2TOQywa0=";
//支付宝公钥
let RSA_PUBLIC = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";

// 支付宝安全支付服务apk的名称，必须与assets目录下的apk名称一致
let ALIPAY_PLUGIN_NAME = "alipay_msp.apk";
/*******************end*************************/

///**********************支付宝参数永福号***************************************/
////商户PID
//var PARTNER = "2088021336132195";
////商户收款账号
//var SELLER = "352122038@qq.com"//"137826854@qq.com";
////商户私钥，pkcs8格式
//var RSA_PRIVATE = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANImRjGs8CIZX06MiVh3TfHuF2VTQ3FWP1Wk7qiy1I1lNaaJEkWQqK8eEQFggY9CK8CeKNIluUvAf60If+N8KFP4brMWWxydHgZNaDO6fRjfa1Wqrg/I/KreIIhsOMwKqyavEqfSKtAQGjNl2sMje9s24hwTvEvNbYEZVkUAyl6vAgMBAAECgYAzYQYyaPzA6YEivDtsNKcK6lIwBL5tfE+5ybxL5IURGNiYIdUkyuxi/C/eLVEfzGbUDhce4fg+rA7LKFPUM2vMQk2zu1LTxR6jG45aWagRiAxlsswKvZfiYTYHws8U7vGe+qez0/P8gE0npVnkCnez+d8zVILNmxDG5huMFTuDGQJBAPVRti0lB4RIjUf5eXrqWcdKNQ79plA6Bo9AjrutS1Kd3lJovlG5tNv2W6vst1lWlJnjehHu1xwMy2VsBbQFvtMCQQDbTJElPngHE68FP9o33ZiKMMn2K9N0BWkII1XAef8AQlwOpygGffn7mlAvXlONgDnauiLVn7pKesTVuzU0to81AkEAscbOU3bjNJzzLXZ/73BHMWH4g22Tic4TFNr+1Mjnre5Tv7rCOS1wAHtOwY+g6zAQLlkoDDjeUCiBeXVHyMblGwJAVtcbIwR5w1OoGwwN/dFidlaboz/3nBoIXZCghHfK4u9kROkskGWSeG/DEP7pVz9Pqa3L3YxC2PuEtp5Lk3Q3gQJBAOBkf1OQywvMTceUncOuTlDz5dD4Aljb3FOZ48aCQcQWM64RDicR3SdVNPVcmooTww598vJWBvt7avx203xlhoU=";
////支付宝公钥
//var RSA_PUBLIC = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDSJkYxrPAiGV9OjIlYd03x7hdlU0NxVj9VpO6ostSNZTWmiRJFkKivHhEBYIGPQivAnijSJblLwH+tCH/jfChT+G6zFlscnR4GTWgzun0Y32tVqq4PyPyq3iCIbDjMCqsmrxKn0irQEBozZdrDI3vbNuIcE7xLzW2BGVZFAMperwIDAQAB";
//
//// 支付宝安全支付服务apk的名称，必须与assets目录下的apk名称一致
//var ALIPAY_PLUGIN_NAME = "alipay_msp.apk"

//支付宝支付调用
func payforUseAlipay(#tradeNO:String,#productName:String,#productDescription:String,#amount:String,#notifyURL:String,#whoAreYou:String){
    var order = Order()
    order.partner = PARTNER;
    order.seller = SELLER;
    order.tradeNO = tradeNO                                //订单ID（由商家自行制定）
    order.productName = productName              //商品标题
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
        NSNotificationCenter.defaultCenter().postNotificationName("aliPayResultReq\(whoAreYou)", object: result)
    }
}

/*************************************************************/
//#tradeNO:String,#productName:String,#productDescription:String,#amount:String,#notifyURL:String,#whoAreYou:String
func weiXinPay(#tradeNO:String,#productName:String,#productDescription:String,#amount:String,#notifyURL:String,#whoAreYou:String)->Int{
    
    if !WXApi.isWXAppInstalled() {
        ProgressHUD.dismiss()
        var alart = UIAlertView(title: "提示", message: "请先安装微信后再进行支付", delegate: nil, cancelButtonTitle: "确定")
        alart.show()
        return 0
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
    
    return 1
}




//网络连接测试
func serverIsAvalaible()->Bool{
    
    NSLog("网络连接检测》》》》》》》》》》》》》》》》》》》》》》》")
    
    
    var netState :NetworkStatus = reach!.currentReachabilityStatus()
    
    var state = false
    
    switch(netState){
    case NetworkStatus.NotReachable :
//        var alart = UIAlertView(title: "提示", message: "无可用的网络!!!", delegate: nil, cancelButtonTitle: "确定")
//        alart.show()
        state = false
        println("NotReachable")
        
    case NetworkStatus.ReachableViaWiFi:
        println("ReachableViaWiFi")
        state = true
    default:
        state = true
        println("ReachableViaWWAN")
        break
    }
    
    
    
    return state
}


















