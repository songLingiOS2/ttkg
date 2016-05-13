//
//  FirstBuyProductDetailVC.swift
//  YaoDe
//
//  Created by iosnull on 16/1/19.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class FirstBuyProductDetailVC: UIViewController,SDCycleScrollViewDelegate {
    var http = ShoppingHttpReq.sharedInstance
    var product = Product()
    var imagesURLStrings = [String]()
    //滚动广告
    var sdCycleScrollView : SDCycleScrollView!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var price: UILabel!
    
    @IBOutlet var PdNum: UILabel! //规格
    
    @IBOutlet var HuoDongDetail: UILabel!
    
    @IBOutlet var shopName: UILabel!
    
    @IBOutlet var shopContactTel: UILabel!
    
    
    
    @IBAction func toBuyBtnClk(sender: AnyObject) {
        NSLog("我是新用户，我要买")
 
    }
    
    
    func setSubViewPara(){
        //adImageViewHeigth.constant = UIScreen.mainScreen().bounds.width/2
        //滚动广告轮播
        sdCycleScrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.width/2), imageURLStringsGroup: nil)
        
        sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        sdCycleScrollView.delegate = self
        //        sdCycleScrollView.titlesGroup = titles;
        sdCycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        //sdCycleScrollView.placeholderImage = UIImage(named: "logo")
        sdCycleScrollView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(sdCycleScrollView)
        
        contentViewHeight.constant = screenWith/2
        
    }

    /**
    滚动图片
    
    - parameter cycleScrollView: cycleScrollView description
    - parameter index:           index description
    */
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        
    }
    
    //获取当前商品的图片
    func getCurrentProductAllPicReqProcess(sender:NSNotification){
        ProgressHUD.dismiss()
        
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = JSON(sender.object!)
            NSLog("dataTemp = \(dataTemp)")
            
            if "100" == dataTemp["result"].stringValue{
                
                var dataArry = dataTemp["data"]
                
                imagesURLStrings = []
                
                for(var i = 0 ; i < dataArry.count ; i++) {
                    var dataA = dataArry[i]
                    var imageUrlTemp = ""
                    imageUrlTemp = serversBaseUrlForPicture + dataA["url"].stringValue
                    imagesURLStrings.append(imageUrlTemp)
                }
                
                if !imagesURLStrings.isEmpty {
                    self.sdCycleScrollView.imageURLStringsGroup = imagesURLStrings
                }else{
                    self.sdCycleScrollView.imageURLStringsGroup = [product.img_url]
                }
            }else{
                self.sdCycleScrollView.imageURLStringsGroup = [product.img_url]
                self.sdCycleScrollView.autoScroll = false
            }
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /**
        加载子视图
        */
        setSubViewPara()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getCurrentProductAllPicReqProcess:"), name: "getCurrentProductAllPicReq", object: nil)
        
        http.getCurrentProductAllPic(pdid: product.pd_keyid)
        
        name.text = "商品名称：" + product.p_title
        price.text = "商品价格：" + "￥" + product.pd_ptprice 
        PdNum.text = "规格：" + product.pd_spec
        
        HuoDongDetail.text  = "活动规则：\n\t  1，在要得100平台没有产生过线上交易的客户可参与次活动\n\t  2，本活动一个新用户只能参与一次\n\t  3，活动产品不累计订单不追加，一次只能购买一个产品 \n\t  4，购买成功的用户，平台将在3个工作日(72小时)内审核并发货\n\t  5，购买疑问请致电：05851-82222237"
        
        
        shopName.text = product.shop_name + "(商家名称)"
        
        if product.shop_contact != "" {
            shopContactTel.text = product.shop_contact
        }else{
            shopContactTel.text = "联系电话:0851-82222237"
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
