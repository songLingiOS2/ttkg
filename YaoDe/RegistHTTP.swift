//
//  roleid
//  kuaixiaopin
//
//  Created by iosnull on 15/8/10.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



var   serverUrl  =  serversBaseURL

//网络请求
class RegistHTTP {
    static let sharedInstance = RegistHTTP()
    private init() {
    }
    
    //注册区域地址选择http://111.85.254.82:82/fp/area/getallareas?format=normal
    func registAddress(){
        let registAddressUrl = serverUrl + "/area/get?"
        
        if netIsavalaible {
        
        Alamofire.request(.GET,registAddressUrl,parameters: nil).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil{
                self.httpReqError()
                
            }
            NSNotificationCenter.defaultCenter().postNotificationName("registAddressReq", object: data, userInfo: nil)
            
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    
    func httpReqError(){
        var alart = UIAlertView(title: "提示", message: "网络未连接!!!", delegate: nil, cancelButtonTitle: "确定")
        alart.show()
    }
    
    
    /**
    注册当前用户可以使用的地址
    */
    func customerSelectArea(){
        let customerSelectAreaUrl = serverUrl + "/area/get?"
        
        if netIsavalaible {
        Alamofire.request(.GET,customerSelectAreaUrl,parameters: nil).responseString { (request, response, data, error) in
            NSNotificationCenter.defaultCenter().postNotificationName("customerSelectAreaReq", object: data, userInfo: nil)
            
            }
        }else{
            netIsEnable("网络不可用")
        }

    }
    
    //2角色列表请求
    func roleInformationReq(){//http://192.168.1.178/role/get
        let getRolesBaseUrl = serverUrl + "/role/get"
        
        
        
        if netIsavalaible {
        Alamofire.request(.GET,getRolesBaseUrl,parameters: nil).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil{
                self.httpReqError()
                
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("roleInformationReq", object: data, userInfo: nil)
            
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    

    
    //获取商店类别
    func getShoppingClass(){
        ///fp/st/getstlist?format=normal&querytype=all
        //http://111.85.254.82:82/fp/st/getstlist?format=normal&querytype=all
        let manageRoleLoginBaseUrl = serverUrl + "/shoptype/get"
        
        if netIsavalaible {
        Alamofire.request(.GET,manageRoleLoginBaseUrl,parameters: nil).responseString{ (request, response, data, error) in
            
            NSLog("data = \(data)")
            
            
            if error != nil {
                var alart = UIAlertView(title: "提示", message: "服务器连接超时", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("shoppingClassReq", object: data)
        }
        }else{
            netIsEnable("网络不可用")
        }
 
    }
    
    /**
    获取验证码
    - parameter telNum: 手机号
    */
    func getVerifyCode(telNum:String){
        let getVerifyCodeBaseUrl = serverUrl + "/utils/sms?"
        let parameters = ["mobile":telNum]
        
        if netIsavalaible {
        Alamofire.request(.GET,getVerifyCodeBaseUrl,parameters: parameters).responseString { (request, response, data, error) in
            NSLog("error = \(error)")
            NSLog("data = \(data)")
            //获取到数据
            NSNotificationCenter.defaultCenter().postNotificationName("verifyCodeReq", object: data, userInfo: nil)  
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    
    /**
    商户角色登陆
    - parameter adminid: 商户身份证
    - parameter pwd:     商户密码
    */
    func manageRoleLogin(#adminid:String,pwd:String){
        let manageRoleLoginBaseUrl = serverUrl + "/member/login"
        //let para = ("adminid":"admin","pwd":"7FEF6171469E80D32C0559F88B377245")
//        let pwd = "7FEF6171469E80D32C0559F88B377245"
        let parameters =  ["adminid" : "\(adminid)"  , "pwd" : "\(pwd)"]
        println("parameters = \(parameters)")
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["admininfo":dataString]
        
        if netIsavalaible {
        
        Alamofire.request(.POST,manageRoleLoginBaseUrl,parameters: para).responseString{ (request, response, data, error) in
                println("request= \(request) \n")
                println("response =\(response)")
            NSNotificationCenter.defaultCenter().postNotificationName("manageRoleLoginReq", object: data)
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    /**
    切换到商店角色
    
    - parameter adminid: adminid description
    - parameter pwd:     pwd description
    */
    func changeToManageer(#adminid:String,pwd:String){
        let manageRoleLoginBaseUrl = serverUrl + "/fp/user/mloginuser?"
        let parameters = ["format": "normal",
            "adminid":adminid,
            "pwd":pwd
        ]
        
        
        
        if netIsavalaible {
        Alamofire.request(.POST,manageRoleLoginBaseUrl,parameters: parameters).responseJSON{ (request, response, data, error) in
            NSNotificationCenter.defaultCenter().postNotificationName("changeToManageerReq", object: data)
        }
            
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    /*
    /**
    //普通用户登陆
    - parameter userid: 用户名
    - parameter pwd:    用户密码
    */
    func customerRoleLogin(#userid:String,pwd:String){
        let customerRoleLoginUrl = serverUrl + "/fp/user/loginuser?"
        let parameters = ["format": "normal","userid":userid,"pwd":pwd]
        Alamofire.request(.POST,customerRoleLoginUrl,parameters: parameters).responseJSON{ (request, response, data, error) in
            NSNotificationCenter.defaultCenter().postNotificationName("customerRoleLoginReq", object: data)
        }
    }
    
    /**
    切换到普通用户
    
    - parameter userid:
    - parameter pwd:
    */
    func changeToCustomer(#userid:String,pwd:String){
        let customerRoleLoginUrl = serverUrl + "/fp/user/loginuser?"
        let parameters = ["format": "normal","userid":userid,"pwd":pwd]
        Alamofire.request(.POST,customerRoleLoginUrl,parameters: parameters).responseJSON{ (request, response, data, error) in
            NSNotificationCenter.defaultCenter().postNotificationName("changeToCustomerReq", object: data)
        }
    }
    
    */
    
    /**
    密码加密
    - parameter pwd: 密码字符串
    */
    func pwdCode(pwd:String,whoAreYou:String){
        //action=setpassword&strpwd=123456
        let pwdCodeBaseUrl = secretBaseURL + "/utils/encrypt"
        let parameters = ["source":pwd]
        
        
        if netIsavalaible {
        Alamofire.request(.GET,pwdCodeBaseUrl,parameters: parameters).responseString{ (request, response, data, error) in

            NSNotificationCenter.defaultCenter().postNotificationName("haveGetPwdCode" + whoAreYou, object: data)
            }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    //零售---商店注册
    func manageRoleRegist(pwd:String,roleid:String,tel:String,shopname:String,address:String,sptypeid:String,areaid:String,recom_code:String){
        let manageRoleRegistBaseUrl = serverUrl + "/member/register"
        let parameters = [
            
            "recommendcode":recom_code,//推荐码
            "pwd":pwd,//密码
            "roleid":roleid,//商家角色ID
            "tel":tel,//商家注册电话
            "shopname":shopname,//商家店铺名称
            "address":address,//商铺地址
            "sptypeid":sptypeid,//商家类别 ID
            "areaid":areaid//所属区域 ID(
        ]
        
        NSLog("参数为\(parameters)")
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["admininfo":dataString]
        
        
        if netIsavalaible {
        
        Alamofire.request(.POST,manageRoleRegistBaseUrl,parameters: para).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil{
                self.httpReqError()
                
            }
            NSLog("request = \(request)")
            NSLog("manageRoleRegistBaseUrldata = \(data)")

        NSNotificationCenter.defaultCenter().postNotificationName("manageRoleRegistReq", object: data, userInfo: nil)
            
        }
        }else{
            netIsEnable("网络不可用")
        }

    }
    //注册配送商
    func managePeiSongRoleRegist(pwd:String,roleid:String,tel:String,shopname:String,address:String,sptypeid:String,areaid:String,recom_code:String){
        let manageRoleRegistBaseUrl = serverUrl + "/member/register"
        let parameters = [
            "recommendcode":recom_code,//推荐码
            "pwd":pwd,//密码
            "roleid":roleid,//配送商角色ID
            "tel":tel,//配送商注册电话
            "shopname":shopname,//配送商名称
            "address":address,//配送商地址
            "sptypeid":sptypeid,//配送商类别 ID
            "areaid":areaid//配送商所属区域 ID(
        ]
        
        
        
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["admininfo":dataString]
        
        
        
        
        if netIsavalaible {
        Alamofire.request(.POST,manageRoleRegistBaseUrl,parameters: para).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil{
                self.httpReqError()
                
            }
            NSLog("request = \(request)")
            NSLog("manageRoleRegistBaseUrldata = \(data)")
            
            NSNotificationCenter.defaultCenter().postNotificationName("peiSongRoleRegistReq", object: data, userInfo: nil)
            
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }

    
    
    
    
    
    
    
    //58.16.130.50:88/fp/user/reguser?format=normal&userid=zhangsan&username=张三&pwd=123456&tel=13312345678&sex=男&address=贵州省贵阳市观山湖区科技大厦&remark=无
    
    //普通消费者进行注册
    func CustomerRoleRegist(#tel:String,pwd:String) {
        let CustomerRoleRegistUrl = serverUrl + "/fp/user/reguser?"
        let parameters = ["format": "normal","userid":tel,"username":"无","pwd":pwd,"tel":tel,"sex":"无","address":"无","remark":"无"]
        
        if netIsavalaible {
        Alamofire.request(.GET,CustomerRoleRegistUrl,parameters: parameters).responseJSON{ (request, response, data, error) in
            NSNotificationCenter.defaultCenter().postNotificationName("customerRoleRegistReq", object: data, userInfo: nil)
        }
            
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    
    
}








