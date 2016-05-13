//
//  BecomeShoppingVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/22.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON

class BecomeShoppingVC: UITableViewController,UITextFieldDelegate,ShoppingClassVCDelegate,SelectAreaVCDelegate{
    var http = RegistHTTP.sharedInstance
    
    @IBOutlet var pwd: UITextField!
    var usrTel = ""
    var usrKid = ""
    @IBOutlet var applyBtn: UIButton!
    
    @IBAction func applyBtnClk(sender: UIButton) {
        if shoppingName.text.length == 0 || detailAddress.text.length == 0 {
            var alart = UIAlertView(title: "提示", message: "请完善用户信息后进行提交", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        if pwd.text.length < 6 {
            var alart = UIAlertView(title: "提示", message: "密码要求（6-18位）", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        if areaKeyID.length == 0 {
            var alart = UIAlertView(title: "提示", message: "未填写商店区域或选择的区域无效", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        if shoppingClass.text.length == 0 {
            var alart = UIAlertView(title: "提示", message: "请填写商店类别", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        
        if serverIsAvalaible(){
            http.pwdCode(pwd.text, whoAreYou: "BecomeShoppingVC")
        }
    }
    
    var shoppingClassKeyID = "" //商品分类ID
    var areaKeyID = ""//区域id
    
    func resignAll(){
        pwd.resignFirstResponder()
        shoppingName.resignFirstResponder()
        detailAddress.resignFirstResponder()
        shoppingArea.resignFirstResponder()
        shoppingClass.resignFirstResponder()
        salesManNum.resignFirstResponder()
        
        

        
    }
    
    @IBOutlet var shoppingName: UITextField!
    @IBOutlet var detailAddress: UITextField!
    @IBOutlet var shoppingArea: UITextField!
    @IBOutlet var shoppingClass: UITextField!
    @IBOutlet var salesManNum: UITextField!
    
    
    @IBOutlet var selectShopRole: UIButton! //选择商店类别
    
    @IBOutlet var selectCity: UIButton!//选择省市区
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyBtn.layer.masksToBounds = true
        applyBtn.layer.borderWidth = 1
        applyBtn.layer.cornerRadius = 5
        applyBtn.layer.borderColor = UIColor(red: 38/255, green: 168/255, blue: 231/255, alpha: 1 ).CGColor
        
        
        shoppingArea.delegate = self
        shoppingClass.delegate = self
        
        shoppingArea.userInteractionEnabled = false
        shoppingClass.userInteractionEnabled = false
        
        //haveGetPwdCode
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("haveGetPwdCodeProcess:"), name: "haveGetPwdCodeBecomeShoppingVC", object: nil)
        
        //manageRoleRegistReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("manageRoleRegistReqProcess:"), name: "manageRoleRegistReq", object: nil)
        
        //返回到登陆页面
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("gotoLogin"))
        
    }
    
    
    @IBAction func selectShopRoleBtnClick(sender: AnyObject) {
        
        resignAll()
        var shoppingClassVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingClassVC") as! ShoppingClassVC
        
        shoppingClassVC.delegate = self
        
        self.navigationController?.pushViewController(shoppingClassVC, animated: true)
        
    }
    
    @IBAction func selectCityBtnClick(sender: AnyObject) {
        
        resignAll()
        var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
        selectAreaVC.delegate = self
        
        
        self.navigationController?.pushViewController(selectAreaVC, animated: true)
    }
    
    func gotoLogin(){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func  textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        NSLog("textFieldShouldBeginEditing")
//        if shoppingClass.isFirstResponder()||shoppingArea.isFirstResponder(){
//            return false
//        }
        return true
    }
    
    
    
    
    var keyBoard = IQKeyboardManager.sharedManager()
    func textFieldDidBeginEditing(textField: UITextField) {
        /*
        if shoppingClass.isFirstResponder(){//商店角色获取商店分类
            NSLog("textFieldDidBeginEditing")
            
            keyBoard.resignFirstResponder()
            keyBoard.resignFirstResponder()
            var shoppingClassVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingClassVC") as! ShoppingClassVC
            
            shoppingClassVC.delegate = self
            
            self.navigationController?.pushViewController(shoppingClassVC, animated: true)
        }
        if shoppingArea.isFirstResponder(){
            NSLog("商店区域选择")
            keyBoard.resignFirstResponder()
            keyBoard.resignFirstResponder()
            
            
            var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
            selectAreaVC.delegate = self
            

            self.navigationController?.pushViewController(selectAreaVC, animated: true)
        
        }
        */
    }
    
    func selectCountryIs(name: String, area: String) {
        shoppingArea.text = name
        areaKeyID = area
        NSLog("areaKeyID = \(area)")
    }
    
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func selectedShoppingClass(name: String, classID: String) {
        shoppingClass.text = name
        print("商店名称是\(name)")
        shoppingClassKeyID = classID
        print("商店ID是\(classID)")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        resignAll()
//        IQKeyboardManager.sharedManager().enable = false
//        
        
//        super.viewWillDisappear(true)
//        self.view.endEditing(true)
        
    }
    
    //获取到加密密码
    func haveGetPwdCodeProcess(sender:NSNotification){
        if let haveValue: AnyObject = sender.object{
            ProgressHUD.show("数据提交中...")
            var MD5pwd = NSNotificationToJSON(sender)
            
            
            NSLog("MD5pwd = \(MD5pwd)")
            var passWord = MD5pwd["data"]["value"].stringValue
            //数据发送，服务器请求

             http.manageRoleRegist(passWord, roleid: usrKid, tel: usrTel, shopname: shoppingName.text, address: detailAddress.text, sptypeid: "1", areaid: "1", recom_code: salesManNum.text)
            
            
        }else{
            //密码验证未获取到数据
            var alart = UIAlertView(title: "提示", message: "网络请求故障,请稍后再试", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        
    }
    
    //商店注册结果处理
    func manageRoleRegistReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        NSLog("aresult = \(sender.object)")
        if let haveValue: AnyObject = sender.object {

            var result =  NSNotificationToJSON(sender)
            NSLog("result  == \(result)")
            
            if "true" == result["success"].stringValue {
                var message = result["message"].stringValue
                var alertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                var gotoLoginAction = UIAlertAction(title: "登陆", style: UIAlertActionStyle.Default, handler:{(Void) in
                    self.gotoLogin()
                })
                
                alertController.addAction(gotoLoginAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }else{
                var message = result["message"].stringValue
                
                
                var alart = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
              

            
        }
    }

}
