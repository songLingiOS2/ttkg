//
//  AddressManagerVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/9.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class AddressManagerVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate{
    var tel = "4006603870"
    
    var http = ShoppingHttpReq.sharedInstance
    
    //收货地址数组
    var placeOfReceiptArry = [PlaceOfReceipt]()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var addNewAddress: UIButton!
    @IBAction func addNewAddressBtnClk(sender: UIButton) {
        NSLog("添加新收货地址")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册cell
        tableView.registerNib(UINib(nibName: "PlaceOfReceiptCell", bundle: nil), forCellReuseIdentifier: "placeOfReceiptCell")
        
        setSubViewPara()
        
        
        tableView.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: Selector("pullDownUpdate"))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getPlaceOfReceiptReqProcess:"), name: "getPlaceOfReceiptReqAddressManagerVC", object: nil)
        
    }
    
    func pullDownUpdate(){
        showJuHuaAnimate(self.navigationController!.view, "请等待....")
        http.getPlaceOfReceipt(usertype:"1", userid: currentRoleInfomation.keyid, whoAreYou: "AddressManagerVC")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setSubViewPara(){
        addNewAddress.layer.masksToBounds = true
        addNewAddress.layer.borderWidth = 1
        addNewAddress.layer.cornerRadius = 10
        addNewAddress.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
    
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = "管理收货地址"
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        
        pullDownUpdate()
        //tableView.reloadData()
        //self.tabBarController?.tabBar.hidden = true
       
        var usertypeTemp = "1"    //没有消费者端的usertypeTemp
        
        
        NSLog("currentRoleInfomation.keyid = \(currentRoleInfomation.keyid )")
        //http.getPlaceOfReceipt(usertype: usertypeTemp, userid: currentRoleInfomation.keyid, whoAreYou: "AddressManagerVC")
    }

}



extension AddressManagerVC{
    func getPlaceOfReceiptReqProcess(sender:NSNotification){
        
        placeOfReceiptArry = []  //清空收货地址数组
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            
            NSLog("dataTemp == \(dataTemp)")
            
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
                
                showMessageAnimate(self.navigationController!.view, message)

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return placeOfReceiptArry.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("placeOfReceiptCell") as! PlaceOfReceiptCell
        cell.setSubViewPara = placeOfReceiptArry[indexPath.row]
        if (placeOfReceiptArry[indexPath.row].IsAuditStatus == "1") {
            cell.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1 )
            cell.userInteractionEnabled = false
        }else{
            cell.userInteractionEnabled = true
        }
        return cell
    }
    
    
    //设置收货地址的显示问题
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("你选择的是\(placeOfReceiptArry[indexPath.row].name)\(placeOfReceiptArry[indexPath.row].phone)\(placeOfReceiptArry[indexPath.row].address)")
        
        for (var cnt = 0 ; cnt < placeOfReceiptArry.count ; cnt++ ) {
            placeOfReceiptArry[cnt].isEditing = false
        }
        
        placeOfReceiptArry[indexPath.row].isEditing = true
        
        if (placeOfReceiptArry[indexPath.row].IsAuditStatus == "1" ){
            
            NSLog("待审核的不能点击")
            
        }else{
            NSLog("可以点击")
            var showCurrentPlaceReceiptVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ShowCurrentPlaceReceiptVC") as! ShowCurrentPlaceReceiptVC
            showCurrentPlaceReceiptVC.addressKid = placeOfReceiptArry[indexPath.row].keyid //获取点击的收货地址的kid
            showCurrentPlaceReceiptVC.placeOfReceiptArry = self.placeOfReceiptArry
            showCurrentPlaceReceiptVC.rootPushVC = "AddressManagerVC"
            self.navigationController?.pushViewController(showCurrentPlaceReceiptVC, animated: true)
        }
        
        
        
    }
}
