//
//  MainViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/11/21.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var cellNameArray : [String] = []
    var clickVCArray  : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        
        self.addCell(cellTitle: "ImageCompress", clickClass: PhotolibrarController.self)
        self.addCell(cellTitle: "DownloadImage", clickClass: WebImageViewController.self)
        self.addCell(cellTitle: "TextLayout", clickClass: TextLayoutController.self)
        self.addCell(cellTitle: "LottieAnimation", clickClass: LottieViewController.self)
        self.addCell(cellTitle: "Network", clickClass: NetworkingViewController.self)
        self.addCell(cellTitle: "block1", clickClass: BlockViewController.self)
        self.addCell(cellTitle: "block2", clickClass: Black2ViewController.self)
        self.addCell(cellTitle: "Animation", clickClass: AnimationViewController.self)
        self.addCell(cellTitle: "Player", clickClass: PlayerViewController.self)
        self.addCell(cellTitle: "Particle", clickClass: ParticleViewController.self)
        self.tableView.reloadData()
        
    }
    
    func addCell(cellTitle: String, clickClass: AnyClass) {
        cellNameArray.append(cellTitle)
        clickVCArray.append(NSStringFromClass(clickClass))
    }
    
    lazy var tableView : UITableView = {
        let _tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.showsVerticalScrollIndicator = false
        _tableView.showsVerticalScrollIndicator = false
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        _tableView.tableFooterView = UIView.init(frame: .zero)
        return _tableView
    }()
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = cellNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vcClass = NSClassFromString(clickVCArray[indexPath.row]) as! HCBaseViewController.Type
        let vc = vcClass.init()
        vc.title = cellNameArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
