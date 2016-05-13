//
//  ShoppingCartTableViewCell.swift
//  YaoDe
//
//  Created by iosnull on 15/9/7.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol ShoppingCartTableViewCellDelegate{
    func shoppingCartNumOfProductChanged(#section:Int,row:Int,nums:Int)
    func removeProductFromCart(#section:Int,row:Int)
}

class ShoppingCartTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    weak var delegate:ShoppingCartTableViewCellDelegate?
    

    @IBOutlet var productImage: UIImageView!
    //商品简介
    @IBOutlet var brief: UILabel!
    //销量
    @IBOutlet var sellCnt: UILabel!
    //库存
    @IBOutlet var storeCnt: UILabel!
    //价格
    @IBOutlet var price: UILabel!
    //购买数量显示（按钮）
    @IBOutlet var buyCntBtn: UIButton!
    //移除购物车（按钮）
    @IBOutlet var removeCart: UIButton!
    @IBAction func removeCartBtnClk(sender: UIButton) {
        NSLog("移除购物车的是 第个\(self.brief.tag)section和 第\(self.tag)row ")
        delegate?.removeProductFromCart(section: self.brief.tag, row: self.tag)
    }
    
    
    
    //增加按钮
    //减少按钮
    @IBOutlet var stepper: UIStepper!
    @IBAction func stepperBtnClk(sender: UIStepper) {
        NSLog("数量选择按钮点击了 sender.value = \(sender.value)  ")
        var num = Int(sender.value)
        buyCntBtn.setTitle(num.description, forState: UIControlState.Normal)
        
        NSLog("你选择的是 第个\(self.brief.tag)section和 第\(self.tag)row ;购买数量为：\(num)")
        delegate?.shoppingCartNumOfProductChanged(section: self.brief.tag, row: self.tag, nums: num)
    }
    
    var ShoppingCartCellValue = ShoppingCartProduct()
    var setValue:ShoppingCartProduct{
        set{
            ShoppingCartCellValue = newValue
            brief.text = newValue.pdname
            storeCnt.text = "库存:" + newValue.stock
            //sellCnt.text = ?
            price.text = "￥" + newValue.price
            buyCntBtn.setTitle(newValue.nums, forState: UIControlState.Normal)
            var num = NSNumberFormatter()
            //= num.numberFromString(newValue.nums)
            stepper.value = num.numberFromString(newValue.nums)!.doubleValue
            
            productImage.sd_setImageWithURL(NSURL(string: serversBaseUrlForPicture + "\(newValue.imgurl)"))
            
            removeCart.layer.masksToBounds = true
            removeCart.layer.borderWidth = 1
            removeCart.layer.cornerRadius = 3
            removeCart.layer.borderColor = UIColor(red: 38/255, green: 168/255, blue: 231/255, alpha: 1 ).CGColor
        }
        get{
            return ShoppingCartCellValue
        }
    }
    
    
    class func loadFromNib()->ShoppingCartTableViewCell {
        
        return NSBundle.mainBundle().loadNibNamed("ShoppingCartTableViewCell", owner: nil, options:nil).last as! ShoppingCartTableViewCell
    }

    deinit{
        NSLog("ShoppingCartTableViewCell  deinit")
    }
    
}
