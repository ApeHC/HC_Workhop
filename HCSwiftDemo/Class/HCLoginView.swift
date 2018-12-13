//
//  HCLoginView.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/12/5.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

protocol HCLoginStatusDelegate : NSObjectProtocol{
    func loginStatusClick(code : Int)
}

class HCLoginView: UIView {

    weak var delegate : HCLoginStatusDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loginForAccount() {
        DispatchQueue.global().async {
            sleep(2)
            let code = 2656
            DispatchQueue.main.async {
                self.delegate?.loginStatusClick(code: code)
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
