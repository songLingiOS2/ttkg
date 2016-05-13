//
//  SelectPalceOfReceiptVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/10.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class SelectPalceOfReceiptVC: UITableViewController,UIAlertViewDelegate {
    
    var selectedFlag = true
    var tel = "4006603870"
    var http = ShoppingHttpReq.sharedInstance
    
    //收货地址数组
    var placeOfReceiptArry = [PlaceOfReceipt]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        setNavigationBar()
        
        //注册cell
        tableView.registerNib(UINib(nibName: "PlaceOfReceiptCell", bundle: nil), forCellReuseIdentifier: "placeOfReceiptCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getPlaceOfReceiptReqProcess:"), name: "getPlaceOfReceiptReqSelectPalceOfReceiptVC", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit{
        ProgressHUD.dismiss()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setNavigationBar(){
        var rightBtn = UIBarButtonItem(title: "管理", style: UIBarButtonItemStyle.Done, target: self, action: Selector("manageMyAddress"))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = "选择收货地址"
    }

    func manageMyAddress(){
        var addressManagerVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("AddressManagerVC") as! AddressManagerVC
        self.navigationController?.pushViewController(addressManagerVC, animated: true)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        //判断usertype 为3001 或 3002
        var usertypeTemp = ""
        if currentRoleInfomation.usertype == "30001" {
            usertypeTemp = "2"
        }else
        {
            usertypeTemp = "1"
        }
        
        http.getPlaceOfReceipt(usertype: usertypeTemp, userid: currentRoleInfomation.keyid, whoAreYou: "SelectPalceOfReceiptVC")
    }
}

extension SelectPalceOfReceiptVC{
    func getPlaceOfReceiptReqProcess(sender:NSNotification){
        placeOfReceiptArry = []  //清空收货地址数组
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            
            NSLog("dataTemp  \(dataTemp)")
            
            var message = dataTemp["message"].stringValue
            if "true" == dataTemp["success"].stringValue {
                NSLog("收货地址数据获取成功")
                var dataArry = dataTemp["data"]
                NSLog("收货地址数据  \(dataArry)")
                
                
                for(var cnt = 0 ; cnt < dataArry.count ; cnt++){
                    var placeReceiptData = dataArry[cnt]
                    var placeReceipttemp = PlaceOfReceipt()
                    placeReceipttemp.isdefault = placeReceiptData["IsDefault"].stringValue
                    placeReceipttemp.keyid = placeReceiptData["KeyID"].stringValue
                    placeReceipttemp.postcode = placeReceiptData["PostCode"].stringValue
                    placeReceipttemp.address = placeReceiptData["ReceiverAddress"].stringValue
                    placeReceipttemp.area = placeReceiptData["ReceiverArea"].stringValue
                    placeReceipttemp.name = placeReceiptData["ReceiverName"].stringValue
                    placeReceipttemp.phone = placeReceiptData["ReceiverPhoneNo"].stringValue
                    placeReceipttemp.remark = placeReceiptData["Remark"].stringValue
                    placeReceipttemp.sphone = placeReceiptData["StandbyPhoneNo"].stringValue
                    placeReceipttemp.userid = placeReceiptData["UserID"].stringValue
                    placeReceipttemp.usertype = placeReceiptData["UserType"].stringValue
                    placeReceipttemp.IsAuditStatus = placeReceiptData["IsAuditStatus"].stringValue
                    
                    placeOfReceiptArry.append(placeReceipttemp)
                }
                
                
            }else{
                
                tel = dataTemp["data"].stringValue
                
                var alert = UIAlertView(title: "提示！", message: message + tel, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "拨打")
                alert.show()
                alert.delegate = self
                
            }
            
        }
        //更新数据显示
        tableView.reloadData()
        
    }
    
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        NSLog("buttonIndex =\(buttonIndex)")
        
        if buttonIndex == 1{
            var url1 = NSURL(string: "tel://400-660-3870")
            UIApplication.sharedApplication().openURL(url1!)
        }else{
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return placeOfReceiptArry.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("placeOfReceiptCell") as! PlaceOfReceiptCell
        
        if (placeOfReceiptArry[indexPath.row].IsAuditStatus == "1") || (placeOfReceiptArry[indexPath.row].IsAuditStatus == "3") {
            cell.setSubViewPara = placeOfReceiptArry[indexPath.row]
            cell.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1 )
            cell.userInteractionEnabled = false
        }else{
            cell.setSubViewPara = placeOfReceiptArry[indexPath.row]
            cell.userInteractionEnabled = true
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 62
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("你选择了地址 \(placeOfReceiptArry[indexPath.row].name)  \(placeOfReceiptArry[indexPath.row].phone) \(placeOfReceiptArry[indexPath.row].address)")
        //var data = placeOfReceiptArry[indexPath.row]
        
        
        if (placeOfReceiptArry[indexPath.row].IsAuditStatus == "1") || (placeOfReceiptArry[indexPath.row].IsAuditStatus == "3") {
        
        }else{
        
        let data = ["selectedAddress":[
            "address":placeOfReceiptArry[indexPath.row].address ,
            "area":placeOfReceiptArry[indexPath.row].area ,
            "isdefault":placeOfReceiptArry[indexPath.row].isdefault ,
            "keyid":placeOfReceiptArry[indexPath.row].keyid ,
            "name":placeOfReceiptArry[indexPath.row].name ,
            "phone":placeOfReceiptArry[indexPath.row].phone ,
            "postcode":placeOfReceiptArry[indexPath.row].postcode ,
            "remark":placeOfReceiptArry[indexPath.row].remark ,
            "sphone":placeOfReceiptArry[indexPath.row].sphone ,
            "userid":placeOfReceiptArry[indexPath.row].userid ,
            "usertype":placeOfReceiptArry[indexPath.row].usertype]]
        
        NSNotificationCenter.defaultCenter().postNotificationName("usrHaveSelectedAddress", object: data, userInfo: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
        
    }
    
}
