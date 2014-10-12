//
//  AppDelegate.swift
//  weixinSwift
//
//  Created by mengdong on 14-10-7.
//  Copyright (c) 2014年 com.mengdong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate {

    var window: UIWindow?
    //信息通道
    var xs : XMPPStream?
    //服务器是否开启
    var isOpen = false
    //用户密码
    var pwd = ""
    
    //状态代理
    var ztdl: ZtDL?
    //消息代理
    var xxdl: XxDL?
    
    //收到消息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        //如果是聊天消息
        if message.isChatMessage() {
            //保存消息结构体
            var msg = WXMessage()
            //对方是否正在输入
            if message.elementForName("composing") != nil{
                msg.isComposing = true
            }
            //是否离线消息
            if message.elementForName("delay") != nil {
                msg.isDelay = true
            }
            //消息正文
            if let body =  message.elementForName("body") {
                msg.body = body.stringValue()
            }
            //保存完整用户名
            msg.from = message.from().user + "@" + message.from().domain
            //执行代理方法
            xxdl?.newMsg(msg)
        }
    }
    //收到状态
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        //自己的用户名
        let myUser = sender.myJID.user
        //好友的用户名
        let user = presence.from().user
        //好友所在域名
        let domain = presence.from().domain
        //状态类型
        let pType = presence.type()
        
        if user != myUser {
            //保存状态结构
            var zt = Zhuangtai()
            //状态完整用户名
            zt.name = user + "@" + domain
            
            if pType == "available" {
                zt.isOnline = true
                //执行代理方法
                ztdl?.isOn(zt)
                
            }else if pType == "unavailable" {
                //执行代理方法
                ztdl?.isOff(zt)
            }
        }
    }
    
    //链接成功
    func xmppStreamDidConnect(sender: XMPPStream!) {
        isOpen = true
        //验证密码
        xs?.authenticateWithPassword(pwd, error: nil)
    }
    //验证成功
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        //上线
        goOnline()
    }
  
    //建立通道
    func buildStream(){
        xs = XMPPStream()
        xs?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    //发送上线状态
    func goOnline(){
        var p = XMPPPresence()
        xs?.sendElement(p)
    }
    //发送下线状态
    func goOffline(){
        var p = XMPPPresence(type: "unavailable")
        xs?.sendElement(p)
    }
    //链接服务器（查看服务器是否可链接）
    func connect() -> Bool{
        buildStream()
        if xs!.isConnected() {
            return true
        }
        //获取系统中保存的用户名，密码和服务器
        let user = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        let password = NSUserDefaults.standardUserDefaults().stringForKey("weixinPwd")
        let server = NSUserDefaults.standardUserDefaults().stringForKey("weixinServer")
        
        if user != nil && password != nil {
            //通道用户名
            xs?.myJID = XMPPJID.jidWithString(user)
            xs?.hostName = server!
            //保存密码备用
            pwd = password!
            //进行链接
            return xs!.connectWithTimeout(5000, error: nil)
        }
        
        return false
    }
    
    //断开连接
    func disConnect() {
        if xs != nil {
            if xs!.isConnected() {
                goOffline()
                xs?.disconnect()
            }
        }
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

