//
//  ProfileVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/12.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire

class ProfileVC: UITableViewController,UIAlertViewDelegate {
    
    @IBOutlet var sheBeiLabel: UILabel!
    var sheBeiStatus = ""
    
    
    
    var httpLogin = RegistHTTP.sharedInstance
    
    
    
    
    //@IBOutlet var chooseRole: UISegmentedControl!
    //积分
    //@IBOutlet var Integral: UILabel!
    
    //var usrname = UILabel()
    
    
    @IBOutlet var usrName: UILabel!
    
    @IBOutlet var usrImage: UIImageView!
    
    
    
    @IBAction func usrInfo(sender: UITapGestureRecognizer) {
        NSLog("用户信息")
        if currentRoleInfomation.usertype == "30001" {//普通用户
            //            var nomerUsrInfoVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("NomerUsrInfoVC") as! NomerUsrInfoVC
            //
            //            self.navigationController?.pushViewController(nomerUsrInfoVC, animated: true)
        }else{//管理级别用户
            var merchantInfoVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("MerchantInfoVC") as! MerchantInfoVC
            self.navigationController?.pushViewController(merchantInfoVC, animated: true)
        }
        
        
    }
    
    
    func setNavigationBar(){
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        
        //changeToManageerReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeToManageerReqProcess:"), name: "changeToManageerReq", object: nil)
        
        //changeToCustomerReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeToCustomerReqProcess:"), name: "changeToCustomerReq", object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        SDImageCache.sharedImageCache().clearMemory()
    }
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "个人中心"
        
        
        self.usrName.text = currentRoleInfomation.shopname
        getSheBeiState(currentRoleInfomation.keyid)
        
    }
    
    func getSheBeiState(userid:String) {
        
        
        let url = serversBaseURL + "/member/credit"
        
        
        let parameters = ["adminkeyid":userid]
        
        if netIsavalaible {
        NSLog("*****************************")
        Alamofire.request(.GET,url,parameters: parameters).responseString{ (request, response, data, error) in
            
            
            var json = StringToJSON(data!)
            //NSLog("json = \(json)")
            if json["success"].stringValue == "true" {
                var data = json["data"]
                //NSLog("data =\(data)")
                
                if data["creditStatus"].stringValue == "true" {
                    
                    self.sheBeiStatus = data["creditStatus"].stringValue
                    self.sheBeiLabel.text = "可用额度为￥" + data["creditAvailable"].doubleValue.description
                }else{
                    self.sheBeiLabel.text = "未开通爽购功能"
                }
                
            }
            
            
            
        }
        }else{
            netIsEnable("网络不可用")
        }
        
        
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.cellForRowAtIndexPath(indexPath)?.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.section == 3 {
            if indexPath.row == 0 {//修改密码
                

                
                var changePasswordVC = ChangePasswordVC()
                changePasswordVC.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(changePasswordVC, animated: false)
                
                
            }
            if indexPath.row == 1 {
                NSLog("退出登录按钮被点击")
                NSUserDefaults.standardUserDefaults().setObject("loginOut", forKey: "loginState")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })

                
            }
            
            
            
        }
        if indexPath.section == 2 {
            if indexPath.row == 2 {
                var addressManagerVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("AddressManagerVC") as! AddressManagerVC
                addressManagerVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(addressManagerVC, animated: true)
            }
            
            if indexPath.row == 0{
                
                var aboutMeVC = aboutVC()
                aboutMeVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(aboutMeVC, animated: true)
            }
            
            if indexPath.row == 1 {
                NSLog("分享按钮点击")
                UMSocialSnsService.presentSnsIconSheetView(self, appKey: "56039ecee0f55aef3d002702", shareText: "天天快购选购您的商品", shareImage: UIImage(named: "园logo-01"), shareToSnsNames: [UMShareToSina,UMShareToRenren,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToWechatFavorite], delegate: nil)
                
                //UMShareToQQ,UMShareToWechatFavorite,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina,UMShareToTencent,UMShareToRenren
                //点击按钮后进入指定的网址为
                UMSocialData.defaultData().extConfig.wechatSessionData.url = "https://app.ttkg365.com/app/index"
            }
            
        }
        
        
        /**
        *  查看购物记录
        */
        if indexPath.section == 1{
//            if indexPath.row == 1{
//                /*
//                var historyRecodeVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("HistoryRecordVC") as! HistoryRecordVC
//                self.navigationController?.pushViewController(historyRecodeVC, animated: false)
//                */
//                ProgressHUD.showSuccess("该功能即将开放，请耐心等待")
//            }
            
            if indexPath.row == 0{
                
                var myOrderShow = MyOrderInfoShowVC()
                myOrderShow.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myOrderShow, animated: false)
            }
            
            if indexPath.row == 1 {
                
                if self.sheBeiStatus == "true"{
                    var sheBeiInfoVC = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SheBeiInfoVC") as! SheBeiInfoVC
                    sheBeiInfoVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(sheBeiInfoVC, animated: true)
                }else{
                    var alert = UIAlertView(title: "提示！", message: "亲！开通此功能需要联系我们的人工客服。电话：400-660-3870", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "联系开通")
                    alert.show()
                    alert.delegate = self
                }
                
                
            }
            
            
            
        }
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        NSLog("buttonIndex =\(buttonIndex)")
        
        if buttonIndex == 1{
            var url1 = NSURL(string: "tel://400-660-3870")
            UIApplication.sharedApplication().openURL(url1!)
        }else{
            
        }
        
        
        
        
    }
    
    
    
    
}

extension ProfileVC {
    func pushMyoder(){
        var myOrderShow = MyOrderInfoShowVC()
        myOrderShow.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myOrderShow, animated: false)
    }
}

