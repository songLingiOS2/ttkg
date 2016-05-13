//
//  WriteTelVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/13.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON

class WriteTelVC: UIViewController ,UITextFieldDelegate{

    @IBAction func disMissBtnClk(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBAction func agreeBtnClk(sender: UIButton) {
        //agreeBtn.setBackgroundImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        if  UIImage(named: "che_nor") == agreeBtn.backgroundImageForState(UIControlState.Normal) {
            NSLog("che_sel")
            agreeBtn.setBackgroundImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        }else{
            agreeBtn.setBackgroundImage(UIImage(named: "che_nor"), forState: UIControlState.Normal)
            NSLog("che_nor")
        }
        
    }
    
    var http = RegistHTTP.sharedInstance
    
    @IBOutlet var agreeBtn: UIButton!
    @IBAction func getVerifyBtnClk(sender: UIButton) {
        NSLog("获取验证码")

            //2、判断手机号位数是否正确，正确后按钮才可以被点击
            if telNum.text.length == 11 {
                if serverIsAvalaible() { //网络监测
                    http.getVerifyCode(telNum.text)
                    
                }else{
                    var alart = UIAlertView(title: "提示", message: "无可用网络", delegate: nil, cancelButtonTitle: "确定")
                    alart.show()
                }
                
            }else{
                var alart = UIAlertView(title: "提示", message: "请输入11位手机号码", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            
        
        
        
    }
    
    @IBOutlet var telNum: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBar()
        
        telNum.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("verifyCodeReqProcess:"), name: "verifyCodeReq", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func verifyCodeReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            if "true" == dataTemp["success"].stringValue {
                var virifyCodeNum =  dataTemp["data"]["code"].stringValue
                
                var writeVerifyCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WriteVerifyCodeVC") as! WriteVerifyCodeVC
                
                writeVerifyCodeVC.resistTelNum = telNum.text
                writeVerifyCodeVC.virifyCodeNum = virifyCodeNum
                self.navigationController?.pushViewController(writeVerifyCodeVC, animated: true)
                
            }else if "50001" == dataTemp["result"].description {
                var alart = UIAlertView(title: "提示", message: "操作过于频繁，请在1分钟后重新获取", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
                
            }else if "50002" == dataTemp["result"].description {
                var alart = UIAlertView(title: "提示", message: "操作次数过多，请联系客服", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else{
                var alart = UIAlertView(title: "提示", message: "没有成功获取到验证码", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
        }
    }

    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setNavigationBar(){
//        navigationBar常用属性
//        一. 对navigationBar直接配置,所以该操作对每一界面navigationBar上显示的内容都会有影响(效果是一样的)
//        1.修改navigationBar颜色
//        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
//        
//        2.关闭navigationBar的毛玻璃效果
//        self.navigationController.navigationBar.translucent = NO;
//        3.将navigationBar隐藏掉
//        
//        self.navigationController.navigationBarHidden = YES;
//        
//        4.给navigationBar设置图片
//        不同尺寸的图片效果不同:
//        1.320 * 44,只会给navigationBar附上图片
//        
//        2.高度小于44,以及大于44且小于64:会平铺navigationBar以及状态条上显示
//        
//        3.高度等于64:整个图片在navigationBar以及状态条上显示

        //1、返回标签
        let item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        //2、颜色（UINavigationBar）
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
         self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //隐藏毛玻璃效果
        self.navigationController?.navigationBar.translucent = false
        
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
