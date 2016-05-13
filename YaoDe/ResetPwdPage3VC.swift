//
//  ResetPwdPage3VC.swift
//  YaoDe
//
//  Created by iosnull on 15/11/18.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit

class ResetPwdPage3VC: UIViewController {
    
    var code = ""  //短信验证码
    var usr = "" //用户名称
    
    @IBOutlet var verifyCode: UITextField!
    
    @IBOutlet var newPwd: UITextField!
    
    
    func checkPara()->Bool{
        if code != verifyCode.text {
            var alart = UIAlertView(title: "提示", message: "验证码输入有误", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if newPwd.text.length < 6 {
            var alart = UIAlertView(title: "提示", message: "密码长度必须大于6位", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        return true
    }
    
    
    @IBAction func changePwdBtnClk(sender: UIButton) {
        if checkPara() {
            http.secretPwd(newPwd.text)
            ProgressHUD.show("正在修改,请稍等...")
        }
        
    }
    
    var http = ShoppingHttpReq.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("secretPwdProcess:"), name: "secretPwd", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changePwdResultProcess:"), name: "changePwdResult", object: nil)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func changePwdResultProcess(sender:NSNotification){
        
        if let haveValue: AnyObject = sender.object{
            var dataTemp = NSNotificationToJSON(sender)
            
            var message = dataTemp["message"].stringValue
            if "true" == dataTemp["success"].stringValue && dataTemp["status"].stringValue == "0" {
                NSLog("修改密码成功")
                
                ProgressHUD.showSuccess(message)
                NSUserDefaults.standardUserDefaults().setValue("", forKey: "yaode_pwd")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    NSLog("返回到登陆页面")
                })
            }else{
                ProgressHUD.showError(message)
            }
            
            
            
            
        }else{
            
        }
        
        
        
    }
    
    func secretPwdProcess(sender:NSNotification){
        
        if let haveValue: AnyObject = sender.object{
            NSLog("\(sender.object)")
            var password = NSNotificationToJSON(sender)
            NSLog("password == \(password)")
            
            if "true" == password["success"].stringValue {
                var newPasswd = password["data"]["value"].stringValue
                http.changePwd("changePwdResult", phone: usr, password: newPasswd)
            }
            
            
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        ProgressHUD.dismiss()
    }
    
    
}
