//
//  aboutVC.swift
//  
//
//  Created by yd on 15/12/9.
//
//

import UIKit

class aboutVC: UIViewController,UIWebViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()


        //CGRect(x: 0, y: 0, width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: CGRectGetHeight(UIScreen.mainScreen().bounds))
        var webView = UIWebView(frame:self.view.frame)
        webView.delegate = self
        var url = NSURL(string: "https://app.ttkg365.com/notify/about")
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.scalesPageToFit = true
        self.view.addSubview(webView)        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    
    func webViewDidStartLoad(webView: UIWebView) {
        ProgressHUD.show("请稍等...")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        ProgressHUD.dismiss()
    }
    

    deinit {
        ProgressHUD.dismiss()
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
