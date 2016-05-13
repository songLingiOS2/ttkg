//
//  ResetPwdPage1VC.swift
//  YaoDe
//
//  Created by iosnull on 15/11/18.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class ResetPwdPage1VC: UIViewController {
    
    func setNavigationBar(){
        //        navigationBar常用属性
        //        一. 对navigationBar直接配置,所以该操作对每一界面navigationBar上显示的内容都会有影响(效果是一样的)
        //        1.修改navigationBar颜色
        //        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
        //
        //        2.关闭navigationBar的毛玻璃效果
        //        self.navigationController.navigationBar.translucent = NO;
        //        3.将navigationBar隐藏掉
        //
        //        self.navigationController.navigationBarHidden = YES;
        //
        //        4.给navigationBar设置图片
        //        不同尺寸的图片效果不同:
        //        1.320 * 44,只会给navigationBar附上图片
        //
        //        2.高度小于44,以及大于44且小于64:会平铺navigationBar以及状态条上显示
        //
        //        3.高度等于64:整个图片在navigationBar以及状态条上显示
        
        //1、返回标签
        let item = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        //2、颜色（UINavigationBar）
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //设置背景颜色
         self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 43/255, blue: 74/255, alpha: 1.0)
        //富文本设置颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        //隐藏毛玻璃效果
        self.navigationController?.navigationBar.translucent = false
        
    }

    @IBAction func disBtnClk(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
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
