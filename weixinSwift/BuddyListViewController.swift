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
    //当前正在聊天的好友
    var currentBuddyName = ""
    
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
        //获取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        //设置title
        self.navigationItem.title = myID! + "的好友"
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
        //获取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        //获取是否自动登录
        let autoLogin = NSUserDefaults.standardUserDefaults().boolForKey("weixinAutoLogin")
        //如果设置了用户名和自动登录
        if (myID != nil && autoLogin){
            println("第一次登录")
            //登录
            self.login()
        }else {
            println("跳转到登录界面")
            //跳转到登录界面
            self .performSegueWithIdentifier("presentLoginSegue", sender: self)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
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
    
    //自己离线
    func meOff() {
        println("自己离线")
        logoff()
    }
    //上线状态处理
    func isOn(zt: Zhuangtai) {
        println("isOn = \(zt)")
        //逐步查找状态数据源
        for (index, oldZt) in enumerate(statesList){
            //如果找到旧的用户状态
            if zt.name == oldZt.name {
                statesList.removeAtIndex(index)
                break
            }
        }
        
        //添加新状态
        statesList.append(zt)
        //刷新列表
        self.tableView.reloadData()
    }
    //下线状态处理
    func isOff(zt: Zhuangtai) {
        //逐步查找状态数据源
        for (index, oldZt) in enumerate(statesList){
            //如果找到旧的用户状态
            if zt.name == oldZt.name {
                statesList[index].isOnline = false
                break
            }
        }
        //刷新列表
        self.tableView.reloadData()
    }
    //MARK: - Xiao xi Delegate
    func newMsg(aMsg: WXMessage) {
        
        //println("newMsg = \(aMsg)")
        
        //如果消息有正文o
        if aMsg.body != "" {
            //添加数据源
            unreadMsgList.append(aMsg)
            //刷新列表
            self.tableView.reloadData()
        }
        
    }
    //MAEK: - Actions
    
    @IBAction func login(sender: UIBarButtonItem) {
        
        if logged {
            //如果登录，那么登出
            logoff()
        }else {
            //如果登出，那么登录
            login()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("cellForRowAtIndexPath = \(statesList)")
        
         let cell = tableView.dequeueReusableCellWithIdentifier("buddyListCell", forIndexPath: indexPath) as UITableViewCell
        //获取好友上线状态
        let isOnline = statesList[indexPath.row].isOnline
        //获取好友姓名
        let name = statesList[indexPath.row].name
        //获取当前好友的未读消息
        var msgs = [WXMessage]()
        for aMsg in unreadMsgList{
            if aMsg.from == name {
                msgs.append(aMsg)
            }
        }
        cell.textLabel?.text = name + "(\(msgs.count))"
        //上下线标志
        if isOnline {
            cell.imageView?.image = UIImage(named: "on")
        } else {
            cell.imageView?.image = UIImage(named: "off")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //存储选择的好友
        currentBuddyName = statesList[indexPath.row].name
        //跳转到聊天界面
        self.performSegueWithIdentifier("showChatSegue", sender: self)

    }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //判断穿越到聊天界面
        if segue.identifier == "showChatSegue" {
            //获取控制器对象
            let destinVC = segue.destinationViewController as ChatViewController
            //传递好友名字
            destinVC.toBuddyName = currentBuddyName
            //遍历未读数组，找出当前用户的未读消息
            for (index, aMsg) in enumerate(unreadMsgList)  {
                if aMsg.from == currentBuddyName {
                    //将当前好友未读消息添加到数组里面
                    destinVC.msgsList.append(aMsg)
                }
            }
            //从数据源中删除对应消息
            removeValue(currentBuddyName, fromArray: &unreadMsgList)
            //刷新列表
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
       // println("unwind........")
        //
        let source  = segue.sourceViewController  as LoginViewController
        if source.requireLogin {
            //注销旧用户
            self.logoff()
            //登录新用户
            self.login()
            
        }
    }
    //删除数组中制定值
    func getRemovedIndexs(fromValue: String, fromArray:[WXMessage]) -> [Int] {
        var indexsAry = [Int]()
        //正确索引数组
        var correctIndexsAry = [Int]()
        //获取原始的索引，并添加到数组中
        for (index, value) in enumerate(fromArray) {
            if value.from == fromValue {
                indexsAry.append(index)
            }
        }
        //
        for (index, orignIndexValue) in enumerate(indexsAry) {
            //获取正确的索引
            var correctIndex = orignIndexValue - index
            //将正确的索引添加到数组中
            correctIndexsAry.append(correctIndex)
        }
        return correctIndexsAry
    }
    
    func removeValue(value:String, inout fromArray:[WXMessage]) {
        //正确索引数组
        var correctIndexsAry = getRemovedIndexs(value, fromArray: fromArray)
        //
        for index in correctIndexsAry {
            fromArray.removeAtIndex(index)
        }
    }

}
