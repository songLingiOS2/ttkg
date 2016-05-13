//
//  PlaceOfReceipt.swift
//  YaoDe
//
//  Created by iosnull on 15/9/9.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import Foundation

//收货地址
struct PlaceOfReceipt {

    
    var name = ""
    var phone = ""
    var sphone = ""
    var address = ""
    var postcode = ""
    var remark = ""
    var area = ""
    var usertype = ""
    var userid = ""
    
    var isdefault = "0"//为1是默认收货地址
    var IsAuditStatus = "" //是否审核收货地址
    
    var haveDefaultAddress = false
    
    /*****************************/
    //收货地址Id
    var keyid = ""
    
    //当前地址正在进行编辑修改
    var isEditing = false
}