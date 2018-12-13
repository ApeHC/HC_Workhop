//
//  AnimationViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/12/7.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class AnimationViewController: HCBaseViewController {

    fileprivate var contentView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 350, height: 350))
        contentView.center = self.view.center
        contentView.backgroundColor = UIColor.lightGray
        self.view.addSubview(contentView)
    }
    
    
}
