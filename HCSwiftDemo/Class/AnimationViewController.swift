//
//  AnimationViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/12/7.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class AnimationViewController: HCBaseViewController {

    fileprivate var defaultCornerRadius: CGFloat = 175
    fileprivate var contentView : UIView!
    fileprivate var shapeLayer = CAShapeLayer.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 350, height: 350))
        contentView.center = self.view.center
        contentView.backgroundColor = UIColor.orange
        self.view.addSubview(contentView)
        
        let path = UIBezierPath.init()
        path.addArc(withCenter: CGPoint.init(x: 175, y: 350), radius: 175, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: 350, height: 350)
        shapeLayer.position = CGPoint.init(x: 175, y: 175)
        
        let animation = CABasicAnimation.init()
        animation.keyPath = "cornerRadius"
        animation.fromValue = 0
        animation.toValue = 2 * CGFloat.pi
        animation.duration = 1.5

        let group = CAAnimationGroup.init()
        group.animations = [animation]
        group.duration = 1.5
        group.repeatCount = HUGE
        group.fillMode = CAMediaTimingFillMode.forwards
        group.isRemovedOnCompletion = false

        shapeLayer.add(group, forKey: "111")
        
        contentView.layer.addSublayer(shapeLayer)

//        let timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(changeCornerRadius), userInfo: nil, repeats: true)
//        timer.fire()
    }
    
    @objc func changeCornerRadius() {
        defaultCornerRadius += 3
        animationPath(cornerRadius: defaultCornerRadius)
    }
    
    func animationPath(cornerRadius: CGFloat) {
        shapeLayer.path = nil
        let path = UIBezierPath.init()
        path.addArc(withCenter: CGPoint.init(x: 175, y: 350 + defaultCornerRadius - 175), radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)
        shapeLayer.path = path.cgPath

    }
}
