//
//  ClassProductCell.swift
//  YaoDe
//
//  Created by iosnull on 15/9/1.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class ClassProductCell: UICollectionViewCell {

    @IBOutlet var classProductName: UILabel!
    @IBOutlet var image: UIImageView!
    
    var classProduct = ClassProduct()
    var setClassProductShow:ClassProduct{
        set{
            classProduct = newValue
            classProductName.text = newValue.title
            
            var imageUrl = serversBaseUrlForPicture + newValue.picurl
            image.sd_setImageWithURL(NSURL(string: imageUrl))
        }
        get{
            return classProduct
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func loadFromNib()->ClassProductCell {
        
        return NSBundle.mainBundle().loadNibNamed("ClassProductCell", owner: nil, options:nil).last as! ClassProductCell
    }
}
