//
//  ZengpinInfoModel.swift
//
//
//  Created by yd on 16/5/12.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

class ZengpinInfoModel: NSObject {
    var success = ""
    var status = ""
    var message = ""
    var data : [ DataSub ] = []
    
    func getData(json:JSON){
        self.success = json["success"].stringValue
        self.status = json["status"].stringValue
        self.message = json["message"].stringValue
        
        if self.success == "true" {
            var dataTemp = json["data"]
            
            for var i = 0 ; i < dataTemp.count ; i++ {
                var dataSub = DataSub()
                var data = dataTemp[i]
                dataSub.GiveMsg = data["GiveMsg"].stringValue
                dataSub.shopName = data["ShopName"].stringValue
                var dataA = data["CartList"]
                for var j = 0 ; j < dataA.count; j++ {
                    var productInfo = ProductInfo()
                    var dataTempA = dataA[j]
                    productInfo.giveMsg = dataTempA["GiveMsg"].stringValue
                    productInfo.productName = dataTempA["ProductName"].stringValue
                    dataSub.cartList.append(productInfo)
                }
                
                self.data.append(dataSub)
            }
            NSLog("self.data==\(self.data.description)")
        }
        
        
        
        
    }
}


struct DataSub {
    var shopName = ""
    var GiveMsg = ""
    var cartList : [ProductInfo] = []
}

struct ProductInfo {
    var productName = ""
    var giveMsg = ""
    
    
}


extension ZengpinInfoModel {
    func returnMerchantHeader(section:Int) ->(String,String){
        let str = self.data[section].shopName + self.data[section].GiveMsg
        NSLog("str = \(str)")
        return (self.data[section].shopName,self.data[section].GiveMsg)
    }
    
    func returnGiftCellInfo(section:NSIndexPath) -> String {
        var str = self.data[section.section].cartList[section.row].productName + ":" + self.data[section.section].cartList[section.row].giveMsg
        //去掉空格
        str = str.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        NSLog("formatterTemp = \(str)")
        return str
    }
    
    
    
}


