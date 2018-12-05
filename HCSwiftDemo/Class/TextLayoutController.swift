//
//  TextLayoutController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/22.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class TextLayoutController: HCBaseViewController {

    var textBlock : ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let textView = YYLabel.init()
        textView.frame = CGRect.init(x: 2, y: 0, width: KHCScreenWidth-4, height: KHCScreenWidth)
        textView.center = self.view.center
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        view.addSubview(textView)
        
        let textStr : String = "--------->TapAction<--------"
        let subTextStr : String = "TapAction"
        let range : NSRange = TransformRange.getWithText(textStr, subText: subTextStr)
        /*
        let attrText = NSString.compositeText(withText: textStr,
                                              textColor: .blue,
                                              subText: "TapAction",
                                              subTextColor: .red,
                                              textFont: UIFont.systemFont(ofSize: 15))
        */
        let attribute = NSMutableAttributedString.init(string: textStr)
        attribute.font = UIFont.systemFont(ofSize: 20)
        attribute.backgroundColor = UIColor.orange
        attribute.setColor(UIColor.orange, range: range)
        attribute.setTextHighlight(range, color: .red, backgroundColor: UIColor.lightGray) { (view, attributeString, range, rect) in
            UIApplication.shared.open(URL.init(string: "https://www.baidu.com/")! , options: [:], completionHandler: nil)
        }
        textView.attributedText = attribute
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
