//
//  PlaceOfReceiptCell.swift
//  YaoDe
//
//  Created by iosnull on 15/9/10.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class PlaceOfReceiptCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var tel: UILabel!
    
    @IBOutlet var placeOfReceipt: UILabel!
    
    
    @IBOutlet var shenHeStatus: UIImageView!
    
    
    
    var placeOfReceiptTemp = PlaceOfReceipt()
    
    var setSubViewPara:PlaceOfReceipt{
        set{
            placeOfReceiptTemp = newValue
            
            name.text = newValue.name
            NSLog("name = \(name.text)")
            tel.text = newValue.phone
            placeOfReceipt.text = newValue.address
            
            
            if (newValue.IsAuditStatus == "1"){
                shenHeStatus.image = UIImage(named: "addrss_false")
            }else if (newValue.IsAuditStatus == "3") {
                shenHeStatus.image = UIImage(named: "addrss_no")
            }else{
                shenHeStatus.hidden = true
            }
            

            
        }
        get{
            return placeOfReceiptTemp
        }
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
