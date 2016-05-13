//
//  Product.swift
//  kuaixiaopin
//
//  Created by iosnull on 15/8/16.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

struct  Product {
    //图片
    var  img_url = ""
    //是否促销活动   0促销/1非促销 
    var  p_promotion = ""
    //总销量
    var  p_salesvolume = ""
    //是否可以购买 （0可以/1不可以）
    var  p_shelves = ""
    //产品标题（名称）
    var  p_title = ""
    //产品详细中的关联产品ID
    var  pd_pid = ""
    //产品详情介绍
    var  pd_descript = ""
    //库存量
    var  pd_stock = ""
    //具体产品的销量
    var  pd_salesvolume = ""
    //商铺名称
    var  shop_name = ""
    //商家联系方式
    var  shop_contact = ""
    //商家详情简介
    var  shop_introduce = ""
    //商品价格
    var pd_price = ""
    //产品促销价格
    var pd_ptprice = ""
    
    //产品详细ID
    var pd_keyid = ""
    //HTML
    var pd_discript = ""
    //商品单位
    var pd_spec = ""
    
    //产品所属商家ID
    var p_adminid = ""
    
    //商品单日限购量
    var pd_purchasenum = "100"
    //0表示该商品存在限购
    var pd_ispurchase = "10" //默认该值不限购
    
    var pd_conditionnums = ""//买的件数（条件）单位填：件）
    var pd_givingnums = "" //获得的数量（单位不用填）
    var pd_givingproduct = ""  //赠品名称
    
    
    //以下变量为自己添加，方便计算和统计
    //扩展标识符(是否被加入了购物车)
    var haveBeenClk = false
    var nums = "1"//打算购买此商品的数量
    
    
    var c_id = "" //判断是不是一元购可以使用它
    
    
    
    
    
    //2016-5-5
    var IsGivestate = "" //赠送状态（0：开启，1：关闭）
    
    
    
    
}
