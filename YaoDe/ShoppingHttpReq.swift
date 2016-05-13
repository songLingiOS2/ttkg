//
//  ShoppingHttpReq.swift
//  YaoDe
//
//  Created by iosnull on 15/8/31.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

class ShoppingHttpReq {
    //单例模式
    static let sharedInstance = ShoppingHttpReq()
    private init() {
    }
    
    
    //获取商店类别
    func getShoppingClass(){
        
        let manageRoleLoginBaseUrl = serverUrl + "/shoptype/get"
        
        if netIsavalaible {
        Alamofire.request(.GET,manageRoleLoginBaseUrl,parameters:  nil).responseString{ (request, response, data, error) in
            
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getShoppingClassReq", object: data)
        }
        }else{
            netIsEnable("网络不可用")
        }
    
    }


    //注册区域地址选择
    func registAddress(){
        let registAddressUrl = serverUrl + "/fp/area/getallareas?"
        let parameters = ["format": "normal"]
        
        if netIsavalaible {
        Alamofire.request(.GET,registAddressUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("shopRegistAddressReq", object: data, userInfo: nil)
            
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    //获取某商家类别下的小类别
    func getShopSubClass(adminkeyid:String,whoAreYou:String){
        //58.16.130.50:88/fp/cg/getcgclistbymcid?format=normal&m_id=80&c_id=6
        let getShopSubClassUrl = serversBaseURL + "/category/member"
        let parameters = ["adminkeyid": adminkeyid]
        
        
        if netIsavalaible {
        
        Alamofire.request(.GET,getShopSubClassUrl,parameters: parameters).responseString { (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getShopSubClassReq" + "\(whoAreYou)", object: data, userInfo: nil)
        }
        
        }else{
            netIsEnable("网络不可用")
        }

    }
    
    
    //获取最近购买过的商品列表
    func getHistoryRecordInfomation(u_id:NSString,usertype:String){
        
        
        var usertypeTemp = ""
        if usertype == "30001" {
            usertypeTemp = "2"
        }else{
            usertypeTemp = "1"
        }
        
        let getHistoryRecordInformationUrl = serversBaseURL + "/fp/pro/getlbt?"
        let parameters = ["format":"normal","u_id":u_id,"usertype":usertypeTemp,"s_row":0,"e_row":30]
        
        
        if netIsavalaible {
        Alamofire.request(.GET,getHistoryRecordInformationUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("购买记录data = \(data)")
            
            NSNotificationCenter.defaultCenter().postNotificationName("getShopListRecordReq", object: data, userInfo: nil)
            
            
            
        }
        
        }else{
        netIsEnable("网络不可用")
        }
    
    }

    //获取最近购买过商品的商家列表
    func getShopHistoryList(u_id:String,usertype:String){
        
        var usertypeTemp = ""
        if usertype == "30001" {
            usertypeTemp = "2"
        }else{
            usertypeTemp = "1"
        }
        
        
        let getShopHistoryListUrl = serversBaseURL + "/fp/user/getlbm?"
        let parameters = ["format":"normal","u_id":u_id,"usertype":usertypeTemp]
        
        if netIsavalaible {
        Alamofire.request(.GET,getShopHistoryListUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("购买的商店记录data = \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("getMerchantListRecordReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }

    
    
    
    //获取某商家产品类别
    func getSomeoneShopProductClass(m_id:String,whoreAreYou:String){
        let getSomeoneShopProductClassUrl = serversBaseURL + "/fp/cg/getcglistbymid?"
        
        let parameters = ["format": "normal","m_id":m_id]
        
        
        if netIsavalaible {
        Alamofire.request(.GET,getSomeoneShopProductClassUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("showgetClassProductReq" + "\(whoreAreYou)", object: data, userInfo: nil)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }



    //获取配送商商家产品列表
    func getPeiSongShoppingProducts(#adminkeyid:String,pagesize:String,currentpage:String,categoryid:String){
        
        let userProductListBaseUrl = serversBaseURL + "/product/member"
        
        let parameters = ["adminkeyid": adminkeyid,
            "pagesize":pagesize,
            "currentpage":currentpage,
            "categoryid":categoryid
        ]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        NSLog("******para=\(userProductListBaseUrl)")
        NSLog("******para=\(para)")
        
        
        if netIsavalaible {
        
        Alamofire.request(.GET,userProductListBaseUrl,parameters: para).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getPeiSongShoppingProductsReq", object: data, userInfo: nil)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    //获取产品列表
    func userProductList(#areaid:String,currentpage:String,pagesize:String,roleid:String){
        //format=normal&r_id=1&s_row=1&e_row=10
        let userProductListBaseUrl = serversBaseURL + "/product/index"
        
        let parameters = ["areaid":areaid,"roleid":roleid,"pagesize":pagesize,"currentpage":currentpage
        ]
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        
        if netIsavalaible {
        Alamofire.request(.GET,userProductListBaseUrl,parameters: para).responseString{ (request, response, data, error) in
            NSLog("request = \(request)")
            
            NSNotificationCenter.defaultCenter().postNotificationName("userProductListReqtt", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
        
        
    }
    
    //获取广告数据
    func getShoppingAdvertisement(r_id:String,areaid:String){
        
        let getShoppingAdvertisementUrl = serversBaseURL + "/alerts/get"
        let parameters = ["roleid":r_id,"areaid":areaid]
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
            Alamofire.request(.GET,getShoppingAdvertisementUrl,parameters: para).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            if error != nil {
                serverIsAvalaible()
            }
            //NSLog("data = \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("getShoppingAdvertisementReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }

    }

    //分类信息显示
    func getClassProduct(parentid:String,whoAreYou:String){
       
        let classProductReqUrl = serversBaseURL + "/category/index"
        
        
        if netIsavalaible {
        Alamofire.request(.GET,classProductReqUrl,parameters: nil).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("data = \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("getClassProductReq\(whoAreYou)", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    //点击更多 按钮  信息显示
    func getMoreClassProduct(#whoAreYou:String){
        
        let classProductReqUrl = serversBaseURL + "/category/get"
        
        
        if netIsavalaible {
        Alamofire.request(.GET,classProductReqUrl,parameters: nil).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("data = \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("getMoreClassProduct\(whoAreYou)", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    //111.85.254.82:82/fp/pro/getpromolist?format=json&params={"a_id":"1","s_row":"1","e_row":"10"}
    //获取商家促销商品
    func getDiscountProduct(roleID:String,startNum:String,toNum:String){
        let getDiscountProductUrl = serversBaseURL + "/fp/pro/getpromolist?"
        let parameters = ["format": "normal","a_id": roleID,"s_row":startNum,"e_row":toNum]
        
        if netIsavalaible {
        Alamofire.request(.GET,getDiscountProductUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("data = \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("getDiscountProductReq", object: data, userInfo: nil)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }


    //获取某一商家信息
    func getSomeOneInformation(#keyID:String){
        
        let gerSomeOneInformationUrl = serversBaseURL + "/fp/user/shopinfo?"
        let parameters = ["format": "normal","shopid": keyID]
        
        if netIsavalaible {
        Alamofire.request(.GET,gerSomeOneInformationUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("data = \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("gerSomeOneInformationReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }

    }
    
    //商品加入购物车
    func addToShoppingCart(#usertype:String,userid:String,shopid:String,pdid:String,price:String,nums:String,imgurl:String,pdname:String,whoAreYou:String){
        
        let addToShoppingCartUrl = serversBaseURL + "/fp/order/addsc?"
        let parameters = ["format": "normal","usertype": usertype,
            "userid":userid,
            "shopid":shopid,
            "pdid":pdid,
            "price":price,
            "nums":nums,
            "imgurl":imgurl,
            "pdname":pdname
        ]
        
        
        
        if netIsavalaible {
        Alamofire.request(.GET,addToShoppingCartUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("addToShoppingCartUrlReq\(whoAreYou)", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    
    }


    //购物车商品数据请求
    func getShoppingCart(#usertype:String,userid:String){
        //fp/order/getsc?format=normal&usertype=1&userid=2
        let getShoppingCartUrl = serversBaseURL + "/shoppingcart/cartlist"
        let parameters = ["usertype": "1","userid":userid]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        
        
        if netIsavalaible {
        Alamofire.request(.GET,getShoppingCartUrl,parameters: para).responseString { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getShoppingCartReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }

    }
    
    
    //移除购物车
    func removeProductFromCart(#scid:String){
        //58.16.130.50:88/fp/order/delsco?format=normal&scid=1
        let removeProductFromCartUrl = serversBaseURL + "/fp/order/delsco?"
        let parameters = ["format": "normal","scid": scid]
        
        if netIsavalaible {
        Alamofire.request(.GET,removeProductFromCartUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("removeProductFromCartReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }


    //修改购物车里商品的数量
    ////58.16.130.50:88/fp/order/usc?format=normal&scid=1&nums=5
    func modifyProductCnt(#scid:String,nums:String){
        let modifyProductCntUrl = serversBaseURL + "/fp/order/usc?"
        let parameters = ["format": "normal","scid": scid,"nums":nums]
        if netIsavalaible {
        Alamofire.request(.GET,modifyProductCntUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("modifyProductCntUrlReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    
    //获取对应产品的所有图片
    func getCurrentProductAllPic(#pdid:String){
        //完整测试URL : http://58.16.130.50:88/fp/img/getimgs?format=normal&pdid=19
        let getCurrentProductAllPicUrl = serversBaseURL + "/fp/img/getimgs?"
        let parameters = ["format": "normal","pdid": pdid]
        
        
        
        if netIsavalaible {
        Alamofire.request(.GET,getCurrentProductAllPicUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getCurrentProductAllPicReq", object: data, userInfo: nil)
        }
        
        }else{
        netIsEnable("网络不可用")
        }

    }



    //添加用户收货地址
    func addUsrPlaceOfReceipt(#name:String,phone:String,sphone:String,area:String,address:String,postcode:String,remark:String,usertype:String,userid:String,isdef:String){
        
        let addUsrPlaceOfReceiptUrl = serversBaseURL + "/address/post"
        let parameters = ["ReceiverName":name,"ReceiverPhoneNo":phone,"ReceiverAddress":address,"PostCode":postcode,"Remark":remark,"StandbyPhoneNo":sphone,"ReceiverArea":area,"UserType":usertype,"UserID":userid,"IsDefault":isdef]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["addressinfo":dataString]
        
        if netIsavalaible {
        Alamofire.request(.POST,addUsrPlaceOfReceiptUrl,parameters: para).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("addUsrPlaceOfReceiptUrlReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    //获取全部收货地址
    func getPlaceOfReceipt(#usertype:String,userid:String,whoAreYou:String){
        
        let getPlaceOfReceiptUrl = serversBaseURL + "/address/list"
        let parameters = ["usertype":usertype,"userid":userid]
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
        Alamofire.request(.GET,getPlaceOfReceiptUrl,parameters: para).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getPlaceOfReceiptReq\(whoAreYou)", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    //删除收货地址
    func deletePlaceOfReceipt(#KeyID:String,UserID:String,whoAreYou:String){
        
        let deletePlaceOfReceiptUrl = serversBaseURL + "/address/delete"
        let parameters = ["KeyID": KeyID,"UserID":UserID]
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["addressinfo":dataString]
        
        
        if netIsavalaible {
        Alamofire.request(.POST,deletePlaceOfReceiptUrl,parameters: para).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("deletePlaceOfReceiptReq\(whoAreYou)", object: data, userInfo: nil)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }

    //设置成默认收货地址
    func placeOfReceiptBeenSetDefault(#KeyID:String,UserID:String,whoAreYou:String){
        
        let placeOfReceiptBeenSetDefaultUrl = serversBaseURL + "/address/default"
        let parameters = ["KeyID":KeyID,"UserID":UserID]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["addressinfo":dataString]
        
        
        if netIsavalaible {
        Alamofire.request(.POST,placeOfReceiptBeenSetDefaultUrl,parameters: para).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("placeOfReceiptBeenSetDefaultUrlReq\(whoAreYou)", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    //修改地址数据
    func modifyPlaceOfReceipt(#name:String,phone:String,address:String,postcode:String,remark:String,sphone:String,area:String,usertype:String,userid:String,KeyID:String,whoAreYou:String){
        
        let modifyPlaceOfReceiptUrl = serversBaseURL + "/address/put"
        let parameters = ["ReceiverName":name,
            "ReceiverPhoneNo":phone,"ReceiverAddress":address,"PostCode":postcode,"Remark":remark,"StandbyPhoneNo":sphone,"ReceiverArea":area,
            "UserType":usertype,"UserID":userid,"KeyID":KeyID]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["addressinfo":dataString]
        
        if netIsavalaible {
        Alamofire.request(.POST,modifyPlaceOfReceiptUrl,parameters: para).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("modifyPlaceOfReceiptReq\(whoAreYou)", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }

    /****************************************************************************************************************/
    
    //获取商家列表
    func getMerchantList(#roleid:String,areaid:String,pagesize:String,currentpage:String){
        //58.16.130.50:88/fp/user/getdbl?format=normal&roleid=7&areaid=5&s_row=1&e_row=10
        let getMerchantListUrl = serversBaseURL + "/member/get"
        let parameters = ["roleid":roleid,"areaid":areaid,"pagesize":pagesize,"currentpage":currentpage]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        
        if netIsavalaible {
        Alamofire.request(.GET,getMerchantListUrl,parameters: para).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getMerchantListReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    /*****************************************************************************************************************/
    //根据分类获取商品
    func getClassProducData(#roleid:String,pagesize:String,currentpage:String,categoryid:String,areaid:String){
        //58.16.130.50:88/fp/pro/getppalistbc?format=normal&r_id=1&c_id=6&s_row=1&e_row=8&areaid=2
        
            let getClassProducDataUrl = serversBaseURL + "/product/get"
            let parameters = ["roleid":roleid,"pagesize":pagesize,"currentpage":currentpage,"categoryid":categoryid,"areaid":areaid]
            let data = JSON(parameters)
            let dataString = data.description
            let para = ["filter":dataString]
        
        
        if netIsavalaible {
            Alamofire.request(.GET,getClassProducDataUrl,parameters: para).responseString{ (request, response, data, error) in
                
                if error != nil {
                    serverIsAvalaible()
                }
                NSNotificationCenter.defaultCenter().postNotificationName("getClassProducDataReq", object: data, userInfo: nil)
            }
            }else{
                netIsEnable("网络不可用")
            }
    
    }

    /***************************************************************************************************************/
    //根据关键字获取内容
    func getProductAccordingToKeyValue(#areaid:String,roleid:String,pagesize:String,currentpage:String,keywords:String){
        //58.16.130.50:88/fp/pro/getppalistbc?format=normal&r_id=1&c_id=6&s_row=1&e_row=8&areaid=2
        
        let getProductAccordingToKeyValueUrl = serversBaseURL + "/product/search"
        let parameters = ["areaid":areaid,"roleid":roleid,"pagesize":pagesize,"currentpage":currentpage,"keywords":keywords]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
        Alamofire.request(.GET,getProductAccordingToKeyValueUrl,parameters: para).responseString { (request, response, data, error) in
            
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getProductAccordingToKeyValueReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    /**
    根据商家ID和关键字搜索商品
    */
    func getProductAccordingToShopIdAndKeyValue(adminkeyid:String,roleid:String,pagesize:String,currentpage:String,keywords:String){
        //58.16.130.50:88/fp/pro/searchprokm?format=normal&m_id=24&key=酒&s_row=0&e_row=10
        let getProductAccordingToShopIdAndKeyValueURL = serversBaseURL + "/product/searchmember"
        let parameters = [
            "adminkeyid":adminkeyid,
            "roleid":roleid,
            "pagesize":pagesize,
            "currentpage":currentpage,
            "keywords":keywords
        ]
        
        NSLog("parameters= \(parameters)")
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
        Alamofire.request(.GET,getProductAccordingToShopIdAndKeyValueURL,parameters: para).responseString{ (request, response, data, error) in
            
            if error != nil {
                serverIsAvalaible()
            }
        NSNotificationCenter.defaultCenter().postNotificationName("getProductAccordingToKeyValueReq", object: data, userInfo: nil)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }


    /***************************************************************************************************************/
    //获取全部订单
    func getAllOrderInfo(#usertype:String,payway:String,userid:String,IsWaybill:String,status:String,CurrentPage:String,PageSize:String){
        let getAllOrderInfoUrl = serversBaseURL + "/orders/list"
        
        //let parameters = ["payway": payway,"usertype":usertype,"userid":userid,"IsWaybill":IsWaybill,"status":status, "PageSize":PageSize,"CurrentPage":CurrentPage]
        let parameters = ["usertype":"1","userid":userid,"payway":payway,"IsWaybill":IsWaybill,"status":status,"PageSize":PageSize,"CurrentPage":CurrentPage]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
        Alamofire.request(.GET,getAllOrderInfoUrl,parameters: para).responseString{ (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getAllOrderInfoReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    //已签收
    func getConfirmOrderInfo(#usertype:String,userid:String,orderno:String){
        //58.16.130.50:88/fp/order/allolist?format=normal&usertype=1&userid=2&startrow=0&endrow=10
        
        
        
        let getAllOrderInfoUrl = serversBaseURL + "/orders/conform"
        let parameters = ["orderno": orderno,"usertype":"1","userid":userid]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["orderinfo":dataString]
        
        if netIsavalaible {
        Alamofire.request(.GET,getAllOrderInfoUrl,parameters: para).responseString { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getConfirmOrderInfo", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }



    //获取待付款订单
    func getWaitToPayOrderInfo(#usertype:String,userid:String,startrow:String,endrow:String){
        //58.16.130.50:88/fp/order/allolist?format=normal&usertype=1&userid=2&startrow=0&endrow=10
        var usertypeTemp = ""
        if usertype == "30001" {
            
            usertypeTemp = "2"
        }else{
            usertypeTemp = "1"
        }
        
        
        let getWaitToPayOrderInfoUrl = serversBaseURL + "/fp/order/wpolist?"
        let parameters = ["format": "normal","usertype":usertypeTemp,"userid":userid,"startrow":startrow,"endrow":endrow]
        
        if netIsavalaible {
        Alamofire.request(.GET,getWaitToPayOrderInfoUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getWaitToPayOrderInfoReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }

    
    //代发货
    func getWaitToDeliverOrderInfo(#usertype:String,userid:String,startrow:String,endrow:String){
        //58.16.130.50:88/fp/order/allolist?format=normal&usertype=1&userid=2&startrow=0&endrow=10
        var usertypeTemp = ""
        if usertype == "30001" {
            
            usertypeTemp = "2"
        }else{
            usertypeTemp = "1"
        }
        
        
        let getWaitToDeliverOrderInfoUrl = serversBaseURL + "/fp/order/woolist?"
        let parameters = ["format": "normal","usertype":usertypeTemp,"userid":userid,"startrow":startrow,"endrow":endrow]
        
        if netIsavalaible {
        Alamofire.request(.GET,getWaitToDeliverOrderInfoUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getWaitToDeliverOrderInfoReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }

    //待签收
    func getWaitToSignInOrderInfo(#usertype:String,userid:String,startrow:String,endrow:String){
        //58.16.130.50:88/fp/order/allolist?format=normal&usertype=1&userid=2&startrow=0&endrow=10
        var usertypeTemp = ""
        if usertype == "30001" {
            
            usertypeTemp = "2"
        }else{
            usertypeTemp = "1"
        }
        
        
        let getWaitToDeliverOrderInfoUrl = serversBaseURL + "/fp/order/wsolist?"
        let parameters = ["format": "normal","usertype":usertypeTemp,"userid":userid,"startrow":startrow,"endrow":endrow]
        
        if netIsavalaible {
        Alamofire.request(.GET,getWaitToDeliverOrderInfoUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("getWaitToSignInOrderInfoReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }

    //取消订单
    func cancelOrder(#orderno:String){
        //58.16.130.50:88/fp/order/cancelorder?format=normal&orderno=20150817151431688
        
        let cancelOrderUrl = serversBaseURL + "/fp/order/cancelorder?"
        let parameters = ["format": "normal","orderno":orderno]
        if netIsavalaible {
        Alamofire.request(.GET,cancelOrderUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("cancelOrderReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }

    }

    //删除订单
    func deleteOrder(#orderno:String){
        //58.16.130.50:88/fp/order/ldelorder?format=normal&orderno=20150817151431688
        let deleteOrderUrl = serversBaseURL + "/fp/order/ldelorder?"
        let parameters = ["format": "normal","orderno":orderno]
        
        if netIsavalaible {
        
        Alamofire.request(.GET,deleteOrderUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("deleteOrderReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
   //用户密码修改
    func modifySecret(#utype:String,oldpwd:String,newpwd:String,uname:String){
        //58.16.130.50:88/fp/user/upwd?format=normal&utype=30001&oldpwd=123456&newpwd=12345678&uname=zhangsan
        let modifySecretUrl = serversBaseURL + "/fp/user/upwd?"
        let parameters = ["format": "normal","utype":utype,"oldpwd":oldpwd,"newpwd":newpwd,"uname":uname]
        
        
        if netIsavalaible {
        Alamofire.request(.GET,modifySecretUrl,parameters: parameters).responseJSON { (request, response, data, error) in
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("modifySecretReq", object: data, userInfo: nil)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }

    //密码加密
    func pwdCode(pwd:String,whoAreYou:String){
        //action=setpassword&strpwd=123456
        let pwdCodeBaseUrl = secretBaseURL + "/sys/ashx/app.ashx?"
        let parameters = ["action": "setpassword","strpwd":pwd]
        
        if netIsavalaible {
        Alamofire.request(.POST,pwdCodeBaseUrl,parameters: parameters).responseString{ (request, response, data, error) in
            
            if error != nil {
                serverIsAvalaible()
            }
            
            NSLog("登录密码加密后是：\(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("haveGetPwdCodeReq\(whoAreYou)", object: data)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    //用户修改密码
    func usrModifyPwd(#utype:String,oldpwd:String,newpwd:String,uname:String){
        //58.16.130.50:88/fp/user/upwd?format=normal&utype=30001&oldpwd=123456&newpwd=12345678&uname=zhangsan
        let usrModifyPwdUrl = serversBaseURL + "/fp/user/upwd?"
        let parameters = ["format": "normal","utype":utype,"oldpwd":oldpwd,"newpwd":newpwd,"uname":uname]
        
        if netIsavalaible {
        Alamofire.request(.POST,usrModifyPwdUrl,parameters: parameters).responseJSON{ (request, response, data, error) in
            NSLog("request = \(request)")
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("usrModifyPwdReq", object: data)
        }
        }else{
        netIsEnable("网络不可用")
        }
    }


    //用户下单
    func  usrOrder(#order:[JSON] ,whoAreYou:String){
        //58.16.130.50:88/fp/order/addorder?format=normal&order
        
        var orderTemp = order.description
        
        let parameters = [ "format": "normal" ,"order": orderTemp]
        
        
        let usrOrderUrl:String = serversBaseURL + "/fp/order/addorder?"
        
        NSLog("parameters = \(parameters)")
        
        if netIsavalaible {
        
        Alamofire.request(.POST,usrOrderUrl,parameters: parameters).responseJSON{ (request,response, data, error) in
            
            if error != nil {
                serverIsAvalaible()
            }
            
            NSLog("error= \(error)")
//            
            //NSLog("request = \(request)")
//            
            NSLog("data= \(data)")
//            NSLog("response= \(response)")
            
            NSNotificationCenter.defaultCenter().postNotificationName("usrOrderReq\(whoAreYou)", object: data)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    
    
    
    
    
  //保存用户信息
    func reSaveUsrInfo(#admin:String,uname:String,tel:String,contact:String,address:String,intro:String){
        //"aid":"admin","uname":"管理员","tel":"13312345678","contact":"0851-85243688","address":"贵州省贵阳市云岩区新添大道北段158号幸福大厦8楼","intro":"简介暂无"}

        let parameters = [ "format": "normal","aid": admin ,"uname": uname,"tel":tel,"contact":contact,"address":address,"intro":intro]
        let reSaveUsrInfoUrl:String = serversBaseURL + "/fp/user/uminfo?"
        if netIsavalaible {
        Alamofire.request(.GET,reSaveUsrInfoUrl,parameters: parameters).responseJSON{ (_, _, data, error) in
            
            if error != nil {
                serverIsAvalaible()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("reSaveUsrInfoReq", object: data)
        }
        }else{
        netIsEnable("网络不可用")
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
        Alamofire.request(.GET,getProductInfoFromBarCodeUrl,parameters: para).responseString{ (_, _, data, error) in
            
            if error != nil {
                serverIsAvalaible()
            }
            NSLog("data = \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("getProductInfoFromBarCodeReq", object: data)
        }
            
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    
    /**
    确认用户手机号正确
    
    - parameter whoAreYou: whoAreYou description
    - parameter usr:       usr description
    - parameter roleType:  roleType description
    */
    func verifyTelBeforeChangePwd(whoAreYou:String,usr:String,roleType:String){
        let parameters = ["adminid":usr ,"usertype":roleType]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["admininfo":dataString]
        let verifyTelBeforeChangePwdUrl:String = serversBaseURL + "/fp/user/rpcm?"
        
        if netIsavalaible {
        
        Alamofire.request(.GET,verifyTelBeforeChangePwdUrl,parameters: parameters).responseString{ (request, _, data, error) in
            NSLog("data = \(data)")
            NSLog("request = \(request)")
            NSNotificationCenter.defaultCenter().postNotificationName("\(whoAreYou)", object: data)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    
    /**
    获取验证码
    
    - parameter whoAreYou: whoAreYou description
    - parameter usr:       usr description
    - parameter roleType:  roleType description
    */
    func getVerifyCode(whoAreYou:String,usr:String){
        
        let parameters = ["mobile":usr]
        
        let getVerifyCodeUrl:String = serversBaseURL + "/utils/sms"
        
        if netIsavalaible {
        Alamofire.request(.GET,getVerifyCodeUrl,parameters: parameters).responseString{ (request, _, data, error) in
            NSLog("data = \(data)")
            NSLog("request = \(request)")
            NSNotificationCenter.defaultCenter().postNotificationName("\(whoAreYou)", object: data)
        }
        }else{
        netIsEnable("网络不可用")
        }
    }


    /**
    重置密码
    
    - parameter whoAreYou: 通知名
    - parameter phone:     电话号码
    - parameter password:  密码
    */
    func changePwd(whoAreYou:String,phone:String,password:String){
        let getVerifyCodeUrl:String = serversBaseURL + "/member/reset"
        let parameters = [ "phone":phone ,"password":password]
        
        
        if netIsavalaible {
        Alamofire.request(.POST,getVerifyCodeUrl,parameters: parameters).responseString{ (request, _, data, error) in
            NSLog("data = \(data)")
            NSLog("request = \(request)")
            NSNotificationCenter.defaultCenter().postNotificationName("\(whoAreYou)", object: data)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    /**
    加密密码
    
    - parameter pwd: pwd description
    */
    func secretPwd(pwd:String){
        //action=setpassword&strpwd=123456
        let pwdCodeBaseUrl = secretBaseURL + "/utils/encrypt"
        let parameters = ["source":pwd]
        
        if netIsavalaible {
        Alamofire.request(.GET,pwdCodeBaseUrl,parameters: parameters).responseString{ (request, response, data, error) in
            NSLog("\(request)")
            NSLog("加密后是:\(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("secretPwd", object: data)
        }
        }else{
            netIsEnable("网络不可用")
        }
    }


    /**
    从服务器获取iOS最新版本号
    */
    func iOSVersion(){
        
        var appVeision: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        NSLog("appVeision=\(appVeision)")
        
        let getAppVersionUrl = "https://app.ttkg365.com/appInformation/check?version=\(appVeision)&type=4"
        if netIsavalaible {
            
        Alamofire.request(.GET,getAppVersionUrl).responseString{ (request, response, data, error) in
            NSLog("request =\(request)")
            NSNotificationCenter.defaultCenter().postNotificationName("iOSVersion", object: data)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    /**
    *获取支付方式
    */
    func paymentWay(){
        let paymentWayUrl = serversBaseURL + "/config/get"
        
        if netIsavalaible {
        Alamofire.request(.GET,paymentWayUrl,parameters: nil).responseString{ (request, response, data, error) in
            NSLog("\(request)")
            NSLog("支付方式 == \(data)")
            NSNotificationCenter.defaultCenter().postNotificationName("paymentWayReq", object: data)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
    }

}