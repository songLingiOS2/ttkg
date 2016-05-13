//
//  MoreClassHeader.swift
//  
//
//  Created by yd on 16/3/17.
//
//

import UIKit

class MoreClassHeader: UIView {


//    self.backgroundColor = UIColor.yellowColor()
    
//    var button = UIButton(frame: CGRectMake(0, 0, 120, 50))
//    button.addTarget(self, action: Selector("buttonClick"), forControlEvents: UIControlEvents.TouchUpInside)
    
    var open = false
    
    var button = UIButton()
    var imageView = UIImageView()
    var nameLabel = UILabel()
    override init(frame: CGRect){
        super.init(frame:frame)
        button.frame = self.frame
        button.backgroundColor  = UIColor.whiteColor()
        button.addTarget(self, action: Selector("MoreClassHeaderBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        
        imageView.frame  = CGRectMake(5, 5, 55, 55)
        imageView.backgroundColor = UIColor.whiteColor()
        self.addSubview(imageView)
        
        nameLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 20, CGRectGetWidth(UIScreen.mainScreen().bounds)-80, 40)
        nameLabel.text = "xxx"
        self.addSubview(nameLabel)
        
        
        
    }
    
    
    
    
    func MoreClassHeaderBtnClick(sender:UIButton){
        NSLog("sender is clicked == \(sender.tag)")
        open = !open
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ClassModel_Cell: UICollectionViewCell {
    var img : UIImageView!
    var title = UILabel()
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        img = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 20))
        img.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(img)
        title = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(img.frame), width: frame.width, height: frame.height - CGRectGetHeight(img.frame)))
        title.textAlignment = NSTextAlignment.Center
        title.font  = UIFont.systemFontOfSize(8)
        self.addSubview(title)
        
    }
    
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ClassGetMoreInfoCell: UITableViewCell {
        var view : UIView!
        var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        view = UIView(frame: CGRect(x:2,y:0,width:5 ,height:34))
        self.addSubview(view)
        label = UILabel(frame: CGRect(x:CGRectGetMaxX(view.frame) + 2,y:0,width:70 ,height:34))
        label.textAlignment = NSTextAlignment.Left
        label.font  = UIFont.systemFontOfSize(14)
        self.addSubview(label)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



