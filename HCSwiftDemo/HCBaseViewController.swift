//
//  HCBaseViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/21.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class HCBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

func Log<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG           /// debug
    let nowDate = Date.init()
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let time = formatter.string(from: nowDate)
    print("[\(time)] [\((file as NSString).lastPathComponent), line: \(line), method: \(method)]\t\(message)")
    #endif
}
