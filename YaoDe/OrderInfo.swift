//
//  OrderInfo.swift
//  YaoDe
//
//  Created by iosnull on 15/9/12.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import Foundation

//订单信息
struct OrderInfo {
   var deduct = " "
   var orderno = " "
   var address = " "
   var display = " "
   var creattime = " "
   var postcode = " "
   var payway = " "
   var remark = " "
   var contacttel = " "
   var finishtime = " "
   var money = " "
   var integral = " "
   var iswaybill = " "
   var shopname = " "
   var name = " "
   var shopid = " "
   var status = " "
    
    
   var orderid = " "
    
   var acutualmoney = "" //实际交易价格
    
   /********订单选中标记******/
   var orderSelectedState = false
    
}

//订单下详情商品信息
struct OrderDetail {
   var imgurl = " "
   var keyid = " "
   var num = " "
   var orderno = " "
   var pdid = " "
   var pname = " "
   var price = " "
   var  MerchantPriceID = ""
   var detail_remark = ""//赠送了什么
    
}