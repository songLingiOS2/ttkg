//
//  RegistVC.swift
//  YaoDe
//
//  Created by iosnull on 15/8/24.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//
/*
import UIKit
import SwiftyJSON

class RegistVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    //跳转到相应注册控制器
    @IBAction func jumpToRegistVC(sender: AnyObject) {
        NSLog("跳转到注册控制器\(selectedRole)")
        if selectedRole.keyid == "7"{//零售商
            var shoppingRegistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShoppingRegistVC") as!  ShoppingRegistVC
            
            //角色标记(顶部显示用)
            shoppingRegistVC.roleName = selectedRole.rolename
            
            //角色ID
            shoppingRegistVC.manageRoleRegistInfo.roleid = selectedRole.keyid
            
            self.navigationController?.pushViewController(shoppingRegistVC, animated: true)
            
//        }else if selectedRole.keyid == "6"{//配送商
//            var distributionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DistributionRegistVC") as!  DistributionRegistVC
//            //角色标记(顶部显示用)
//            distributionVC.roleName = selectedRole.rolename
//            //角色ID
//            distributionVC.manageRoleRegistInfo.roleid = selectedRole.keyid
//            self.navigationController?.pushViewController(distributionVC, animated: true)
        }else{
            var alart = UIAlertView(title: "提示", message: "该角色未被支持", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        
        
    }
    
    
    
    var roleInfoArry:[roleInfo] = [roleInfo]()
    var selectedRole:roleInfo = roleInfo()
    
    @IBOutlet var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var alart = UIAlertView(title: "提示", message: "当前只支持零售商入驻", delegate: nil, cancelButtonTitle: "确定")
        alart.show()
        
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        //默认选择第一行
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
        
        //请求角色数据
        var http = RegistHTTP.sharedInstance
        http.roleInformationReq()
        //添加通知监测
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("roleInformationReqPrecess:"), name: "roleInformationReq", object: nil)
        
    }
    
    //角色通知处理
    func roleInformationReqPrecess(sender:NSNotification?){
        
        if let roleData0: AnyObject = sender!.object {
            
            let roleData = NSNotificationToJSON(sender!)
            
            
                    if roleData["success"].stringValue == "true" {
                        
                        
                        var data = roleData["data"]["items"]
                        var roleTemp = roleInfo()
                        for(var cnt = 0 ; cnt < data.count ; cnt++ ){
            
                            var whichRole = data[cnt]
            
                            //roleTemp.sortnum = whichRole["sortnum"].stringValue
                            roleTemp.keyid = whichRole["keyid"].stringValue
                            roleTemp.rolename = whichRole["name"].stringValue
                            //roleTemp.isdefault = whichRole["isdefault"].stringValue
                            //roleTemp.remark = whichRole["remark"].stringValue
            
                            //过滤掉管理员
                            if roleTemp.keyid != "1"{
                                roleInfoArry.append(roleTemp)
                            }
                        }
                        
                        pickerView.reloadAllComponents()
                        NSLog("data = \(data)")
                    }
        }
        
        
    }
    //取消通知订阅
    deinit{
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - PickerView
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return roleInfoArry.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if roleInfoArry.count > 0 {
           return roleInfoArry[row].rolename
        }else{
          return ""
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if roleInfoArry.count > 0 {
            NSLog("你选择的是\(roleInfoArry[row].rolename)")
            selectedRole = roleInfoArry[row]
        }else{
            
        }
        
        
    }

}
*/