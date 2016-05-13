//
//  shoppingRegistVC.swift
//  YaoDe
//
//  Created by iosnull on 15/8/24.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShoppingRegistVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    
    //标记(true 为 区域选择，false 为商店类别选择)
    var flagPickerBelongTo = false
    
    var shoppingClassArry:[ShoppingClass] = [ShoppingClass]()
    
    var manageRoleRegistInfo = ManageRoleRegistInfo()
    
    //省
    var provinceArry:[String] = [String]()
    //市
    var citys:[String:[String]] = [String:[String]]()
    //县、区
    var countries:[String:[String]] = [String:[String]]()
    ////县、区(区域ID)
    var areaID:[String:String] = [String:String]()
    
    var http = RegistHTTP.sharedInstance
    
    //当前角色名称
    var roleName = ""
    var alart:UIAlertView?
    
    var agreeProtocolBtnState = false
    
    
    @IBOutlet var shopoingClass: UITextField!
    @IBOutlet var pickerViewMissBtn: UIButton!
    @IBAction func pickerViewMissBtnClk(sender: AnyObject) {
        NSLog("pickerViewMissBtnClk")
        addressPickerViewNotShow()
    }
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var indicatorBackView: UIView!
    @IBAction func registBtnClk(sender: UIButton) {
        NSLog("点击注册按钮了")
        
        //判断各个输入框内容是否符合注册条件
        if checkUsrInputIsOK() {
            indicatorShow()
            http.pwdCode(pwd.text, whoAreYou: "ShoppingRegistVC")
        }
    }
    
    
    
    @IBOutlet var agreeProtocolBtn: UIButton!
    @IBAction func agreeProtocolBtnClk(sender: AnyObject) {
        if agreeProtocolBtnState{
            agreeProtocolBtn.setBackgroundImage(UIImage(named: "notAgreeBtn"), forState: UIControlState.Normal)
            agreeProtocolBtnState = false
        }else{
            agreeProtocolBtn.setBackgroundImage(UIImage(named: "agreeBtn"), forState: UIControlState.Normal)
            agreeProtocolBtnState = true
        }
    }
    @IBOutlet var selectedAddress: UITextField!
    @IBOutlet var rePwd: UITextField!
    @IBOutlet var pwd: UITextField!
    @IBOutlet var verify: UITextField!
    @IBOutlet var tel: UITextField!
    @IBOutlet var usr: UITextField!
    //背景触摸放弃所有输入的响应
    @IBAction func backgroundViewClk(sender: AnyObject) {
        resignAllSubViewFirstResponder()
    }
    @IBOutlet var backgroundView: UIControl!
    @IBOutlet var detailAddress: UITextField!
    
    
    //获取验证码按钮
    @IBOutlet var verifyBtn: UIButton!
    @IBAction func verifyBtnClk(sender: UIButton) {
        if tel.text.length == 11 {
            http.getVerifyCode(tel.text)
            //禁止用户交互
            //self.view.userInteractionEnabled = false
            indicatorShow()
            
        }else{
            alart = UIAlertView(title: "提示", message: "电话号码输入有误", delegate: nil, cancelButtonTitle: "确定")
            alart!.show()
        }
    }
    @IBOutlet var addressPickerView: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏addressPickerView
        addressPickerView.hidden = true
        indicatorBackView.hidden = true
        pickerViewMissBtn.hidden = true
        
        addressPickerView.delegate = self
        addressPickerView.dataSource = self
        
        addAllSubViewDelegate()
        
        setSubViewBorder()
        self.navigationItem.title = roleName + "注册"
        
        notificationAddObserver()
    }

    func addAllSubViewDelegate(){
        selectedAddress.delegate = self
        rePwd.delegate = self
        pwd.delegate = self
        verify.delegate = self
        tel.delegate = self
        usr.delegate = self
        detailAddress.delegate = self
        shopoingClass.delegate = self
        
    }
    
    //通知接收添加
    func notificationAddObserver(){
        //添加通知监测
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("verifyCodePrecess:"), name: "verifyCode", object: nil)
        
        //keyBoardShow
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: "UIKeyboardDidShowNotification", object: nil)
        
        //keyBoardDismiss
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: "UIKeyboardWillHideNotification", object: nil)
        //registAddressReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("registAddressReqProcess:"), name: "registAddressReq", object: nil)
        
        //haveGetPwdCode
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("haveGetPwdCodeProcess:"), name: "haveGetPwdCodeShoppingRegistVC", object: nil)
        
        //manageRoleRegistReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("manageRoleRegistReqProcess:"), name: "manageRoleRegistReq", object: nil)
        //shoppingClassReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("shoppingClassReqProcess:"), name: "shoppingClassReq", object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //设置子视图边框
    func setSubViewBorder(){
//        detailAddress.layer.masksToBounds = true
//        detailAddress.layer.borderWidth = 1
//        detailAddress.layer.cornerRadius = 5
//        detailAddress.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
//        detailAddress.text = "请输入详细地址"
        
        verifyBtn.layer.masksToBounds = true
        verifyBtn.layer.borderWidth = 1
        verifyBtn.layer.cornerRadius = 5
        verifyBtn.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
        indicatorBackView.layer.masksToBounds = true
        indicatorBackView.layer.borderWidth = 1
        indicatorBackView.layer.cornerRadius = 10
        indicatorBackView.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
    }
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

extension ShoppingRegistVC{
    //MARK Indicator
    func indicatorNotShow(){
        indicatorBackView.hidden = true
        indicator.stopAnimating()
    }
    
    func indicatorShow(){
        
        indicatorBackView.hidden = false
        indicator.startAnimating()
        
    }
    
    //MARK --addressPickerViewShow
    func addressPickerViewShow(){
        addressPickerView.hidden = false
        pickerViewMissBtn.hidden = false
        //selectedAddress.text = ""
    }
    
    func addressPickerViewNotShow(){
        addressPickerView.hidden = true
        pickerViewMissBtn.hidden = true
    }
    
    //检测用户输入信息是否符合要求
    func checkUsrInputIsOK()->Bool{
        if usr.text.isEmpty {
            var alart = UIAlertView(title: "提示", message: "用户名不能为空", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        if tel.text.isEmpty {
            var alart = UIAlertView(title: "提示", message: "手机号不能为空", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if tel.text.length != 11 {
            var alart = UIAlertView(title: "提示", message: "手机号位数不对", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if verify.text.isEmpty {
            var alart = UIAlertView(title: "提示", message: "验证码不能为空", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if verify.text != manageRoleRegistInfo.verifyCode {
            var alart = UIAlertView(title: "提示", message: "验证码输入错误,请重新输入或获取", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        if pwd.text.length < 6 {
            var alart = UIAlertView(title: "提示", message: "密码不能少于6位,请重新输入", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if rePwd.text.length < 6 {
            var alart = UIAlertView(title: "提示", message: "密码不能少于6位,请重新输入", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        if (pwd.text != rePwd.text) {
            var alart = UIAlertView(title: "提示", message: "两次密码输入不一致,请核对后重新输入", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if selectedAddress.text.length < 1 {
            var alart = UIAlertView(title: "提示", message: "地址未输入,请重新输入", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        
        
        if detailAddress.text.length < 1 {
            var alart = UIAlertView(title: "提示", message: "未填写详细地址,请重新填写", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if !(agreeProtocolBtnState) {
            var alart = UIAlertView(title: "提示", message: "必须同意我平台相关协议才能够继续注册", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        if shopoingClass.text.length < 1 {
            var alart = UIAlertView(title: "提示", message: "未填写商店类别,请重新填写", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            return false
        }
        
        return true
    }
    
    //所有子控件放弃第一响应者
    func  resignAllSubViewFirstResponder()  {
        shopoingClass.resignFirstResponder()
        selectedAddress.resignFirstResponder()
        rePwd.resignFirstResponder()
        pwd.resignFirstResponder()
        verify.resignFirstResponder()
        tel.resignFirstResponder()
        usr.resignFirstResponder()
        detailAddress.resignFirstResponder()
        addressPickerViewNotShow()
        //调整frame
        if view.frame.minY != 0{
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.view.frame = CGRectMake(0.0, 0, self.view.frame.size.width, self.view.frame.size.height)
            })
            
        }
        
        
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        if flagPickerBelongTo == true{
           return 3
        }else{
           return 1
        }
        
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if flagPickerBelongTo == true{
            if provinceArry.count > 0 {
                if (0 == component)
                {
                    return provinceArry.count//省级数量
                }
                if (1 == component) {//市级数量
                    //查看第一列选择的是什么
                    
                    var rowProvince = pickerView.selectedRowInComponent(0)
                    var provinceName = provinceArry[rowProvince]
                    
                    if let returnCitys:[String] = citys[provinceName]{
                        return returnCitys.count
                    }else{
                        return 0
                    }
                    
                    
                }else{//区级数量
                    
                    var rowProvince = pickerView.selectedRowInComponent(0)
                    var provinceName = provinceArry[rowProvince] //省
                    
                    if let returnCitys:[String] = citys[provinceName]{  //市
                        //市
                        var rowCity = pickerView.selectedRowInComponent(1)
                        var cityName = returnCitys[rowCity]
                        
                        //县
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

        }else{
           return shoppingClassArry.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if flagPickerBelongTo == true{
            if (0 == component) {
                return provinceArry[row];
            }
            if(1 == component){
                var rowProvince =  pickerView.selectedRowInComponent(0);
                var  provinceName =  provinceArry[rowProvince];
                if let  citysTemp:[String] = citys[provinceName]{
                    return citysTemp[row];
                }
                return "错误"
            }else{
                var rowProvince =  pickerView.selectedRowInComponent(0)
                var  provinceName = provinceArry[rowProvince];
                var  citysTemp:[String] = citys[provinceName]!;
                var rowCity = pickerView.selectedRowInComponent(1)
                var  cityName = citysTemp[rowCity];
                if let  country:[String] = countries[cityName]{
                    return country[row]
                }
                return "错误"
                
            }

        }else{
            return shoppingClassArry[row].name
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if flagPickerBelongTo == true{
            var usrSelectedAddress = ""
            
            if(0 == component){
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
                NSLog("省份选择是：\(provinceArry[row])")
                usrSelectedAddress = trimLineString(provinceArry[row])
            }
            if( 1 == component ){
                pickerView.reloadComponent(2)
                var rowOne:Int = pickerView.selectedRowInComponent(0)
                var rowTow:Int = pickerView.selectedRowInComponent(1)
                var rowThree:Int = pickerView.selectedRowInComponent(2)
                var  provinceName:String = provinceArry[rowOne]
                
                if let  citysTemp:[String] = citys[provinceName]{
                    var  cityName:String = citysTemp[rowTow]
                    usrSelectedAddress = trimLineString(provinceName) + trimLineString(cityName)
                }else{
                    NSLog("\(provinceArry[rowOne])")
                }
                
                
            }
            
            if (2 == component){
                pickerView.reloadComponent(2)
                var rowOne:Int = pickerView.selectedRowInComponent(0)
                var rowTow:Int = pickerView.selectedRowInComponent(1)
                var rowThree:Int = pickerView.selectedRowInComponent(2)
                var  provinceName:String = provinceArry[rowOne]
                
                if let  citysTemp:[String] = citys[provinceName]{
                    var  cityName:String = citysTemp[rowTow]
                    //NSLog("cityName = \(cityName)")
                    if let  countrys:[String] = countries[cityName]{
                        //NSLog("\(provinceArry[rowOne]), \(citysTemp[rowTow]),\(countrys[rowThree])")
                        manageRoleRegistInfo.areaid = areaID[countrys[rowThree]]!
                        //NSLog("manageRoleRegistInfo.areaid = \(manageRoleRegistInfo.areaid) ")
                        usrSelectedAddress = trimLineString(provinceName) + trimLineString(cityName) + trimLineString(countrys[rowThree])
                    }else{
                        //NSLog("\(provinceArry[rowOne]), \(citysTemp[rowTow])")
                    }
                }else{
                    //NSLog("\(provinceArry[rowOne])")
                }
                
            }
            
            selectedAddress.text = usrSelectedAddress
        }else{
            //商店类别keyid
            manageRoleRegistInfo.sptypeid = shoppingClassArry[row].keyid
            shopoingClass.text = shoppingClassArry[row].name
        }
        
        
    }
    
    
    //区域地址显示数据获取
    func registAddressReqProcess(sender:NSNotification){
        //允许用户交互
        //self.view.userInteractionEnabled = true
        if let haveValue: AnyObject = sender.object{
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

            indicatorNotShow()
            addressPickerView.reloadAllComponents()
            addressPickerViewShow()
            
        }
        
    }
    //获取到验证码返回信息
    func verifyCodePrecess(sender:NSNotification){
        //NSLog("获取到验证码")
        //允许用户交互
        //self.view.userInteractionEnabled = true
        indicatorNotShow()
        
        if let haveValue: AnyObject = sender.object {
            var virifyCodeData = JSON(sender.object!)
            var successCodeFlag = virifyCodeData["result"].stringValue
            
            if successCodeFlag == "100" {
                //存储验证码
                manageRoleRegistInfo.verifyCode = virifyCodeData["data"].stringValue
                NSLog("验证码是：\(manageRoleRegistInfo.verifyCode)")
                
                alart = UIAlertView(title: "提示", message: "验证码已发送至手机\(tel.text)", delegate: nil, cancelButtonTitle: "确定")
                verify.becomeFirstResponder()
            }else{
                alart = UIAlertView(title: "提示", message: "验证码获取失败！", delegate: nil, cancelButtonTitle: "确定")
                
            }
            verifyBtn.setTitle("重新获取验证码", forState: UIControlState.Normal)
            alart!.show()
            
        }
        
        
        
    }
    
    //获取到加密密码
    func haveGetPwdCodeProcess(sender:NSNotification){
        
        indicatorNotShow()
        
        if let haveValue: AnyObject = sender.object{
            manageRoleRegistInfo.shopname = usr.text
            manageRoleRegistInfo.tel = tel.text
            manageRoleRegistInfo.pwd = sender.object!.description
            manageRoleRegistInfo.address = detailAddress.text
            //数据发送，服务器请求
            
            indicatorShow()
            
            NSLog("manageRoleRegistInfo address= \(manageRoleRegistInfo.address),areaid=\(manageRoleRegistInfo.areaid),name=\(manageRoleRegistInfo.name),pic=\(manageRoleRegistInfo.pic),\(manageRoleRegistInfo.pwd),roleid=\(manageRoleRegistInfo.roleid),shopname=\(manageRoleRegistInfo.shopname),sptypeid=\(manageRoleRegistInfo.sptypeid)，tel=\(manageRoleRegistInfo.tel)，verifyCode=\(manageRoleRegistInfo.verifyCode)")
            
            http.manageRoleRegist(manageRoleRegistInfo.pwd, roleid: "1", tel: manageRoleRegistInfo.tel, shopname: manageRoleRegistInfo.shopname, address: manageRoleRegistInfo.address, sptypeid: "1", areaid: manageRoleRegistInfo.areaid, recom_code: "123")
            NSLog("sender.object = \(sender.object)")
        }else{
            //密码验证未获取到数据
            var alart = UIAlertView(title: "提示", message: "网络请求故障,请稍后再试", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
        }
        
    }
    
    //商店注册结果处理
    func manageRoleRegistReqProcess(sender:NSNotification){
        indicatorNotShow()
        NSLog("aresult = \(sender.object)")
        if let haveValue: AnyObject = sender.object {
//            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//                let json = JSON(data: dataFromString)
//            }
            var result =  JSON(sender.object!)
            
            if "100" == result["result"].stringValue {
                var alart = UIAlertView(title: "提示", message: "恭喜！注册成功", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else if "101" == result["result"].stringValue {
                var alart = UIAlertView(title: "提示", message: "注册失败!!!", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else if "10002" == result["result"].stringValue{
                var alart = UIAlertView(title: "提示", message: "参数错误", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else if "10003" == result["result"].stringValue{
                var alart = UIAlertView(title: "提示", message: "该手机号已经被注册过,请返回登录页面进行登录！", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else{
                var alart = UIAlertView(title: "提示", message: "未知错误", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            
        }
    }
    
    
    
    
    //商店类别
    func shoppingClassReqProcess(sender:NSNotification){
        //允许用户交互
        //self.view.userInteractionEnabled = true
       indicatorNotShow()
        if let haveValue: AnyObject = sender.object{
            
            var data = NSNotificationToJSON(sender)
            NSLog("data = \(data)")
            
            NSLog("\(JSON(sender.object!))")
            var result =  JSON(sender.object!)
            
            if "100" == result["result"].stringValue {
                
                var data = result["data"]
                var shoppingClass = ShoppingClass()
                shoppingClassArry = []//[ShoppingClass]()
                for (var cnt = 0 ; cnt < data.count ; cnt++ ){
                    var dataTemp = data[cnt]
                    shoppingClass.display = dataTemp["display"].stringValue
                    shoppingClass.keyid = dataTemp["keyid"].stringValue
                    shoppingClass.name = dataTemp["name"].stringValue
                    shoppingClassArry.append(shoppingClass)
                    NSLog("data = \(data[cnt])")
                    
                }
                NSLog("shoppingClassArry = \(shoppingClassArry)")
                addressPickerView.reloadAllComponents()
                addressPickerViewShow()
                
            }else if "101" == result["result"].stringValue {
                var alart = UIAlertView(title: "提示", message: "商店类别获取失败!!!", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else if "1002" == result["result"].stringValue{
                var alart = UIAlertView(title: "提示", message: "参数错误", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }else{
                var alart = UIAlertView(title: "提示", message: "请求无数据", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
  
        }
    }
    
    //MARK  -- 键盘任务
    //键盘任务
    func keyboardWasShown(aNotification:NSNotification){
        var info:NSDictionary =  aNotification.userInfo!
        var kbSize:CGSize  = info.objectForKey("UIKeyboardFrameBeginUserInfoKey")!.CGRectValue().size
        
        //判断当前响应者是谁
        if selectedAddress.isFirstResponder(){
            selectedAddress.resignFirstResponder()//退第一响应者，关闭键盘
            self.view.bringSubviewToFront(addressPickerView)
        }
        
        if shopoingClass.isFirstResponder(){
            self.view.bringSubviewToFront(addressPickerView)
            shopoingClass.resignFirstResponder()//退第一响应者，关闭键盘
        }
//        if pwd.isFirstResponder(){
//            if( pwd.frame.maxY > (UIScreen.mainScreen().bounds.height - kbSize.height)){
//                //bottomView.center.y = pwd.frame.maxY - (UIScreen.mainScreen().bounds.height - kbSize.height)
//            }
//        }
//        if detailAddress.isFirstResponder() {
//            if( detailAddress.frame.maxY > (UIScreen.mainScreen().bounds.height - kbSize.height)  - 20 ){
//                UIView.animateWithDuration(0.5, animations: { () -> Void in
//                    self.view.center.y = (UIScreen.mainScreen().bounds.height - kbSize.height) - 130
//                })
//            }  
//        }
        
        
        NSLog("键盘的frame是：\(kbSize)")
        //NSLog("self.bottomBtn.frame是：\(self.bottomBtn.frame)")
        
        
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        //var info:NSDictionary =  aNotification.userInfo!
        //var kbSize:CGSize  = info.objectForKey("UIKeyboardFrameBeginUserInfoKey")!.CGRectValue().size
        
        //self.view.center.y = UIScreen.mainScreen().bounds.height/2
    }
    
    //textField任务
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAllSubViewFirstResponder()
        return true
    }
    
    //进入第一响应者
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == selectedAddress{
            flagPickerBelongTo = true //标记当前picker属于区域数据展示
            indicatorShow()
            clearProvinceCityCountry()
            //addressPickerViewShow()
            http.registAddress()
            //禁止用户交互
            //self.view.userInteractionEnabled = false
        }
        
        if textField == shopoingClass{
            flagPickerBelongTo = false //标记当前picker属于商店类别数据展示
            NSLog("商店类别选择")
            indicatorShow()
            shopoingClass.text = ""
            //addressPickerViewShow()
            http.getShoppingClass()
            //禁止用户交互
            //self.view.userInteractionEnabled = false
        }
    }
    
    //清空省市县数据,区域ID
    func clearProvinceCityCountry(){
        self.provinceArry = []
        self.citys = [String:[String]]()
        self.countries = [String:[String]]()
        self.areaID = [String:String]()
    }
    
    //移除空字符和回车字符
    func trimLineString(str:String)->String{
        var nowStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return nowStr
    }
}
