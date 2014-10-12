//
//  BuddyListViewController.swift
//  weixinSwift
//
//  Created by mengdong on 14-10-8.
//  Copyright (c) 2014年 com.mengdong. All rights reserved.
//

import UIKit

class BuddyListViewController: UITableViewController , ZtDL, XxDL{

    @IBOutlet var myStates: UIBarButtonItem!
    //好友数组作为表格的数据源
    var unreadMsgList = [WXMessage]()
    //好友状态数组，作为表格数据源
    var statesList = [Zhuangtai]()
    
    //是否已登录
    var logged = false
    
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    //登陆
    func  login() {
        //清空数据源记录
        unreadMsgList.removeAll(keepCapacity: false)
        statesList.removeAll(keepCapacity: false)
        //链接
        zdl().connect()
        //设置为已登录状态
        myStates.image = UIImage(named: "on")
        //保存登录状态
        logged = true
        //刷新列表
        self.tableView.reloadData()
    }
    
    //登出
    func logoff() {
        //清空记录
        unreadMsgList.removeAll(keepCapacity: false)
        statesList.removeAll(keepCapacity: false)

        
        zdl().disConnect()
        //设置为未登录状态
        myStates.image = UIImage(named: "off")
        //保存登出状态
        logged = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        //获取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        //获取是否自动登录
        let autoLogin = NSUserDefaults.standardUserDefaults().boolForKey("weixinAutoLogin")
        //如果设置了用户名和自动登录
        if (myID != nil && autoLogin){
            //登录
            self.login()
            //设置title
            self.navigationItem.title = myID! + "的好友"
        }else {
            //跳转到登录界面
            self .performSegueWithIdentifier("presentLoginSegue", sender: self)
        }
        //接管消息代理
        zdl().xxdl = self
        //接管状态代理
        zdl().ztdl = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Zhuang Tai delegate
    
    //MARK: - Xiao xi Delegate
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
        //
        let source  = segue.sourceViewController  as LoginViewController
        if source.requireLogin {
            //注销旧用户
            self.logoff()
            //登录新用户
            self.login()
            
        }
    }

}
