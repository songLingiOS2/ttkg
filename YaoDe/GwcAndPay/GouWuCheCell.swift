//
//  GouWuCheCell.swift
//  YaoDe
//
//  Created by iosnull on 16/3/21.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

let headerHeigth = screenWith/8
class GouWuCheHeaderView: UIView {
    
    var shangJiaHuoDong = UILabel()
    var xiaoLaBaImg = UIImageView()
    
    //声明一个闭包
    private var selectedAll:GoodsClosure?
    //下面这个方法需要传入上个界面的postMessage函数指针
    func initWithClosure(closure:GoodsClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了postMessage函数中的局部变量等的引用
        selectedAll = closure
    }
    
    var actionOBJ:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    var img:UIImageView!
    var selectedAllGoodsBtn:UIButton
    var shopName:UILabel
    
    var enterShop:UIButton!
    
    var gotoThisShop:UIButton
    
    var selectedAllGoodsFlag = true {
        didSet{
            if selectedAllGoodsFlag {
                NSLog("你选中了该商家下的所有商品")
                img.image = UIImage(named: "che_sel")
            }else{
                img.image = UIImage(named: "che_nor")
                NSLog("你不会买该商家下的商品")
            }
        }
    }
    func selectedAllGoodsBtnClk(){
        
        if selectedAll != nil {
            selectedAll!(index: actionOBJ, name: GouWuCheViewAction.对该商家商品批量操作,cnt:0)
        }else{
            NSLog("传值有错误")
        }
        
    }
    
    func gotoThisShopBtnClk(){
        NSLog("去该商家进行购买")
        if selectedAll != nil {
            selectedAll!(index: actionOBJ, name: GouWuCheViewAction.进入该商家,cnt:0)
        }else{
            NSLog("传值有错误")
        }
        
        
    }
    
    override init(frame: CGRect) {
        
        
        img = UIImageView(frame: CGRect(x: 5, y: 3, width: headerHeigth - 6, height: headerHeigth - 6))
        self.selectedAllGoodsBtn = UIButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: headerHeigth))
        
        shopName = UILabel(frame: CGRect(x: img.frame.maxX, y: 3, width: screenWith - img.frame.maxX - 120, height: headerHeigth - 6))
        
        gotoThisShop = UIButton(frame: CGRect(x: screenWith - 120, y: 0, width: 120, height: headerHeigth))
        
        gotoThisShop.setTitle("进入商家", forState: UIControlState.Normal)
        gotoThisShop.setTitleColor(UIColor(red: 229/255, green: 70/255, blue: 80/255, alpha: 1), forState: UIControlState.Normal)
        
        shopName.text = "商家名称"
        shopName.textAlignment = NSTextAlignment.Left
        super.init(frame: frame)
        
        selectedAllGoodsBtn.addTarget(self, action: Selector("selectedAllGoodsBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        gotoThisShop.addTarget(self, action: Selector("gotoThisShopBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        img.image = UIImage(named: "che_sel")
        img.contentMode = UIViewContentMode.Left
        self.addSubview(selectedAllGoodsBtn)
        self.addSubview(img)
        self.addSubview(shopName)
        self.addSubview(gotoThisShop)
        self.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        
        
        self.addSubview(shangJiaHuoDong)
        self.addSubview(xiaoLaBaImg)
        xiaoLaBaImg.image = UIImage(named: "detailPageShopSay")
        xiaoLaBaImg.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(10)
            make.top.equalTo(img.snp_bottom).offset(2)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        shangJiaHuoDong.textColor = UIColor.redColor()
        shangJiaHuoDong.font = UIFont.systemFontOfSize(14)
        shangJiaHuoDong.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(xiaoLaBaImg.snp_right).offset(8)
            make.centerY.equalTo(xiaoLaBaImg.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-10)
            make.height.equalTo(28)
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GouWuCheFooterView:UIView {
    var spareView = UIView()
    
    var huoDong:UILabel //活动显示
    
    var shopWantToSay:UILabel
    var shouldGotoThisShop = true //应该去凑
    var gotoShopBtn:UIButton
    
    //声明一个闭包
    private var gotoShopBtnClosure:GoodsClosure?
    //下面这个方法需要传入上个界面的postMessage函数指针
    func initWithClosure(closure:GoodsClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了postMessage函数中的局部变量等的引用
        gotoShopBtnClosure = closure
    }
    
    var actionOBJ = NSIndexPath()
    
    func gotoShopBtnClk(){
        if gotoShopBtnClosure != nil {
            gotoShopBtnClosure!(index: actionOBJ, name: GouWuCheViewAction.进入该商家,cnt:0)
        }else{
            NSLog("传值有错误")
        }
    }
    
    //设置活动
    func setHuoDongInfo(text:String){
        var size = CGSize(width: screenWith, height: 500)
        var rect = getTextRectSize(text, font: UIFont.systemFontOfSize(14), size:size )
        
        //NSLog("size.height = \(size.height)")
        //shopWantToSay.backgroundColor = UIColor.redColor()
        huoDong.snp_updateConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(5)
            make.right.equalTo(self.snp_right)
            
            if shopWantToSay.text?.length != 0 {
                make.top.equalTo(shopWantToSay.snp_bottom)
            }else{
                make.top.equalTo(self.snp_top)
            }
            
            make.height.equalTo(rect.height)
        }
        
        
        huoDong.text = text
        huoDong.textColor = UIColor.redColor()
    }
    
    /*!
    根据内容设置显示高度
    - parameter text: text description
    */
    func setTextContenty(text:String){
        
        
        var size = CGSize(width: screenWith, height: 500)
        var rect = getTextRectSize(text, font: UIFont.systemFontOfSize(14), size:size )
        
        NSLog("size.height = \(size.height)")
        //shopWantToSay.backgroundColor = UIColor.redColor()
        shopWantToSay.snp_updateConstraints { (make) -> Void in
                        make.left.equalTo(self.snp_left).offset(5)
                        make.right.equalTo(self.snp_right)
                        make.top.equalTo(self.snp_top)
                        make.height.equalTo(rect.height)
        }
        
        
        shopWantToSay.text = text
        gotoShopBtn.frame = shopWantToSay.frame
        //NSLog("shopWantToSay.text = \(shopWantToSay.text)")
        //NSLog("shopWantToSay.frame = \(shopWantToSay.frame)")
    }
    
    func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        var attributes = [NSFontAttributeName: font]
        var option = NSStringDrawingOptions.UsesLineFragmentOrigin
        var rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        //        println("rect:\(rect)");
        return rect;
    }
    
    override init(frame: CGRect) {
        
        shopWantToSay = UILabel(frame: CGRect(x: 5, y: 0, width: screenWith, height: 21))
        shopWantToSay.numberOfLines = 0
        shopWantToSay.textAlignment = NSTextAlignment.Left
        
        
        huoDong = UILabel()
        huoDong.textAlignment = NSTextAlignment.Left
        huoDong.numberOfLines = 0
        huoDong.font = UIFont.systemFontOfSize(13)
        huoDong.textColor = UIColor.blackColor()//UIColor(red: 241/255, green: 170/255, blue: 1/255, alpha: 1)
        
        gotoShopBtn = UIButton(frame: CGRect(x: 0, y: 0, width: screenWith, height: 21))
        super.init(frame: frame)
        shopWantToSay.text = ""
        shopWantToSay.textColor = UIColor.blackColor()//UIColor(red: 241/255, green: 170/255, blue: 1/255, alpha: 1)
        //self.backgroundColor = UIColor(red: 220/255, green: 236/255, blue: 236/255, alpha: 1)
        //shopWantToSay.textAlignment = NSTextAlignment.Center
        shopWantToSay.font = UIFont.systemFontOfSize(13)
        
        gotoShopBtn.addTarget(self, action: Selector("gotoShopBtnClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(gotoShopBtn)
        self.addSubview(shopWantToSay)
        self.addSubview(huoDong)
        self.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)//UIColor(red: 254/255, green: 247/255, blue: 233/255, alpha: 1)
        
        self.addSubview(spareView)
        spareView.backgroundColor = UIColor.whiteColor()
        spareView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.bottom.equalTo(self.snp_bottom)
            make.height.equalTo(5)
            
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GouWuCheCell: UITableViewCell,UITextFieldDelegate {
    
    //声明一个闭包
    private var selectGoodsClosure:GoodsClosure?
    //下面这个方法需要传入上个界面的postMessage函数指针
    func initWithClosure(closure:GoodsClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了postMessage函数中的局部变量等的引用
        selectGoodsClosure = closure
    }
    
    
    //屏幕尺寸
    let screenWith = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var setSelectedBtn:UIButton?
    var img:UIImageView?
    var goodsTitle:UILabel?
    var oldPrice:UILabel?
    var nowPrice:UILabel?
    var cnt:UILabel?
    var numTextField:UITextField!
    
    var huoDong = UILabel()
    
    var removeGoods:UIButton?
    
    var erroCharaterCnt = 0
    var currentCnt = "1"
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        NSLog("string = \(string)")
        switch(string){
        case "0","1","2","3","4","5","6","7","8","9","":
            break;
        default:
            NSLog("character = \(string)")
            erroCharaterCnt++
            
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        NSLog("输入完成了")
        if erroCharaterCnt == 0 {
        if numTextField.text.length != 0 {
            var cnt = NSNumberFormatter().numberFromString(numTextField.text)!.integerValue
            if cnt == 0 {
                cnt = 1
            }
            //if cnt > 100 {
            //    cnt = 100
            //}
            
            if selectGoodsClosure != nil {
                selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.修改商品数量, cnt: cnt)
                numTextField.text = cnt.description
            }else{
                NSLog("传值有错误")
            }
        }else{
            if selectGoodsClosure != nil {
                selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.修改商品数量, cnt: 1)
                numTextField.text = "1"
            }
        }
        }else{
            var alert = UIAlertView(title: "提示", message: "请输入数字量", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            var cnt = NSNumberFormatter().numberFromString(currentCnt)!.integerValue
            selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.修改商品数量, cnt: cnt)
            erroCharaterCnt = 0
        }
    }
    
    var selectedFlag:Bool = true{
        didSet{
            var imgName = ""
            if selectedFlag {
                NSLog("你选中了该商品")
                imgName = "che_sel"
            }else{
                NSLog("你不打算买该商品了吗？")
                imgName = "che_nor"
            }
            setSelectedBtn!.setImage(UIImage(named: imgName), forState: UIControlState.Normal)
        }
    }
    
    //界面对象的唯一ID
    var actionOBJ:NSIndexPath = NSIndexPath()
    
    func attributedText(priceString:String)->NSAttributedString{
        return  NSAttributedString(string: "\(priceString)", attributes: [NSStrikethroughStyleAttributeName: 2])
    }
    
    /**
    修改了商品数量
    */
    
    //减少数量
    func subNum(){
        NSLog("减数量")
        if numTextField.text.length != 0 {
            var cnt = NSNumberFormatter().numberFromString(numTextField.text)!.integerValue
            cnt--
            if cnt == 0 {
                cnt = 1
            }
            //if cnt > 100 {
            //    cnt = 100
            //}
            
            if selectGoodsClosure != nil {
                selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.修改商品数量, cnt: cnt)
                numTextField.text = cnt.description
            }else{
                NSLog("传值有错误")
            }
        }else{
            if selectGoodsClosure != nil {
                selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.修改商品数量, cnt: 1)
                numTextField.text = "1"
            }
        }
        
    }
    //增加数量
    func addNum(){
        NSLog("加数量")
        if numTextField.text.length != 0 {
            var cnt = NSNumberFormatter().numberFromString(numTextField.text)!.integerValue
            cnt++
            
            if cnt == 0 {
                cnt = 1
            }
            //if cnt > 100 {
            //    cnt = 100
            //}
            
            if selectGoodsClosure != nil {
                selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.修改商品数量, cnt: cnt)
                numTextField.text = cnt.description
            }else{
                NSLog("传值有错误")
            }
        }else{
            if selectGoodsClosure != nil {
                selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.修改商品数量, cnt: 1)
                numTextField.text = "1"
            }
        }
        
    }
    

    
    /**
    移除该商品
    */
    func removeThisGoods(){
        NSLog("你需要移除该商品吗")
        if selectGoodsClosure != nil {
            selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.删除商品,cnt:0)
        }else{
            NSLog("传值有错误")
        }
    }
    
    /**
    选中该商品
    */
    func selectedThisGoods(){
        NSLog("你选中了该商品位于 \(actionOBJ.section)  \(actionOBJ.row)")
        if selectGoodsClosure != nil {
            selectGoodsClosure!(index: actionOBJ, name: GouWuCheViewAction.选中商品,cnt:0)
        }else{
            NSLog("传值有错误")
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        img = UIImageView(frame: CGRect(x: 30, y: 5, width: screenWith/3, height: screenWith/3 ))
        img?.backgroundColor = UIColor.clearColor()
        self.addSubview(img!)
        
        setSelectedBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: img!.frame.maxY + 5))
        
        //设置选中图片
        setSelectedBtn!.imageView!.contentMode  = UIViewContentMode.Center
        setSelectedBtn!.setImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        setSelectedBtn?.addTarget(self, action: Selector("selectedThisGoods"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(setSelectedBtn!)
        
        //商品名称
        goodsTitle = UILabel(frame: CGRect(x: img!.frame.maxX, y: 5, width:screenWith - img!.frame.maxX, height: 38))
        goodsTitle?.text = ""
        goodsTitle?.numberOfLines = 0
        goodsTitle?.font = UIFont.systemFontOfSize(15)
        self.addSubview(goodsTitle!)
        
        nowPrice = UILabel(frame: CGRect(x: img!.frame.maxX + 8, y: goodsTitle!.frame.maxY , width: 120, height: 22))
        nowPrice?.textColor = UIColor.redColor()
        nowPrice?.text = ""
        self.addSubview(nowPrice!)
        
        oldPrice = UILabel(frame: CGRect(x: nowPrice!.frame.minX, y: nowPrice!.frame.maxY , width: 120, height: 22))
        oldPrice?.textColor = UIColor.grayColor()
        //富文本显示
        oldPrice!.attributedText = attributedText("")
        self.addSubview(oldPrice!)
        
        //移除该商品
        removeGoods = UIButton(frame: CGRect(x: img!.frame.maxX + 3, y: img!.frame.maxY - 30, width: 60, height: 30))
        //removeGoods?.setTitle("移除", forState: UIControlState.Normal)
        
        //removeGoods?.imageRectForContentRect(CGRect(x: 0, y: 0, width: 50, height: 50))
        //removeGoods?.titleRectForContentRect(CGRect(x: 60, y: 0, width: 60, height: 30))
        
        //背景垃圾桶
        var imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.image = UIImage(named: "shanchu")
        removeGoods?.addSubview(imgView)
        
        var deleteTitle = UILabel(frame: CGRect(x: 30, y: 0, width: 60, height: 30))
        deleteTitle.text = "移除"
        deleteTitle.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        deleteTitle.font = UIFont.systemFontOfSize(12)
        removeGoods?.addSubview(deleteTitle)
        
        
        removeGoods?.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        
        
        //removeGoods?.layer.borderWidth = 0.5
        removeGoods?.addTarget(self, action: Selector("removeThisGoods"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(removeGoods!)
        
        /**************************************************/
        //替代stepperView
        var btnContainerView = UIView(frame: CGRect(x: screenWith - 115, y: img!.frame.maxY - 30, width: 110, height: 30))
        var leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        
        var rightBtn = UIButton(frame: CGRect(x: 70, y: 0, width: 40, height: 30))
        
        
        numTextField  = UITextField(frame: CGRect(x: 35, y: 0, width: 40, height: 30))
        numTextField.delegate = self
        numTextField.keyboardType = UIKeyboardType.NumberPad
        numTextField.textAlignment = NSTextAlignment.Center
        numTextField.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        
        var leftImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        leftImg.image = UIImage(named: "3213213213")
        var rightImg = UIImageView(frame: CGRect(x: 75, y: 0, width: 35, height: 30))
        rightImg.image = UIImage(named: "321321321")
        
        btnContainerView.addSubview(leftBtn)
        btnContainerView.addSubview(rightBtn)
        btnContainerView.addSubview(numTextField)
        
        btnContainerView.addSubview(leftImg)
        btnContainerView.addSubview(rightImg)
        
        btnContainerView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 243/255, alpha: 1)
        
        //数量减
        leftBtn.addTarget(self, action: Selector("subNum"), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.addTarget(self, action: Selector("addNum"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(btnContainerView)
        /**************************************************/
        
        
        
        self.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        self.addSubview(huoDong)
        huoDong.font = UIFont.systemFontOfSize(12)
        huoDong.textColor = UIColor.redColor()
        huoDong.textAlignment = NSTextAlignment.Left
        huoDong.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(imgView.snp_left)
            make.right.equalTo(self.snp_right).offset(-8)
            make.bottom.equalTo(imgView.snp_top).offset(-1)
            make.height.equalTo(22)
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

////宏定义闭包
typealias GoodsClosure=(index:NSIndexPath,name:GouWuCheViewAction,cnt:Int)->Void

enum GouWuCheViewAction {
    case 选中商品
    case 删除商品
    case 对该商家商品批量操作
    case 修改商品数量
    case 进入该商家
}


extension GouWuCheVC {
    //选中商品闭包回调函数
    func GoodsViewActionAtSection(index:NSIndexPath,name:GouWuCheViewAction,cnt:Int){
        NSLog("index = \(index.section)  and \(index.row)")
        
        switch name {
        case GouWuCheViewAction.选中商品:
            selectThisGoods(index)
        case GouWuCheViewAction.删除商品:
            removeThisGoods(index)
        case GouWuCheViewAction.对该商家商品批量操作 :
            selectedThisShopAllGoods(index)
        case GouWuCheViewAction.修改商品数量:
            changeGoodsCnt(index, cnt:cnt)
        case GouWuCheViewAction.进入该商家:
            gotoThisShop(index)
        default:
            NSLog("没有对应的闭包操作")
        }
        
        showAllGoodsPrice()
        self.tableView.reloadData()
        
    }
    
    /**
    设置界面选中总价值
    */
    func showAllGoodsPrice(){
        var allValue = String(format: "%.2f", gouWuCheModel.allGoodsPrice())
        self.totalPrice.text = "总计:\(allValue)"
    }
    
    /**
    选中该商品
    
    - parameter index: index description
    */
    func selectThisGoods(index:NSIndexPath){
        var flag = gouWuCheModel.shopGoodsInfo[index.section].lists[index.row].selectThisGood
        gouWuCheModel.shopGoodsInfo[index.section].lists[index.row].selectThisGood = !flag
        
        //遍历该商家，若全部商品都被选中后，更新头部全选按钮
        var allSelectFlagCnt = 0 //全部选择计数
        var allNotSelectFlagCnt = 0 //全部不选
        for var i = 0 ; i < gouWuCheModel.shopGoodsInfo[index.section].lists.count ; i++ {
            if gouWuCheModel.shopGoodsInfo[index.section].lists[i].selectThisGood {
                allSelectFlagCnt++
            }else{
                allNotSelectFlagCnt++
            }
        }
        /**
        *  全部选择后更新全选标记
        */
        if allSelectFlagCnt == gouWuCheModel.shopGoodsInfo[index.section].lists.count {
            gouWuCheModel.shopGoodsInfo[index.section].selectThisShop = true
        }else if allNotSelectFlagCnt != 0 {
            gouWuCheModel.shopGoodsInfo[index.section].selectThisShop = false
        }
        
        checkSelectAllGoods()
        
    }
    
    
    /**
    删除该商品
    */
    func removeThisGoods(index:NSIndexPath){
        
        let cartid = gouWuCheModel.shopGoodsInfo[index.section].lists[index.row].cartid
        
        let url = serversBaseURL + "/shoppingcart/delcart"
        
        let parameters = ["cartid":cartid]
        //let data = JSON(parameters)
        //let dataString = data.description
        //let para = ["filter":dataString]
        if netIsavalaible {
        Alamofire.request(.POST,url,parameters: parameters).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            NSLog("request = \(request)")
            NSLog("data = \(data)")
            
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            var message =  json["message"].stringValue
            if json["success"].stringValue == "true" {
                ProgressHUD.showSuccess(message)
            }else{
                ProgressHUD.showError(message)
            }
            
        }
        
        //进行移除操作
        gouWuCheModel.shopGoodsInfo[index.section].lists.removeAtIndex(index.row)
        //检测该商家下的商品是否全部被移除
        if gouWuCheModel.shopGoodsInfo[index.section].lists.count == 0 {
            gouWuCheModel.shopGoodsInfo.removeAtIndex(index.section)
        }
        
        }else{
            netIsEnable("网络不可用")
        }
        
        
        
        
        
        
    }
    
    
    
    
    /**
    对该商家下商品进行批量选择
    
    - parameter index: index description
    */
    func selectedThisShopAllGoods(index:NSIndexPath){
        //进行取反操作
        var flag = gouWuCheModel.shopGoodsInfo[index.section].selectThisShop
        if flag {
            gouWuCheModel.shopGoodsInfo[index.section].selectThisShop = false
            for var i = 0 ; i < gouWuCheModel.shopGoodsInfo[index.section].lists.count; i++ {
                gouWuCheModel.shopGoodsInfo[index.section].lists[i].selectThisGood = false
                
                NSLog("---------")
            }
        }else{
            gouWuCheModel.shopGoodsInfo[index.section].selectThisShop = true
            
            for var i = 0 ; i < gouWuCheModel.shopGoodsInfo[index.section].lists.count; i++ {
                gouWuCheModel.shopGoodsInfo[index.section].lists[i].selectThisGood = true
                NSLog("**********")
            }
        }
        
        checkSelectAllGoods()
    }
    
    /**
    修改商品数量
    
    - parameter index: index description
    - parameter cnt:   cnt description
    */
    func changeGoodsCnt(index:NSIndexPath,cnt:Int){
        let keyid = gouWuCheModel.shopGoodsInfo[index.section].lists[index.row].cartid
        let nums = cnt
        
        let url = serversBaseURL + "/shoppingcart/operation"
        
        let parameters = ["keyid":keyid,"nums":nums]
        let data = JSON(parameters)
        let dataString = data.description
        let para = ["filter":dataString]
        ProgressHUD.show("数据请求中...")
        NSLog("para = \(para.description)")
        
        if netIsavalaible {
        Alamofire.request(.POST,url,parameters: para).responseString{ (request, response, data, error) in
            NSLog("error = \(error)")
            NSLog("request = \(request)")
            NSLog("data = \(data)")
            
            ProgressHUD.dismiss()
            
            var json = StringToJSON(data!)
            NSLog("json = \(json)")
            var message =  json["message"].stringValue
            if json["success"].stringValue == "true" {
//                ProgressHUD.showSuccess(message)
                showMessageAnimate(self.navigationController!.view, message)
                self.gouWuCheModel.shopGoodsInfo[index.section].lists[index.row].nums = cnt.description
            }else{
//                ProgressHUD.showError(message)
                showMessageAnimate(self.navigationController!.view, message)
            }
            
        }
        }else{
            netIsEnable("网络不可用")
        }
        
        
        
        
    }
    
    /**
    进入对应的商家进行选购商品
    
    - parameter index: index description
    */
    func gotoThisShop(index:NSIndexPath){
        NSLog("需要进入的商家名称是\(gouWuCheModel.shopGoodsInfo[index.section].shopname)")
        let adminkeyid = gouWuCheModel.shopGoodsInfo[index.section].shopid
        //在此push进入商家(可以传如需要购买的商品信息)
        
        var merchantVC = MerchantDetailVC()
        merchantVC.shopImageUrl = gouWuCheModel.shopGoodsInfo[index.section].shopImg
        merchantVC.adminkid = adminkeyid
        merchantVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(merchantVC, animated: true)
    }
}