//
//  PlayerViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2019/2/19.
//  Copyright © 2019 HeChuang. All rights reserved.
//

import UIKit

class PlayerViewController: HCBaseViewController {

    var player: HCPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player = HCPlayer.init(url: URL(string: "https://scontent-sea1-1.cdninstagram.com/vp/acffd4a9f3c6babf0ff2fb8f4add853f/5C6D9AD4/t50.2886-16/52364692_235139487391765_760731874552184832_n.mp4?_nc_ht=scontent-sea1-1.cdninstagram.com"))
        player?.frame = CGRect.init(x: 0, y: 200, width: KHCScreenWidth, height: KHCScreenWidth * 9.0 / 16.0)
        player?.rate = 1.0
        self.view.addSubview(player!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.stop()
        player = nil
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
