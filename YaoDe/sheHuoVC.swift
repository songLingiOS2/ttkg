//
//  OrderInfoVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/12.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import SnapKit
import Alamofire

class sheHuoVC: UIViewController,UITableViewDataSource,UITableViewDelegate ,OrderFooterViewDelegate,OrderHeaderViewDelegate{
    
    var http = ShoppingHttpReq.sharedInstance
    //订单数据
    var orderInfoArry = [OrderInfo]()
    //对应订单下面的所有商品信息
    var orderDetailDic:[String:[OrderDetail]] =  [String:[OrderDetail]]()
    
    
    
    
    
    
    @IBOutlet var orderClassSegment: UISegmentedControl!
    
    var scidArry = [String]()//购物车SCID数组
    
    //底部视图
    
    
    
    @IBOutlet var orderTableView: UITableView!
    
    
    
    var whichClassOrder = 0 {
        
        didSet{
            
            
            
            ProgressHUD.show("数据请求中...")
            switch(whichClassOrder){
            case 0 ://全部订单
                http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "0", status: "0", CurrentPage: "1", PageSize: "100")
                break
            
            case 1 ://待发货 待发货： IsWaybill=1 status=2
                http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "1", status: "0", CurrentPage: "1", PageSize: "100")
                break
            case 2 : //待签收 待签收： IsWaybill=2 status=2
                http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "2", status: "0", CurrentPage: "1", PageSize: "100")
                break
            case 3://已签收 已签收： IsWaybill=3 status=2
                http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "3", status: "0", CurrentPage: "1", PageSize: "100")
            default:
                break
            }

            
        }
    }
    @IBAction func orderClassSegmentClk(sender: UISegmentedControl) {
        var numSelect = sender.selectedSegmentIndex
        whichClassOrder = numSelect
        
        
        NSLog("numSelect = \(numSelect)"    )
    }
    
    
    func pullDownRefresh(){
        if netIsavalaible {
        NSLog("下拉刷新")
        switch(whichClassOrder){
        case 0 ://全部订单
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "0", status: "2", CurrentPage: "1", PageSize: "100")
            break
       
        case 1 ://待发货 待发货： IsWaybill=1 status=2
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "1", status: "2", CurrentPage: "1", PageSize: "100")
            break
        case 2 : //待签收 待签收： IsWaybill=2 status=2
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "2", status: "2", CurrentPage: "1", PageSize: "100")
            break
        case 3://已签收 已签收： IsWaybill=3 status=2
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "3", status: "2", CurrentPage: "1", PageSize: "100")
        default:
            break
        }
        }else{
            netIsEnable("网络不可用")
            orderTableView.mj_header.endRefreshing()
        }
        
    }
    
    //上拉加载更多
    func loadMoreData(){
        if netIsavalaible {
        NSLog("上拉加载更多")
        //1、获取当前订单数组长度
        var orderLength = ( orderDetailDic.count  / 10 ) * 10  +  10 //订单数
        var endNum = String(orderLength)
        
        switch(whichClassOrder){
        case 0 ://全部订单
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "0", status: "0", CurrentPage: "1", PageSize: "100")
            break
        
        case 1 ://待发货 待发货： IsWaybill=1 status=2
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "1", status: "2", CurrentPage: "1", PageSize: "100")
            break
        case 2 : //待签收 待签收： IsWaybill=2 status=2
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "2", status: "2", CurrentPage: "1", PageSize: "100")
            break
        case 3://已签收 已签收： IsWaybill=3 status=2
            http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "3", status: "2", CurrentPage: "1", PageSize: "100")
        default:
            break
        }

        }else{
            netIsEnable("网络不可用")
            orderTableView.mj_footer.endRefreshing()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //去掉间距
        self.automaticallyAdjustsScrollViewInsets = false
        
        /*****************************************************************************************/
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        /************************************下拉刷新*****************************************************/
        orderTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        orderTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("loadMoreData"))
        /*****************************************************************************************/
        
        //注册cell
        orderTableView.registerNib(UINib(nibName: "OrderInfoCell", bundle: nil), forCellReuseIdentifier: "OrderInfoCell")
        
        //getAllOrderInfoReq //全部订单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getAllOrderInfoReqProcess:"), name: "getAllOrderInfoReq", object: nil)
        
        //getWaitToDeliverOrderInfoReq//待发货
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getAllOrderInfoReqProcess:"), name: "getWaitToDeliverOrderInfoReq", object: nil)
        //getWaitToSignInOrderInfoReq//待收货
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getAllOrderInfoReqProcess:"), name: "getWaitToSignInOrderInfoReq", object: nil)
        
        //cancelOrderReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("cancelOrderReqProcess:"), name: "cancelOrderReq", object: nil)
        //deleteOrderReq删除订单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("deleteOrderReqProcess:"), name: "deleteOrderReq", object: nil)
        
        //aliPayResultReq
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("aliPayResultReqOrderProcess:"), name: "aliPayResultReqOrderShowVC", object: nil)
        
        //getConfirmOrderInfo 已签收
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getConfirmOrderInfoProcess:"), name: "getConfirmOrderInfo", object: nil)
        
        
    }
    
    
    
    //取消通知订阅
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.sharedImageCache().clearMemory()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return orderInfoArry.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var orderNum = orderInfoArry[section].orderno //订单号
        return orderDetailDic[orderNum]!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderInfoCell") as! OrderInfoCell
        var orderNum = orderInfoArry[indexPath.section].orderno
        var orderDetailTemp:[OrderDetail] = orderDetailDic[orderNum]!
        cell.setOrderInfo = orderDetailTemp[indexPath.row]
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var orderFooterView = NSBundle.mainBundle().loadNibNamed("OrderFooterView", owner: nil, options: nil).last as! OrderFooterView
        var orderNum = orderInfoArry[section].orderno
        //NSLog("orderNum = \(orderNum)")
        var setOrderDetail:[OrderDetail] = orderDetailDic[orderNum]!
        
        //订单简介
        orderFooterView.orderInfo = orderInfoArry[section]
        //订单下所有商品详情
        orderFooterView.setOrderDetail = setOrderDetail //商品详情
        orderFooterView.allProductPrice = orderInfoArry[section].money //订单总价（应付）
        orderFooterView.actualProductsPrice = orderInfoArry[section].acutualmoney //订单总价（应付）
        
        
        //显示赠品或留言查看按钮
        if orderInfoArry[section].remark != "无" && orderInfoArry[section].remark != ""{
            orderFooterView.havePresent(true,remark: orderInfoArry[section].remark)
        }else{
            orderFooterView.havePresent(false,remark: orderInfoArry[section].remark)
        }
        
        orderFooterView.orderStatus = orderState(orderState: self.orderInfoArry[section].status, payway: self.orderInfoArry[section].payway,isWayBill:self.orderInfoArry[section].iswaybill) //订单状态
        orderFooterView.tag = section
        orderFooterView.delegate = self
        return  orderFooterView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var orderHeaderView = NSBundle.mainBundle().loadNibNamed("OrderHeaderView", owner: nil, options: nil).last as! OrderHeaderView
        orderHeaderView.name.text = self.orderInfoArry[section].shopname //订单号对应的商家名称
        orderHeaderView.orderState.text = orderState(orderState: self.orderInfoArry[section].status, payway: self.orderInfoArry[section].payway,isWayBill:self.orderInfoArry[section].iswaybill) //订单状态
        orderHeaderView.tag = section
        orderHeaderView.delegate = self
        orderHeaderView.selectedBtnState = self.orderInfoArry[section].orderSelectedState
        
        if whichClassOrder != 1 {//在全部订单显示页面，不显示每个商家tableview的头的选中按钮
            orderHeaderView.selectCurrentBtn.hidden = true
        }else{
            orderHeaderView.selectCurrentBtn.hidden = true //暂时不支持多订单支付
            //orderHeaderView.selectCurrentBtn.hidden = false
        }
        
        
        
        return orderHeaderView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.title = "我的赊货订单"
        
        
        
        ProgressHUD.show("数据请求中...")
        http.getAllOrderInfo(usertype: "1", payway: "3", userid: currentRoleInfomation.keyid, IsWaybill: "0", status: "0", CurrentPage: "1", PageSize: "100")
        
        
        orderClassSegment.selectedSegmentIndex = whichClassOrder
    }
    
    
    
    
}

extension sheHuoVC{
    
    func getAllOrderInfoReqProcess(sender:NSNotification){
        
        self.orderTableView.mj_header.endRefreshing()
        self.orderTableView.mj_footer.endRefreshing()
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            
            //清空当前订单数据
            orderDetailDic = [:]
            orderInfoArry = []
            
            if "true" == dataTemp["success"].stringValue {
                NSLog("获取到全部订单信息")
                var message = dataTemp["message"].stringValue
                ProgressHUD.showSuccess(message)
                //获取数据进行填充
                var data = dataTemp["data"]["list"]
                NSLog("data = \(data)")
                for(var cnt = 0 ; cnt < data.count ; cnt++ ){
                    var orderInfoTemp = data[cnt]
                    var orderInfomation = OrderInfo()
                    orderInfomation.shopid = orderInfoTemp["shopid"].stringValue
                    orderInfomation.status = orderInfoTemp["status"].stringValue
                    orderInfomation.payway = orderInfoTemp["payway"].stringValue
                    orderInfomation.iswaybill = orderInfoTemp["IsWaybill"].stringValue
                    orderInfomation.orderno = orderInfoTemp["orderno"].stringValue
                    orderInfomation.integral = orderInfoTemp["totalprice"].stringValue
                    orderInfomation.acutualmoney = orderInfoTemp["paidAmount"].stringValue
                    orderInfomation.shopname = orderInfoTemp["shopname"].stringValue
                    orderInfomation.orderid = orderInfoTemp["orderid"].stringValue
                    
                    
                    //添加订单信息
                    orderInfoArry.append(orderInfomation)
                    
                    //获取订单下所有商品详细信息
                    var  orderdetail = orderInfoTemp["item"]
                    
                    var orderDetailArryTemp = [OrderDetail]()
                    
                    for(var i = 0 ; i < orderdetail.count ; i++ ){
                        var orderDetailTemp = OrderDetail()
                        var dataTemp  = orderdetail[i]
                        orderDetailTemp.imgurl = dataTemp["imageUrl"].stringValue
                        NSLog("orderDetailTemp.imgurl  = \(orderDetailTemp.imgurl )")
                        orderDetailTemp.price = dataTemp["price"].stringValue
                        orderDetailTemp.pname = dataTemp["productTitle"].stringValue
                        orderDetailTemp.num = dataTemp["number"].stringValue
                        orderDetailTemp.MerchantPriceID = dataTemp["MerchantPriceID"].stringValue
                        //买满多少件送多少件什么
                        orderDetailTemp.detail_remark = dataTemp["detail_remark"].stringValue
                        orderDetailArryTemp.append(orderDetailTemp)
                    }
                    //保存订单下的所有商品信息
                    orderDetailDic[orderInfomation.orderno] = orderDetailArryTemp
                    
                }
            }else{
                ProgressHUD.showError("亲~你的订单还没有产生哦!!!")
            }
            
            orderTableView.reloadData()
        }else{
            ProgressHUD.showError("亲~获取订单数据出错了")
        }
    }
    
    //订单状态返回
    func orderState(#orderState:String,payway:String,isWayBill:String)->String{
        var numState = ""
        switch(orderState){
        case "2" :
            numState = "已支付"
        case "1" :
            numState = "未支付"
        case "3" :
            numState = "已退款"
        default :
            numState = "其他状态"
        }
        
        
        
        if numState == "已支付" {
            switch(isWayBill){
            case "1":
                numState = "待出库"
            case "2":
                numState = "配送中"
            case "3":
                numState = "已签收"
            default:
                break
            }
            numState = "爽购付款" + "("  + numState + ")"
        }
        
       
        
        return numState
    }
    
    
    
    //订单按钮响应
    func footerViewBtnClk(#actionName: String, whichSection: Int) {
        NSLog("\(actionName) 第\(whichSection)Section")
        if actionName == "留言信息" {
            let remark = orderInfoArry[whichSection].remark
            var alart = UIAlertView(title: "留言信息", message: remark, delegate: nil, cancelButtonTitle: "确定")
            alart.show()
            
        }
        
        if actionName == "取消订单" {//取消订单
            http.cancelOrder(orderno: orderInfoArry[whichSection].orderno)
        }else if actionName == "删除订单" {//取消订单
            http.deleteOrder(orderno: orderInfoArry[whichSection].orderno)
        }else if actionName == "付款" {//付款
            NSLog("付款 = \(orderInfoArry[whichSection].orderno)")
            var alertController = UIAlertController(title: "提示", message: "请选择支付方式", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var productName:[OrderDetail] = orderDetailDic[self.orderInfoArry[whichSection].orderno]!
            var pname = productName[0].pname
            
            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
            var deleteAction = UIAlertAction(title: "支付宝支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("支付宝支付")
                //调起支付宝进行支付
                let clientType = "&clientdevicetype=iOS"
                var  notifyUrl = serversBaseURL + "/fp/order/paycallback?op=\(self.orderInfoArry[whichSection].orderno)&scid=-1" + clientType
                
                var amount = self.orderInfoArry[whichSection].acutualmoney
                payforUseAlipay(tradeNO: self.orderInfoArry[whichSection].orderno, productName: pname, productDescription: pname, amount:amount , notifyURL: notifyUrl, whoAreYou: "OrderShowVC")
                
                
            } )
            var archiveAction = UIAlertAction(title: "微信支付", style: UIAlertActionStyle.Destructive, handler: {(Void) in  NSLog("微信支付")
                
                //调起微信进行支付--------http://58.16.130.50:88/fp/order/wxpaycallback?params={"op":"2015001,2015002,...2015099","scid":"1,2,3,4,...99"}
                //var  notifyUrl = "http://58.16.130.50:88/fp/order/wxpaycallback?params={\"op\":\"\(self.orderInfoArry[whichSection].orderno)\",\"scid\":\"-1\"}"
                
                var  notifyUrl = serversBaseURL + "/fp/order/wxpaycallback?params={\"op\":\"\(self.orderInfoArry[whichSection].orderno)\",\"scid\":\"-1\",\"clientdevicetype\"=\"iOS\"}"
                
                
                
                var scidString = ""
                for(var cnt = 0 ; cnt < self.scidArry.count ; cnt++ ){
                    NSLog("scidArry[\(cnt)] = \(self.scidArry[cnt])")
                    
                    if scidString.length != 0{
                        scidString += "," + self.scidArry[cnt]
                    }else{
                        scidString = self.scidArry[cnt]
                    }
                    
                }
                
                NSLog("notifyUrl = \(notifyUrl)")
                var amount = self.orderInfoArry[whichSection].acutualmoney
                
                var price =  NSNumberFormatter().numberFromString(amount)!.doubleValue * 100
                NSLog("self.orderInfoArry[whichSection].name = \(self.orderInfoArry[whichSection].name)")
                
                //srand( (unsigned)time(0) );
                //NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
                
                var  timeTemp = time(nil)
                NSLog("name = \(self.orderInfoArry[whichSection].name)" )
                
                weiXinPay(tradeNO:timeTemp.description , productName:pname, productDescription:pname, amount: Int(price).description, notifyURL: notifyUrl, whoAreYou: "OrderShowVC")
                
            } )
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            alertController.addAction(archiveAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else if actionName == "签收" {
            
            NSLog("待签收\(self.orderInfoArry[whichSection].orderno)")
            
            
            
            let confirmGoodsUrl = serversBaseURL + "/orders/conform"
            let parameters = ["userid":currentRoleInfomation.keyid,"orderno":self.orderInfoArry[whichSection].orderno,"usertype":"1"]
            let data = JSON(parameters)
            let dataString = data.description
            let para = ["orderinfo":dataString]
            
            if netIsavalaible {
            
            Alamofire.request(.POST,confirmGoodsUrl,parameters: para).responseString { (request, response, data, error) in
                if error != nil {
                    serverIsAvalaible()
                }
                
                NSLog("\(data )")
                var datatemp = JSON(data!)
                
                let result = datatemp.description
                NSLog("result = \(result)")
                
                var resultTemp = StringToJSON(result)
                NSLog("resultTemp = \(resultTemp)")
                
                if "true" == resultTemp["success"].stringValue {
                    var message = resultTemp["success"].stringValue
                    
                    ProgressHUD.showSuccess(message)
                    self.whichClassOrder = 3
                    
                    ProgressHUD.dismiss()
                }
            }
            
            }else{
                netIsEnable("网络不可用")
            }
            
        }
        
    }
    
    ////支付宝状态标记（支付结果显示）
    func aliPayResultReqOrderProcess(sender:NSNotification){
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            var resultStatus = dataTemp["resultStatus"].stringValue
            if resultStatus == "9000" {
                var alart = UIAlertView(title: "提示", message: "该订单支付成功", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
                self.navigationController?.popViewControllerAnimated(false)
            }else if resultStatus == "6001" {
                var alart = UIAlertView(title: "提示", message: "该订单未支付成功", delegate: nil, cancelButtonTitle: "确定")
                alart.show()
            }
            
        }
        
    }
    
    
    
    func selectHeaderBtn(#num: Int) {
        NSLog("选中了订单号: \(orderInfoArry[num].orderno)")
        if orderInfoArry[num].orderSelectedState {
            orderInfoArry[num].orderSelectedState = false
        }else{
            orderInfoArry[num].orderSelectedState = true
        }
        //是否显示底部view
        if manyOrderSelect(orderInfoArry: orderInfoArry) {
            
        }else{
            
        }
        
        orderTableView.reloadData()
    }
    
    //调出底部批量提交view
    func manyOrderSelect(#orderInfoArry:[OrderInfo])->Bool{
        if orderClassSegment.selectedSegmentIndex == 1{
            for(var cnt = 0 ; cnt < orderInfoArry.count ; cnt++ ){
                if orderInfoArry[cnt].orderSelectedState {
                    return true
                }
            }
            
        }
        return false
    }
    
    
    //取消订单
    func cancelOrderReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            
            if "100" == dataTemp["result"].stringValue {
                NSLog("取消订单成功")
                whichClassOrder = orderClassSegment.selectedSegmentIndex
            }
        }
        
    }
    
    //订单删除
    func deleteOrderReqProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            if "100" == dataTemp["result"].stringValue {
                NSLog("删除订单成功")
                whichClassOrder = orderClassSegment.selectedSegmentIndex
            }
        }
    }
    
    //确认签收
    func getConfirmOrderInfoProcess(sender:NSNotification){
        self.orderTableView.mj_header.endRefreshing()
        self.orderTableView.mj_footer.endRefreshing()
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            
            //清空当前订单数据
            orderDetailDic = [:]
            orderInfoArry = []
            
            if "100" == dataTemp["result"].stringValue {
                NSLog("获取到全部订单信息")
                ProgressHUD.showSuccess("获取到订单数据")
                //获取数据进行填充
                var data = dataTemp["data"]
                NSLog("data = \(data)")
                for(var cnt = 0 ; cnt < data.count ; cnt++ ){
                    var orderInfoTemp = data[cnt]
                    var orderInfomation = OrderInfo()
                    
                    
                    if ("2" == orderInfoTemp["status"].stringValue && "3" == orderInfoTemp["iswaybill"].stringValue) || ("2" == orderInfoTemp["payway"].stringValue && "3" == orderInfoTemp["iswaybill"].stringValue) {
                        
                        
                        
                        orderInfomation.contacttel = orderInfoTemp["contacttel"].stringValue
                        orderInfomation.iswaybill = orderInfoTemp["iswaybill"].stringValue
                        orderInfomation.money = orderInfoTemp["money"].stringValue
                        orderInfomation.shopname = orderInfoTemp["shopname"].stringValue
                        orderInfomation.deduct = orderInfoTemp["deduct"].stringValue
                        orderInfomation.display = orderInfoTemp["display"].stringValue
                        orderInfomation.postcode = orderInfoTemp["postcode"].stringValue
                        orderInfomation.orderno = orderInfoTemp["orderno"].stringValue
                        orderInfomation.creattime = orderInfoTemp["creattime"].stringValue
                        orderInfomation.payway = orderInfoTemp["payway"].stringValue
                        orderInfomation.shopid = orderInfoTemp["shopid"].stringValue
                        orderInfomation.address = orderInfoTemp["address"].stringValue
                        
                        orderInfomation.remark = orderInfoTemp["remark"].stringValue
                        orderInfomation.finishtime = orderInfoTemp["finishtime"].stringValue
                        orderInfomation.integral = orderInfoTemp["integral"].stringValue
                        orderInfomation.name = orderInfoTemp["name"].stringValue
                        orderInfomation.status = orderInfoTemp["status"].stringValue
                        orderInfomation.acutualmoney = orderInfoTemp["acutualmoney"].stringValue
                        //添加订单信息
                        orderInfoArry.append(orderInfomation)
                        
                        
                        NSLog(" orderInfoArry ==\(orderInfoArry)")
                        
                        //获取订单下所有商品详细信息
                        var  orderdetail = orderInfoTemp["orderdetail"]
                        
                        var orderDetailArryTemp = [OrderDetail]()
                        
                        for(var i = 0 ; i < orderdetail.count ; i++ ){
                            var orderDetailTemp = OrderDetail()
                            var dataTemp  = orderdetail[i]
                            orderDetailTemp.imgurl = dataTemp["imgurl"].stringValue
                            NSLog("orderDetailTemp.imgurl  = \(orderDetailTemp.imgurl )")
                            orderDetailTemp.price = dataTemp["price"].stringValue
                            orderDetailTemp.keyid = dataTemp["keyid"].stringValue
                            orderDetailTemp.pname = dataTemp["pname"].stringValue
                            orderDetailTemp.num = dataTemp["num"].stringValue
                            orderDetailTemp.orderno = dataTemp["orderno"].stringValue
                            orderDetailTemp.pdid = dataTemp["pdid"].stringValue
                            orderDetailArryTemp.append(orderDetailTemp)
                        }
                        //保存订单下的所有商品信息
                        orderDetailDic[orderInfomation.orderno] = orderDetailArryTemp
                        
                    }
                    
                    
                }
            }
            
            orderTableView.reloadData()
        }else{
            ProgressHUD.showError("亲~获取订单数据出错了")
        }
        
        
    }
    
    
    
}
