//
//  LottieViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/12/5.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class LottieViewController: HCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        animation1.frame = CGRect.init(x: 0, y: 0, width: 200, height: 200)
        animation1.center = self.view.center
        self.view.addSubview(animation1)
        animation1.play()
    }
    
    lazy var animation1 : LOTAnimationView = {
        let _animation1 = LOTAnimationView.init(name: "heartBeat")
        _animation1.contentMode = .scaleAspectFill
        _animation1.loopAnimation = true
        return _animation1
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
