//
//  BecomePeisongVC.swift
//  
//
//  Created by yd on 15/12/24.
//
//

import UIKit
import SwiftyJSON

class BecomePeisongVC: UITableViewController,UITextFieldDelegate,SelectAreaVCDelegate{
    
    
    var http = RegistHTTP.sharedInstance
    var areaId = ""
    var usrKid = ""
    
    @IBOutlet weak var PeiSongName: UITextField!
    @IBOutlet weak var PeiSongTel: UITextField!

    @IBOutlet weak var PeiSongAear: UITextField!
    
    @IBOutlet weak var PeiSongAddress: UITextField!
    
    @IBOutlet weak var PeiSongPsw: UITextField!
    
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var YewuCode: UITextField!
    
    
    
    @IBOutlet var selectCity: UIButton!
    
    
    
    @IBAction func selectCityBtnClick(sender: AnyObject) {
        resignAll()
        var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
        selectAreaVC.delegate = self
        
        self.navigationController?.pushViewController(selectAreaVC, animated: true)
        
    }
    
    
    func resignAll(){
        PeiSongName.resignFirstResponder()
        PeiSongTel.resignFirstResponder()
        PeiSongAear.resignFirstResponder()
        PeiSongAddress.resignFirstResponder()
        PeiSongPsw.resignFirstResponder()
        YewuCode.resignFirstResponder()
    }
    
    
    @IBAction func applyBtn(sender: AnyObject) {
        
        
        if PeiSongName.text.length == 0 || PeiSongAddress.text.length == 0 {
            var alart = UIAlertView(title: "提示", message: "请完善用户信息后进行提交", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        if PeiSongTel.text.length == 11{
            NSLog("电话号码===\(PeiSongTel.text)")
        }else{
            var alart = UIAlertView(title: "提示", message: "请完善用户联系电话后进行提交", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        if PeiSongAear.text.length == 0 {
            var alart = UIAlertView(title: "提示", message: "未填写商店区域或选择的区域无效", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        if PeiSongAddress.text.length == 0{
            var alart = UIAlertView(title: "提示", message: "未填写配送商地址", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        
        if PeiSongPsw.text.length < 6 {
            var alart = UIAlertView(title: "提示", message: "密码要求（6-18位）", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return
        }
        
        if serverIsAvalaible(){
            http.pwdCode(PeiSongPsw.text, whoAreYou: "BecomePeisongVC")
        }

        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyBtn.layer.masksToBounds = true
        applyBtn.layer.borderWidth = 1
        applyBtn.layer.cornerRadius = 5
        applyBtn.layer.borderColor = UIColor(red: 38/255, green: 168/255, blue: 231/255, alpha: 1 ).CGColor
        
        PeiSongAear.delegate = self
        
        PeiSongAear.userInteractionEnabled = false
        
        //haveGetPwdCode
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("haveGetPwdCodeProcess:"), name: "haveGetPwdCodeBecomePeisongVC", object: nil)
        
        //manageRoleRegistReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("manageRoleRegistReqProcess:"), name: "peiSongRoleRegistReq", object: nil)
        
        

        // Do any additional setup after loading the view.
        //返回到登陆页面
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("gotoLogin"))
    }
    
    
    
    
    func gotoLogin(){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        resignAll()
    }
    
    
    func  textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        NSLog("textFieldShouldBeginEditing")
        if PeiSongAear.isFirstResponder(){
            return false
        }
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    var keyBoard = IQKeyboardManager.sharedManager()
    func textFieldDidBeginEditing(textField: UITextField){
        println("textField");
        /* if PeiSongAear.isFirstResponder(){
            NSLog("商店区域选择")
            
            keyBoard.resignFirstResponder()
            keyBoard.resignFirstResponder()
            
            
            var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
            selectAreaVC.delegate = self
            
            self.navigationController?.pushViewController(selectAreaVC, animated: true)
            
            
            
        } */

        
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func selectCountryIs(name:String,area:String){
        println("TextField");
        
        PeiSongAear.text = name
        areaId = area
        
    }
    
    //获取到加密密码
    func haveGetPwdCodeProcess(sender:NSNotification){
        if let haveValue: AnyObject = sender.object{
            ProgressHUD.show("数据提交中...")
            var MD5pwd = NSNotificationToJSON(sender)
            
            
            NSLog("MD5pwd = \(MD5pwd)")
            var passWord = MD5pwd["data"]["value"].stringValue
            
            //数据发送，服务器请求
            http.managePeiSongRoleRegist( passWord, roleid: usrKid, tel: PeiSongTel.text, shopname: PeiSongName.text , address: PeiSongAddress.text, sptypeid: "0",  areaid: areaId, recom_code: YewuCode.text)
            
        }else{
            //密码验证未获取到数据
            var alart = UIAlertView(title: "提示", message: "网络请求故障,请稍后再试", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        
    }

    
    
    func manageRoleRegistReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        NSLog("aresult = \(sender.object)")
        if let haveValue: AnyObject = sender.object {
            
            var data = NSNotificationToJSON(sender)
            NSLog("data = \(data)")
            var message = data["message"].stringValue
            if "true" == data["success"].stringValue {
                
                var alertController = UIAlertController(title: "提示", message: "恭喜！注册成功", preferredStyle: UIAlertControllerStyle.Alert)
                var gotoLoginAction = UIAlertAction(title: "登陆", style: UIAlertActionStyle.Default, handler:{(Void) in
                    self.gotoLogin()
                })
  
                alertController.addAction(gotoLoginAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }else{
                var alart = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
