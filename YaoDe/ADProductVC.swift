//
//  ADProductVC.swift
//  
//
//  Created by yd on 16/1/22.
//
//

import UIKit

class ADProductVC: UIViewController {
    
    var adShowString = [ShoppingAD]()
    var adnum:Int? {
        didSet{
            
        }
    }
    

    
    var web:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "http://management.ttkg365.com"
        
        
        web = UIWebView(frame: self.view.frame)
        web.scalesPageToFit = true
        web.loadHTMLString(adShowString[adnum!].remark, baseURL: nil)
        self.view.addSubview(web)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
