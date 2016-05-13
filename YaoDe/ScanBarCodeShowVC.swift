//
//  ScanBarCodeShowVC.swift
//  TTKG
//
//  Created by iosnull on 16/4/27.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//


    
    import UIKit
    import SwiftyJSON
    import SDWebImage
    
class ScanBarCodeShowVC:UITableViewController {
        
        
        
        //商家内搜索
        var shopID = ""//商家ID
        var shopInternal = false
        //商品显示
        var shopPush = false
        var productShow:[Product] = [Product]()
    
        
        var pagesize = 100
        
        
        
    
        
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            tableView.separatorInset = UIEdgeInsetsZero //设置分割线没有内容边距
            tableView.layoutMargins = UIEdgeInsetsZero //清空默认布局边距
        }
        
        override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            //注册cell
            tableView.registerNib(UINib(nibName: "HomePageProductCell", bundle: nil), forCellReuseIdentifier: "cell")
            
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            

            
            tableView.tableFooterView = UIView()
        }
        

        
        override func viewWillAppear(animated: Bool) {
            
        }
        
        
        
        // MARK: - Table view data source
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Potentially incomplete method implementation.
            // Return the number of sections.
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete method implementation.
            // Return the number of rows in the section.
            return productShow.count
        }
        
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomePageProductCell
            
            //cell.delegate = self
            cell.tag = indexPath.row
            cell.setProductView = productShow[indexPath.row]
            
            return cell
        }
        

        
        
        
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 90
        }
        
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            NSLog("你选择是的是\(productShow[indexPath.row].p_title)")
            
            var shopDetailVC = ShopingDetailVC()
            shopDetailVC.adminkeyid = productShow[indexPath.row].p_adminid
            shopDetailVC.productkeyid = productShow[indexPath.row].pd_keyid
            
            shopDetailVC.usertype = currentRoleInfomation.sptypeid
            shopDetailVC.userid = currentRoleInfomation.roleid
            
            self.navigationController?.pushViewController(shopDetailVC, animated: true)
        }
        
        //取消通知订阅
        deinit{
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            //清理图片内存
            SDImageCache.sharedImageCache().clearMemory()
        }
        
        
        //商品展示
        func getProductAccordingToKeyValueReqProcess(sender:NSNotification){
            
            
            ProgressHUD.dismiss()
            
            if  let senderTemp:AnyObject = sender.object {
                var dataTemp = NSNotificationToJSON(sender)
                NSLog("dataTemp = \(dataTemp)")
                
                if "true" == dataTemp["success"].stringValue{
                    var dataArry = dataTemp["data"]["list"]
                    productShow = []
                    
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
                        
                        //2016-01-20添加限时购
                        product.pd_ispurchase = dataA["pd_ispurchase"].stringValue
                        product.pd_purchasenum = dataA["pd_purchasenum"].stringValue
                        
                        //买满什么多少件送什么
                        product.pd_conditionnums = dataA["pd_conditionnums"].stringValue
                        product.pd_givingnums = dataA["pd_givingnums"].stringValue
                        product.pd_givingproduct = dataA["pd_givingproduct"].stringValue
                        
                        productShow.append(product)
                    }
                    
                    
                    
                    
                    NSLog("\(productShow.count)")
                    if !productShow.isEmpty{
                        self.tableView.reloadData()
                        ProgressHUD.showSuccess("数据已经更新!!!")
                    }else{
                        ProgressHUD.showError("无数据信息!!!")
                    }
                    
                    
                }
                
                
            }else{
                ProgressHUD.showError("获取数据失败!!!")
            }
            
        }
        
}

