//
//  ModifyCurrentPlaceReceiptVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/10.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//


import UIKit
import SDWebImage
import SwiftyJSON

class ModifyCurrentPlaceReceiptVC: UITableViewController {

    var rootPushVC = ""//是哪一个页面控制器要求修改地址
    
    var addressKid = "" //需要修改的收货地址的kid
    
    var http = ShoppingHttpReq.sharedInstance
    //收货地址数组
    var placeOfReceiptArry = [PlaceOfReceipt]()
    //存储当前正在进行编辑的地址数据
    var currentPlaceOfReceiptTemp = PlaceOfReceipt()
    
    @IBOutlet var name: UITextField!
    @IBOutlet var tel: UITextField!
    @IBOutlet var postCode: UITextField!
    @IBOutlet var area: UITextField!
    @IBOutlet var address: UITextField!
    
    /**
    检测用户输入
    */
    func checkUserInputInfo()->Bool{
        if name.text.length == 0 {
            return false
        }
        
        if tel.text.length == 0 {
            return false
        }
        
        if address.text.length == 0 {
            return false
        }
        
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setSubViewPara()
        
        NSLog("placeOfReceiptArry ==\(placeOfReceiptArry)")
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("modifyPlaceOfReceiptReqProcess:"), name: "modifyPlaceOfReceiptReqModifyCurrentPlaceReceiptVC", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func setNavigationBar(){
        var rightBtn = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: Selector("modifyCurrentAddress"))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = "修改收货地址"
    }
    
    func modifyCurrentAddress(){
        NSLog("修改当前地址进行提交")
        //检测用户输入数据
        if checkUserInputInfo(){
            
            
            ProgressHUD.show("修改请求中...")
            var usertypeTemp = "1"
            http.modifyPlaceOfReceipt(name: name.text, phone: tel.text, address: address.text, postcode: postCode.text, remark: "", sphone: tel.text, area: area.text, usertype: usertypeTemp, userid: currentRoleInfomation.keyid, KeyID: addressKid, whoAreYou: "ModifyCurrentPlaceReceiptVC")
            
            
        }else{
            var alart = UIAlertView(title: "提示", message: "请完善用户信息", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        

        
    }

    
    
    func setSubViewPara(){
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
    
    func modifyPlaceOfReceiptReqProcess(sender:NSNotification){
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp= \(dataTemp)")
            var message = dataTemp["message"].stringValue
            
            if "true" == dataTemp["success"].stringValue {
                NSLog("修改收货地址成功")
                ProgressHUD.showSuccess(message)
                if rootPushVC.length == 0 {
                    self.navigationController?.popViewControllerAnimated(true)
                }else{//返回到地址相关根导航控制器
                    
                    for  vcHome in self.navigationController!.viewControllers {
                        
                        if vcHome.isKindOfClass(AddressManagerVC.self) {
                            self.navigationController?.popToViewController(vcHome as! UIViewController, animated: false)
                        }
                    }
                    
                    
                }
                

            }else{
                ProgressHUD.showError("修改失败")
            }
        }else{
            ProgressHUD.showError("修改失败")
        }
    }

}
