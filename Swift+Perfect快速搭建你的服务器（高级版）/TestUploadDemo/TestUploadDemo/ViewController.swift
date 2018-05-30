//
//  ViewController.swift
//  TestUploadDemo
//
//  Created by 任大树 on 2018/5/29.
//  Copyright © 2018年 CRiOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var pictureViewModel = CRUploadPictureViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func uploadBtnPressed(_ sender: UIButton) {
        
        let picker = UIImagePickerController.init()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        guard let imageData = UIImagePNGRepresentation(image) else {
            return
        }
        self.uploadAction(imageData: [imageData])
    }

    func uploadAction(imageData: [Data]) {
        // 如果服务器的Demo在本地运行了，可用此链接：
        let basicURL = "http://127.0.0.1:8181/api/testUploadImage"
        
        // 如果这个接口无法用，意味着我的服务器没有续费（阿里云就不能给优惠给我们写文章的人？）
//        let basicURL = "http://www.crios.cn:8181/api/testUploadImage"
        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMddhhmm"
        let currentTime = dateformatter.string(from: now)
        
        var imgName = [String]()
        imgName.append(currentTime + ".png")
        print("上传中...");
        self.pictureViewModel.upLoadImageRequest(urlString: basicURL, params: ["iOSTime": currentTime], data: imageData, name: imgName, successCallBlock: { resultValue in
            switch "\(resultValue)" {
            case "200":
                print("上传完成...");
                break
            case "500":
                print("上传失败...");
                break
            default:
                break
            }
        })
        
    }

}

