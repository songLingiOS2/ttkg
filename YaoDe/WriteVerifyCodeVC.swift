//
//  WriteVerifyCodeVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/19.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON

class WriteVerifyCodeVC: UIViewController {
    
    var roleInfoArry:[roleInfo] = [roleInfo]()
    
    
    @IBAction func selectRoleAct(sender: UISegmentedControl) {
        
        NSLog("你选择的是：\(selectRole.titleForSegmentAtIndex(selectRole.selectedSegmentIndex))")
    }
    @IBOutlet var selectRole: UISegmentedControl!
    var virifyCodeNum = "xxxx" //
    var resistTelNum = "" //将要注册的手机号码
    var http = RegistHTTP.sharedInstance
    @IBAction func verifyBtnClk(sender: UIButton) {
        if virifyCodeNum == verifyCode.text {
            //判断用户注册角色（是普通用户或者是商家用户）
            if selectRole.selectedSegmentIndex == 10 {//普通用户

                
                
            }else if selectRole.selectedSegmentIndex == 0 {//零售--商家用户
                var roleMsg = roleInfoArry[1]
                
                var becomeShoppingVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("BecomeShoppingVC") as! BecomeShoppingVC
                becomeShoppingVC.usrKid = "5" //零售--商家用户
                becomeShoppingVC.usrTel = resistTelNum
                self.navigationController?.pushViewController(becomeShoppingVC, animated: true)
            }else if selectRole.selectedSegmentIndex == 1{//新增配送商注册
                var roleMsg = roleInfoArry[0]
                var becomePeiSongVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BecomePeisongVC") as! BecomePeisongVC
                becomePeiSongVC.usrKid = "4" //新增配送商
                self.navigationController?.pushViewController(becomePeiSongVC, animated: true)
                
                
            }

        }else{
            var alart = UIAlertView(title: "提示", message: "验证码输入有误，请核对后进行输入", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
    }
    @IBOutlet var verifyCode: UITextField!
    @IBOutlet var sendTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("roleInformationReqProcess:"), name: "roleInformationReq", object: nil)
       
    }

    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        sendTitle.text = "验证码已经发送至" + resistTelNum
        http.roleInformationReq()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    
    func roleInformationReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue{
                var  roleMessage = dataTemp["data"]["items"]
                
                NSLog("roleMessage =\(roleMessage)")
                var roleTemp = roleInfo()
                
                for var i = 0 ; i < roleMessage.count ; i++ {
                    var whichRole = roleMessage[i]
                    roleTemp.keyid = whichRole["keyid"].stringValue
                    roleTemp.rolename = whichRole["name"].stringValue
                    roleInfoArry.append(roleTemp)
                }
                
                
                NSLog("roleInfoArry = \(roleInfoArry)")
                
            }
            
        }
        
    }
   
}
