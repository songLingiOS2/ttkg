//
//  SetPassWordVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/19.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON

class SetPassWordVC: UIViewController {

    var usr = "" //将要进行注册的手机号
    
    @IBOutlet var pwd1: UITextField!
    
    /**
    退出到登陆页面
    - parameter sender:
    */
    @IBAction func resignBtnClk(sender: UIButton) {
        NSLog("退出到登陆页面")
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    @IBOutlet var pwd2: UITextField!
    
    var http = RegistHTTP.sharedInstance
    
    @IBAction func registBtnClk(sender: UIButton) {
        NSLog("提交信息进行注册")
        if serverIsAvalaible(){
            if (pwd1.text == pwd2.text ) &&  (pwd1.text.length >= 6) {
                http.pwdCode(pwd1.text, whoAreYou: "SetPassWordVC")// 密码加密请求
            }else{
                var alart = UIAlertView(title: "提示", message: "密码输入有误，请重新输入", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
 
        }else{
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("haveGetPwdCodeProcess:"), name: "haveGetPwdCodeSetPassWordVC", object: nil)
        
        //customerRoleRegistReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("customerRoleRegistReqProcess:"), name: "customerRoleRegistReq", object: nil)
    }

    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func haveGetPwdCodeProcess(sender:NSNotification){
        if let haveValue: AnyObject = sender.object{
            var pwd = sender.object!.description //密码
            
            if serverIsAvalaible() {
                http.CustomerRoleRegist(tel: usr, pwd: pwd)
            }
            
        }else{
            var alart = UIAlertView(title: "提示", message: "服务器无响应，请稍后再试", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
    }
    
    
    func customerRoleRegistReqProcess(sender:NSNotification) {
        if let haveValue: AnyObject = sender.object{
            var result =  JSON(sender.object!)
            
            if "100" == result["result"].stringValue {
                var alart = UIAlertView(title: "提示", message: "恭喜！注册成功", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else if "101" == result["result"].stringValue {
                var alart = UIAlertView(title: "提示", message: "注册失败!!!", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else if "10002" == result["result"].stringValue{
                var alart = UIAlertView(title: "提示", message: "参数错误", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else if "10003" == result["result"].stringValue{
                var alart = UIAlertView(title: "提示", message: "该手机号已经被注册过,请返回登录页面进行登录！", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else{
                var alart = UIAlertView(title: "提示", message: "服务器忙，请稍后再试", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }

            
        }else{
            var alart = UIAlertView(title: "提示", message: "服务器忙，请稍后再试", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
