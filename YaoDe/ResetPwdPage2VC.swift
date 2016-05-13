//
//  ResetPwdPage2VC.swift
//  YaoDe
//
//  Created by iosnull on 15/11/18.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit
import Alamofire

class ResetPwdPage2VC: UIViewController {
    
    
    var roleType = " "
    
    @IBOutlet var selctRole: UISegmentedControl!
    @IBAction func selectRoleAct(sender: UISegmentedControl) {
        //        var value = selctRole.selectedSegmentIndex
        //        value = value + 1
        //        roleType = value.description
        //        NSLog("\(roleType)")
        
        if selctRole.selectedSegmentIndex == 0{
            roleType = "4"
        }else{
            roleType = "3"
        }
        
        
        
    }
    
    @IBOutlet var usr: UITextField!
    
    
    @IBAction func getVerifyCode(sender: UIButton) {
        if usr.text.length == 11 {
            ProgressHUD.show("请稍等...")
            validationPhone(usr.text)
            
            
        }else{
            var alart = UIAlertView(title: "提示", message: "请输入11位手机号", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
    }
    
    var http = ShoppingHttpReq.sharedInstance
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getVerifyCodeProcess:"), name: "getVerifyCode", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        ProgressHUD.dismiss()
    }
    
    
    
    /**
    检测手机号是否存在
    
    - parameter phone: 手机号
    */
    func validationPhone(phone:String){
        
        let parameters = ["phone":phone]
        
        let getVerifyCodeUrl:String = serversBaseURL + "/member/check"
        if netIsavalaible {
        ProgressHUD.dismiss()
        Alamofire.request(.POST,getVerifyCodeUrl,parameters: parameters).responseString{ (request, _, data, error) in
            NSLog("data = \(data)")
            var dataTemp = StringToJSON(data!)
            NSLog("dataTemp = \(dataTemp)")
            var message = dataTemp["message"].stringValue
            if dataTemp["success"].stringValue == "true" && dataTemp["status"].stringValue == "0" {
                self.http.getVerifyCode("getVerifyCode", usr: self.usr.text)
                
            }else{
                var alert = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    
    
    
    
    func getVerifyCodeProcess(sender:NSNotification){
        
        
        ProgressHUD.dismiss()
        
        if let haveValue: AnyObject = sender.object{
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            var message = dataTemp["message"].stringValue
            
            if "true" == dataTemp["success"].stringValue{
                var code = dataTemp["data"]["code"].stringValue
                NSLog("获取到的验证码是\(code)")
                var resetPwdPage3VC  = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ResetPwdPage3VC") as! ResetPwdPage3VC
                resetPwdPage3VC.usr = usr.text
                resetPwdPage3VC.code = code
                self.navigationController?.pushViewController(resetPwdPage3VC, animated: true)
            }else{
                var alart = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            
        }
    }
    
    
    
}
