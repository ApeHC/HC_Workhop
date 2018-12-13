//
//  BlockViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/12/5.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class BlockViewController: HCBaseViewController {

    fileprivate var loginView : HCLoginView!
    fileprivate var status : ((Bool)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        loginView = HCLoginView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        loginView.center = self.view.center
        loginView.delegate = self
        self.view.addSubview(loginView)
        
        _registerAutomaticlly { (success : Bool) in
            Log("---->, \(success)")
        }
        Log("1")
    }
    
    func _registerAutomaticlly(_ onComplete:((Bool)->Void)?){
        Log("注册")
        status = onComplete
        _loginAutomatically(onComplete)
    }
    
    func _loginAutomatically(_ onComplete:((Bool)->Void)?){
        Log("登录")
        loginView.loginForAccount()
    }
    
    deinit {
        print("<<<<<<<<<<<")
    }
    
}

extension BlockViewController : HCLoginStatusDelegate {
    
    func loginStatusClick(code: Int) {
        Log("登录状态")
        if code == 2656 {
            status!(true)
        }else {
            status!(false)
        }
    }
}

