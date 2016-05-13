//
//  NomerUsrInfoVC.swift
//  YaoDe
//
//  Created by iosnull on 15/9/14.
//  Copyright (c) 2015年 yongzhikeji. All rights reserved.
//

import UIKit

class NomerUsrInfoVC: UITableViewController {

    var usrSex = ""
    
    @IBOutlet var usrName: UITextField!
    @IBOutlet var usrTel: UITextField!
    
    @IBOutlet var usrAddress: UITextField!
    @IBOutlet var usrRemark: UITextField!
    
    @IBAction func modifyBtnClk(sender: UIButton) {
        NSLog("用户信息修改")
    }
    @IBOutlet var modifyBtn: UIButton!
    
    @IBOutlet var selectManBtn: UIButton!
    
    @IBOutlet var selectWomanBtn: UIButton!
    
    @IBAction func selectManBtnClk(sender: UIButton) {
        selectManBtn.setImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        selectWomanBtn.setImage(UIImage(named: "che_nor"), forState: UIControlState.Normal)
        usrSex = "男"
    }
    
    @IBAction func selectWomanBtnClk(sender: UIButton) {
        selectManBtn.setImage(UIImage(named: "che_nor"), forState: UIControlState.Normal)
        selectWomanBtn.setImage(UIImage(named: "che_sel"), forState: UIControlState.Normal)
        usrSex = "女"
    }
    
    func setSubViewPara(){
        modifyBtn.layer.masksToBounds = true
        modifyBtn.layer.borderWidth = 1
        modifyBtn.layer.cornerRadius = 10
        modifyBtn.layer.borderColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1 ).CGColor
        
        self.navigationItem.title = "普通用户"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSubViewPara()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
    }

}
