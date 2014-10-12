
//
//  ZtDL.swift
//  weixinSwift
//
//  Created by mengdong on 14-10-11.
//  Copyright (c) 2014年 com.mengdong. All rights reserved.
//

import Foundation

//状态代理协议
protocol ZtDL {
    func isOn(zt: Zhuangtai)
    func isOff(zt: Zhuangtai)
    func meOff()
}