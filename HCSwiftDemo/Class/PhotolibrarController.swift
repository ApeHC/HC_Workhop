//
//  ViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/10/30.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class PhotolibrarController: HCBaseViewController, UINavigationControllerDelegate , UIImagePickerControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton.init()
        button.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        button.center = self.view.center
        button.setTitle("Photos", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonClick(sender : UIButton) {
        let imagePicker = UIImagePickerController.init()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        imagePicker.allowsEditing = false
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true) {
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: false) {
            
        }
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let vc = ShowViewController()
        vc.showImage = image
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

