//
//  MyOrderInfoShowVC.swift
//
//
//  Created by yd on 16/3/24.
//
//

//
//  MyOrderInfoShowVC.swift
//
//
//  Created by yd on 16/3/24.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


enum FefreshFlag{
    case pullDown
    case pullUp
}

struct OrderModel {
    
    var refreshFlag = FefreshFlag.pullDown
    
    var flag = false {
        didSet{
            /**
            发通知控制器
            */
            NSNotificationCenter.defaultCenter().postNotificationName("orderModelChanged", object: nil)
        }
    }
    
    //给导航栏title显示用
    var orderShowInfo = (OrderPayStatus.全部,OrderTransportStatus.全部,OrderPayWay.全部订单)
    
    func navigationShowTitle()->String{
        var title = ""
        switch(orderShowInfo.2){
        case OrderPayWay.全部订单:
            title = "全部订单"
        case OrderPayWay.在线支付订单:
            title = "在线支付订单"
        case OrderPayWay.未支付订单:
            title = "未支付订单"
        case OrderPayWay.货到付款订单:
            title = "货到付款订单"
        case OrderPayWay.赊呗支付订单:
            title = "爽购支付订单"
        default:
            title = ""
        }
        return title
    }
    
    //顶部显示的该订单下的运输状态(针对已经付款的)，或者显示该订单为未支付订单
    func orderConfirmShow()->([String]){
        var showTitle = [String]()
        //1、先判断是请求的哪一种主要分类（线上，货到，赊呗，未支付，全部）
        switch orderShowInfo.2{
        case OrderPayWay.在线支付订单 ,OrderPayWay.货到付款订单 ,OrderPayWay.赊呗支付订单:
            showTitle = ["全部","待出库","配送中","已签收"]
        case OrderPayWay.未支付订单:
            showTitle = ["未支付订单"]
        case OrderPayWay.全部订单:
            showTitle = ["全部","未支付","待出库","配送中","已签收"]
        default:
            break
            
        }
        NSLog("showTitle = \(showTitle.description)")
        
        return showTitle
    }
    
    var pagesize = ""
    var currentpage = ""
    var data = [Orderlist](){
        didSet{
            
        }
    }
    
    
    
    /**
    多少个商家
    
    - returns: return value description
    */
    func numofSection()->Int{
        if data.count != 0{
            return data.count
        }else{
            return 0
        }
        
        
        
    }
    
    /**
    每个商家下的商品个数
    
    - parameter index: index description
    
    - returns: return value description
    */
    func numsOfRowAtSection(index:Int)->Int{
        if data.count != 0{
            
            return data[index].item.count
        }else{
            return 0
        }
        
        
    }
    
    
    /**
    刷新Cell
    */
    func returnCellInfo(index:NSIndexPath)->OrderItem{
        var orderItem = OrderItem()
        if data.count != 0 {
            orderItem = data[index.section].item[index.row]
        }
        
        return orderItem
    }
    
    /**
    *  刷新header(返回订单号，商家名字，支付状态，配送状态)
    */
    func orderNum_shopName_payStatus_deliveryStatus(index:Int)->(orderNum:String,shopName:String,payStatus_deliveryStatus:String){
        var orderNum = data[index].orderno
        var shopName = data[index].shopname
        
        var 支付状态 = ""
        
        if data[index].status == "2" {
            支付状态 = "已支付"
        }else{
            支付状态 = "未支付"
        }
        
        
        
        
        var 运单状态 = ""
        ////运单状态：1，待出库；2，配送中；3，已签收
        if  data[index].IsWaybill == "3" {
            运单状态 = "(已签收)"
        }else if data[index].IsWaybill == "2" {
            运单状态 = "(配送中)"
        }else if data[index].IsWaybill == "1"{
            运单状态 = "(待出库)"
        }else{
            运单状态 = ""
        }
        
        var payStatus_deliveryStatus = 支付状态 + 运单状态
        
        return (orderNum,shopName,payStatus_deliveryStatus)
    }
    
    func payMethod_actualPay_nums_buttonsHiddenFlag(index:NSIndexPath)->(payMethod:String,actualPay:String,nums:String,deleatBtn:Bool,payBtn:Bool,confirmBtn:Bool){
        
        /// 支付方式 "payway":  //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        var payMethod = ""
        if data[index.section].payway == "1" {
            payMethod = "在线支付"
        }else if data[index.section].payway == "2" {
            payMethod = "货到付款"
        }else if data[index.section].payway == "3" {
            payMethod = "爽购付款"
        }else{
            payMethod = ""
        }
        
        var actualPay = ""
        var allPrice = 0.0
        var nums = 0.0
        for var j = 0 ; j < data[index.section].item.count ; j++ {
            
            var price = NSNumberFormatter().numberFromString(data[index.section].item[j].price)!.doubleValue //单价
            var num = NSNumberFormatter().numberFromString(data[index.section].item[j].number)!.doubleValue //数量
            
            allPrice += price*num
            nums += num
        }
        actualPay = allPrice.description
        
        var deleatBtn = false //一直显示该按钮(只有在未支付或签收状态下才显示)
        

        switch(data[index.section].payway){//1，在线支付；2，货到付款；3，赊呗付款
            case "0" :
                if (data[index.section].status == "1") &&  (data[index.section].IsWaybill == "0"){
                    deleatBtn = true
                }
        case "1" :
            if (data[index.section].status == "2") &&  (data[index.section].IsWaybill == "3"){
                deleatBtn = true
            }
        case "2" :
            if (data[index.section].status == "1") &&  (data[index.section].IsWaybill == "3"){
                deleatBtn = true
            }
        case "3" :
            if (data[index.section].status == "2") &&  (data[index.section].IsWaybill == "3"){
                deleatBtn = true
            }
        default :
            deleatBtn = false
        }
        /***********************************************************************************/
        
        
        var payBtn = false
        
        ////订单状态：1，未支付；2，已支付
        
            //1、wei付款前提下： 不是不是 赊帐情况下
            if (data[index.section].status == "1") && ( !(data[index.section].payway == "2")) && (!(data[index.section].payway == "3"))  {
                payBtn = true
            }else {
                payBtn = false
            }
       
        
        
        /// 只有在配送中的商品才可以进行签收   //运单状态：1，待出库；2，配送中；3，已签收
        var confirmBtn = false
        if data[index.section].IsWaybill == "2" {
            confirmBtn = true
        }else{
            confirmBtn = false
        }
        
        return (payMethod,actualPay,nums.description,deleatBtn,payBtn,confirmBtn)
    }
    
    
}

struct Orderlist {
    var orderid = "" //订单ID
    var orderno = "" //订单号
    var status = "" //订单状态：1，未支付；2，已支付
    var IsWaybill = "" //运单状态：1，待出库；2，配送中；3，已签收
    var payway = "" //支付方式：1，在线支付；2，货到付款；3，赊呗付款
    var shopid = "" //商铺ID
    var shopname = ""//商铺名称
    var totalprice = "" //订单总额
    var paidAmount = "" //订单实付金额
    var IsGivestate = ""//是否开启赠送活动（0：有  1：没有）
    var item = [OrderItem]()
}


struct OrderItem {
    var MerchantPriceID = ""//商家-产品价格ID
    var productTitle = "" //产品名称
    var imageUrl = ""//产品封面图片地址
    var price = ""//产品单价
    var number = ""//产品数量
}


enum OrderPayWay{
    case 在线支付订单
    case 货到付款订单
    case 赊呗支付订单
    case 未支付订单
    case 全部订单
}


//运单运输状态：1，待出库；2，配送中；3，已签收
enum OrderTransportStatus{
    case 待出库
    case 配送中
    case 已签收
    case 全部
    case 待支付
}

/**
订单支付状态  //订单状态：1，未支付；2，已支付
*/
enum OrderPayStatus{
    case 未支付
    case 已支付
    case 全部
}



extension MyOrderInfoShowVC{
    //字符串转JSON
    func StringToJSON(sender:String)->JSON{
        
        var resultData = sender as NSString
        
        if let dataFromString = resultData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data:dataFromString)
            
            return json
        }else{
            return nil
        }
        
    }
    
    
    /**
    告诉我你想要什么数据
    
    - parameter pwaWay:          pwaWay description
    - parameter transportStatus: transportStatus description
    - parameter payStatus:       payStatus description
    */
    func iWantPayWay(pwaWay:OrderPayWay,transportStatus:OrderTransportStatus,payStatus:OrderPayStatus,currentPage:String){
        
        //模型变量设置
        orderModel.orderShowInfo.2 = pwaWay
        orderModel.orderShowInfo.0 = payStatus
        orderModel.orderShowInfo.1 = transportStatus
        
        orderModel.pagesize = "10" //默认
        orderModel.currentpage = currentPage
        
        switch(pwaWay){
        case OrderPayWay.在线支付订单:
            process_online(transportStatus, currentPage: currentPage)
        case OrderPayWay.货到付款订单:
            process_HuoDaoFu(transportStatus,currentPage: currentPage)
        case OrderPayWay.赊呗支付订单:
            process_sheBei(transportStatus,currentPage: currentPage)
        case OrderPayWay.未支付订单:
            process_notPayOrder(pwaWay, currentPage: currentPage)
        case OrderPayWay.全部订单:
            getAllOrderInfoByCondition(payStatus, transportStatus: transportStatus, currentPage: currentPage)
        default:
            getAllOrderInfo(currentPage)
            break
        }
    }
    
    //运输状态，支付状态，无条件来获取数据
    func getAllOrderInfoByCondition(payStatus:OrderPayStatus,transportStatus:OrderTransportStatus,currentPage:String){
        
        NSLog("payStatus = \(payStatus),transportStatus = \(transportStatus), currentPage = \(currentPage)")
        
        //1、全部订单
        if payStatus == OrderPayStatus.全部 && transportStatus == OrderTransportStatus.全部 {
        getOrderData(currentRoleInfomation.keyid, payway: "0", IsWaybill: "0", status: "0", PageSize: "10", CurrentPage: currentPage)
        }
        //2、未支付订单
        if payStatus == OrderPayStatus.全部 && transportStatus == OrderTransportStatus.待支付 {
        getOrderData(currentRoleInfomation.keyid, payway: "0", IsWaybill: "0", status: "1", PageSize: "10", CurrentPage: currentPage)
        }
        //3、待出库订单
        if payStatus == OrderPayStatus.全部 && transportStatus == OrderTransportStatus.待出库 {
        getOrderData(currentRoleInfomation.keyid, payway: "0", IsWaybill: "1", status: "0", PageSize: "10", CurrentPage: currentPage)
        }
        //4、配送中
        if payStatus == OrderPayStatus.全部 && transportStatus == OrderTransportStatus.配送中 {
        getOrderData(currentRoleInfomation.keyid, payway: "0", IsWaybill: "2", status: "0", PageSize: "10", CurrentPage: currentPage)
        }
        //5、已签收
        if payStatus == OrderPayStatus.全部 && transportStatus == OrderTransportStatus.已签收 {
        getOrderData(currentRoleInfomation.keyid, payway: "0", IsWaybill: "3", status: "0", PageSize: "10", CurrentPage: currentPage)
        }
    }
    
    /**
    获取用户所以订单
    */
    func getAllOrderInfo(currentPage:String){
        getOrderData(currentRoleInfomation.keyid, payway: "0", IsWaybill: "0", status: "0", PageSize: "10", CurrentPage: currentPage)
    }
    
    //还没有进行支付的订单
    func process_notPayOrder(pwaWay:OrderPayWay,currentPage:String){
        //IsWaybill 运单状态：1，待出库；2，配送中；3，已签收
        //payway 支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "0", IsWaybill: "0", status: "1", PageSize: "10", CurrentPage: currentPage)
    }
    
    /************************************************************************************************************************/
    
    //赊呗
    func process_sheBei(transportStatus:OrderTransportStatus,currentPage:String){
        switch(transportStatus){
        case OrderTransportStatus.待出库:
            getWaitingToDischarge_SheBeiOrderData(currentPage)
        case OrderTransportStatus.配送中:
            getOnTheWay_SheBeiOrderData(currentPage)
        case OrderTransportStatus.已签收:
            getConfirm_SheBeiOrderData(currentPage)
        case OrderTransportStatus.全部:
            getAllSheBeiOrderData(currentPage)
        default:
            break
        }
        
    }
    
    //在线支付
    func process_online(transportStatus:OrderTransportStatus,currentPage:String){
        switch(transportStatus){
        case OrderTransportStatus.待出库:
            getWaitingToDischarge_OnlineOrderData(currentPage)
        case OrderTransportStatus.配送中:
            getOnTheWay_OnlineOrderData(currentPage)
        case OrderTransportStatus.已签收:
            getConfirm_OnlineOrderData(currentPage)
        case OrderTransportStatus.全部:
            getAllOnlineOrderData(currentPage)
        default:
            break
        }
    }
    
    //货到付款
    func process_HuoDaoFu(transportStatus:OrderTransportStatus,currentPage: String){
        switch(transportStatus){
        case OrderTransportStatus.待出库:
            getWaitingToDischarge_HuoDaoFuKuanOrderData(currentPage)
        case OrderTransportStatus.配送中:
            getOnTheWay_HuoDaoFuKuanOrderData(currentPage)
        case OrderTransportStatus.已签收:
            getConfirm_HuoDaoFuKuanOrderData(currentPage)
        case OrderTransportStatus.全部:
            getAllHuoDaoFuKuanOrderData(currentPage)
        default:
            break
        }
    }
    
    /****************************************************************************/
    /****************************************************************************/
    /****************************************************************************/
    /****************************************************************************/
    
    /**
    获取在线支付的全部订单信息
    */
    func getAllOnlineOrderData(CurrentPage:String){
        
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "1", IsWaybill: "0", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    /**
    在线支付的待出库商品信息
    
    - parameter CurrentPage: CurrentPage description
    */
    func getWaitingToDischarge_OnlineOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "1", IsWaybill: "1", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    /**
    在线支付的配送中的商品
    
    - parameter CurrentPage: CurrentPage description
    */
    func getOnTheWay_OnlineOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "1", IsWaybill: "2", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    
    /**
    在线支付的已经签收商品信息
    
    - parameter CurrentPage: CurrentPage description
    */
    func getConfirm_OnlineOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "1", IsWaybill: "3", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    /****************************************************************************/
    /****************************************************************************/
    /****************************************************************************/
    /****************************************************************************/
    
    /**
    获取货到付款的全部订单信息
    */
    func getAllHuoDaoFuKuanOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "2", IsWaybill: "0", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    /**
    获取货到付款的待出库商品信息
    
    - parameter CurrentPage: CurrentPage description
    */
    func getWaitingToDischarge_HuoDaoFuKuanOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "2", IsWaybill: "1", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    /**
    获取货到付款的配送中的商品
    
    - parameter CurrentPage: CurrentPage description
    */
    func getOnTheWay_HuoDaoFuKuanOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "2", IsWaybill: "2", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    
    /**
    获取货到付款的已经签收商品信息
    
    - parameter CurrentPage: CurrentPage description
    */
    func getConfirm_HuoDaoFuKuanOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "2", IsWaybill: "3", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    
    /****************************************************************************/
    /****************************************************************************/
    /****************************************************************************/
    /****************************************************************************/
    
    /**
    获取赊呗付款的全部订单信息
    */
    func getAllSheBeiOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "3", IsWaybill: "0", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    /**
    获取赊呗的待出库商品信息
    
    - parameter CurrentPage: CurrentPage description
    */
    func getWaitingToDischarge_SheBeiOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "3", IsWaybill: "1", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    /**
    获取赊呗的配送中的商品
    
    - parameter CurrentPage: CurrentPage description
    */
    func getOnTheWay_SheBeiOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "3", IsWaybill: "2", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    
    /**
    获取赊呗的已经签收商品信息
    
    - parameter CurrentPage: CurrentPage description
    */
    func getConfirm_SheBeiOrderData(CurrentPage:String){
        //运单状态：1，待出库；2，配送中；3，已签收
        //支付方式：1，在线支付；2，货到付款；3，赊呗付款
        getOrderData(currentRoleInfomation.keyid, payway: "3", IsWaybill: "3", status: "0", PageSize: "10", CurrentPage: CurrentPage)
    }
    
    
    
    
    
    
    /**
    获取订单信息
    */
    func getOrderData(userid:String,payway:String,IsWaybill:String,status:String,PageSize:String,CurrentPage:String){
        
        ProgressHUD.show("数据请求中...")
        
        let url = serversBaseURL + "/orders/list"
        
        let parameters = ["usertype":"1","userid":userid,"payway":payway,"IsWaybill":IsWaybill,"status":status,"PageSize":PageSize,"CurrentPage":CurrentPage]
        
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        if netIsavalaible {
        Alamofire.request(.GET,url,parameters: para).responseString{ (request, response, data, error) in
                        NSLog("error = \(error)")
                        NSLog("data = \(data)")
            
            
            
            self.tableView.mj_footer.endRefreshing()
            self.tableView.mj_header.endRefreshing()
            
            var json = self.StringToJSON(data!)
            NSLog("json = \(json.description)")
            
            var myOrderModel = OrderModel()
            var message = json["message"].stringValue
            if json["success"].stringValue == "true" {
                
                ProgressHUD.showSuccess(message)
                
                var data = json["data"]
                NSLog("data = \(data.description)")
                    myOrderModel.pagesize = data["pagesize"].stringValue
                    myOrderModel.currentpage = data["currentpage"].stringValue
                    var list = data["list"]
                    NSLog("list = \(list.description)")
                    myOrderModel.data = self.getLists(list)
                
                //下拉刷新数据，上啦加载更多
                if self.orderModel.refreshFlag == .pullDown {
                    self.orderModel.data =  myOrderModel.data
                }else{
                    self.orderModel.data += myOrderModel.data
                }
                
                
                self.orderModel.flag = true
                
            }else{
                ProgressHUD.showError(message)
            }
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    func getLists(json:JSON)->[Orderlist]{
        var orderlists = [Orderlist]()
        NSLog("json = \(json.description)")
        for var i = 0 ; i < json.count ; i++ {
            var listTemp = json[i]
            var list = Orderlist()
            list.orderid = listTemp["orderid"].stringValue
            list.orderno = listTemp["orderno"].stringValue
            list.status = listTemp["status"].stringValue
            list.IsWaybill = listTemp["IsWaybill"].stringValue
            list.payway = listTemp["payway"].stringValue
            list.shopid = listTemp["shopid"].stringValue
            list.shopname = listTemp["shopname"].stringValue
            list.totalprice = listTemp["totalprice"].stringValue
            list.paidAmount = listTemp["paidAmount"].stringValue
            list.IsGivestate = listTemp["IsGivestate"].stringValue
            list.item = getItems(listTemp["item"])
            
            orderlists.append(list)
        }
        
        return orderlists
    }
    
    
    func getItems(json:JSON)->[OrderItem]{
        var orderItems = [OrderItem]()
        NSLog("json = \(json.description)")
        for var i = 0 ; i < json.count ; i++ {
            var itemTemp  = json[i]
            var item = OrderItem()
            item.MerchantPriceID = itemTemp["MerchantPriceID"].stringValue
            item.productTitle = itemTemp["productTitle"].stringValue
            item.imageUrl = itemTemp["imageUrl"].stringValue
            item.price = itemTemp["price"].stringValue
            item.number = itemTemp["number"].stringValue
            
            orderItems.append(item)
        }
        
        return orderItems
    }
    
    
    
    
}




/*************************************************************************/

extension MyOrderInfoShowVC{
    
    //下拉刷新
    func pullDownRefresh(){
        if netIsavalaible {
        orderModel.refreshFlag = .pullDown //标记为下拉刷新
        
        var (orderPayStatus,orderTransportStatus,orderPayWay) = orderModel.orderShowInfo
        iWantPayWay(orderPayWay, transportStatus: orderTransportStatus, payStatus: orderPayStatus, currentPage: "1")
        }else{
                netIsEnable("网络不可用")
            self.tableView.mj_header.endRefreshing()
            }
    }
    
    //上拉加载
    func pullUpRefresh(){
        if netIsavalaible {
        orderModel.refreshFlag = .pullUp //标记为上拉加载
        var Flag = false
        //1、判断当前页面有数据，且是10的倍数
        if (orderModel.data.count) != 0 && (orderModel.data.count%10 == 0) {
            Flag = true
        }else{
            Flag = false
        }
        
        //2、确认请求页面是第几页
        if Flag{
            var pageNum = orderModel.data.count/10 + 1
            var (orderPayStatus,orderTransportStatus,orderPayWay) = orderModel.orderShowInfo
            iWantPayWay(orderPayWay, transportStatus: orderTransportStatus, payStatus: orderPayStatus, currentPage: pageNum.description)
        }else{
            
            ProgressHUD.showError("没有更多数据了")
            self.tableView.mj_footer.endRefreshing()
        }
        }else{
            netIsEnable("网络不可用")
            self.tableView.mj_footer.endRefreshing()
        }
        
    }
}


/*************************************************************************/



class MyOrderInfoShowVC: UIViewController,SphereMenuDelegate,UITableViewDelegate,UITableViewDataSource,SelectContainerViewDelegate,MenuViewDelegate{
    
    
    
    
    var verifyInfo = VerifyInfo()
    
    var tableView :UITableView!
    var orderModel = OrderModel()
    var segment:UISegmentedControl?
    var menuView:MenuView?
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.separatorInset = UIEdgeInsetsZero //设置分割线没有内容边距
        self.tableView.layoutMargins = UIEdgeInsetsZero //清空默认布局边距
        
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func setNavigationBar(){
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        self.view.backgroundColor  = UIColor.whiteColor()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT ), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizesSubviews = false
        
        
        /**********************************************/
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("pullUpRefresh"))
        /**********************************************/
        
        self.view.addSubview(tableView)
        
        self.tableView.registerClass(VirifyInfoCell.self, forCellReuseIdentifier: "cell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("orderModelChanged"), name: "orderModelChanged", object: nil)
        //默认获取全部订单
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: Selector("leftBtnClk"))
    }
    
    
   
    
    deinit{
        ProgressHUD.dismiss()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func leftBtnClk(){
        self.tabBarController?.selectedIndex = 3
        self.navigationController?.popToRootViewControllerAnimated(false)
        
    }
    
    //创建段选择器
    func selectName(name: String, num: Int) {
        NSLog("你点击了\(name),编号是\(num)")
    }

    func clickButton(index:Int){
        NSLog("index = \(index)")
        
        self.orderModel.data = []//清空模型数据
        var orderTransportStatus = OrderTransportStatus.全部
        var payStatus = OrderPayStatus.全部
        
        if orderModel.orderShowInfo.2 == OrderPayWay.全部订单 {
            payStatus = OrderPayStatus.全部
            switch(index){
            case 0:
                NSLog("*******************************************获取全部订单")
                orderTransportStatus = OrderTransportStatus.全部
            case 1:
                NSLog("*******************************************待支付订单")
                orderTransportStatus = OrderTransportStatus.待支付
            case 2:
                NSLog("*******************************************待出库订单")
                orderTransportStatus = OrderTransportStatus.待出库
            case 3:
                NSLog("*******************************************配送中订单")
                orderTransportStatus = OrderTransportStatus.配送中
            case 4:
                NSLog("*******************************************已签收订单")
                orderTransportStatus = OrderTransportStatus.已签收
            default:
                break
                
            }
            
            
        }else if orderModel.orderShowInfo.2 == OrderPayWay.未支付订单{
            payStatus = OrderPayStatus.未支付
            switch(index){
            case 0:
                orderTransportStatus = OrderTransportStatus.待支付
            default:
                break
                
            }
            
        }else{
            payStatus = OrderPayStatus.已支付
            
            switch(index ){
                
            case 0:
                orderTransportStatus = OrderTransportStatus.全部
            case 1:
                orderTransportStatus = OrderTransportStatus.待出库
            case 2:
                orderTransportStatus = OrderTransportStatus.配送中
            case 3:
                orderTransportStatus = OrderTransportStatus.已签收
            default:
                break
                
            }
            
        }
        
        self.iWantPayWay(orderModel.orderShowInfo.2, transportStatus: orderTransportStatus, payStatus: payStatus, currentPage: "1")
        
        
        
    }

    func createMenuView(arrayData:[String]){
        if let view = menuView {
            view.removeFromSuperview()
        }
        
        if arrayData.count < 2 {
           self.tableView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT )
        }else{
            menuView = MenuView(frame: CGRectMake(0, 64, kSCREEN_WIDTH, 44))
            menuView?.titleArray = arrayData
            menuView?.menudDelegate = self
            self.view.addSubview(menuView!)
            
            self.tableView.frame = CGRect(x: 0, y: 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT )
        }
        
        
    }
    

    
    var selectContainerView:SelectContainerView?
    func createSegment(ArrayData:[String]){
       
        
        /**************************************************/
        var arrays = ArrayData as [AnyObject]
        
        if let num = segment?.numberOfSegments {
            segment!.removeFromSuperview()
        }
        
        
        segment = UISegmentedControl(items:arrays)
        segment!.frame =  CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: 44)
        
        segment!.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha:1)
        segment!.tintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //segment!.layer.masksToBounds = true
        
        segment!.enabled = true
        segment!.momentary = false
        segment!.selected = true
        
        segment!.selectedSegmentIndex = 0
        
        
        segment!.addTarget(self, action: Selector("segmentClick:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(segment!)
    }
    
    
    
    func segmentClick(sender:UISegmentedControl) {//sender:UISegmentedControl
        NSLog("segmentClick \(sender.selectedSegmentIndex)")
        //sender.tintColor = UIColor(red: 216/255, green: 109/255, blue: 92/255, alpha: 1)
        
        self.orderModel.data = []//清空模型数据
        var orderTransportStatus = OrderTransportStatus.全部
        var payStatus = OrderPayStatus.全部
        
        if orderModel.orderShowInfo.2 == OrderPayWay.全部订单 {
            payStatus = OrderPayStatus.全部
            switch(sender.selectedSegmentIndex){
            case 0:
                NSLog("*******************************************获取全部订单")
                orderTransportStatus = OrderTransportStatus.全部
            case 1:
                NSLog("*******************************************待支付订单")
                orderTransportStatus = OrderTransportStatus.待支付
            case 2:
                NSLog("*******************************************待出库订单")
                orderTransportStatus = OrderTransportStatus.待出库
            case 3:
                NSLog("*******************************************配送中订单")
                orderTransportStatus = OrderTransportStatus.配送中
            case 4:
                NSLog("*******************************************已签收订单")
                orderTransportStatus = OrderTransportStatus.已签收
            default:
                break
                
            }

            
        }else if orderModel.orderShowInfo.2 == OrderPayWay.未支付订单{
            payStatus = OrderPayStatus.未支付
            switch(sender.selectedSegmentIndex){
            case 0:
                orderTransportStatus = OrderTransportStatus.待支付
            default:
                break
                
            }

        }else{
            payStatus = OrderPayStatus.已支付
            
            switch(sender.selectedSegmentIndex){
                
            case 0:
                orderTransportStatus = OrderTransportStatus.全部
            case 1:
                orderTransportStatus = OrderTransportStatus.待出库
            case 2:
                orderTransportStatus = OrderTransportStatus.配送中
            case 3:
                orderTransportStatus = OrderTransportStatus.已签收
            default:
                break
                
            }

        }
                
        self.iWantPayWay(orderModel.orderShowInfo.2, transportStatus: orderTransportStatus, payStatus: payStatus, currentPage: "1")
        
        
        
        
        
    }
    
    
    
    /**
    有多少个section
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if orderModel.flag {//防止数组越界
        return orderModel.numofSection()
        }else{
            return 0
        }
    }
    /**
    一个section有几行row
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderModel.flag {//防止数组越界
        return orderModel.numsOfRowAtSection(section)
        }else{
            return 0
        }
    }
    /**
    表尾
    */
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if orderModel.data[section].IsGivestate == "0" {
            return 95 + 30
        }else{
            return 95
        }
        
        
        
    }
    
    /**
    表头
    */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /**
    每行row 的高度
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screenWith/3 + 10
    }
    
    /**
    设置表头
    */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MyOrderInfoCell()
        if orderModel.flag {//防止数组越界
        let (orderNum,shopName,payStatus_deliveryStatus)  = orderModel.orderNum_shopName_payStatus_deliveryStatus(section)
        view.shopName.text = shopName
        view.goodsStatus.text = payStatus_deliveryStatus
        view.orderNum.text = "  订单号:" + orderNum
        }
        return view
    }
    /**
    设置表尾
    */
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = MyOrderCellFooter()
        if orderModel.flag {//防止数组越界
        let (payMethod:String,actualPay:String,nums:String,deleatBtn:Bool,payBtn:Bool,confirmBtn:Bool) = orderModel.payMethod_actualPay_nums_buttonsHiddenFlag(NSIndexPath(index: section))
        
        let numsString = String(format: "%.0f",  NSNumberFormatter().numberFromString(nums)!.doubleValue )//数量格式化
        let actualPayString = String(format: "%.2f",  NSNumberFormatter().numberFromString(actualPay)!.doubleValue)//总价格式化
            
            if orderModel.data[section].IsGivestate == "0" {
                view.lookGiftBtn.hidden = false
            }else{
                view.lookGiftBtn.hidden = true
            }
            
        
        
        view.Pricetext.text = "￥" + actualPayString
        view.payWayAndNums.text   = "数量: " + numsString + "件    " +  "\(payMethod)"
        
        view.deleteBtn.tag = section
        view.deleteBtn.addTarget(self, action: Selector("deleteBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.confirmBtn.tag = section
        view.confirmBtn.addTarget(self, action: Selector("confirmBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.payMentBtn.tag = section
        view.payMentBtn.addTarget(self, action: Selector("payMentBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        view.lookGiftBtn.tag = section
        view.lookGiftBtn.addTarget(self, action: Selector("lookGiftBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        if deleatBtn {
            view.deleteBtn.hidden = false
        }else{
            view.deleteBtn.hidden = true
        }
        NSLog("payMethod =\(payMethod)")
        if payBtn {
            view.payMentBtn.hidden = false
        }else{
            view.payMentBtn.hidden = true
        }
        if confirmBtn {
            view.confirmBtn.hidden = false
        }else{
            view.confirmBtn.hidden = true
        }
        
        }
        
        
        
        return view
    }
    
    /**
    设置表cell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! VirifyInfoCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if orderModel.flag {//防止数组越界
        
        let data = orderModel.returnCellInfo(indexPath)
        
        cell.img.sd_setImageWithURL(NSURL(string:serversBaseUrlForPicture + data.imageUrl))
        
        cell.name.text = data.productTitle
        
        cell.nums.text = "X" + data.number
        
            cell.allPrice.text = "￥" + data.price
        }
        
        return cell
    }
    
    
    
    func lookGiftBtnClick(sender:UIButton){
        NSLog("lookGiftBtnClick\(sender.tag)")
        
        let (orderNum,shopName,payStatus_deliveryStatus)  = orderModel.orderNum_shopName_payStatus_deliveryStatus(sender.tag)
        
        let confirmGoodsUrl = serversBaseURL + "/activity/order"
        let parameters = ["userid":currentRoleInfomation.keyid,"orderno":orderNum,"usertype":"1"]
        
        if netIsavalaible {
        Alamofire.request(.POST,confirmGoodsUrl,parameters: parameters).responseString { (request, response, data, error) in
            
            NSLog("\(data )")
            var datatemp = self.StringToJSON(data!)
            var zengPingModel = ZengpinInfoModel()
            zengPingModel.getData(datatemp)
            if zengPingModel.data.count != 0 {
                //确认商品赠送信息
                var zhengPingShowVC = ZhengPingShowVC()
                
                zhengPingShowVC.backGroundImg.image = self.captureImage()
                
                zhengPingShowVC.zengPingModel = zengPingModel
                zhengPingShowVC.affirmOrderBtn.hidden = true
                self.presentViewController(zhengPingShowVC, animated: true) { () -> Void in
                    
                }
//            let result = datatemp.description
//            NSLog("result = \(result)")
            }
        }
            
    }else{
        netIsEnable("网络不可用")
        }

    }

    
    func captureImage()->UIImage{
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
        
    }
        
    /*确认收货*/
    
    
    func confirmBtnClick(sender:UIButton){
        NSLog("confirmBtnClick\(sender.tag)")
        let (orderNum,shopName,payStatus_deliveryStatus)  = orderModel.orderNum_shopName_payStatus_deliveryStatus(sender.tag)
        
        let confirmGoodsUrl = serversBaseURL + "/orders/conform"
        let parameters = ["userid":currentRoleInfomation.keyid,"orderno":orderNum,"usertype":"1"]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["orderinfo":dataString]
        
        if netIsavalaible {
        
        Alamofire.request(.POST,confirmGoodsUrl,parameters: para).responseString { (request, response, data, error) in
            
            NSLog("\(data )")
            var datatemp = JSON(data!)
            
            let result = datatemp.description
            NSLog("result = \(result)")
            
            var resultTemp = self.StringToJSON(result)
            NSLog("resultTemp = \(resultTemp)")
            
            var message = resultTemp["message"].stringValue
            if "true" == resultTemp["success"].stringValue {
                ProgressHUD.showSuccess(message)
                self.orderModel.data.removeAtIndex(sender.tag)
                self.tableView.reloadData()
            }else{
                ProgressHUD.showError(message)
            }
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    
    func  payOrder(orderNum:String, payprice: String, payWay: GoodsPayWay){
        
        let configUrl = serversBaseURL + "/config/get"
        
        if netIsavalaible {
        Alamofire.request(.GET,configUrl,parameters: nil).responseString { (request, response, data, error) in
            
            var datatemp = JSON(data!)
            let result = datatemp.description
            
            var resultTemp = self.StringToJSON(result)
            NSLog("resultTemp = \(resultTemp)")
            
            var message = resultTemp["message"].stringValue
            if "true" == resultTemp["success"].stringValue {
                var data = resultTemp["data"]
                var  IsDelivery = data["IsDelivery"].stringValue
                var IsCredit = data["IsCredit"].stringValue
                var IsOnlinepay = data["IsOnlinepay"].stringValue
                
                
                switch(payWay){
                case GoodsPayWay.weixin:
                    if IsOnlinepay == "true" {
                        self.payWithWeiXin(orderNum, payprice: payprice, payWay: GoodsPayWay.weixin, usertype: "1")
                    }else{
                        var alertView = UIAlertView(title: "提示", message: "不支持您所选的支付方式,请重选", delegate: nil, cancelButtonTitle: "确认")
                        alertView.show()
                    }
                    
                case GoodsPayWay.alipay:
                    if IsOnlinepay == "true" {
                        self.payWithAlipay(orderNum, payprice: payprice, payWay: GoodsPayWay.alipay, usertype: "1")
                    }else{
                        var alertView = UIAlertView(title: "提示", message: "不支持您所选的支付方式,请重选", delegate: nil, cancelButtonTitle: "确认")
                        alertView.show()
                    }
                case GoodsPayWay.huodaofukuan:
                    if IsDelivery == "true" {
                        self.payWithHuoDaoFuKuan(orderNum, payprice: payprice, payWay: GoodsPayWay.huodaofukuan, usertype: "1")
                    }else{
                        var alertView = UIAlertView(title: "提示", message: "不支持您所选的支付方式,请重选", delegate: nil, cancelButtonTitle: "确认")
                        alertView.show()
                    }
                case GoodsPayWay.shebei:
                    if IsCredit == "true" {
                        self.payWithSheBei(orderNum, payprice: payprice, payWay: GoodsPayWay.shebei, usertype: "1")
                    }else{
                        var alertView = UIAlertView(title: "提示", message: "不支持您所选的支付方式,请重选", delegate: nil, cancelButtonTitle: "确认")
                        alertView.show()
                    }
                    
                default:
                    var alertView = UIAlertView(title: "提示", message: "不支持您所选的支付方式,请重选", delegate: nil, cancelButtonTitle: "确认")
                    alertView.show()
                    break
                }
                
            
            }else{
                ProgressHUD.showError(message)
            }
        }
        }else{
            netIsEnable("网络不可用")
        }

    }
    
    /**
    支付功能
    */
    func payMentBtnClick(sender:UIButton){
        
        let (orderNum,shopName,payStatus_deliveryStatus)  = orderModel.orderNum_shopName_payStatus_deliveryStatus(sender.tag)
        let (payMethod:String,actualPay:String,nums:String,deleatBtn:Bool,payBtn:Bool,confirmBtn:Bool) = orderModel.payMethod_actualPay_nums_buttonsHiddenFlag(NSIndexPath(index: sender.tag))
        
        
        var alertController = UIAlertController(title: "提示", message: "请选中支付方式", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
        var shuangGouAction = UIAlertAction(title: "爽购支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("赊呗支付")
            
            
            self.payOrder(orderNum, payprice: actualPay, payWay: GoodsPayWay.shebei)
   
        } )
        
        var aliPayAction = UIAlertAction(title: "支付宝支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("支付宝支付")
            self.payOrder(orderNum, payprice: actualPay, payWay: GoodsPayWay.alipay)
   
        } )
        var weiXinAction = UIAlertAction(title: "微信支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("微信支付")
            self.payOrder(orderNum, payprice: actualPay, payWay: GoodsPayWay.weixin)
            
 
        } )
        var huoDaoAction = UIAlertAction(title: "货到付款", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("货到付款")
            
            self.payOrder(orderNum, payprice: actualPay, payWay: GoodsPayWay.huodaofukuan)
            
        } )
        
        alertController.addAction(cancelAction)
        if self.payMethord_FromNet["IsCredit"] == "true" {
            alertController.addAction(shuangGouAction)
        }
        
        if self.payMethord_FromNet["IsOnlinepay"] == "true" {
            alertController.addAction(aliPayAction)
            alertController.addAction(weiXinAction)
        }
        if self.payMethord_FromNet["IsDelivery"] == "true" {
            alertController.addAction(huoDaoAction)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    /**
    删除功能
    */
    func deleteBtnClick(sender:UIButton){
        
        
        let (orderNum,shopName,payStatus_deliveryStatus)  = orderModel.orderNum_shopName_payStatus_deliveryStatus(sender.tag)
        
        let confirmGoodsUrl = serversBaseURL + "/orders/cancel"
        let parameters = ["userid":currentRoleInfomation.keyid,"orderno":orderNum,"usertype":"1"]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["orderinfo":dataString]
        
        if netIsavalaible {
        
        Alamofire.request(.POST,confirmGoodsUrl,parameters: para).responseString { (request, response, data, error) in
            
            NSLog("\(data )")
            var datatemp = JSON(data!)
            
            let result = datatemp.description
            NSLog("result = \(result)")
            
            var resultTemp = self.StringToJSON(result)
            NSLog("resultTemp = \(resultTemp)")
            
            var message = resultTemp["message"].stringValue
            if "true" == resultTemp["success"].stringValue {
                ProgressHUD.showSuccess(message)
                self.orderModel.data.removeAtIndex(sender.tag)
                self.tableView.reloadData()
            }else{
                ProgressHUD.showError(message)
            }
        }
        }else{
            netIsEnable("网络不可用")
        }

        
        
        
    }
    

    var menu = SphereMenu()
    var images:[UIImage] = []
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.whiteColor()
        let start = UIImage(named: "001")
        let image1 = UIImage(named: "002")
        let image2 = UIImage(named: "003")
        let image3 = UIImage(named: "shuanggou")
        let image4 = UIImage(named: "006")
        let image5 = UIImage(named: "005")
        images = [image1!,image2!,image3!,image4!,image5!]
        
        
        menu = SphereMenu(startPoint: CGPointMake(CGRectGetWidth(self.view.frame)/2 - 20, CGRectGetHeight(self.view.frame) - 80), startImage: start!, submenuImages:images, tapToDismiss:true)
        
        
        
        menu.delegate = self
        self.view.addSubview(menu)
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
        /**
        全部订单
        */
        getAllOrderInfo("1")
        
        //默认全部订单
        let titles = ["全部", "未支付", "待出库", "配送中", "已签收"]
                //createSegment(titles)
        createMenuView(titles)
        pullDownRefresh()
        
        getPayWayFromNet()
        
    }
    
    var payMethord_FromNet = [String:String]()
    func getPayWayFromNet(){
        NSLog("必要信息满足，可以进行购买操作")
        let configUrl = serversBaseURL + "/config/get"
        
        if netIsavalaible {
            Alamofire.request(.GET,configUrl,parameters: nil).responseString { (request, response, data, error) in
                
                var datatemp = JSON(data!)
                let result = datatemp.description
                
                var resultTemp = self.StringToJSON(result)
                NSLog("resultTemp = \(resultTemp)")
                
                var message = resultTemp["message"].stringValue
                if "true" == resultTemp["success"].stringValue {
                    var data = resultTemp["data"]
                    var  IsDelivery = data["IsDelivery"].stringValue
                    var IsCredit = data["IsCredit"].stringValue
                    var IsOnlinepay = data["IsOnlinepay"].stringValue
                    
                    
                    
                    self.payMethord_FromNet["IsDelivery"] = IsDelivery
                    self.payMethord_FromNet["IsCredit"] = IsCredit
                    self.payMethord_FromNet["IsOnlinepay"] = IsOnlinepay
                    
                    for item in self.payMethord_FromNet {
                        NSLog("item \(item)")
                    }
                    
                    
                    
                }else{
                    //ProgressHUD.showError(message)
                }
            }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    func sphereDidSelected(index: Int) {
        NSLog("index ==\(index)")
        
        

        switch(index){
        case 0:
            //self.title = "线上付款订单"
            self.iWantPayWay(OrderPayWay.在线支付订单, transportStatus: OrderTransportStatus.全部, payStatus: OrderPayStatus.已支付, currentPage: "1")
            
            break
        case 1:
            //self.title = "货到付款订单"
            self.iWantPayWay(OrderPayWay.货到付款订单, transportStatus: OrderTransportStatus.全部, payStatus: OrderPayStatus.未支付, currentPage: "1")
            break
        case 2:
            //self.title = "赊呗付款订单"
            self.iWantPayWay(OrderPayWay.赊呗支付订单, transportStatus: OrderTransportStatus.全部, payStatus: OrderPayStatus.未支付, currentPage: "1")
            break
        case 3:
            //self.title = "未支付订单"
            self.iWantPayWay(OrderPayWay.未支付订单, transportStatus: OrderTransportStatus.全部, payStatus: OrderPayStatus.未支付, currentPage: "1")
            break
        case 4:
            //self.title = "全部订单"
            self.iWantPayWay(OrderPayWay.全部订单, transportStatus: OrderTransportStatus.全部, payStatus: OrderPayStatus.全部, currentPage: "1")
            break
        default:
            break
        }
        
        var titles = orderModel.orderConfirmShow()
        
           createMenuView(titles)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.sharedImageCache().clearMemory()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}


extension MyOrderInfoShowVC {
    
    
    /**
    支付宝支付
    */
    func payWithAlipay(myorder:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var productName = "商品名称"
        var productDescription = "商品描述"
        var amount = payprice
        var userid = currentRoleInfomation.keyid
        
        //var notifyURL = serversBaseURL + "/pay/notify?" + "orderno=\(myorder)" + "&userid=\(userid)" + "&usertype=\(usertype)" + "&payprice=\(payprice)" + "&paytype=1"
        var notifyURL = serversBaseURL + "/notify/notify_url.aspx"
        
        //支付宝支付调用
        
        
        var order = Order()
        order.partner = PARTNER;
        order.seller = SELLER;
        order.tradeNO = myorder                                //订单ID（由商家自行制定）
        order.productName = productName              //商品标题
        order.productDescription = productDescription    //商品描述
        order.amount = amount   //商品价格
        //NSLog("order.amount = \(order.amount)")
        
        order.notifyURL =  notifyURL //回调URL
        order.service = "mobile.securitypay.pay";
        order.paymentType = "1";
        order.inputCharset = "utf-8";
        order.itBPay = "30m";
        order.showUrl = "m.alipay.com";
        
        //将商品信息拼接成字符串
        var orderSpec = order.description
        var signer = CreateRSADataSigner(RSA_PRIVATE)
        var signedString = signer.signString(orderSpec)//[signer signString:orderSpec];
        
        var rsa = "RSA"
        var orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"\(rsa)\""
        NSLog("orderString = \(orderString)")
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: "wxc81564befb45171c") { (result) -> Void in
            NSLog("zhifubao = \(result)")
            NSLog("支付宝处理结果")
            //支付宝发出通知
            
            /**
            *  pop到根视图
            */

        }
    }
    /**
    微信支付
    */
    func payWithWeiXin(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        
        var tradeNO = order
        var productName = "商品名称"
        var productDescription = "商品描述"
        
        var allprice = NSNumberFormatter().numberFromString(payprice)!.doubleValue
        
        var amount = String(stringInterpolationSegment: allprice*100) //考虑微信支付价格以分为单位
        
        var userid = currentRoleInfomation.keyid
        
        var notifyURL = serversBaseURL + "/pay/notify?" + "orderno=\(order)" + "&userid=\(userid)" + "&usertype=\(usertype)" + "&payprice=\(payprice)" + "&paytype=2"
        
        if !WXApi.isWXAppInstalled() {
            ProgressHUD.dismiss()
            
            var alart = UIAlertView(title: "提示", message: "请先安装微信后再进行支付", delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            
            
           
            
            return
        }
        
        NSLog("tradeNO = \(tradeNO)  productName = \(productName)  productDescription = \(productDescription) amount = \(amount)  notifyURL = \(notifyURL) ")
        
        var req = payRequsestHandler()
        
        req.initq(APP_ID, mch_id: MCH_ID)
        req.setKey(PARTNER_ID)
        
        var dict:NSMutableDictionary? = req.sendPay_demo(currentRoleInfomation.tel, order_name: productName, order_price: amount, orderno: tradeNO,notify_URL:notifyURL)
        
        
        if let result = dict {//获取签名成功
            NSLog("dict = %@\n\n",dict!);
            //var debug =  req.getDebugifo
            //NSLog("debug = \(debug)")
            var stamp  =  dict!.objectForKey("timestamp") as! String
            //NSLog("stamp = \(stamp)")
            //调起微信支付
            var req :PayReq            = PayReq()
            req.openID              = dict!.objectForKey("appid") as! String
            req.partnerId           = dict!.objectForKey("partnerid") as! String//[dict objectForKey:@"partnerid"];
            req.prepayId            = dict!.objectForKey("prepayid") as! String//[dict objectForKey:@"prepayid"];
            req.nonceStr            = dict!.objectForKey("noncestr") as! String//[dict objectForKey:@"noncestr"];
            
            req.package             = dict!.objectForKey("package") as! String //[dict objectForKey:@"package"];
            req.sign                = dict!.objectForKey("sign") as! String //[dict objectForKey:@"sign"];
            
            var sec = NSNumberFormatter().numberFromString(stamp)!.integerValue
            req.timeStamp           = UInt32(sec)
            WXApi.sendReq(req)
            
            //NSLog("appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,req.timeStamp,req.package,req.sign );
            
            
        }else{
            //错误提示
            NSLog("获取失败")
            //var debug =  req.getDebugifo
            //NSLog("\(debug)")
            ProgressHUD.showError("支付失败")
           
        }
        
        
        
    }
    
    /**
    支付成功后删除对应模型中的数据
    
    - parameter orderNum: <#orderNum description#>
    */
    func removeModelDataAccordingToOrderNum(orderNum:String){
        for var i = 0 ; i < self.orderModel.data.count ; i++ {
            if orderNum == self.orderModel.data[i].orderno {
                self.orderModel.data.removeAtIndex(i)
                break
            }
        }
    }
    
    /**
    货到付款
    */
    func payWithHuoDaoFuKuan(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var url = serversBaseURL + "/pay/delivery"
        var userid = currentRoleInfomation.keyid
        
        let parameters = ["userid":userid,"usertype":usertype,"orderno":order,"payway":"2"]
        
        if netIsavalaible {
        Alamofire.request(.POST,url,parameters: parameters).responseString{ (request, response, data, error) in
            //            NSLog("error = \(error)")
            NSLog("request = \(request)")
            //            NSLog("data = \(data)")
            //self.tableView.mj_header.endRefreshing()
            var json = self.StringToJSON(data!)
            NSLog("json = \(json)")
            if json["success"].stringValue ==  "false" {
                ProgressHUD.showError(json["message"].stringValue)
                
            }else{
                ProgressHUD.showSuccess(json["message"].stringValue)
                //根据订单号移除对应模型里面的数据
                self.removeModelDataAccordingToOrderNum(order)
                self.tableView.reloadData()
            }
            
            
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    /**
    赊呗支付
    */
    
    
    /**
    用户的赊呗功能开启、额度剩余
    */
    func payWithSheBei(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var url = serversBaseURL + "/member/credit"
        
        let parameters = ["adminkeyid":currentRoleInfomation.keyid]
        
        if netIsavalaible {
        
        Alamofire.request(.GET,url,parameters: parameters).responseString{ (request, response, data, error) in
            //            NSLog("error = \(error)")
            NSLog("request = \(request)")
            //            NSLog("data = \(data)")
            //self.tableView.mj_header.endRefreshing()
            var json = self.StringToJSON(data!)
            NSLog("json = \(json)")
            if json["success"].stringValue ==  "false" {
                
            }else{
                
                /// 信用额度
                var creditAvailable =  json["data"]["creditAvailable"].stringValue
                
                /**
                *  检测额度是否够用
                */
                var usrCredit = NSNumberFormatter().numberFromString(creditAvailable)!.doubleValue //用户额度
                var currentGoodsPrice = NSNumberFormatter().numberFromString(payprice)!.doubleValue  //当前商品总价
                
                if json["data"]["creditStatus"].stringValue == "true" {//有额度且开通且额度购用情况下，可以进行支付
                    if usrCredit >= currentGoodsPrice {//额度购支付
                        self.usePayWithSheBei(order, payprice: payprice, payWay: payWay, usertype: usertype)
                    }else{
                        var alert = UIAlertView(title: "提示", message: "你的爽购额度不够支付该笔订单，请多多消费提升爽购额度", delegate: nil, cancelButtonTitle: "确定")
                        
                        alert.show()
                        
                    }
                    
                    
                    
                }else{//还没有开通
                    var alert = UIAlertView(title: "提示", message: "打我们的客服电话去开通爽购吧", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }
            }
        }
        }else{
            netIsEnable("网络不可用")
        }
        
        
    }
    
    func usePayWithSheBei(order:String,payprice:String,payWay:GoodsPayWay,usertype:String){
        
        var url = serversBaseURL + "/pay/creditr"
        var username = currentRoleInfomation.adminid
        
        
        let parameters = ["username":username,"orderno":order,"payprice":payprice]
        
        if netIsavalaible {
        
        Alamofire.request(.POST,url,parameters: parameters).responseString{ (request, response, data, error) in
            
            NSLog("request = \(request)")
            
            var json = self.StringToJSON(data!)
            NSLog("json = \(json)")
            if json["success"].stringValue ==  "false" {
                ProgressHUD.showError(json["message"].stringValue)
            }else{
                ProgressHUD.showSuccess(json["message"].stringValue)
                //根据订单号移除对应模型里面的数据
                self.removeModelDataAccordingToOrderNum(order)
                self.tableView.reloadData()
            }
            
            
        }
        }else{
            netIsEnable("网络不可用")
        }
    }
    
    
    
    
    
    
    /**
    模型数据改变了，控制器进行出现刷新界面
    */
    func orderModelChanged() {
        
        
        self.tableView.reloadData()
        
        
        
        //导航栏标题
        var title = orderModel.navigationShowTitle()
        NSLog("navigationItem.title = \(title)")
        self.title = title
        
    }
}




