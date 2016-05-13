//
//  ShoppingAddressVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/23.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

@objc protocol ShoppingAddressVCDelegate{
    func selectedAreaIs(name:String)
}

class ShoppingAddressVC: UITableViewController {

    weak var delegate:ShoppingAddressVCDelegate?
    
    var shoppingClass:[String] = ["贵州省贵阳市云岩区","贵州省贵阳市小河区","贵州省贵阳市乌当区","贵州省贵阳市观山湖区","贵州省贵阳市花溪区","贵州省贵阳市白云区"]
    
    
    
    //省
    var provinceArry:[String] = [String]()
    //市
    var citys:[String:[String]] = [String:[String]]()
    //县、区
    var countries:[String:[String]] = [String:[String]]()
    ////县、区(区域ID)
    var areaID:[String:String] = [String:String]()
    
    //区域地址显示数据获取
    func registAddressReqProcess(sender:NSNotification){
        var data0 = JSON(sender.object!)
        var data = data0["data"]
        
        //1添加省份
        for(var cnt = 0 ; cnt < data.count ; cnt++){
            var countent = data[cnt]
            var province = countent["title"].stringValue
            provinceArry.append(province)
            
            //2添加城市
            var city = countent["city"]
            var cityArrryTemp = [String]()
            for(var cityCnt = 0 ; cityCnt < city.count ; cityCnt++){
                var cityTemp = city[cityCnt]
                var title = cityTemp["title"].stringValue
                NSLog("title = \(title)")
                cityArrryTemp.append(title)
                if cityArrryTemp.count == city.count{
                    citys[provinceArry[cnt]] = cityArrryTemp
                    cityArrryTemp = []//清空数组
                }
                
                
                //获取县、区
                var countryArryTemp =  cityTemp["area"]
                var countryArry = [String]()
                NSLog("countryArryTemp  = \(countryArryTemp)")
                for(var countryCnt = 0 ; countryCnt < countryArryTemp.count ; countryCnt++ ){
                    var countryTemp = countryArryTemp[countryCnt]
                    
                    var country = countryTemp["title"].stringValue
                    areaID[country] = countryTemp["keyid"].stringValue//添加区域ID
                    NSLog("areaID[\(country)] = \(areaID[country])")
                    countryArry.append(country)
                    NSLog("country = \(country)")
                    if countryArry.count == countryArryTemp.count {
                        countries[cityArrryTemp[cityCnt]] = countryArry
                    }
                }
                
                
            }
            
        }
        
        
        //NSLog("data  = \(data)")
        NSLog("provinceArry  = \(provinceArry)")
        NSLog("citys  = \(citys)")
        NSLog("countries  = \(countries)")

    }
    
    
    
    var http = ShoppingHttpReq.sharedInstance
    
    var selectedFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate?.selectedAreaIs("贵州省贵阳市云岩区")
        
        
        //registAddressReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("registAddressReqProcess:"), name: "shopRegistAddressReq", object: nil)
        
        http.registAddress()
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return shoppingClass.count
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var name = shoppingClass[indexPath.row]
        NSLog("你选择的是\(name)")
        delegate?.selectedAreaIs(name)
        selectedFlag = indexPath.row
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        if selectedFlag == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        cell.textLabel?.text = shoppingClass[indexPath.row]
        return cell
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
