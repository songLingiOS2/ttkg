//
//  ProductOrder.swift
//  YaoDe
//
//  Created by iosnull on 15/9/14.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import Foundation
import SwiftyJSON

struct OrderBuyInfo{
    var pdid = ""
    var pname = ""
    var price = ""
    var quantity = ""
}

struct ProductOrder {
    var shopid = ""
    var utype = ""
    var uid = ""
    var uname = ""
    var pway = ""
    var address = ""
    var otmoney = ""
    var integral = ""
    var deduct = ""
    var contacttel = ""
    var postcode = ""
    var remark = ""
    var odsdata:[OrderBuyInfo] = [OrderBuyInfo]()
}

















