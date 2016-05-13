//
//  ShoppingCartProduct.swift
//  YaoDe
//
//  Created by iosnull on 15/9/6.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import Foundation

struct ShoppingCartProduct {
    var shopname = ""
    var imgurl = ""
    var userid = ""
    var usertype = ""
    var creattime = ""
    var isoverdue = ""
    var pdid = ""  //商品ID
    var price = ""
    var keyid = "" //购物车ID
    var shopid = ""
    var stock = ""
    var pdname = ""
    var nums = ""
    
    var ispurchase = "100"//该商品是否被限购  "0" 为限购
    var purchasenum = ""//该商品限购数量
    
    var cartid = "" //购物车ID
    var carryingamount = "" //商店起配条件
    //当前商品在购物车中是否被选中
    var sellSelf = false
}