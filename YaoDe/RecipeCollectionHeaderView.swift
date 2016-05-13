//
//  RecipeCollectionHeaderView.swift
//  YaoDe
//
//  Created by iosnull on 15/12/3.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
@objc protocol RecipeCollectionHeaderViewDelegate{
    func classProductBtnClk(#row:Int)
    func limitTimeAdClk() //限时购页面
    func goLotteryBtnClk()//抽奖
    func goNewUsrBuyBtnClk()//新用户一元买
}

class RecipeCollectionHeaderView: UICollectionReusableView,SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{

    weak var delegate : RecipeCollectionHeaderViewDelegate?
    
    //分类种类
    var sortArry = [ClassProduct]() {
        didSet{
            NSLog("sortArry  : \(sortArry)")
            self.btnOfProductClass.reloadData()
        }
    }
    //分类产品按钮
    var btnOfProductClass:UICollectionView!
    //广告
    var shoppingAdArry = [ShoppingAD]()
    
    var refresh = false {
        didSet{
            
            imagesURLStrings = []
            for var cnt = 0 ; cnt < shoppingAdArry.count ; cnt++ {
                var imgUrl =  serversBaseUrlForPicture + shoppingAdArry[cnt].picurl
                imagesURLStrings.append(imgUrl)
            }
            
            NSLog("imagesURLStrings = \(imagesURLStrings)")
            
            sdCycleScrollView.imageURLStringsGroup = imagesURLStrings
           
            
            self.btnOfProductClass.reloadData()
        }
    }
    
    
    //滚动广告图片地址
    var imagesURLStrings:[String] = [String]()
    //滚动广告
    var sdCycleScrollView : SDCycleScrollView! = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: screenWith / 2), imageURLStringsGroup: nil)
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!){
        
        NSLog("sortArry  : \(sortArry)")
        self.backgroundColor = UIColor.whiteColor()
        //1滚动广告轮播
        sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        sdCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        sdCycleScrollView.delegate = self
        sdCycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        sdCycleScrollView.placeholderImage = UIImage(named: "园logo-01")
        
        self.addSubview(sdCycleScrollView)
        
        
        
        //2产品分类
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        btnOfProductClass = UICollectionView(frame: CGRect(x: 0, y: screenWith / 2 , width: screenWith, height: 2*((screenWith - 40)/4  + 5) + 25 ), collectionViewLayout: layout)
        
        self.addSubview(btnOfProductClass)
        btnOfProductClass.delegate = self
        btnOfProductClass.dataSource = self
        btnOfProductClass.collectionViewLayout.collectionView
        btnOfProductClass.backgroundColor = UIColor.whiteColor()
        btnOfProductClass.scrollEnabled = false
        
        //btnOfProductClass.layer.cornerRadius = 10.0;
        btnOfProductClass.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        btnOfProductClass.layer.borderWidth = 1.0;
        btnOfProductClass.layer.masksToBounds = true
        
        //注册cell
        btnOfProductClass.registerNib(UINib(nibName: "ClassProductCell", bundle: nil), forCellWithReuseIdentifier: "Collectioncell")
        
        
        //限时抢购
        var img = UIImageView(frame: CGRect(x: 0, y: screenWith / 2 + 2*((screenWith - 40)/4  + 5) + 25, width: UIScreen.mainScreen().bounds.width, height: screenWith/2))
        img.contentMode = UIViewContentMode.ScaleAspectFit
        img.backgroundColor = UIColor.clearColor()
        img.image = UIImage(named: "tj_home_img.jpg")
        
        self.addSubview(img)
        
        var limitButton = UIButton()
        limitButton.frame = img.frame
        
        NSLog("button.frame = \(limitButton.frame)")
        
        limitButton.addTarget(self, action: Selector("limitTimeBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(limitButton)
        
        
        
        /*
        var limitButton = UIButton()
        limitButton.frame = img.frame
        
        NSLog("button.frame = \(limitButton.frame)")
        
        limitButton.addTarget(self, action: Selector("limitTimeBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(limitButton)
        
        //去抽奖
        var goLotteryBtn = UIButton(frame: CGRect(x: 8, y: limitButton.frame.maxY+15, width: screenWith/2 - 16, height: screenWith/4))
        goLotteryBtn.addTarget(self, action: Selector("goLotteryBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        goLotteryBtn.setBackgroundImage(UIImage(named: "choujiang"), forState: UIControlState.Normal)
        
        goLotteryBtn.layer.masksToBounds = true
        goLotteryBtn.layer.borderWidth = 1
        goLotteryBtn.layer.cornerRadius = 10
        goLotteryBtn.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
        self.addSubview(goLotteryBtn)
        
        //新用户一元专区
        var goNewUsrBuyBtn = UIButton(frame: CGRect(x: screenWith/2 + 8, y: limitButton.frame.maxY+15, width: screenWith/2 - 16, height: screenWith/4))
        goNewUsrBuyBtn.addTarget(self, action: Selector("goNewUsrBuyBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        goNewUsrBuyBtn.setBackgroundImage(UIImage(named: "yiyuanqiang"), forState: UIControlState.Normal)
        
        goNewUsrBuyBtn.layer.masksToBounds = true
        goNewUsrBuyBtn.layer.borderWidth = 1
        goNewUsrBuyBtn.layer.cornerRadius = 10
        goNewUsrBuyBtn.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
        
        self.addSubview(goNewUsrBuyBtn)
*/
        
        
        //分割线
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
    }
    
    func goNewUsrBuyBtnClk(){
        NSLog("新用户1元买")
        delegate?.goNewUsrBuyBtnClk()
    }
    
    func goLotteryBtnClk(){
        NSLog("去抽奖")
        delegate?.goLotteryBtnClk()
    }
    
    func limitTimeBtnClk(){
        NSLog("去促销抢购页面")
        delegate?.limitTimeAdClk()
    }
    
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        NSLog("你点击了滚动广告\(index)")
        //方式广告点击通知
        NSNotificationCenter.defaultCenter().postNotificationName("FirstPageAdvertiseBtnClk", object: index)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortArry.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Collectioncell", forIndexPath: indexPath) as! ClassProductCell
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.cornerRadius = 10.0;
        cell.layer.borderColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
        cell.layer.borderWidth = 1.0;
        cell.layer.masksToBounds = true
        //cell.image.sd_setImageWithURL(NSURL(string:sortArry[indexPath.row].picurl ))
        
        cell.setClassProductShow = sortArry[indexPath.row]
        
        return cell
    }
    
    //cell 大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let screenWith = UIScreen.mainScreen().bounds.width
        //var cgsize =  CGSize(width: 80, height: 120)
        var cgsize =  CGSize(width: (screenWith - 40)/4 , height: (screenWith - 40)/4  + 5)
        return cgsize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        var edge = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return edge
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("你点击了\(sortArry[indexPath.row].title)")
        NSLog("sortArry  : \(sortArry)")
        delegate?.classProductBtnClk(row: indexPath.row)
    }
    
}
