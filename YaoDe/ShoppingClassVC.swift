//
//  ShoppingClassVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/23.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit

@objc protocol ShoppingClassVCDelegate{
    func selectedShoppingClass(name:String,classID:String)
}

class ShoppingClassVC: UITableViewController {
    
    weak var delegate:ShoppingClassVCDelegate?
    
    var shoppingClass = [String:String]()  //字典[name:id]表示区域对应的id
    var className = [String]()//分类名字
    
    var selectedFlag = 100
    
    var http = ShoppingHttpReq.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getShoppingClassReqProcess:"), name: "getShoppingClassReq", object: nil)
        
        //请求商店类别
        http.getShoppingClass()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getShoppingClassReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue{
                
                
                var shopData = dataTemp["data"]["items"]
                
                shoppingClass = [:]
                className = []
                var data = shopData//
//                var data = dataTemp["data"]
                for var i = 0 ; i < data.count ; i++ {
                    let para = data[i]
                    let display = para["display"]
                    let name = para["name"].stringValue
                    let keyid = para["keyid"].stringValue
                    className.append(name)
                    shoppingClass[name] = keyid
                }
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var name = className[indexPath.row]
        NSLog("你选择的是\(name)")
        delegate?.selectedShoppingClass(name, classID:shoppingClass[name]!)
        selectedFlag = indexPath.row
        tableView.reloadData()
        
        self.navigationController?.popViewControllerAnimated(false)
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
        return shoppingClass.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        if selectedFlag == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        cell.textLabel?.text = className[indexPath.row]
        return cell
        
        
        
    }
    


}
