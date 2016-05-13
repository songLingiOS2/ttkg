//
//  RoleClass.swift
//  YaoDe
//
//  Created by iosnull on 15/8/24.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import Foundation
//登录角色属性
struct roleInfo {
    var isdefault = ""
    var keyid = ""
    var remark = ""
    var rolename = ""
    var sortnum = ""
}

////商店类别
//struct shopClassInfo {
//    var shopDisplay = ""
//    var shopKeyid = ""
//    var shopName = ""
//}



//管理级别用户注册信息填写
struct ManageRoleRegistInfo{
    var name = ""
    var pwd = ""
    var roleid = ""
    var tel = ""
    var shopname = ""
    var address = ""
    var sptypeid = ""  //除商店外都未“-1”
    var pic  = ""
    var areaid  = ""
    //验证码
    var verifyCode = "000000"
}
