//
//  FirstBuyDiscountVC.swift
//  YaoDe
//
//  Created by iosnull on 16/1/19.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class FirstBuyDiscountVC: UITableViewController {
    //1元商品显示
    var productShow:[Product] = [Product]()
    //数据请求参数、URL
    let parameters = ["format": "normal","startrow":"0","endrow":"30"]
    let manageRoleLoginBaseUrl = serversBaseURL + "/fpactf/a_pro/getnuoyzonepl?"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        //tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("loadMoreData"))
        
        //注册cell
        tableView.registerNib(UINib(nibName: "FirstBuyDiscountCell", bundle: nil), forCellReuseIdentifier: "FirstBuyDiscountCell")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
        getProduct()
    }
    
    
    func getProduct(){
        if serverIsAvalaible() {
            Alamofire.request(.POST,manageRoleLoginBaseUrl,parameters: parameters).responseJSON{ (request, response, data, error) in
                
                NSLog("error= \(error)")
                if error != nil {
                    var alart = UIAlertView(title: "提示", message: "网络响应慢", delegate: nil, cancelButtonTitle: "确定")
                    alart.show()
                }
                if data != nil {//有数据
                    self.dataToModel(data!)
                    
                }
                self.tableView.mj_header.endRefreshing()
                //self.tableView.mj_footer.endRefreshing()
            }
        }
    }


    func dataToModel(data:AnyObject){

        ProgressHUD.dismiss()
        
        var dataTemp = JSON(data)
        NSLog("dataTemp = \(dataTemp)")
        
        if "100" == dataTemp["result"].stringValue{
            NSLog("dataTemp = \(dataTemp)")
            
            var dataArry = dataTemp["data"]
            productShow = []
            
            for(var i = 0 ; i < dataArry.count ; i++) {
                var product = Product()
                var dataA = dataArry[i]
                
                product.img_url = dataA["img_url"].stringValue
                product.pd_price = dataA["pd_price"].stringValue
                product.pd_ptprice = dataA["pd_ptprice"].stringValue
                product.pd_stock = dataA["pd_stock"].stringValue
                product.p_title = dataA["p_title"].stringValue
                product.pd_salesvolume = dataA["pd_salesvolume"].stringValue
                product.pd_keyid = dataA["pd_keyid"].stringValue
                
                product.shop_name = dataA["shop_name"].stringValue
                product.shop_contact = dataA["shop_contact"].stringValue
                
                product.pd_pid = dataA["pd_pid"].stringValue
                product.pd_discript = dataA["pd_discript"].stringValue
                product.pd_spec = dataA["pd_spec"].stringValue
                product.p_adminid = dataA["p_adminid"].stringValue
                product.p_promotion = dataA["p_promotion"].stringValue
                product.c_id = dataA["p_cid"].stringValue
                
                productShow.append(product)
            }
            
            NSLog("productShow = \(productShow.count)")
            if !productShow.isEmpty{
                self.tableView.reloadData()
                ProgressHUD.showSuccess("数据已经更新!!!")
            }else{
                ProgressHUD.showError("无数据信息!!!")
            }
            
            
        }else if "10011" == dataTemp["result"].stringValue{
            ProgressHUD.showError("亲~无更多数据了")
        }
    }
    
    /**
    下拉刷新
    */
    func pullDownRefresh(){
        NSLog("下拉刷新10条数据")
        getProduct()
        
    }
//    /**
//    加载更多
//    */
//    func loadMoreData(){
//        NSLog("上拉加载更多")
//        //1、获取当前订单数组长度
//        var orderLength = ( productShow.count  / 10 ) * 10  +  10 //订单数
//        var endNum = String(orderLength)
//        NSLog("上拉加载\(endNum)")
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productShow.count
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FirstBuyDiscountCell") as! FirstBuyDiscountCell

        cell.setProductView = productShow[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 136
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var firstBuyProductDetailVC = UIStoryboard(name: "FirstBuyDiscountVC", bundle: nil).instantiateViewControllerWithIdentifier("FirstBuyProductDetailVC") as! FirstBuyProductDetailVC
        firstBuyProductDetailVC.product = self.productShow[indexPath.row]
        self.navigationController?.pushViewController(firstBuyProductDetailVC, animated: true)
    }


}
