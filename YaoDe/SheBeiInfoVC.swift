//
//  SheBeiInfoVC.swift
//
//
//  Created by yd on 16/3/28.
//
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire


class SheBeiInfoVC: UIViewController {
    
    
    @IBOutlet var AvailableCredit: UILabel!  //总额度
    
    @IBOutlet var SheBeiCost: UILabel! //赊呗花了多少
    
    @IBOutlet var SheBeiYuE: UILabel! //赊呗的余额
    
    @IBOutlet var SheBeiCreditLabel: UILabel! // 赊呗 可用额度
    
    @IBOutlet var ApplySheBeiBtn: UIButton!
    
    
    
    
    
    @IBAction func ApplySheBeiBtn(sender: AnyObject) {
        ProgressHUD.show("申请中......")
        applySheBeiState(currentRoleInfomation.keyid)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        
        
    }
    
    func applySheBeiState(userid:String) {
        
        
        let url = serversBaseURL + "/member/apply"
        
        
        let parameters = ["adminid":userid]
        
        if netIsavalaible {
        
        Alamofire.request(.POST,url,parameters: parameters).responseString{ (request, response, data, error) in
            
            
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            var message = json["message"].stringValue
            if json["success"].stringValue == "true" {
                
                
                self.ApplySheBeiBtn.setTitle("已申请", forState: UIControlState.Normal)
                
                ProgressHUD.showSuccess(message)
                
                
            }else{
                ProgressHUD.showError(message)
            }
            
            
            
        }
            
        }else{
            netIsEnable("网络不可用")
        }
        
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        getSheBeiState(currentRoleInfomation.keyid)
    }
    
    func getSheBeiState(userid:String) {
        
        
        let url = serversBaseURL + "/member/credit"
        
        
        let parameters = ["adminkeyid":userid]
        
        
        if netIsavalaible {
        Alamofire.request(.GET,url,parameters: parameters).responseString{ (request, response, data, error) in
            
            
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            var message = json["message"].stringValue
            if json["success"].stringValue == "true" {
                var data = json["data"]
                NSLog("data =\(data)")
                
                if data["creditStatus"].stringValue == "true" {
                    self.AvailableCredit.text = String(format: "%.2f", data["creditAmount"].doubleValue)
                    var costPay = (data["creditAmount"].doubleValue) - (data["creditAvailable"].doubleValue)
                    self.SheBeiCost.text = String(format: "%.2f", costPay)
                    self.SheBeiYuE.text = String(format: "%.2f", data["creditAvailable"].doubleValue)
                    
                }else{
                    
                }
                
            }
            
            
            
        }
        }else{
            netIsEnable("网络不可用")
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
