//
//  MerchantHeaderView.swift
//  
//
//  Created by yd on 16/4/7.
//
//

import UIKit

class MerchantHeaderView:UICollectionReusableView{
    
    
    
    
    
    
    
    var imgHeader : UIImageView!
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!){
        
        
        self.backgroundColor = UIColor.whiteColor()
         imgHeader  = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: screenWith / 2))
        self.addSubview(imgHeader)
        
        
        
        //分割线
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1 ).CGColor
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
    

