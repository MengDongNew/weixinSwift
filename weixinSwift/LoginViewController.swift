//
//  LoginViewController.swift
//  weixinSwift
//
//  Created by mengdong on 14-10-9.
//  Copyright (c) 2014年 com.mengdong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet var autoLoginSwitch: UISwitch!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var serverTF: UITextField!
    @IBOutlet var pwdTF: UITextField!
    @IBOutlet var userTF: UITextField!
    
    var requireLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if sender as UIBarButtonItem == self.doneButton {
            //保存用户信息
            NSUserDefaults.standardUserDefaults().setObject(userTF.text, forKey: "weixinID")
            NSUserDefaults.standardUserDefaults().setObject(pwdTF.text, forKey: "weixinPwd")
            NSUserDefaults.standardUserDefaults().setObject(serverTF.text, forKey: "weixinServer")
            //保存自动登录状态
            NSUserDefaults.standardUserDefaults().setBool(autoLoginSwitch.on, forKey: "weixinAutoLogin")
            
            //同步
            NSUserDefaults.standardUserDefaults().synchronize()
            //需要登录
            requireLogin = true
        }
    }
    

}
