//
//  ChangePasswordVC.swift
//  TTKG
//
//  Created by iosnull on 16/4/11.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ChangePasswordVC: UIViewController,UITextFieldDelegate {
    
    
    
    var adminid = currentRoleInfomation.adminid
    
    var password = ""
    var newpassword = "" {
        didSet{
            let parameters = ["adminid":adminid,"password":password,"newpassword":newpassword]
            let data = JSON(parameters)
            let dataString = data.description
            let para = ["admininfo":dataString]
            var url  = serversBaseURL + "/member/passwd"
            
            
            if netIsavalaible {
            Alamofire.request(.POST,url,parameters: para).responseString{ (request, response, data, error) in
                
                var json = StringToJSON(data!)
                NSLog("json = \(json)")
                var message = json["message"].stringValue
                if json["success"].stringValue ==  "false" {
                    ProgressHUD.showError(message)
                }else{
                    ProgressHUD.showSuccess(message)

                    NSUserDefaults.standardUserDefaults().setValue("", forKey: "yaode_pwd")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.dismissViewControllerAnimated(false, completion: { () -> Void in
                        
                        
                    })
                }
            }
            }else{
                netIsEnable("网络不可用")
            }

        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    //输入参数检测
    func checkInput()->Bool{
        var alert = UIAlertView(title: "提示", message: "", delegate: nil, cancelButtonTitle: "确定")
        
        if oldPwd.text.length == 0 {
            alert.message = "请输入原始密码"
            alert.show()
            return false
        }
        
        if newPwd.text.length == 0 {
            alert.message = "请输入新密码"
            alert.show()
            return false
        }
        
        if confirmPwd.text.length == 0 {
            alert.message = "请确认密码"
            alert.show()
            return false
        }
        
        if newPwd.text != confirmPwd.text {
            alert.message = "密码输入不匹配，请重新输入"
            alert.show()
            newPwd.text = ""
            confirmPwd.text = ""
            return false
        }
        
        if newPwd.text == oldPwd.text {
            alert.message = "新密码和原密码相同，请重新输入"
            alert.show()
            newPwd.text = ""
            confirmPwd.text = ""
            return false
        }
        
        
        return true
    }
    
    
    

    
    
    
    var img = UIImageView()
    
    var oldPwd = UITextField()
    var newPwd = UITextField()
    var confirmPwd = UITextField()
    var confirmBtn = UIButton()

    func constrictionSubView(){
        oldPwd.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(90)
        }
        
        newPwd.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(oldPwd.snp_bottom).offset(8)
        }

        confirmPwd.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(newPwd.snp_bottom).offset(8)
        }
        
        confirmBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(confirmPwd.snp_bottom).offset(20)
            make.height.equalTo(40)
        }
        
        img.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(confirmPwd.snp_bottom).offset(20)
            make.bottom.equalTo(0)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        oldPwd.placeholder = "请输入原始密码"
        oldPwd.borderStyle = UITextBorderStyle.RoundedRect
        oldPwd.secureTextEntry = true
        
        newPwd.placeholder = "请输入新密码"
        newPwd.borderStyle = UITextBorderStyle.RoundedRect
        newPwd.secureTextEntry = true
        
        confirmPwd.placeholder = "确认新密码"
        confirmPwd.borderStyle = UITextBorderStyle.RoundedRect
        confirmPwd.secureTextEntry = true
        
        oldPwd.delegate = self
        newPwd.delegate = self
        confirmPwd.delegate = self
        
        
        self.view.addSubview(img)
        
        self.view.addSubview(oldPwd)
        self.view.addSubview(newPwd)
        self.view.addSubview(confirmPwd)
        
        confirmBtn.backgroundColor = UIColor(red: 1, green: 74/255, blue: 101/255, alpha: 1)
        confirmBtn.setTitle("确认修改", forState: UIControlState.Normal)
        confirmBtn.addTarget(self, action: Selector("confirmBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(confirmBtn)
        
        constrictionSubView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setSecret(oldPwd:String, nowPwd:String){
        let pwdCodeBaseUrl = secretBaseURL + "/utils/encrypt"
        let parameters = ["source":oldPwd]
        if netIsavalaible {
        Alamofire.request(.GET,pwdCodeBaseUrl,parameters: parameters).responseString{ (request, response, data, error) in
            
            
            if error != nil {
                var alert = UIAlertView(title: "提示", message: "网络响应慢", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                
            }else{
                
                var json = StringToJSON(data!)
                
                if json["success"].stringValue == "true" {
                    //得到了老密码
                    self.password  = json["data"]["value"].stringValue
                    NSLog("self.password = \(self.password)")
                    
                    let para = ["source":nowPwd]
                    
                    if netIsavalaible {
                    
                    Alamofire.request(.GET,pwdCodeBaseUrl,parameters: para).responseString{ (request, response, data, error) in
                        if error != nil {
                            var alert = UIAlertView(title: "提示", message: "网络响应慢", delegate: nil, cancelButtonTitle: "确定")
                            alert.show()
                        }else{
                            
                            var json = StringToJSON(data!)
                            if json["success"].stringValue == "true" {
                                self.newpassword = json["data"]["value"].stringValue
                            }else{
                                var message = json["message"].stringValue
                                var alert = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                                alert.show()
                            }
                            
                        }
                    }
                    }else{
                        netIsEnable("网络不可用")
                    }
                    
                    
                }else{
                    var message = json["message"].stringValue
                    var alert = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }
                
            }
            
        }
        }else{
            netIsEnable("网络不可用")
        }

    }


    func confirmBtnClk(){
        NSLog("确认修改密码")
        if checkInput() {
            
            setSecret(oldPwd.text, nowPwd:newPwd.text)
            
        }else{
            
        }
    }
    
}
