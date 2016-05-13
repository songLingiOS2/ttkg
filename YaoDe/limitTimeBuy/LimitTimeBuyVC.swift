//
//  LimitTimeBuyVC.swift
//  YaoDe
//
//  Created by iosnull on 16/1/11.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON



//限时购商品内容
struct LimitProduct {
    var img_creattime = ""
    var img_ding = ""
    var img_display = ""
    var img_keyid = ""
    var img_targetid = ""
    var img_type = ""
    var img_url = ""
    var img_urlsmall = ""
    var p_Description = ""
    var p_adminid = ""
    var p_cid = ""
    var p_creattime = ""
    var p_ding = ""
    var p_display = ""
    var p_dtid = ""
    var p_endtime = ""
    var p_keyid = ""
    var p_limit = ""
    var p_promotion = ""
    var p_recommend = ""
    var p_salesvolume = ""
    var p_shelves = ""
    var p_starttime = ""
    var p_status = ""
    var p_title = ""
    var p_type = ""
    var pd_creattime = ""
    var pd_discript = ""
    var pd_display = ""
    var pd_ispurchase = ""
    var pd_keyid = ""
    var pd_pid = ""
    var pd_pname = ""
    var pd_price = ""
    var pd_ptprice = ""
    var pd_purchasenum = ""
    var pd_salesvolume = ""
    var pd_spec = ""
    var pd_stock = ""
    var shop_contact = ""
    var shop_introduce = ""
    var shop_name = ""
    
}

class LimitTimeBuyVC: UITableViewController,UIAlertViewDelegate {
    
    
    //限时购商品
    var limitProduct = [LimitProduct]()
    var currenttime = ""//服务器当前时间
    var starttime = ""//活动开始时间
    var endtime = ""//活动计算时间
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return limitProduct.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let cell = UITableViewCell()
        cell.textLabel?.text = limitProduct[indexPath.row].p_title
        cell.imageView?.sd_setImageWithURL(NSURL(string: limitProduct[indexPath.row].img_url), placeholderImage: UIImage(named: "园logo-01"))
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("你选择的是：\(indexPath.row)")
        var limitBuyProductInfoVC = UIStoryboard(name: "LimitTimeBuy", bundle: nil).instantiateViewControllerWithIdentifier("LimitBuyProductInfoVC") as! LimitBuyProductInfoVC
        
        //limitBuyProductInfoVC.currentTimeStr =   currenttime //服务器当前时间
        //limitBuyProductInfoVC.startTimeStr = starttime  //活动开始时间
        //limitBuyProductInfoVC.endTimeStr = endtime  //活动计算时间
        
        limitBuyProductInfoVC.p_adminid = limitProduct[indexPath.row].p_adminid
        limitBuyProductInfoVC.pd_keyid = limitProduct[indexPath.row].pd_keyid
        limitBuyProductInfoVC.productName = limitProduct[indexPath.row].p_title
        limitBuyProductInfoVC.productPrice =  limitProduct[indexPath.row].pd_ptprice
        limitBuyProductInfoVC.imageURL = limitProduct[indexPath.row].img_url
        limitBuyProductInfoVC.pd_pid = limitProduct[indexPath.row].pd_pid
        
        self.navigationController?.pushViewController(limitBuyProductInfoVC, animated: true)
    }
    

    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true  //隐藏tabBarController
        
        //网络请求获取商品数据
        //192.168.99.124:8080/fpactf/a_pro/getadstpl?format=normal&atype=all
        let getWaitToDeliverOrderInfoUrl = serversBaseURL + "/fpactf/a_pro/getadstpl?"
        let parameters = ["format": "normal","atype":"all"]
        
        if netIsavalaible {
        Alamofire.request(.GET,getWaitToDeliverOrderInfoUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("data == \(data)")
            if let dataTemp: AnyObject = data {
                self.limitProduct = []
                var dataTemp = JSON(data!)
                if "100" == dataTemp["result"] {
                     self.currenttime = dataTemp["currenttime"].stringValue//服务器当前时间
                     self.starttime = dataTemp["starttime"].stringValue//活动开始时间
                     self.endtime = dataTemp["endtime"].stringValue//活动计算时间
                    
                    var dataArry = dataTemp["data"]
                    
                    var limitProduct = LimitProduct()
                    for(var cnt = 0 ; cnt < dataArry.count ; cnt++ ){
                        var data  = dataArry[cnt]
                        limitProduct.img_url = data["img_url"].stringValue
                        limitProduct.img_urlsmall = data["img_urlsmall"].stringValue
                        limitProduct.p_title = data["p_title"].stringValue
                        limitProduct.pd_ptprice = data["pd_ptprice"].stringValue
                        limitProduct.pd_price = data["pd_price"].stringValue
                        limitProduct.p_keyid = data["p_keyid"].stringValue
                        limitProduct.pd_keyid = data["pd_keyid"].stringValue
                        limitProduct.p_adminid = data["p_adminid"].stringValue
                        limitProduct.pd_pid = data["pd_pid"].stringValue
                        self.limitProduct.append(limitProduct)
                    }
                    self.tableView.reloadData()
                }else if  "703" == dataTemp["result"]{
                    var alertView = UIAlertView(title: "抢购信息", message: "亲~ 还没到抢购时间哦！", delegate: self, cancelButtonTitle: "确定")
                    alertView.delegate = self
                    alertView.show()
                   
                }
                
                
                
                
                
                
            }

        }
        }else{
            netIsEnable("网络不可用")
        }

        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        NSLog("buttonIndex == \(buttonIndex)")
        if 0 == buttonIndex {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    

    
}
