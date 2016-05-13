//
//  ModifySecretVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/14.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit

class ModifySecretVC: UITableViewController {

    var http = ShoppingHttpReq.sharedInstance
    
    @IBOutlet var oldPwd: UITextField!
    @IBOutlet var pwd: UITextField!
    @IBOutlet var comfirmPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var rightBtn = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: Selector("saveBtnClk"))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.navigationItem.title = "密码修改"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //addToShoppingCartUrlReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("modifySecretReqProcess:"), name: "modifySecretReq", object: nil)
        
        //haveGetPwdCodeReqModifySecretVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("haveGetPwdCodeReqModifySecretVCProcess:"), name: "haveGetPwdCodeReqModifySecretVC", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("haveGetPwdCodeReqNewSecretProcess:"), name: "haveGetPwdCodeReqNewSecret", object: nil)
        
        //usrModifyPwdReqProcess
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("usrModifyPwdReqProcess:"), name: "usrModifyPwdReq", object: nil)
        
    }
    
    
    
    
    //获取到加密后的密码
    func haveGetPwdCodeReqModifySecretVCProcess(sender:NSNotification){
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            //对比密码是否匹配
            if currentRoleInfomation.pwd == dataTemp.stringValue {
                NSLog("旧密码输入正确")
                //进行密码修改
                if pwd.text  == comfirmPwd.text {
                   http.pwdCode(pwd.text, whoAreYou: "NewSecret")
                }else{
                   ProgressHUD.showError("两次密码不匹配，请重新输入")
                }
            }else{
                ProgressHUD.showError("秘密输入有误!!!")
            }
        }
    }

    
    func usrModifyPwdReqProcess(sender:NSNotification){
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            
            NSLog("dataTemp = \(dataTemp)")

            if "100" == dataTemp["result"].stringValue {
                NSLog("用户密码修改成功")
                
                //保存用户的密码
                NSUserDefaults.standardUserDefaults().setObject(pwd.text, forKey: "yaode_pwd")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                ProgressHUD.showSuccess("密码修改成功")
                
                self.navigationController?.popToRootViewControllerAnimated(true)

            }else{
                var alart = UIAlertView(title: "提示", message: "修改密码失败", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            
        }
    }
    
    //获取到新加密的密码
    func haveGetPwdCodeReqNewSecretProcess(sender:NSNotification){
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            var newPwd = dataTemp.description
            http.usrModifyPwd(utype: currentRoleInfomation.usertype, oldpwd: currentRoleInfomation.pwd, newpwd: newPwd, uname: currentRoleInfomation.adminid)
            
        }else{
            ProgressHUD.showError("密码更新失败!!!")
        }
    }


    func modifySecretReqProcess(sender:NSNotification){
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            if "100" == dataTemp["result"]{
                
            }
        }
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func saveBtnClk(){
        NSLog("用户密码修改")
        
        
        if checkInputPara(){
            http.pwdCode(oldPwd.text, whoAreYou: "ModifySecretVC")
            
        }else{
            var alart = UIAlertView(title: "提示", message: "输入信息有误，请核对后重新输入", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        
    }
    
    func checkInputPara()->Bool{
        NSLog("currentRoleInfomation.pwd = \(currentRoleInfomation.pwd)")
        
        if pwd.text != comfirmPwd.text {
            return false
        }
        
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
