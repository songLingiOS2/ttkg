//
//  AppDelegate.swift
//  YaoDe
//
//  Created by iosnull on 15/8/24.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,WXApiDelegate,UIAlertViewDelegate{
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func onResp(resp: BaseResp!) {
        
        //        返回结果
        //        名称	描述	解决方案
        //        0	成功	展示成功页面
        //        -1	错误	可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
        //        -2	用户取消	无需处理。发生场景：用户不支付了，点击取消，返回APP。
        
        var errCode = resp.errCode
        var errStr = resp.errStr
        var type = resp.type
        NSLog("errCode = \(errCode)")
        NSLog("errStr = \(errStr)")
        NSLog("type = \(type)")
        
        //var myOrderShow = MyOrderInfoShowVC()
        //self.navigationController?.pushViewController(myOrderShow, animated: false)
        
//        //weixin发出通知
//        NSNotificationCenter.defaultCenter().postNotificationName("weixinPayResultReqOrderConfirmVC", object: errCode.description)
//        
//        NSNotificationCenter.defaultCenter().postNotificationName("weixinPayResultReqOrderConfirmationVC", object: errCode.description)
//        //发给抢购
//        NSNotificationCenter.defaultCenter().postNotificationName("weixinPayResultReqLimitBuyProductInfoVC", object: errCode.description)
        
    }
    func onReq(req: BaseReq!) {
        NSLog("req = \(req)")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (result) -> Void in
            NSLog("zhifubao = \(result)")
            NSLog("支付宝回调结果")
        })
        
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    
    func netIsAvalaible()->Bool{
        
        NSLog("网络连接检测》》》》》》》》》》》》》》》》》》》》》》》")
        
        
        var netState :NetworkStatus = reach!.currentReachabilityStatus()
        
        var state = false
        
        switch(netState){
        case NetworkStatus.NotReachable :
//            var alart = UIAlertView(title: "提示", message: "网络不可用", delegate: nil, cancelButtonTitle: "确定")
//            alart.show()
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
        
        //全局变量
        netIsavalaible = state
        
        return state
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //有未签收的订单通知
        NSNotificationCenter.defaultCenter().postNotificationName("havaNotReceivedGoods", object: nil)
        
        
        Bugly.startWithAppId("900024567")//bug日志分析
        //网络连接监听
        reach!.startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("netIsAvalaible"), name:kReachabilityChangedNotification, object: nil)
        
        
        //iOS版本
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("iOSVersionProcess:"), name: "iOSVersion", object: nil)
        
        
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        window?.backgroundColor = UIColor.whiteColor()
        
        var    rootVC:UIViewController
        
        rootVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginRegistVC") as!  LoginRegistVC
        
        window?.rootViewController = rootVC
        
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        WXApi.registerApp("wxc81564befb45171c", withDescription: "demo 2.0")
        //友盟Appkey
        UMSocialData.setAppKey("56039ecee0f55aef3d002702")
        //友盟微信分享集成
        UMSocialWechatHandler.setWXAppId("wxc81564befb45171c", appSecret: "cb8f3d32faa539e46555447c1b51f385", url: "www.ttkg.com")
        //友盟消息推送
        UMessage.startWithAppkey("56039ecee0f55aef3d002702", launchOptions: launchOptions)
        //获取设备的 DeviceToken
        
        
        
        //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        if true{
            //register remoteNotification types （iOS 8.0及其以上版本）
            var action1:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            action1.identifier = "action1_identifier";
            action1.title = "Accept";
            action1.activationMode = UIUserNotificationActivationMode.Foreground;//当点击的时候启动程序
            
            var action2 = UIMutableUserNotificationAction()//第二按钮
            action2.identifier =  "action2_identifier";
            action2.title =   "Reject";
            action2.activationMode = UIUserNotificationActivationMode.Background;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = true ;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = true
            
            var categorys =  UIMutableUserNotificationCategory()
            categorys.identifier =  "category1";//这组动作的唯一标示
            categorys.setActions([action1,action2], forContext: UIUserNotificationActionContext.Default)
            //[categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            
            //UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|categories:[NSSet setWithObject:categorys]];UIUserNotificationTypeAlert
            var userSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge|UIUserNotificationType.Sound|UIUserNotificationType.Alert, categories: NSSet(objects: categorys) as Set<NSObject> )//NSSet(object: categorys)
            
            UMessage.registerRemoteNotificationAndUserNotificationSettings(userSettings)
            
            
            
            UMessage.setLogEnabled(true)//开启日志打印
            
        }
        
        
        //键盘
        IQKeyboardManager.sharedManager().enable = true
        
        
        return true
    }
    
    
    /**
    完成推送功能
    2015-12-14 PM3:53
    - parameter application: application description
    - parameter deviceToken: deviceToken description
    */
    
    //推送用
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        UMessage.registerDeviceToken(deviceToken)
        var tokenn = deviceToken.description
        NSLog("tokenn = \(tokenn)")
    }
    //推送用
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        UMessage.didReceiveRemoteNotification(userInfo)
        
    }
    /**********************************************************************************************/
    
    
    
    /**********************************************************************************************/
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        
    }
    
    
    var http = ShoppingHttpReq.sharedInstance
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //检测版本更新
        NSLog("应用进入前台")
        http.iOSVersion()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
    }
    
    func iOSVersionProcess(sender:NSNotification){
        
        
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            var message = dataTemp["msg"].stringValue
            var description = dataTemp["description"].stringValue
            
            NSLog("dataTemp = \(dataTemp)")
            if "true" == dataTemp["success"].stringValue {
                if "1" == dataTemp["appstate"].stringValue && "1" == dataTemp["state"].stringValue {
                    
                    var alert = UIAlertView(title: message, message: description, delegate: self, cancelButtonTitle: "确认", otherButtonTitles: "取消")
                    alert.delegate = self
                    alert.tag = 50
                    alert.show()
                }else if  "4" == dataTemp["appstate"].stringValue && "1" == dataTemp["state"].stringValue{
                    
                    var alert = UIAlertView(title: message, message: description, delegate: self, cancelButtonTitle: "确认")
                    alert.delegate = self
                    alert.tag = 100
                    alert.show()
                    
                    
                    
                }else if "2" == dataTemp["appstate"].stringValue && "1" == dataTemp["state"].stringValue{
                    
                }else{
                    
                }
                
                
                
            }else{
                if  "-1" == dataTemp["state"].stringValue{
                    var message = dataTemp["msg"].stringValue
                    var alert = UIAlertView(title: message, message: description, delegate: self, cancelButtonTitle: "确认")
                    
                    alert.show()
                }else{
                    
                }
                
            }
            
            
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if alertView.tag == 50{
        
        if buttonIndex == 1 {
            NSLog("buttonIndex == \(buttonIndex)")
        }else{
            NSLog("buttonIndex == \(buttonIndex)")
            
            let updateURL = "https://app.ttkg365.com/app/index"
            
            UIApplication.sharedApplication().openURL(NSURL(string:updateURL )!)
            
         }
        }
        
        
        if alertView.tag == 100 {
            if buttonIndex == 0 {
                NSLog("buttonIndex == \(buttonIndex)")
                
                let updateURL = "https://app.ttkg365.com/app/index"
                
                UIApplication.sharedApplication().openURL(NSURL(string:updateURL )!)
                
            }
        }
        
        
        
        
        
        
    }
    
    
}

