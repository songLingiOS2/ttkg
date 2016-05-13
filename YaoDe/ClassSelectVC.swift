//
//  ClassSelectVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/11.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit



class ClassSelectVC: UITableViewController {

    var mainAndSub = [String:[ClassProduct]]()
    var mainArry = [ClassProduct]()
    var listTempProductArry = [ClassProduct]()
    var shopID = "" //商家id
    var shopPush = false
   
    var http = ShoppingHttpReq.sharedInstance
    var classProduct = ClassProduct()
    var subClassProduct:[ClassProduct] = [ClassProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.edgesForExtendedLayout = UIRectEdge.None

        //注册cell
        tableView.registerNib(UINib(nibName: "SubClassCell", bundle: nil), forCellReuseIdentifier: "SubClassCell")
        
//        tableView.style = UITableViewStyle.Grouped
        
        ProgressHUD.show("数据请求中...")
        
        if shopPush {//是商家push过来的
        
            //通知getMoreClassProductProcess
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getMoreClassProductProcess:"), name: "getShopSubClassReqClassSelectVC", object: nil)
           http.getShopSubClass(shopID,  whoAreYou: "ClassSelectVC")
        }else{
            //通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getMoreClassProductProcess:"), name: "getMoreClassProductClassSelectVC", object: nil)
            http.getMoreClassProduct(whoAreYou:"ClassSelectVC")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mainArry.count
    }

    var btnFlag  = [Bool]()
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var xxtitle  = mainArry[section].title
        NSLog("xxtitle == \(xxtitle)")
        if btnFlag[section] {
            return mainAndSub[xxtitle]!.count
        }else{
            return 0
        }
        
        
        
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        var headerView = MoreClassHeader(frame: CGRect(x: 0, y:0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 65))
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.button.tag = section
        headerView.button .addTarget(self, action: Selector("headerBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        var xxtitle = mainArry[section].title
        var imageUrl = serversBaseUrlForPicture + mainArry[section].picurl
        headerView.imageView.sd_setImageWithURL(NSURL(string: imageUrl))
        
        headerView.nameLabel.text = xxtitle
        return headerView
    }
    
    func headerBtnClick(sender:UIButton){
        NSLog("sender.tag = \(sender.tag)")
        btnFlag[sender.tag ] =  !btnFlag[sender.tag]
        
        var xxtitle  = mainArry[sender.tag].title
        NSLog("xxtitle == \(xxtitle)")
        
        var xxx = mainAndSub[xxtitle]
        NSLog("xxx \(xxx)")
        var listTempProductArry = [ClassProduct]()
        subClassProduct = xxx!
        for (var i = 0; i < listTempProductArry.count; i++ ){
            var temp = listTempProductArry[i]
            NSLog("temp= \(temp.title)")
        }
        tableView.reloadData()
    }
    
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubClassCell") as! SubClassCell
        var xxtitle  = mainArry[indexPath.section].title
        NSLog("xxtitle == \(xxtitle)")
        
        var xxx = mainAndSub[xxtitle]
        NSLog("xxx \(xxx)")
        
        subClassProduct = xxx!
        cell.setClassProduct = subClassProduct[indexPath.row]
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        NSLog("点击了\(indexPath.section)的\(indexPath.row)")
        var xxtitle  = mainArry[indexPath.section].title
        NSLog("xxtitle == \(xxtitle)")
        
        var xxx = mainAndSub[xxtitle]
        NSLog("xxx \(xxx)")
        
        subClassProduct = xxx!
    
        tableView.registerNib(UINib(nibName: "HomePageProductCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        var classProductVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ClassProductVC") as! ClassProductVC
        NSLog("subClassProduct[indexPath.row].title == \(subClassProduct[indexPath.row].keyid)")
        
        classProductVC.navigationItem.title = subClassProduct[indexPath.row].title
        classProductVC.KeyID = subClassProduct[indexPath.row].keyid
        classProductVC.classProduct = subClassProduct[indexPath.row]
        
        NSLog("shopPush =\(shopPush)")
        if shopPush {
            classProductVC.MerchantPush = true
        }else{
            
        }
        
        
        classProductVC.MerchantKeyID = shopID
        
        self.navigationController?.pushViewController(classProductVC, animated: true)


    }
    
    

    
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

extension ClassSelectVC{
    //分类按钮展示
    
    func getMoreClassProductProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue{
                mainAndSub = [:]
                btnFlag = [ ]//选中标记
                NSLog("获取到分类产品展示数据")
                ProgressHUD.dismiss()
                
                var classProductData = dataTemp["data"]
                var classProductTemp = ClassProduct()
                for(var cnt = 0 ; cnt < classProductData.count ; cnt++ ){
                    var data  = classProductData[cnt]
                    classProductTemp.picurl = data["picurl"].stringValue
                    classProductTemp.title = data["name"].stringValue
                    classProductTemp.keyid = data["keyid"].stringValue
                    
                    var list = data["list"]
                    var listProductArry = [ClassProduct]()
                    for (var i = 0; i < list.count; i++ ) {
                        var list0 = list[i]
                        var listProductTemp = ClassProduct()
                        
                        listProductTemp.picurl = list0["picurl"].stringValue
                        listProductTemp.title = list0["name"].stringValue
                        listProductTemp.keyid = list0["keyid"].stringValue
                        NSLog("listProductTemp.keyid == \(listProductTemp.title)")
                        listProductArry.append(listProductTemp)
                    }
//                    NSLog("mainArry == \(mainArry[cnt].title)")
                    
                    btnFlag.append(false)
                    mainArry.append(classProductTemp)
                    mainAndSub[classProductTemp.title] = listProductArry
                    NSLog("mainArry == \(mainArry[cnt].picurl)")
//                    classProductTemp.listArray.append(listProductTemp)
                    
                    
                    //NSLog("classProductTemp.listArray == \(classProductTemp.listArray.count)")
                    
                    //NSLog("classProductTemp = \(classProductTemp)")
                    //subClassProduct.append(classProductTemp)
                }
                
                NSLog("mainAndSub = \(mainAndSub)")
                tableView.reloadData()
//                if !subClassProduct.isEmpty{
//                    tableView.reloadData()
//                }
                
                
            }else{
                ProgressHUD.showError("数据获取失败!!!")
                //self.navigationController?.popViewControllerAnimated(true)
            }
        }else{
            ProgressHUD.showError("数据获取失败!!!")
        }
        
    }
}
