
//
//  ShowViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/16.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class ShowViewController: HCBaseViewController {

    var showImage : UIImage? {
        didSet {
            compressImage()
        }
    }
    private var showImageView = UIImageView.init()
    private var imageInfoLabel = UILabel.init()
            
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showImageView.frame = self.view.bounds
        self.showImageView.contentMode = .scaleAspectFit
        self.view.addSubview(showImageView)
        
        self.imageInfoLabel.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        self.imageInfoLabel.textColor = .red
        self.imageInfoLabel.textAlignment = .center
        self.imageInfoLabel.bottom = UIScreen.main.bounds.size.height
        self.view.addSubview(self.imageInfoLabel)
        
        // Do any additional setup after loading the view.
    }
    
    func compressImage() {
        let OrData = showImage?.jpegData(compressionQuality: 0.5)?.count ?? 0
        let image = showImage?.wxCompress(type: .timeline)
        let AfData = image?.jpegData(compressionQuality: 0.5)?.count ?? 0
        showImageView.image = image
        
        self.imageInfoLabel.text = " origin: \(OrData/1000)k, After: \(AfData/1000)k"
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
