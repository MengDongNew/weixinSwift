//
//  ChatViewController.swift
//  weixinSwift
//
//  Created by mengdong on 14-10-9.
//  Copyright (c) 2014年 com.mengdong. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController, XxDL {

    @IBOutlet var msgTF: UITextField!
    
    //聊天的好友
    var toBuddyName = ""
    //聊天消息
    var msgsList = [WXMessage]()
    
    
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

    //MARK - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //接管消息代理
        zdl().xxdl = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Response Actions
    
    
    @IBAction func isComposing(sender: UITextField) {
        //构建XML消息
        var xmlMsg = DDXMLElement.elementWithName("message") as DDXMLElement
        
        //增加属性
        xmlMsg.addAttributeWithName("to", stringValue: toBuddyName)
        xmlMsg.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
        //构建正文
        var composing = DDXMLElement.elementWithName("composing") as DDXMLElement
        composing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
        //向消息添加子节点
        xmlMsg.addChild(composing)
        //总代理发送消息
        zdl().xs?.sendElement(xmlMsg)
    }
    
    //发送消息
    @IBAction func sendMsg(sender: UIBarButtonItem) {
        println("sendMsg.....")
        //获取聊天信息
        let chatStr = msgTF.text
        if !chatStr.isEmpty {
            //构建XML消息
            var xmlMsg = DDXMLElement.elementWithName("message") as DDXMLElement
            
            //增加属性
            xmlMsg.addAttributeWithName("type", stringValue: "chat")
            xmlMsg.addAttributeWithName("to", stringValue: toBuddyName)
            xmlMsg.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
            //构建正文
            var body = DDXMLElement.elementWithName("body") as DDXMLElement
            body.setStringValue(chatStr)
            //消息子节点中加入正文
            xmlMsg.addChild(body)
            //总代理向通道发送消息
            zdl().xs?.sendElement(xmlMsg)
            //清空聊天框
            msgTF.text = ""
            //保存自己的消息
            var msg = WXMessage()
            msg.isMe = true
            msg.body = chatStr
            //加入到聊天框
            msgsList.append(msg)
            //刷新表格
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Xiao xi Delegate
    func newMsg(aMsg: WXMessage) {
        //获取好友名字
        toBuddyName = aMsg.from
        //println("newMsg = \(aMsg)")
        //如果对方正在输入
        if aMsg.isComposing {
            self.navigationItem.title = "正在输入..."
        }
        //如果消息有正文o
        if aMsg.body != "" {
            self.navigationItem.title = toBuddyName
            //添加数据源
            msgsList.append(aMsg)
            //刷新列表
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("msgs.count = \(msgsList.count)")
        return msgsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as UITableViewCell
        let msg = msgsList[indexPath.row]
        //判断如果是自己发的
        if msg.isMe {
            cell.textLabel?.textAlignment = .Right
            cell.textLabel?.textColor = UIColor.grayColor()
        } else {
            //如果不是自己发的
            cell.textLabel?.textColor = UIColor.orangeColor()
        }
        
        cell.textLabel?.text = msg.body
        
        return cell
    }
    

    //
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
