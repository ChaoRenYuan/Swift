//
//  CRUploadPictureViewModel.swift
//  News
//
//  Created by 任大树 on 2017/7/25.
//  Copyright © 2017年 任大树. All rights reserved.
//

import Foundation

// Vendor
import Alamofire
import SwiftyJSON

class CRUploadPictureViewModel: NSObject {
    
    /// 上传图片block
    typealias UploadPictureBlock = (Int)->()
    var successBlock: UploadPictureBlock?

    //MARK:- 上传图片
    func upLoadImageRequest(urlString: String, params: [String:String], data: [Data], name: [String], successCallBlock: @escaping UploadPictureBlock) {
        
        let headers = ["content-type":"multipart/form-data"]
        self.successBlock = successCallBlock
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key,value) in params {
                assert(value is String, "参数必须能够转换为NSData的类型，比如String")
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
            
            for i in 0..<data.count {
                multipartFormData.append(data[i], withName: name[i], fileName: name[i], mimeType: "image/png")
            }
            
        },to: urlString,headers: headers,encodingCompletion: { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):

                upload.responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("🇨🇳请求的接口:" + "\n" + "\(urlString)" + "\n" +
                            "Result:" + "\n" + "\(json)" + "\n")
                        guard let successBlock = self.successBlock else { return }
                        successBlock(200)
                        
                    case .failure(let error):
                        print(error)
                        guard let successBlock = self.successBlock else { return }
                        successBlock(201)
                    }
                }
            case .failure(let error):
                print(error)
                guard let successBlock = self.successBlock else { return }
                successBlock(500)
            }
        })
    }
    
    
}

