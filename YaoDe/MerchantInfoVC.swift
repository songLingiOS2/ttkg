//
//  MerchantInfoVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/14.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON

class MerchantInfoVC: UITableViewController {

    var http = ShoppingHttpReq.sharedInstance
    
    @IBOutlet var usrName: UITextField!
    @IBOutlet var mobilPhone: UITextField!
    @IBOutlet var tel: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var remark: UITextField!
    
    @IBOutlet var modifyBtn: UIButton!
    @IBAction func modifyBtnClk(sender: UIButton) {
    }
    
    @IBOutlet var usr: UILabel!
    func setSubViewPara(){
        var rightBtn = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: Selector("saveBtnClk"))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
        self.navigationItem.title = "管理级别用户"
        usr.text = currentRoleInfomation.adminid  //登录用户名（不能被修改）
        usrName.text = currentRoleInfomation.name //用户真实姓名
        mobilPhone.text = currentRoleInfomation.tel //用户移动电话
        address.text = currentRoleInfomation.address
        tel.text = currentRoleInfomation.contact
        address.text = currentRoleInfomation.address
        
    }
    
    func saveBtnClk(){
        NSLog("保存用户信息")
        http.reSaveUsrInfo(admin: usr.text!, uname: usrName.text, tel: mobilPhone.text, contact: tel.text, address: address.text, intro:remark.text)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSubViewPara()
        
        //aliPayResultReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reSaveUsrInfoReqProcess:"), name: "reSaveUsrInfoReq", object: nil)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

    }
    

    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func reSaveUsrInfoReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            
            if "100" == dataTemp["result"].stringValue {
                NSLog("用户信息更新成功")
                ProgressHUD.showSuccess("用户信息更新成功")
            }else{
                ProgressHUD.showError("用户信息更新失败!!!")
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1{
            var modifySecretVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ModifySecretVC") as! ModifySecretVC
            
            self.navigationController?.pushViewController(modifySecretVC, animated: true)
        }
    }

}
