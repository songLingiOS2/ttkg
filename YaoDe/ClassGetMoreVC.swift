//
//  ClassGetMoreVC.swift
//  
//
//  Created by yd on 16/3/29.
//
//

import UIKit


struct classMessageInfo {
    var success = ""
    var status = ""
    var message = ""
    var data = ""
}

struct dataInfoModel {
    var keyid = ""
    var name = ""
    var picurl = ""
    var list = ""
}







class ClassGetMoreVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var mainAndSub = [String:[ClassProduct]]()
    var mainArry = [ClassProduct]()
    var listTempProductArry = [ClassProduct]()
    var shopID = "" //商家id
    var shopPush = false
    
    var http = ShoppingHttpReq.sharedInstance
    var classProduct = ClassProduct()
    var subClassProduct:[ClassProduct] = [ClassProduct]()
    
    var tableView = UITableView()
    
    
    var collectionView : UICollectionView?
    
    
    var NumforCollectionCell = 0
    var setClassModelInfo = [ClassProduct]()
    
    
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ProgressHUD.show("数据请求中...")
        
        if shopPush {//是商家push过来的
            
            //通知getMoreClassProductProcess
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getMoreClassProductProcess:"), name: "getShopSubClassReqClassGetMoreVC", object: nil)
            http.getShopSubClass(shopID,  whoAreYou: "ClassGetMoreVC")
        }else{
            //通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getMoreClassProductProcess:"), name: "getMoreClassProductClassGetMoreVC", object: nil)
            http.getMoreClassProduct(whoAreYou:"ClassGetMoreVC")
        }
        
        
        self.edgesForExtendedLayout = UIRectEdge.None
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: SCREEN_HEIGHT), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.view.addSubview(tableView)
        
        tableView.separatorColor = UIColor(red: 243/255, green: 244/255, blue: 243/255, alpha: 1)
        
        tableView.tableFooterView = UIView() //去除多余的分割线显示
       
        
        var layout = UICollectionViewFlowLayout()
        
        
        
        collectionView = UICollectionView(frame: CGRect(x: CGRectGetMaxX(tableView.frame), y: 0, width: SCREEN_WIDTH - CGRectGetWidth(tableView.frame), height: SCREEN_HEIGHT - 64),collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        self.view.addSubview(collectionView!)
       
        collectionView?.registerClass(ClassModel_Cell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView?.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 243/255, alpha: 1)
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return NumforCollectionCell
    }
    
    //cell宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{

        let screenWith = UIScreen.mainScreen().bounds.width
        var cgsize =  CGSize(width: CGRectGetWidth(collectionView.frame)/3 - 16, height: CGRectGetWidth(collectionView.frame)/3 - 16 )
        return cgsize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        /// collection 布局间距
        var edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return edge
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ClassModel_Cell
        
        var url = serversBaseUrlForPicture + setClassModelInfo[indexPath.row].picurl
        cell.img.sd_setImageWithURL(NSURL(string: url))
        cell.title.text = setClassModelInfo[indexPath.row].title
        cell.title.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var classProductVC  = UIStoryboard(name: "ShoppingPage", bundle: nil).instantiateViewControllerWithIdentifier("ClassProductVC") as! ClassProductVC
        NSLog("subClassProduct[indexPath.row].title == \(setClassModelInfo[indexPath.row].keyid)")
        
        classProductVC.navigationItem.title = setClassModelInfo[indexPath.row].title
        classProductVC.KeyID = setClassModelInfo[indexPath.row].keyid
        classProductVC.classProduct = setClassModelInfo[indexPath.row]
        
        NSLog("shopPush =\(shopPush)")
        if shopPush {
            classProductVC.MerchantPush = true
        }else{
            
        }
        
        
        classProductVC.MerchantKeyID = shopID
        
        self.navigationController?.pushViewController(classProductVC, animated: true)

    }
    
    /********************************************************************************************************/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mainArry.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ClassGetMoreInfoCell()
        
        cell.label.text = mainArry[indexPath.row].title
        cell.separatorInset = UIEdgeInsetsMake(0,0, 0, 0)
    
        if mainArry[indexPath.row].selectFlag{
            cell.view.backgroundColor = UIColor.redColor()
            cell.label.textColor = UIColor.redColor()
            
            cell.backgroundColor  = UIColor(red: 243/255, green: 244/255, blue: 243/255, alpha: 1)
            
        }else{
            cell.view.backgroundColor = UIColor.whiteColor()
            cell.label.textColor = UIColor.blackColor()
            cell.backgroundColor  = UIColor.whiteColor()
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("select \(indexPath.row)hang")
        var xxtitle  = mainArry[indexPath.row].title
        NSLog("xxtitle == \(xxtitle)")
        for var i = 0; i < mainArry.count; i++ {
            mainArry[i].selectFlag = false
        }
       
        
        mainArry[indexPath.row].selectFlag = true
        
        NumforCollectionCell = mainAndSub[xxtitle]!.count
        
        setClassModelInfo = mainAndSub[xxtitle]!
        tableView.reloadData()
        collectionView?.reloadData()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

extension ClassGetMoreVC {
    
    func getMoreClassProductProcess(sender:NSNotification){
        if  let senderTemp:AnyObject = sender.object {
            var dataTemp = NSNotificationToJSON(sender)
            NSLog("dataTemp = \(dataTemp)")
            
            if "true" == dataTemp["success"].stringValue{
                mainAndSub = [:]
                
                NSLog("获取到分类产品展示数据")
                ProgressHUD.dismiss()
                
                var classProductData = dataTemp["data"]
                var classProductTemp = ClassProduct()
                for(var cnt = 0 ; cnt < classProductData.count ; cnt++ ){
                    var data  = classProductData[cnt]
                    classProductTemp.picurl = data["picurl"].stringValue
                    classProductTemp.title = data["name"].stringValue
                    classProductTemp.keyid = data["keyid"].stringValue
                    classProductTemp.selectFlag = false
                    var list = data["list"]
                    var listProductArry = [ClassProduct]()
                    listProductArry.append(classProductTemp)
                    for (var i = 0; i < list.count; i++ ) {
                        var list0 = list[i]
                        var listProductTemp = ClassProduct()
                        
                        listProductTemp.picurl = list0["picurl"].stringValue
                        listProductTemp.title = list0["name"].stringValue
                        listProductTemp.keyid = list0["keyid"].stringValue
                        listProductTemp.IsGivestate = list0["IsGivestate"].stringValue
                        NSLog("listProductTemp.keyid == \(listProductTemp.title)")
                        listProductArry.append(listProductTemp)
                    }
                   
                    
                    
                    mainArry.append(classProductTemp)
                    mainAndSub[classProductTemp.title] = listProductArry
                    NSLog("mainArry == \(mainArry[cnt].picurl)")
                    
                }
                NSLog("mainArry == \(mainArry.count)")
                NSLog("mainAndSub = \(mainAndSub)")
                if mainArry.count != 0 {
                    mainArry[0].selectFlag = true
                }
                
                
                
                
                
                
                var xxtitle  = mainArry[0].title
                
                NumforCollectionCell = mainAndSub[xxtitle]!.count
                
                setClassModelInfo = mainAndSub[xxtitle]!
                
                tableView.reloadData()
                collectionView?.reloadData()
                
            }else{
                ProgressHUD.showError("数据获取失败!!!")
                
            }
        }else{
            ProgressHUD.showError("数据获取失败!!!")
        }
        
    }

    
}


