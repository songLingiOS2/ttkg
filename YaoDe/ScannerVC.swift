////
////  ScannerVC.swift
////  YaoDe
////
////  Created by iosnull on 15/10/10.
////  Copyright (c) 2015年 yongzhikeji. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import SDWebImage
//
//
//struct BarCodeInfo {
//    var d_stock = ""
//    var p_endtime = ""
//    var d_description = ""
//    var d_price = ""
//    var a_setareaid = ""
//    var p_starttime = ""
//    var d_keyid = ""
//    var d_ptprice = ""
//    var p_status = ""
//    var a_shopname = ""
//    var p_keyid = ""
//    var a_roleid = ""
//    var d_spec = ""
//    var p_title = ""
//    var a_KeyID = ""
//    var p_display = ""
//    var p_promotion = ""
//    var p_adminid = ""
//    var d_pid = ""
//    var prostatus = ""
//    var img_url = ""
//    var p_shelves = ""
//    
//    
//}
//
//class ScannerVC: UIViewController {
//    
//    var http = ShoppingHttpReq.sharedInstance
//    var scannerView = UIView()
//    var scanner:MTBBarcodeScanner!
//    
//    //var barCodeInfoArry = [BarCodeInfo]()//扫描到的商品信息
//    
//    
//    @IBOutlet var barCodeInput: UITextField!
//    
//    
//    
//    func setBtn(){
//        searchBtn.layer.masksToBounds = true
//        searchBtn.layer.borderWidth = 1
//        searchBtn.layer.cornerRadius = 3
//        searchBtn.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
//    }
//    
//    
//    @IBOutlet var searchBtn: UIButton!
//    @IBAction func searchBtnclk(sender: UIButton) {
//        if barCodeInput.text.length > 0 {
//            self.codeNum = barCodeInput.text
//            //http.getProductInfoFromBarCode(pagesize: "10",currentpage: "1",roleid: currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid, barcode: codeNum)
//            //NSLog("self.codeNum  \(self.codeNum)")
//        }else{
//            var alart = UIAlertView(title: "提示", message: "请输入商品的条形码", delegate: nil, cancelButtonTitle: "确定")
//            alart.show()
//        }
//        
//    }
//    
//    var codeNum:String = "0" {  //条形码记录
//        didSet{
//            //http.getProductInfoFromBarCode(pagesize: "10",currentpage: "1",roleid: currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid, barcode: codeNum)
//            //codeNum = "0"
//        }
//    }
//    
//    var rightBtn = UINavigationItem(title: "")
//    
//    @IBOutlet var scanerView: UIView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        setBtn()
//        
//        scanner = MTBBarcodeScanner(previewView: self.view)
//        
//        
//        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫描", style: UIBarButtonItemStyle.Done, target: self, action: Selector("scanBtnClk"))
//        
//        //getProductInfoFromBarCodeReq
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getProductInfoFromBarCodeReqProcess:"), name: "getProductInfoFromBarCodeReq", object: nil)
//        self.view.addSubview(scanerView)
//    }
//    
//    func scanBtnClk(){
//        //NSLog("扫描按钮动作")
//        self.barCodeInput.text = ""
//        MTBBarcodeScanner.requestCameraPermissionWithSuccess { (success) -> Void in
//            if success{
//                //NSLog("有相机权限")
//                self.scanner.startScanningWithResultBlock({ (codes:[AnyObject]!) -> Void in
//                    var code:AVMetadataMachineReadableCodeObject = codes.first  as!AVMetadataMachineReadableCodeObject
//                    //println("code = \(code.stringValue)")
//                    
//                    self.codeNum = code.stringValue
//                    self.barCodeInput.text = code.stringValue
//                    
//                    self.scanner.stopScanning()
//                    
//                    self.http.getProductInfoFromBarCode(pagesize: "10",currentpage: "1",roleid: currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid, barcode: self.codeNum)
//                })
//            }else{
//                //NSLog("没有相机权限")
//                showMessageAnimate(self.view, "没有权限打开相机")
//            }
//        }
//    }
//    
//    //取消通知订阅
//    deinit{
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    override func viewWillAppear(animated: Bool) {
//        
//        
//        self.tabBarController?.tabBar.hidden = true
//        MTBBarcodeScanner.requestCameraPermissionWithSuccess { (success) -> Void in
//            if success{
//                self.scanner.startScanningWithResultBlock({ (codes:[AnyObject]!) -> Void in
//                    var code:AVMetadataMachineReadableCodeObject = codes.first  as!AVMetadataMachineReadableCodeObject
//                    //println("code = \(code.stringValue)")
//                    
//                    self.codeNum = code.stringValue
//                    self.barCodeInput.text = code.stringValue
//                    self.scanner.stopScanning()
//                    self.http.getProductInfoFromBarCode(pagesize: "10",currentpage: "1",roleid: currentRoleInfomation.roleid, areaid: currentRoleInfomation.areaid, barcode: code.stringValue)
//                })
//            }else{
//                showMessageAnimate(self.view, "没有权限打开相机")
//            }
//        }
//        
//    }
//    
//    
//    override func viewWillDisappear(animated: Bool) {
//        
//    }
//    
//    
//    
//    func getProductInfoFromBarCodeReqProcess(sender:NSNotification){
//        
//        ProgressHUD.dismiss()
//        
//        if  let senderTemp:AnyObject = sender.object {
//            var dataTemp = NSNotificationToJSON(sender)
//            NSLog("dataTemp = \(dataTemp)")
//            let message = dataTemp["message"].stringValue
//            if "true" == dataTemp["success"].stringValue {
//                
//                NSLog("dataTemp = \(dataTemp)")
//                
//                if  dataTemp["status"].stringValue == "2" {
//                    scanBtnClk()
//                    //showMessageAnimate(self.navigationController!.view, message)
//                }else{
//                    
//                    var dataTemp = dataTemp["data"]["list"]
//                    
//                    
//                    var barCodeInfo = BarCodeInfo()
//                    for var i = 0 ;i < dataTemp.count ; i++ {
//                        
//                        var pData = dataTemp[i]
//                        
//                        barCodeInfo.a_shopname = pData["shopname"].stringValue
//                        barCodeInfo.d_stock = pData["salesvolume"].stringValue
//                        barCodeInfo.p_keyid = pData["ProductKeyID"].stringValue
//                        barCodeInfo.d_price = pData["MinPrice"].stringValue
//                        barCodeInfo.img_url = pData["pictureURL"].stringValue
//                        barCodeInfo.p_adminid = pData["AdminKeyID"].stringValue
//                        barCodeInfo.p_title = pData["title"].stringValue
//                        
//                    }
//                    
//                    if barCodeInfo.p_keyid != "" {
//                        
//                        var shopDetailVC = ShopingDetailVC()
//                        shopDetailVC.adminkeyid = barCodeInfo.p_adminid
//                        shopDetailVC.productkeyid = barCodeInfo.p_keyid
//                        
//                        shopDetailVC.usertype = currentRoleInfomation.sptypeid
//                        shopDetailVC.userid = currentRoleInfomation.roleid
//                        
//                        self.navigationController?.pushViewController(shopDetailVC, animated: true)
//                    }else{
//                        showMessageAnimate(self.navigationController!.view, message)
//                    }
//                }
//                
//                
//            }else{
//                
//                showMessageAnimate(self.navigationController!.view, message)
//                
//            }
//        }else{
//            ProgressHUD.showError("扫描错误")
//        }
//    }
//    
//}
