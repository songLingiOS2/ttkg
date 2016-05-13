//
//  ShowCurrentPlaceReceiptVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/10.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class ShowCurrentPlaceReceiptVC: UITableViewController {
    var rootPushVC = ""
    var http = ShoppingHttpReq.sharedInstance
    //收货地址数组
    var placeOfReceiptArry = [PlaceOfReceipt]()
    //存储当前正在进行编辑的地址数据
    var currentPlaceOfReceiptTemp = PlaceOfReceipt()
    
    var addressKid = ""
    
    @IBOutlet var name: UILabel!
    @IBOutlet var tel: UILabel!
    @IBOutlet var postCode: UILabel!
    @IBOutlet var area: UILabel!
    @IBOutlet var address: UILabel!
    
    @IBAction func deleteCurrentAddressBtnClk(sender: UIButton) {
        NSLog("删除收货地址")
        
        var usertypeTemp = "1"
            http.deletePlaceOfReceipt(KeyID: addressKid, UserID: currentPlaceOfReceiptTemp.userid, whoAreYou: "ShowCurrentPlaceReceiptVC")
        
    }
    
    
    
    @IBOutlet var defaultAddressBtn: UIButton!
    @IBAction func defaultAddressBtnClk(sender: UIButton) {
        NSLog("设置成默认地址")
        /*
        var usertypeTemp = ""
        if currentRoleInfomation.usertype == "30001" {
            usertypeTemp = "2"
        }else{
            usertypeTemp = "1"
        }
        */

        //修改当前地址未默认地址
        ProgressHUD.show("数据请求中... ")
        var usertypeTemp = "1"
        http.placeOfReceiptBeenSetDefault(KeyID: addressKid, UserID: currentPlaceOfReceiptTemp.userid, whoAreYou: "ShowCurrentPlaceReceiptVC")
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViewPara()
        setNavigationBar()
       
        
        NSLog("address = \(addressKid)")
        NSLog("currentPlaceOfReceiptTemp.keyid \(currentPlaceOfReceiptTemp.userid)")
        //删除地址通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("deletePlaceOfReceiptReqProcess:"), name: "deletePlaceOfReceiptReqShowCurrentPlaceReceiptVC", object: nil)
        
        //placeOfReceiptBeenSetDefaultUrlReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("placeOfReceiptBeenSetDefaultUrlReqProcess:"), name: "placeOfReceiptBeenSetDefaultUrlReqShowCurrentPlaceReceiptVC", object: nil)
        
    }
    
    func deletePlaceOfReceiptReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp= \(dataTemp)")
            if "true" == dataTemp["success"].stringValue {
                ProgressHUD.showSuccess("删除成功")
                for temp in self.navigationController!.viewControllers {
                    
                    if temp.isKindOfClass(SelectPalceOfReceiptVC) {
                        self.navigationController?.popToViewController(temp as! SelectPalceOfReceiptVC, animated: true)
                    }
                }
            }
        }
        
    }

    //设置成默认收货地址
    func placeOfReceiptBeenSetDefaultUrlReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp= \(dataTemp)")
            
            
            if "true" == dataTemp["success"].stringValue {
                //跳转到指定控制器界面
                ProgressHUD.showSuccess("默认地址修改成功")
//                for temp in self.navigationController!.viewControllers {
//                    if temp.isKindOfClass(OrderConfirmationVC) {
//                        self.navigationController?.popToViewController(temp as! OrderConfirmationVC, animated: true)
//                    }
//                }

                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
 
    
    func setSubViewPara(){
        defaultAddressBtn.layer.masksToBounds = true
        defaultAddressBtn.layer.borderWidth = 1
        defaultAddressBtn.layer.cornerRadius = 10
        defaultAddressBtn.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
        
        for(var cnt = 0 ; cnt < placeOfReceiptArry.count ; cnt++ ){
            //设置界面
            if placeOfReceiptArry[cnt].isEditing {
                name.text = placeOfReceiptArry[cnt].name
                tel.text = placeOfReceiptArry[cnt].phone
                area.text = placeOfReceiptArry[cnt].area
                address.text = placeOfReceiptArry[cnt].address
                postCode.text = placeOfReceiptArry[cnt].postcode
                
                currentPlaceOfReceiptTemp = placeOfReceiptArry[cnt]
            }
        }
    }

    func setNavigationBar(){
        var rightBtn = UIBarButtonItem(title: "修改", style: UIBarButtonItemStyle.Done, target: self, action: Selector("showCurrentAddress"))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = "收货地址"
    }
    
    func showCurrentAddress(){
        var modifyCurrentPlaceReceiptVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ModifyCurrentPlaceReceiptVC") as! ModifyCurrentPlaceReceiptVC
        modifyCurrentPlaceReceiptVC.placeOfReceiptArry = self.placeOfReceiptArry
        modifyCurrentPlaceReceiptVC.addressKid =  addressKid//将需要修改的收货地址的kid传到下一个页面
        modifyCurrentPlaceReceiptVC.rootPushVC = rootPushVC
        
        self.navigationController?.pushViewController(modifyCurrentPlaceReceiptVC, animated: true)
    }
    
    
}
