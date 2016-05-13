//
//  MerchantDetailVC.swift
//
//
//  Created by yd on 16/3/22.
//
//

import UIKit
import Alamofire
import SwiftyJSON

struct ShopDetailInfo {
    
    var refreshFlag = FefreshFlag.pullDown
    
    var currentpage = ""
    var pagesize = ""
    var list = [GoodList]()
    
}

struct GoodList {
    var  AdminKeyID = ""
    var  pictureURL = ""
    var  title = ""
    var MinPrice = ""
    var  ProductKeyID = ""
    var  salesvolume = ""
    var shopname = ""
    var IsGivestate = ""
}






class MerchantDetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,NavigationLeftViewDelegate{
    
    var adminkid = " "//商家kid
    
    var shopImageUrl = "" //商家图片
    
    
    var collectionView : UICollectionView?
    
    
    var shopDetailInfo = ShopDetailInfo(){
        didSet{
            self.collectionView!.reloadData()
        }
    }
    
    
    
    
    var titleView = NavigationLeftView.loadFromNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.show("")
        
        getGoodsInfo(adminkid, roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: "1")
        
        
        titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width/2, height: 30)
        
        titleView.delegate = self
        titleView.searchBtn.setTitle("搜索", forState: UIControlState.Normal)
        titleView.backgroundColor = UIColor.clearColor()
        
        titleView.searchBtn.layer.masksToBounds = true
        titleView.searchBtn.layer.borderWidth = 1
        titleView.searchBtn.layer.cornerRadius = 3
        titleView.searchBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        self.navigationItem.titleView = titleView
        //右侧分类按钮
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分类", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("scanBtnClk"))
        
        var layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH , height: SCREEN_HEIGHT),collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        self.collectionView!.registerNib(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        //注册一个cell
        collectionView?.registerClass(MerchantHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        //        self.collectionView?.registerClass(MerchantDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: nil)
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("pullDownRefresh"))
        self.collectionView?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("pullUpRefresh"))
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
    
    deinit{
        ProgressHUD.dismiss()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    //下拉刷新
    func pullDownRefresh(){
        if netIsavalaible {
        shopDetailInfo.refreshFlag = .pullDown //标记为下拉刷新
        getGoodsInfo(adminkid, roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: "1")
        }else{
            netIsEnable("网络不可用")
            self.collectionView!.mj_header.endRefreshing()
        }
    }
    
    //获取更多
    func pullUpRefresh(){
        if netIsavalaible {
        shopDetailInfo.refreshFlag = .pullUp //标记为下拉刷新
        
        var Flag = false
        //1、判断当前页面有数据，且是10的倍数
        if ((shopDetailInfo.list.count) != 0) && (shopDetailInfo.list.count%10 == 0) {
            Flag = true
        }else{
            Flag = false
        }
        
        //2、确认请求页面是第几页
        if Flag{
            var pageNum = shopDetailInfo.list.count/10
            
            getGoodsInfo(adminkid, roleid: currentRoleInfomation.roleid, pagesize: "10", currentpage: (pageNum + 1).description)
            
        }else{
            ProgressHUD.showError("没有更多数据了")
            self.collectionView!.mj_footer.endRefreshing()
        }
        }else{
            netIsEnable("网络不可用")
            self.collectionView!.mj_footer.endRefreshing()
        }
        
    }
    
    func getGoodsInfo(adminkeyid:String,roleid:String,pagesize:String,currentpage:String){
        
        self.collectionView?.mj_header.endRefreshing()
        self.collectionView?.mj_footer.endRefreshing()
        
        
        let url = serversBaseURL  + "/product/member"
        
        let parameters = ["adminkeyid":adminkeyid,"roleid":roleid,"pagesize":pagesize,"currentpage":currentpage]
        
        
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        
        NSLog("para = \(para.description)")
        
        ProgressHUD.show("")
        if netIsavalaible {
        Alamofire.request(.GET,url,parameters: para).responseString{ (request, response, data, error) in
            NSLog("request = \(request)")
            
            var json = self.StringToJSON(data!)
            NSLog("json = \(json)")
            var message = json["message"].stringValue
            if "true" == json["success"].stringValue {
                var shopDetailInfoTemp = ShopDetailInfo()
                var dataTemp = json["data"]
                shopDetailInfoTemp.currentpage = dataTemp["currentpage"].stringValue
                var  lists = [GoodList]()
                for var i = 0 ; i < dataTemp["list"].count ; i++ {
                    var listTemp = GoodList()
                    var dataA = dataTemp["list"][i]
                    listTemp.AdminKeyID = dataA["AdminKeyID"].stringValue
                    listTemp.pictureURL = dataA["pictureURL"].stringValue
                    listTemp.title = dataA["title"].stringValue
                    listTemp.MinPrice = dataA["MinPrice"].doubleValue.description
                    listTemp.ProductKeyID = dataA["ProductKeyID"].stringValue
                    listTemp.salesvolume = dataA["salesvolume"].stringValue
                    listTemp.shopname = dataA["shopname"].stringValue
                    listTemp.IsGivestate = dataA["IsGivestate"].stringValue
                    lists.append(listTemp)
                }
                
                if self.shopDetailInfo.refreshFlag == .pullDown {
                    shopDetailInfoTemp.list = lists
                    self.shopDetailInfo = shopDetailInfoTemp
                }else{
                    shopDetailInfoTemp.list = lists
                    self.shopDetailInfo.list += lists
                }
                
                
                ProgressHUD.showSuccess(message)
                
            }else{
                ProgressHUD.showError(message)
            }
            
            
            
            
            
        }
        }else{
            netIsEnable("网络不可用")
        }
        
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
        var  HeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headView", forIndexPath: indexPath) as! MerchantHeaderView
        
        NSLog("shopImageUrl=\(shopImageUrl)")
        HeaderView.imgHeader.sd_setImageWithURL(NSURL(string: shopImageUrl), placeholderImage: UIImage(named:"店铺详情_02" ))
        return HeaderView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        /// 获取表头的高
        var cgsize =  CGSize(width: screenWith, height: screenWith/2)
        
        return cgsize
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        FirstPageProductInfo
        NSLog("self.shopDetailInfo.list.count =\(self.shopDetailInfo.list.count)")
        return self.shopDetailInfo.list.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FirstPageProductInfo
        
        
        
        cell.layer.cornerRadius = 1.0;
        cell.layer.borderColor =  UIColor.grayColor().CGColor
        cell.layer.borderWidth = 0.5;
        cell.layer.masksToBounds = true
        
        cell.name.text =  self.shopDetailInfo.list[indexPath.row].title
        cell.price.text = "￥" + self.shopDetailInfo.list[indexPath.row].MinPrice
        cell.img.sd_setImageWithURL(NSURL(string: serversBaseUrlForPicture + self.shopDetailInfo.list[indexPath.row].pictureURL))
        cell.limitSellCnt.text = "已售:" + self.shopDetailInfo.list[indexPath.row].salesvolume
        cell.shopName.text = "[" + self.shopDetailInfo.list[indexPath.row].shopname + "]"
        
        if self.shopDetailInfo.list[indexPath.row].IsGivestate == "0" {
            cell.huodongImage.hidden = false
        }else{
            cell.huodongImage.hidden = true
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        
        
        
        var shopDetailVC = ShopingDetailVC()
        shopDetailVC.adminkeyid = self.shopDetailInfo.list[indexPath.row].AdminKeyID
        shopDetailVC.productkeyid = self.shopDetailInfo.list[indexPath.row].ProductKeyID
        
        shopDetailVC.usertype = currentRoleInfomation.sptypeid
        shopDetailVC.userid = currentRoleInfomation.keyid
        
        self.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(shopDetailVC, animated:false)
    }
    
    
    //cell宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let screenWith = UIScreen.mainScreen().bounds.width
        
        var cgsize =  CGSize(width: screenWith/2 - 16, height: screenWith/2 + 50 )
        
        return cgsize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        /// collection 布局间距
        var edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return edge
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
//        ProgressHUD.show("数据加载中")
    }
    override func viewWillDisappear(animated: Bool) {
        
 
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



extension MerchantDetailVC {
    
    func locationBtnClk(){
        
    }
    func searchBtnClk(){
        NSLog("搜索按钮点击")
        var searchVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("SearchVC") as! SearchVC
        searchVC.shopInternal = true
        searchVC.shopID = adminkid
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    func scanBtnClk(){
        NSLog("点击了分类按钮")
        
        var classProductSelectVC = ClassGetMoreVC()
        classProductSelectVC.shopPush = true
        classProductSelectVC.shopID = adminkid
        self.navigationController?.pushViewController(classProductSelectVC, animated: false)
        
        
    }
    
    
    
}
