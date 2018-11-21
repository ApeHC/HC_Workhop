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
    var clickVCArray  : [HCBaseViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        
        self.addCell(cellTitle: "ImageCompress", clickClass: PhotolibrarController())
        self.addCell(cellTitle: "DownloadImage", clickClass: WebImageViewController())
        
        
        self.tableView.reloadData()
        
    }
    
    func addCell(cellTitle: String, clickClass: HCBaseViewController) {
        cellNameArray.append(cellTitle)
        clickVCArray.append(clickClass)
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
        let vc : HCBaseViewController = clickVCArray[indexPath.row]
        vc.title = cellNameArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
