//
//  NetworkingViewController.swift
//  HCSwiftDemo
//
//  Created by HeChuang on 2018/12/5.
//  Copyright © 2018 HeChuang. All rights reserved.
//

import UIKit

class NetworkingViewController: HCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var requestHeader:HTTPHeaders = Dictionary();
        requestHeader["token"] = "0d4991a46c73b7915690a3c78c82de82";
        
        let data = UIImage.init(named: "bigImg1")?.jpegData(compressionQuality: 0.5)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data!, withName: "image", fileName: "image", mimeType: "image/jpeg")
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: "http://datingtest.alphatech.mobi/api/deletePhoto", method: .post, headers: requestHeader) { (encodingResult) in
            switch encodingResult {
                
            case .success(let request, _, _):
                request.uploadProgress(closure: { (progress) in
                    print( "defa: \(progress.completedUnitCount) / \(progress.totalUnitCount)")
                })
                break
            case .failure(_):
                
                break
            }
        }
        
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
