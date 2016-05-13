//
//  ShoppingRootVC.swift
//  YaoDe
//
//  Created by iosnull on 15/8/31.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ShoppingRootVC: UITabBarController,UIAlertViewDelegate {
    
    var itemNameArray:[String] = ["首页_03","首页_05","首页_07","首页_09"]
    var itemNameSelectArray:[String] = ["首页_04","首页_06","首页_08","首页_10"]
    
    func configTabBar() {
        var count:Int = 0;
        let items = self.tabBar.items
        for item in items as! [UITabBarItem] {
            var image:UIImage = UIImage(named: itemNameArray[count])!
            var selectedimage:UIImage = UIImage(named: itemNameSelectArray[count])!;
            image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            selectedimage = selectedimage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            item.selectedImage = selectedimage;
            item.image = image;
            count++;
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置tabbarItem颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 168/255, green: 35/255, blue: 45/255, alpha: 1.0)], forState: UIControlState.Selected)
        
        
        
        NSLog("tabbarselect 0")
        self.selectedIndex = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("progressHavaNotReceivedGoods"), name:"havaNotReceivedGoods", object: nil)
        
    }
    
    func progressHavaNotReceivedGoods(){
        
    }
    
    /**
    获取订单信息
    */
    func getOrderData(userid:String,payway:String,IsWaybill:String,status:String,PageSize:String,CurrentPage:String){
        
        
        let url = serversBaseURL + "/orders/list"
        
        let parameters = ["usertype":"1","userid":userid,"payway":payway,"IsWaybill":IsWaybill,"status":status,"PageSize":PageSize,"CurrentPage":CurrentPage]
        
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
            Alamofire.request(.GET,url,parameters: para).responseString{ (request, response, data, error) in
                NSLog("error = \(error)")
                NSLog("data = \(data)")
                
                var json = self.StringToJSON(data!)
                NSLog("json = \(json.description)")
                
                var myOrderModel = OrderModel()
                var message = json["message"].stringValue
                if json["success"].stringValue == "true" {
                    
                    var data = json["data"]
                    NSLog("data = \(data.description)")
                    
                    var list = data["list"]
                    NSLog("list = \(list.count)")
                    if list.count != 0 {
                        var alert = UIAlertView(title: "提示", message: "你有\(list.count)笔未签收的订单", delegate: self, cancelButtonTitle: "稍后去看", otherButtonTitles: "去签收")
                        alert.show()
                    }
                    
                }else{
                    
                }
            }
        }else{
            //netIsEnable("网络不可用")
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("代理\(buttonIndex)")
        if buttonIndex == 1 {
            //            var myOrderShow = ProfileVC()
            //            myOrderShow.pushMyoder()
            //            myOrderShow.hidesBottomBarWhenPushed = true
            
            self.selectedIndex = 3
            
            if let childrenVC = self.viewControllers {
                NSLog("childrenVC = \(childrenVC.description)")
                var vc: UINavigationController = childrenVC[3] as! UINavigationController
                var myOrderShow = MyOrderInfoShowVC()
                vc.pushViewController(myOrderShow, animated: false)
                
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeFromParentViewController()
        NSLog("ShoppingRootVC")

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    
    func setNavigationBar(){
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        configTabBar()
        setNavigationBar()
        
        
        self.selectedViewController?.beginAppearanceTransition(true, animated: animated)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        refreshGouWuCheBadgeValue(self)
        
        NSLog("tabbarselect 0")
        //self.selectedIndex = 0
        self.selectedViewController?.endAppearanceTransition()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.selectedViewController?.beginAppearanceTransition(false, animated: animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.selectedViewController?.endAppearanceTransition()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
