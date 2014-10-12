//
//  WXMessage.swift
//  weixinSwift
//
//  Created by mengdong on 14-10-8.
//  Copyright (c) 2014年 com.mengdong. All rights reserved.
//

//import Foundation
import Foundation

//好友消息结构
struct WXMessage {
    var body: String = "" //消息内容
    var from: String = "" //消息来自谁
    var isComposing: Bool = false //是否正在编辑
    var isDelay: Bool = false //是否是离线消息
    var isMe: Bool = false //是否是我发的
}

//状态结构
struct Zhuangtai {
    var name = "" //用户名
    var isOnline = false //是否上线
}
