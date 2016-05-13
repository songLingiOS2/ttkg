//
//  MerchantVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/11.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit

class MerchantVC: UITableViewController {

    //商家数据
    var merchantInfoArry = [MerchantInfo]()
    var http = ShoppingHttpReq.sharedInstance
    
    func setNavigationBar(){
                UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
         self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show("数据请求中")
        
        

        setNavigationBar()
        self.view.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 243/255, alpha: 1)
        //注册cell
        tableView.registerNib(UINib(nibName: "MerchantCell", bundle: nil), forCellReuseIdentifier: "MerchantCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //getMerchantListReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getMerchantListReqProcess:"), name: "getMerchantListReq", object: nil)
        
        
    }
    
    
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        ProgressHUD.dismiss()
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return merchantInfoArry.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MerchantCell") as! MerchantCell
        cell.setSubViewPara = merchantInfoArry[indexPath.section]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if merchantInfoArry[section].IsGivestate == "0" {
            return 35
        }else{
            return 0
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var merchantFooterView = MerchantFooterView(frame: CGRect(x: 0, y: 0, width: screenWith, height: 32))
        if merchantInfoArry[section].IsGivestate == "0" {
            merchantFooterView.text.text = merchantInfoArry[section].GiveMsg
            return merchantFooterView
        }else{
            return nil
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
      return 150
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("你选择的商家是：\(merchantInfoArry[indexPath.section].shopname)")
        
        
        
        var merchantVC = MerchantDetailVC()
        merchantVC.adminkid = merchantInfoArry[indexPath.section].keyid
        merchantVC.shopImageUrl = merchantInfoArry[indexPath.section].pic
        merchantVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(merchantVC, animated: true)

    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        http.getMerchantList(roleid: currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid, pagesize: "500", currentpage: "1")
        
    }

    override func viewWillDisappear(animated: Bool) {
        ProgressHUD.dismiss()
    }
}

extension MerchantVC {
    func getMerchantListReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        //清空数组
        merchantInfoArry = []
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue{
                
                
                var message = dataTemp["message"].stringValue
                
//                showMessageAnimate(self.view, message)
                
                ProgressHUD.showSuccess(message)
                
                var data = dataTemp["data"]["list"]
                for(var cnt = 0 ; cnt < data.count ; cnt++){
                    var merchantInfoTemp = MerchantInfo()
                    var merchantInfoData = data[cnt]
                    
                    merchantInfoTemp.areaid = merchantInfoData["areaid"].stringValue
                    merchantInfoTemp.shopname = merchantInfoData["shopname"].stringValue
                    merchantInfoTemp.roleid = merchantInfoData["roleid"].stringValue
                    merchantInfoTemp.address = merchantInfoData["address"].stringValue
                    merchantInfoTemp.pic = merchantInfoData["pic"].stringValue
                    merchantInfoTemp.keyid = merchantInfoData["KeyID"].stringValue
                    merchantInfoTemp.tel = merchantInfoData["tel"].stringValue
                    
                    merchantInfoTemp.carryingamount = merchantInfoData["carryingamount"].stringValue
                    merchantInfoTemp.IsGivestate = merchantInfoData["IsGivestate"].stringValue
                    merchantInfoTemp.givebase = merchantInfoData["givebase"].stringValue
                    merchantInfoTemp.gift = merchantInfoData["gift"].stringValue
                    merchantInfoTemp.giftQuota = merchantInfoData["giftQuota"].stringValue
                    merchantInfoTemp.GiveMsg = merchantInfoData["GiveMsg"].stringValue
                    merchantInfoArry.append(merchantInfoTemp)
                    
                    
                }
                
            }else{
                var message = dataTemp["message"].stringValue
                
                showMessageAnimate(self.view, message)
                //ProgressHUD.showError(message)
            }
        }
        tableView.reloadData()
    }
    
    
    
    
    
    
    
}
