//
//  WebImageViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/21.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class WebImageViewController: HCBaseViewController {

    private var imageView : UIImageView!
    private let urlStr = "http://dlcj1uppc65bl.cloudfront.net/userPhoto/1542731707_cytQ.jpg"
    //"http://dlcj1uppc65bl.cloudfront.net/userPhoto/07a4fa834f70ca0465aa9673c9d1abb852576.jpeg"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        YYWebImageManager.shared().requestImage(with: URL.init(string: urlStr)!,
                                                options: .showNetworkActivity,
                                                progress: nil,
                                                transform: nil) { (image : UIImage?, url : URL, from : YYWebImageFromType, stage : YYWebImageStage, error : Error?) in
                                                    
                                                    
        }
        */
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: KHCScreenWidth, height: KHCScreenWidth))
        imageView.center = self.view.center
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.lightGray
        self.view.addSubview(imageView)
        
        self.view.addSubview(progressLine)
        self.view.addSubview(progressLabel)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.downLoadWebImage(url: self.urlStr)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func downLoadWebImage(url: String) {
        imageView.setImageWith(URL.init(string: url)!,
                               placeholder: nil,
                               options: [.showNetworkActivity, .progressiveBlur, .ignoreDiskCache],
                               progress: { (receivedSize, expectedSize) in
                                self.imageDownloadProgress(currentValue: receivedSize, totalValue: expectedSize, url: url)
        }, transform: { (image: UIImage, url: URL) -> UIImage? in
            return image
        }) { (image, url, from, stage, error) in
            
        }
    }
    
    func imageDownloadProgress(currentValue: Int, totalValue: Int, url: String) {
        guard totalValue != 0 else {
            progressLabel.text = "loading...\n\(url) "
            return
        }
        let current = Float(currentValue)
        let total = Float(totalValue)
        progressLine.progress = current/total
        progressLabel.text = "\(current/1000.0) / \(total/1000.0)Kb \n\(url)"
    }
    
    lazy var progressLine : UIProgressView = {
        let _progressLine = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: KHCScreenWidth, height: 2))
        _progressLine.centerX = self.view.centerX
        _progressLine.top = imageView.bottom + 2
        _progressLine.progressViewStyle = UIProgressView.Style.default
        _progressLine.progressTintColor = .blue
        _progressLine.tintColor = UIColor.lightGray
        return _progressLine
    }()
    
    lazy var progressLabel : UILabel = {
        let _progressLabel = UILabel.init(frame: CGRect.init(x: 0, y: 2, width: KHCScreenWidth, height: 40))
        _progressLabel.top = imageView.bottom
        _progressLabel.textColor = .red
        _progressLabel.textAlignment = .right
        _progressLabel.font = UIFont.systemFont(ofSize: 15)
        _progressLabel.numberOfLines = 2
        return _progressLabel
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
