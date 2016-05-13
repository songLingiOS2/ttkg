//
//  GoodsHTML.swift
//  YaoDe
//
//  Created by iosnull on 16/3/30.
//  Copyright (c) 2016年 yongzhikeji. All rights reserved.
//

import UIKit

class GoodsHTML: UIViewController {
    var webView = UIWebView()
    var content = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.frame = self.view.frame
        
        self.view.addSubview(webView)
        webView.loadHTMLString(content, baseURL: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
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
