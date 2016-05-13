//
//  LoginRegistVC.swift
//  YaoDe
//
//  Created by iosnull on 15/8/24.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON




class LoginRegistVC: UIViewController ,UITextFieldDelegate,EAIntroDelegate{
    
    
    var http:RegistHTTP = RegistHTTP.sharedInstance
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var AccountView: UIView!

    @IBOutlet var PwdView: UIView!
    @IBOutlet var usr: UITextField!
    @IBOutlet var pwd: UITextField!
    
    @IBOutlet var LoginBtn: UIButton!
    

    @IBAction func loginBtnClk(sender: AnyObject) {
        NSLog("登录按钮点击")
        
        //保存用户名和密码
        NSUserDefaults.standardUserDefaults().setObject(usr.text, forKey: "yaode_usr")
        NSUserDefaults.standardUserDefaults().synchronize()
        NSUserDefaults.standardUserDefaults().setObject(pwd.text, forKey: "yaode_pwd")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        //检测用户名和密码不能为空
        if usr.text.length ==  0 || pwd.text.length == 0 {
            var alart = UIAlertView(title: "提示", message: "请输入正确的用户名和密码", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            
            return
        }
        
        var name = NSUserDefaults.standardUserDefaults().objectForKey("yaode_usr") as! String
        var sec = NSUserDefaults.standardUserDefaults().objectForKey("yaode_pwd") as! String
        NSLog("usr = \(name)   sec = \(sec)")
        
        ProgressHUD.show("登录中...")
        
        //发送明文进行加密
        if checkUsrLoginPara() {
            
            http.pwdCode(pwd.text, whoAreYou: "LoginRegistVC")
        }else{
            var alart = UIAlertView(title: "提示", message: "请输入正确的用户名和密码", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        
    }
    
    func checkUsrLoginPara()->Bool{
        if usr.text.length == 0 {
            return false
        }
        if pwd.text.length == 0 {
            return false
        }
        return true
    }
    
    @IBAction func registBtnCLK(sender: AnyObject) {
    }
    
    
    //设置高斯模糊效果
    func setBackGroundBlurEffect(backgroundView:UIView,image:UIImage){
        var blurEffect = UIBlurEffect(style:UIBlurEffectStyle.Dark)
        
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.view.bounds
        
        var backgroundImageView = UIImageView(frame: backgroundView.frame)
        backgroundImageView.addSubview(blurEffectView)
        
        backgroundImageView.image = image
        
        backgroundImageView.alpha = 0.4
        
        backgroundView.addSubview(backgroundImageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //setBackGroundBlurEffect(self.view, image: UIImage(named: "welcome")!)
        
        self.AccountView.layer.masksToBounds = true
        self.AccountView.layer.cornerRadius = 20
        self.AccountView.layer.borderColor = UIColor(red: 213/255, green: 215/255, blue: 218/255, alpha: 1).CGColor
        self.AccountView.layer.borderWidth = 1
        
        
        
        self.PwdView.layer.masksToBounds = true
        self.PwdView.layer.cornerRadius = 20
        self.PwdView.layer.borderColor = UIColor(red: 213/255, green: 215/255, blue: 218/255, alpha: 1).CGColor

        self.PwdView.layer.borderWidth = 1
        
        
        self.LoginBtn.layer.masksToBounds = true
        self.LoginBtn.layer.cornerRadius = 20
        
        
        if let flag:String = NSUserDefaults.standardUserDefaults().valueForKey("first_login") as? String{
        }else{
            //是否是第一次启动页面
            NSUserDefaults.standardUserDefaults().setValue("yes", forKey: "first_login")
            NSUserDefaults.standardUserDefaults().synchronize()
        
            //展示页面
            var page1:EAIntroPage = EAIntroPage()
            //page1.title = "HELLO WORLD"
            page1.bgImage = UIImage(named: "1")
            
            var page2:EAIntroPage = EAIntroPage()
            //page2.title = "HELLO WORLD"
            page2.bgImage = UIImage(named: "2")
            
            var page3:EAIntroPage = EAIntroPage()
            //page3.title = "HELLO WORLD"
            page3.bgImage = UIImage(named: "4")
            
            
            
            var intro = EAIntroView(frame: self.view.bounds, andPages: [page1,page2,page3])
            intro.delegate = self
            
            intro.showInView(self.view, animateDuration: 0.0)
        }
        

        
        
        //textFieldDelegate
        usr.delegate = self
        pwd.delegate = self
        
        
        usr.text = ""
        pwd.text = ""
        
        //haveGetPwdCode
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("haveGetPwdCodeProcess:"), name: "haveGetPwdCodeLoginRegistVC", object: nil)
        
        
        //manageRoleLoginReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("manageRoleLoginReqProcess:"), name: "manageRoleLoginReq", object: nil)
        
        
        
    }

    

    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        //免输入设置
        
        if let usrName:String = NSUserDefaults.standardUserDefaults().objectForKey("yaode_usr") as? String{
            usr.text = NSUserDefaults.standardUserDefaults().objectForKey("yaode_usr") as! String
        }
        
        if let usrSecret:String = NSUserDefaults.standardUserDefaults().objectForKey("yaode_pwd") as? String{
            pwd.text = NSUserDefaults.standardUserDefaults().objectForKey("yaode_pwd") as! String
        }
        

        //用户登录自动登录
        if let loginState:String = NSUserDefaults.standardUserDefaults().objectForKey("loginState") as? String {
            if loginState == "loginIn" {
                loginBtnClk(1)
            }
            
        }
    
        
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        ProgressHUD.dismiss()
    }
    
    @IBOutlet var roleSwitch: UISwitch!
    @IBAction func roleSwitchAct(sender: UISwitch) {
        NSLog("roleSwitch.on = \(sender.on)")
    }
    
}





extension LoginRegistVC{

    
    
    func haveGetPwdCodeProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        
            
        var data = NSNotificationToJSON(sender)
        if data["success"].stringValue == "true" {
        
            var passWord = data["data"]["value"].stringValue
            NSLog("passWord = \(passWord)")
            
            ProgressHUD.show("登录中...")
            http.manageRoleLogin(adminid: usr.text, pwd: passWord)
        
        
        }else{
            
        }
            
            
       
        
    }

    
    
    

    func manageRoleLoginReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        NSLog("sender = \(sender.object)")
        if let resultDataTemp: AnyObject = sender.object{
            
             var  resultData = NSNotificationToJSON(sender)
            NSLog("resultData  = \(resultData)")
            var success = resultData["success"].stringValue
            var message = resultData["message"].stringValue
            
            if  resultData["success"].stringValue == "true" && resultData["status"].stringValue == "0" {
                NSLog("登录验证成功")
                
                ProgressHUD.showSuccess("登陆成功")
                
                var roleData = resultData["data"][0]["roleid"].stringValue
                NSLog("roleData = \(roleData)")
                
                currentRoleInfomation.status = resultData["data"][0]["status"].stringValue
                
                currentRoleInfomation.usertype = roleData
                if roleData == "5" || roleData == "4"{//是 商家 和 配送商 级别用户
                  
                    var data0 = resultData["data"]
                    NSLog("data0 = \(data0)")
                    var data = data0[0]
                    //获取该角色所有信息
                    currentRoleInfomation.tel = data["tel"].stringValue
                    currentRoleInfomation.shopname = data["shopname"].stringValue
                    currentRoleInfomation.name = data["name"].stringValue
                    currentRoleInfomation.brief = data["brief"].stringValue
                    currentRoleInfomation.adminid = data["adminid"].stringValue
                    currentRoleInfomation.signintime = data["signintime"].stringValue
                    currentRoleInfomation.address = data["address"].stringValue
                    currentRoleInfomation.display = data["display"].stringValue
                    currentRoleInfomation.pwd = data["pwd"].stringValue
                    currentRoleInfomation.sptypeid = data["sptypeid"].stringValue
                    currentRoleInfomation.typeid = data["typeid"].stringValue
                    currentRoleInfomation.keyid = data["keyid"].stringValue
                    currentRoleInfomation.contact = data["contact"].stringValue
                    currentRoleInfomation.areaid = data["areaid"].stringValue
                    currentRoleInfomation.creattime = data["creattime"].stringValue
                    currentRoleInfomation.disable = data["disable"].stringValue
                    currentRoleInfomation.integral = data["integral"].stringValue
                    currentRoleInfomation.status = data["status"].stringValue
                    currentRoleInfomation.roleid = data["roleid"].stringValue
                    
                    
                    NSLog("currentRoleInfomation.adminid = \(currentRoleInfomation.adminid)")
                    NSLog("currentRoleInfomation.roleid = \(currentRoleInfomation.roleid)")
                    NSLog("currentRoleInfomation.areaid = \(currentRoleInfomation.areaid)")
                    NSLog("currentRoleInfomation.disable = \(currentRoleInfomation.disable)")
                    NSLog("currentRoleInfomation.display = \(currentRoleInfomation.display)")
                    
                    
                    
                    if (currentRoleInfomation.status == "0") && (currentRoleInfomation.disable == "0") && (currentRoleInfomation.display == "0") {
                        
                        
                        //读取用户登录状态
                    NSUserDefaults.standardUserDefaults().setObject("loginIn", forKey: "loginState")
                    NSUserDefaults.standardUserDefaults().synchronize()

                    var shoppingRootVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingRootVC") as! ShoppingRootVC
                    self.presentViewController(shoppingRootVC, animated: true, completion: { () -> Void in})
                        
                    }
                    
                    
                }
                
                
                
            }else{
                var alart = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                alart.show()
                
            }
        }else{
            var alart = UIAlertView(title: "提示", message: "网络响应慢，请重试", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        
        
    }
    
    
    
    
    func saveRoleInfoFromServer(data:CurrentRoleInfomation){
        
    }
    
    
    func intro(introView: EAIntroView!, pageAppeared page: EAIntroPage!, withIndex pageIndex: UInt) {
        
    }
    
    func intro(introView: EAIntroView!, pageEndScrolling page: EAIntroPage!, withIndex pageIndex: UInt) {
        
    }
    
    func intro(introView: EAIntroView!, pageStartScrolling page: EAIntroPage!, withIndex pageIndex: UInt) {
        
    }
    
    func introDidFinish(introView: EAIntroView!) {
        
    }
    
    
}
