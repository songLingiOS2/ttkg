//
//  SelectAreaVC.swift
//  YaoDe
//
//  Created by iosnull on 15/10/19.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol SelectAreaVCDelegate{
    func selectCountryIs(name:String,area:String)
    
}







class SelectAreaVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    weak var delegate:SelectAreaVCDelegate?
    
    var refresh = false
    //省
    var provinceArry:[String] = [String]()
    //市
    var AllCitys:[String:[String]] = [String:[String]]()
    //县、区
    var countries:[String:[String]] = [String:[String]]()
    //区县对应的keyID
    var countriesID:[String:String] =  [String:String]()
    
    var selectedAreaID:String = "0" {
        didSet{
            NSLog("区域ID是:\(selectedAreaID)")
        }
    }
    
    
    @IBOutlet var exitBtn: UIButton!
    
    @IBAction func exitBtnClick(sender: UIButton) {
        
    }
    
    
    
    @IBAction func confirmBtnClick(sender: UIButton) {
        
    }
    
    @IBOutlet var selfAreaShow: UILabel!
    
    var http = RegistHTTP.sharedInstance
    var selectAddress = ""
    
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //registAddressReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("customerSelectAreaReqProcess:"), name: "customerSelectAreaReq", object: nil)
        
        http.customerSelectArea()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    
    deinit{
        ProgressHUD.dismiss()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        
        
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 3
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if !refresh{
            return 0
        }
        
        if component == 0 {
            NSLog("0.count = \(provinceArry.count)")
            return provinceArry.count
        }
        if component == 1 {
            var rowProvince = pickerView.selectedRowInComponent(0)
            var provinceName = provinceArry[rowProvince]
            NSLog("1.count = \(provinceArry.count)")
            
            
            if AllCitys[provinceName]?.count > 0 {
            if let returnCitys:[String] = AllCitys[provinceName]{
                return returnCitys.count
            }else{
                return 0
            }
            }else{
                return 0
            }
        }
        
        if component == 2{
            var rowProvince = pickerView.selectedRowInComponent(0)
            var provinceName = provinceArry[rowProvince] //省
            NSLog("2.count = \(provinceArry.count)")
            if AllCitys[provinceName]?.count > 0 {
            if let returnCitys:[String] = AllCitys[provinceName]{  //市
                //市
                var rowCity = pickerView.selectedRowInComponent(1)
                var cityName = returnCitys[rowCity]
                
                //县
                if countries[cityName]?.count > 0 {
                if  let countryArry:[String] = countries[cityName]{
                    return countryArry.count
                }else{
                    return 0
                }
                }else{
                    return 0 
                }
            }
            
            }else{
                return 0
            }
            
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (0 == component) {
            
            return provinceArry[row]
        }
        if(1 == component){
            var rowProvince =  pickerView.selectedRowInComponent(0);
            var  provinceName =  provinceArry[rowProvince];
            if let  citysTemp:[String] = AllCitys[provinceName]{
                    return citysTemp[row];
            }
            return "错误"
        }else{
            var rowProvince =  pickerView.selectedRowInComponent(0)
            var  provinceName = provinceArry[rowProvince];
            var  citysTemp:[String] = AllCitys[provinceName]!;
            var rowCity = pickerView.selectedRowInComponent(1)
            var  cityName = citysTemp[rowCity];
            if let  country:[String] = countries[cityName]{
                return country[row]
            }
            return "错误"
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(0 == component){
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            NSLog("省份选择是：\(provinceArry[row])")
            
        }
        if( 1 == component ){
            pickerView.reloadComponent(2)
            var rowOne:Int = pickerView.selectedRowInComponent(0)
            var rowTow:Int = pickerView.selectedRowInComponent(1)
            var rowThree:Int = pickerView.selectedRowInComponent(2)
            var  provinceName:String = provinceArry[rowOne]
            
            if let  citysTemp:[String] = AllCitys[provinceName]{
                var  cityName:String = citysTemp[rowTow]
                NSLog("市选择是：\(cityName)")
                
            }else{
                NSLog("错误")
            }
            
            
        }
        
        if (2 == component){
            pickerView.reloadComponent(2)
            var rowOne:Int = pickerView.selectedRowInComponent(0)
            var rowTow:Int = pickerView.selectedRowInComponent(1)
            var rowThree:Int = pickerView.selectedRowInComponent(2)
            var  provinceName:String = provinceArry[rowOne]
            
            if let  citysTemp:[String] = AllCitys[provinceName]{
                var  cityName:String = citysTemp[rowTow]
                if let  countrys:[String] = countries[cityName]{
                    var country = countrys[rowThree]
                    var areaID = countriesID[country]
                    selectedAreaID = areaID! //区域ID
                    NSLog("country = \(country)")
                    selfAreaShow.text = "您选择的是:" +  provinceArry[rowOne] + citysTemp[rowTow] + country //显示选择的区域
                    selectAddress = provinceArry[rowOne] + citysTemp[rowTow] + country
                    delegate?.selectCountryIs(selectAddress, area: selectedAreaID)
                    pickerView.delegate = nil
                    pickerView.dataSource = nil
                    self.navigationController?.popViewControllerAnimated(false)
                    
                    
                }else{
                    NSLog("错误")
                }
            }else{
                NSLog("错误")
            }
            
        }
        
        
    }
    
    
    //区域地址显示数据获取
    func customerSelectAreaReqProcess(sender:NSNotification){
        NSLog("data0 = \(sender.object)")
        
        var data0 = NSNotificationToJSON(sender)
//        NSLog("data1 = \(data0)")
        
        

        
        var data = data0["data"]
//        NSLog("data = \(data)")
        
        var removeSpaceAndNewline:NSCharacterSet =  NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        for var i = 0 ;i < data.count ; i++ {
            NSLog("data = \(data)")
            var dataA = data[i]
            var province = dataA["name"].stringValue //省
            
            //去掉空格
            province = province.stringByTrimmingCharactersInSet(removeSpaceAndNewline)
            //存储省信息
            provinceArry.append(province)
            var citys = dataA["list"] //市
            
            var AllCitysTemp = [String]()
            for var j = 0 ; j < citys.count ; j++ {
                var citys = citys[j]
                var cityName = citys["name"].stringValue
                NSLog("cityName = \(cityName)")  //市
                cityName = cityName.stringByTrimmingCharactersInSet(removeSpaceAndNewline)
                AllCitysTemp.append(cityName)
                
                /// countrysTempArry
                var countrysTempArry = [String]()
                var countrys = citys["list"]
                for var k = 0 ; k < countrys.count ; k++ {
                    var country = countrys[k]
                    var countryName = country["name"].stringValue
                    countryName = countryName.stringByTrimmingCharactersInSet(removeSpaceAndNewline)
                    countrysTempArry.append(countryName)
                    countries[cityName] = countrysTempArry //市：[县、区]
                    countriesID[countryName] = country["id"].stringValue
                }
                
            }
            
            AllCitys[province] = AllCitysTemp
            
        }
        
        NSLog("province = \(provinceArry)")  //省
        NSLog("AllCitys = \(AllCitys)")  //区，县
        NSLog("countries = \(countries)")  //区，县
        refresh = true
        pickerView.reloadAllComponents()
        
    }
    
}
