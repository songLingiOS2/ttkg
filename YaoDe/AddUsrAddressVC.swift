//
//  AddUsrAddressVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/9.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class AddUsrAddressVC: UITableViewController,UITextFieldDelegate,SelectAreaVCDelegate {

    var http = ShoppingHttpReq.sharedInstance
    var pickerView = UIPickerView()
    
    //收货地址
    var placeOfReceipt = PlaceOfReceipt()
    
    @IBOutlet var name: UITextField!
    @IBOutlet var tel: UITextField!
    @IBOutlet var spareTel: UITextField!
    @IBOutlet var code: UITextField!
    @IBOutlet var provinceCityCountry: UITextField!
    @IBOutlet var detailAddress: UITextField!
    
    
    @IBOutlet var selectCity: UIButton!
    
    @IBAction func selectCityBtnClick(sender: AnyObject) {
        
        
        resignAllFirstResponder()
        var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
        selectAreaVC.delegate = self
        provinceCityCountry.userInteractionEnabled = false
        self.navigationController?.pushViewController(selectAreaVC, animated: true)
        
        
    }
    
    
    //获取用户输入地址信息
    func getUsrAddressInfo(){
        placeOfReceipt.name = name.text
        placeOfReceipt.phone = tel.text
        if spareTel.text.isEmpty{
           placeOfReceipt.sphone = tel.text
        }else{
           placeOfReceipt.sphone = spareTel.text
        }
        placeOfReceipt.postcode = code.text
        placeOfReceipt.area = provinceCityCountry.text
        placeOfReceipt.address = detailAddress.text
        
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
       /* if provinceCityCountry.isFirstResponder() && textField.tag == 100 {
                resignAllFirstResponder()
            var selectAreaVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SelectAreaVC") as! SelectAreaVC
            selectAreaVC.delegate = self
            provinceCityCountry.userInteractionEnabled = false
            self.navigationController?.pushViewController(selectAreaVC, animated: true)
        }*/
    }
    
    
    
    
    func selectCountryIs(name: String, area: String) {
        provinceCityCountry.text = name
        NSLog("areaKeyID = \(name)")
    }

    
    
    
    @IBAction func resignAllSubView(sender: UITapGestureRecognizer) {
        resignAllFirstResponder()
    }
    
    func resignAllFirstResponder(){
        name.resignFirstResponder()
        tel.resignFirstResponder()
        spareTel.resignFirstResponder()
        code.resignFirstResponder()
        provinceCityCountry.resignFirstResponder()
        detailAddress.resignFirstResponder()
    }
    
    func setNavigationBar(){
        var rightButton = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Done, target: self, action: Selector("addAddressBtnClk:"))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "收货地址添加"
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        provinceCityCountry.delegate = self
        provinceCityCountry.tag = 100
        
        
        provinceCityCountry.userInteractionEnabled = false
        
        
        
        setNavigationBar()
        //addUsrPlaceOfReceiptUrlReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addUsrPlaceOfReceiptUrlReqProcess:"), name: "addUsrPlaceOfReceiptUrlReq", object: nil)
        
    }
    
    


    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addAddressBtnClk(sender:UIBarButtonItem){
      NSLog("确定添加地址数据")
        if checkInputPara(){
            getUsrAddressInfo()
            
            //判断usertype 为3001 或 3002  
            /*
            var usertypeTemp = ""
            if currentRoleInfomation.usertype == "30001" {
                usertypeTemp = "2"
            }else
            {
                usertypeTemp = "1"
            }
            */
            var usertypeTemp = "1"
            
            http.addUsrPlaceOfReceipt(name: placeOfReceipt.name, phone: placeOfReceipt.phone, sphone: placeOfReceipt.sphone, area: placeOfReceipt.area, address: placeOfReceipt.address, postcode: placeOfReceipt.postcode, remark: placeOfReceipt.remark, usertype: usertypeTemp, userid: currentRoleInfomation.keyid, isdef: placeOfReceipt.isdefault)
        }else{
            var alart = UIAlertView(title: "提示", message: "用户收货信息不能为空，请重新输入", delegate: nil, cancelButtonTitle: "重新输入")
            alart.show()
        }
        
    }
    
    func checkInputPara()->Bool{
        
        if name.text.isEmpty {
            return  false
        }
        
        if tel.text.isEmpty {
            return false
        }
        
        if provinceCityCountry.text.isEmpty{
            return false
        }
        
        if detailAddress.text.isEmpty{
            return false
        }
        
        return true
    }
    
    func returnBtnClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddUsrAddressVC{
    //添加地址网络请求处理
    func addUsrPlaceOfReceiptUrlReqProcess(sender:NSNotification){
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            var message = dataTemp["message"].stringValue
            if "true" == dataTemp["success"].stringValue {
                NSLog("添加地址成功")
                
                
                showMessageAnimate(self.navigationController!.view, message)
                
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                showMessageAnimate(self.navigationController!.view, message)
            }
        }
    }
}
