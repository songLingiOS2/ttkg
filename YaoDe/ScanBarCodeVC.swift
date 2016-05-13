//
//  ScanBarCodeVC.swift
//  TTKG
//
//  Created by iosnull on 16/4/27.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ScanBarCodeVC: UIViewController,RMScannerViewDelegate,UIAlertViewDelegate {
    var scannerView: RMScannerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didScanCode(scannedCode: String!, onCodeType codeType: String!) {
         NSLog("scannedCode = \(scannedCode)")
         //scannerView startScanSession  //可以再次进行扫描
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Scanned %@", [scannerView humanReadableCodeTypeForCode:codeType]] message:scannedCode delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"New Session", nil];
//        [alert show];
        
        var codeType  = scannerView!.humanReadableCodeTypeForCode(codeType)
        NSLog("codeType = \(codeType)")
        
        var alert = UIAlertView(title: "条形码扫描", message: "该商品条形码是:" + scannedCode, delegate: self, cancelButtonTitle: "去查看", otherButtonTitles: "重新扫描")
        alert.delegate = self
        alert.tag = 200
        alert.show()
        barCode = scannedCode
        
    }
    
    var barCode = "" //条形码
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 200 {
        if buttonIndex == 0 {
           getProductInfoFromBarCode(pagesize: "50",currentpage: "1",roleid: currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid, barcode: barCode)
        }else{
           scannerView!.startScanSession()
        }
        }else{
            if buttonIndex == 0 {
                self.navigationController?.popViewControllerAnimated(false)
            }else{
                self.scannerView!.startScanSession()
            }
        }
    }
    
    func shouldEndSessionAfterFirstSuccessfulScan() -> Bool {
        return true
    }
    
    //字符串转JSON
    func StringToJSON(sender:String)->JSON{
        
        var resultData = sender as NSString
        
        if let dataFromString = resultData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data:dataFromString)
            
            return json
        }else{
            return nil
        }
        
    }

    //条形码获取商品信息
    func getProductInfoFromBarCode(#pagesize:String,currentpage:String,roleid:String,areaid:String,barcode:String){
        
        let parameters = ["pagesize": pagesize, "currentpage": currentpage ,"roleid":roleid,"areaid":areaid,"barcode":barcode]
        let getProductInfoFromBarCodeUrl:String = serversBaseURL + "/product/scan"
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
            ProgressHUD.show("")
            Alamofire.request(.GET,getProductInfoFromBarCodeUrl,parameters: para).responseString{ (request, response, data, error) in
                
                
                ProgressHUD.dismiss()
                var json = self.StringToJSON(data!)
                NSLog("json = \(json.description)")
                var message = json["message"].stringValue
                var status = json["status"].stringValue
                if ("true" == json["success"].stringValue) &&  (status != "2") {
                    
                    self.scannerView!.stopCaptureSession()
                    
                    var dataArry = json["data"]["list"]
                    var productShow = [Product]()
                    
                    for(var i = 0 ; i < dataArry.count ; i++) {
                        var product = Product()
                        var dataA = dataArry[i]
                        
                        //NSLog("dataA = \(dataA)")
                        product.img_url = dataA["pictureURL"].stringValue
                        product.pd_price = dataA["MinPrice"].doubleValue.description
                        product.p_title = dataA["title"].stringValue
                        product.pd_salesvolume = dataA["salesvolume"].stringValue
                        product.pd_keyid = dataA["ProductKeyID"].stringValue
                        product.p_adminid = dataA["AdminKeyID"].stringValue
                        product.shop_name = dataA["shopname"].stringValue
                        
                        
                        
                        product.shop_contact = dataA["shop_contact"].stringValue
                        product.pd_discript = dataA["pd_discript"].stringValue
                        product.pd_spec = dataA["pd_spec"].stringValue
                        product.p_promotion = dataA["p_promotion"].stringValue
                        

                        
                        productShow.append(product)
                    }
                    
                    var scanBarCodeShowVC = ScanBarCodeShowVC()
                    scanBarCodeShowVC.productShow = productShow
                    scanBarCodeShowVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(scanBarCodeShowVC, animated: false)
                    
                }else{

                    
                    var alert = UIAlertView(title: "提示", message: message, delegate: self, cancelButtonTitle: "退出扫描", otherButtonTitles: "扫描其他")
                    alert.delegate = self
                    alert.tag = 100
                    alert.show()
                    
                    
                }
                
                
            }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if scannerView?.superview == nil {
        
        }else{
            scannerView!.removeFromSuperview()
        }
        
        scannerView = RMScannerView(frame: self.view.frame)
        scannerView!.delegate = self
        scannerView!.verboseLogging = true
        // Set animations to YES for some nice effects
        //[scannerView setAnimateScanner:YES];
        scannerView!.animateScanner = true
        // Set code outline to YES for a box around the scanned code
        //[scannerView setDisplayCodeOutline:YES];
        scannerView!.displayCodeOutline = true
        // Start the capture session when the view loads - this will also start a scan session
        //[scannerView startCaptureSession];
        scannerView!.startCaptureSession()
        scannerView!.delegate = self
        self.view.addSubview(scannerView!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func errorGeneratingCaptureSession(error: NSError!) {
        scannerView!.stopCaptureSession()
        var alert = UIAlertView(title: "提示", message:"请前往手机【设置>隐私>相机】开启权限后即可使用" , delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    deinit{
        
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
