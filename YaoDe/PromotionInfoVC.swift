//
//  PromotionInfoVC.swift
//
//
//  Created by yd on 16/3/25.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

struct PromotionDetailInfo {
    var refreshFlag = FefreshFlag.pullDown
    var currentpage = ""
    var pagesize = ""
    var list = [PromotionList]()
    
}

struct PromotionList {
    var  AdminKeyID = ""
    var  pictureURL = ""
    var  title = ""
    var originalPrice = ""
    var MinPrice = ""
    var  ProductKeyID = ""
    var  salesvolume = ""
    var shopname = ""
    var promotionalPrice = ""
}






class PromotionInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var promotionDetailInfo = PromotionDetailInfo(){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "促销页面"
        
        self.view.backgroundColor  = UIColor.whiteColor()
        getPromotionGoodsInfo(currentRoleInfomation.areaid, roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: "1")
        
        tableView.frame = CGRect(x:0 ,y:0,width:screenWith,height:screenHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("pullUpRefresh"))
        
        tableView.registerClass(PromotionCell.self, forCellReuseIdentifier: "cellID")
        
        self.view.addSubview(tableView)
        
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        ProgressHUD.show("")
    }
    
    
    //下拉刷新
    func pullDownRefresh(){
        if netIsavalaible {
        promotionDetailInfo.refreshFlag = .pullDown //标记为下拉刷新
        getPromotionGoodsInfo(currentRoleInfomation.areaid, roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: "1")
        tableView.mj_header.endRefreshing()
        }else{
            netIsEnable("网络不可用")
            tableView.mj_header.endRefreshing()
        }
    }
    
    //获取更多
    func pullUpRefresh(){
        if netIsavalaible {
        promotionDetailInfo.refreshFlag = .pullUp //标记为下拉刷新
        
        var Flag = false
        //1、判断当前页面有数据，且是10的倍数
        if ((promotionDetailInfo.list.count) != 0) && (promotionDetailInfo.list.count%10 == 0) {
            Flag = true
        }else{
            Flag = false
        }
        
        //2、确认请求页面是第几页
        if Flag{
            var pageNum = promotionDetailInfo.list.count/10
            
            getPromotionGoodsInfo(currentRoleInfomation.areaid, roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: (pageNum + 1).description)
            
        }else{
            ProgressHUD.showError("没有更多数据了")
            self.tableView.mj_footer.endRefreshing()
        }
        }else{
            netIsEnable("网络不可用")
            self.tableView.mj_footer.endRefreshing()
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.promotionDetailInfo.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let attr = NSMutableAttributedString(string: "原价￥" + self.promotionDetailInfo.list[indexPath.row].originalPrice)
        let length = self.promotionDetailInfo.list[indexPath.row].originalPrice.length + 3
        attr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(integer: 1), range: NSMakeRange(2, length-2))
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as! PromotionCell
        cell.img.backgroundColor = UIColor.redColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let imgUrl = self.promotionDetailInfo.list[indexPath.row].pictureURL
        cell.img.sd_setImageWithURL(NSURL(string: serversBaseUrlForPicture + imgUrl))
        cell.oldPrice.text = "￥" + self.promotionDetailInfo.list[indexPath.row].originalPrice
        cell.oldPrice.attributedText = attr
        cell.oldPrice.sizeToFit()
        cell.sellCnt.text = "销量:" + self.promotionDetailInfo.list[indexPath.row].salesvolume
        
        cell.name.text = self.promotionDetailInfo.list[indexPath.row].title
        cell.shopName.text = self.promotionDetailInfo.list[indexPath.row].shopname
        cell.nowPrice.text = "￥" + self.promotionDetailInfo.list[indexPath.row].promotionalPrice
        cell.shopName.text = "[" + self.promotionDetailInfo.list[indexPath.row].shopname + "]"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SCREEN_WIDTH/3 + 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        var shopingDetailVC = ShopingDetailVC()
        shopingDetailVC.adminkeyid = self.promotionDetailInfo.list[indexPath.row].AdminKeyID
        shopingDetailVC.productkeyid = self.promotionDetailInfo.list[indexPath.row].ProductKeyID
        shopingDetailVC.userid = currentRoleInfomation.roleid
        self.navigationController?.pushViewController(shopingDetailVC, animated: false)
    }
    
    
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
    
    
    func showMessageAnimate(message:String){
        var HUD = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        
        HUD.mode = MBProgressHUDMode.Text
        HUD.label.text = message
        HUD.offset = CGPointMake(0.0, MBProgressMaxOffset);
        HUD.hideAnimated(true, afterDelay: 3)
    }
    
    func getPromotionGoodsInfo(areaid:String,roleid:String,pagesize:String,currentpage:String){
        
        
        
        
        
        let url = serversBaseURL  + "/product/promotional"
        
        let parameters = ["areaid":areaid,"roleid":roleid,"pagesize":pagesize,"currentpage":currentpage]
        
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        
        if netIsavalaible {
        
        Alamofire.request(.GET,url,parameters: para).responseString{ (request, response, data, error) in
            
            var json = self.StringToJSON(data!)
            NSLog("json = \(json)")
            var message = json["message"].stringValue
            
            self.showMessageAnimate(message)
            
            ProgressHUD.dismiss()
            if "true" == json["success"].stringValue {
                var promotionDetailInfoTemp = PromotionDetailInfo()
                var dataTemp = json["data"]
                promotionDetailInfoTemp.currentpage = dataTemp["currentpage"].stringValue
                var  lists = [PromotionList]()
                for var i = 0 ; i < dataTemp["list"].count ; i++ {
                    var listTemp = PromotionList()
                    var dataA = dataTemp["list"][i]
                    listTemp.AdminKeyID = dataA["AdminKeyID"].stringValue
                    listTemp.pictureURL = dataA["pictureURL"].stringValue
                    listTemp.title = dataA["title"].stringValue
                    listTemp.MinPrice = dataA["MinPrice"].doubleValue.description
                    listTemp.ProductKeyID = dataA["ProductKeyID"].stringValue
                    listTemp.salesvolume = dataA["salesvolume"].stringValue
                    listTemp.shopname = dataA["shopname"].stringValue
                    listTemp.originalPrice = dataA["originalPrice"].doubleValue.description
                    listTemp.promotionalPrice = dataA["promotionalPrice"].doubleValue.description
                    lists.append(listTemp)
                }
                
                
                
                
                
                if self.promotionDetailInfo.refreshFlag == .pullDown {
                    promotionDetailInfoTemp.list = lists
                    self.promotionDetailInfo = promotionDetailInfoTemp
                }else{
                    promotionDetailInfoTemp.list = lists
                    self.promotionDetailInfo.list += lists
                    self.tableView.mj_footer.endRefreshing()
                }
                
                
                
            }else{
                ProgressHUD.showError(message)
            }
            
            
            
            
            
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
