//
//  SubClassCell.swift
//  YaoDe
//
//  Created by iosnull on 15/9/11.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class SubClassCell: UITableViewCell {

    var classProduct = ClassProduct()
    var setClassProduct:ClassProduct{
        set{
            classProduct = newValue
            var imageUrl = serversBaseUrlForPicture + newValue.picurl
            classImage.sd_setImageWithURL(NSURL(string: imageUrl))
            name.text = newValue.title
        }
        get{
            return classProduct
        }
    }
    
    @IBOutlet var classImage: UIImageView!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
