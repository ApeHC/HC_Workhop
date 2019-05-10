//
//  ParticleViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2019/5/10.
//  Copyright © 2019 HeChuang. All rights reserved.
//

import UIKit

class ParticleViewController: HCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpParticle()
    }
    
    private func setUpParticle() {
        //创建发射器
        let leafEmirtter = CAEmitterLayer.init()
        self.view.layer.addSublayer(leafEmirtter)
        //发射器的中心
        leafEmirtter.emitterPosition = CGPoint.init(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0)
        //发射器的大小
        leafEmirtter.emitterSize = CGSize.init(width: 0, height: 0)
        //发射器的形状
        leafEmirtter.emitterShape = CAEmitterLayerEmitterShape.line
        //发射器的mode
        leafEmirtter.emitterMode = CAEmitterLayerEmitterMode.points
        //设置粒子
        var mutableArray: [CAEmitterCell] = []
        for i in 0 ..< 4 {
            let imageName = "ye\(i).jpg"
            let leaftCell = CAEmitterCell.init()
            
            leaftCell.birthRate = 2
            leaftCell.lifetime = 50
            leaftCell.velocity = 10
            leaftCell.velocityRange = 5
//            leaftCell.yAcceleration = 2
//            leaftCell.xAcceleration = 2
            leaftCell.spin = 1.0
            leaftCell.spinRange = 2.0
            leaftCell.emissionRange = CGFloat.pi * 2
            leaftCell.contents = UIImage.init(named: imageName)?.cgImage
            leaftCell.scale = 0.3
            leaftCell.scaleRange = 0.2
            mutableArray.append(leaftCell)
        }
        leafEmirtter.emitterCells = mutableArray
    }
}
