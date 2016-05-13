//
//  RecipeCollectionFooterView.swift
//  YaoDe
//
//  Created by iosnull on 15/12/4.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class RecipeCollectionFooterView: UICollectionReusableView {
        
    @IBOutlet var backView: UIView!
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!){
        NSLog("RecipeCollectionFooterView   loadView")
        //backView.backgroundColor = UIColor.redColor()
    }
    
}
