// 
//  RoutesHelper.swift
//  TestTemplate
//
//  Created by 任大树 on 2017/12/25.
//

import Foundation
import PerfectLib
import PerfectHTTP

let testStr = "CRTest"
// MARK: - 图片上传
func TestUpload(request: HTTPRequest, response: HTTPResponse) {
    
    do{
        
        guard let uploads = request.postFileUploads, uploads.count >= 1 else {
            let successArray: [String:Any] = ["result":"false", "msg":"请选择正确的图片数量"]
            let jsonStr = try successArray.jsonEncodedString()
            try response.setBody(json: jsonStr)
            response.completed()
            return
        }
        guard let currentTime = request.param(name: "iOSTime") else {
            return
        }
        #if os(Linux)
        guard let parentPath = Dir.workingDir.parentDir?.path else {
            return
        }
        
        let fileDir = Dir(parentPath + "usr/local/sources/pictures/" + currentTime)
        do {
            try fileDir.create()
        } catch {
            Log.error(message: "\(error)")
        }
        #else
        let fileDir = Dir(Dir.workingDir.path + "webroot/pictures")
        do {
            try fileDir.create()
        } catch {
            Log.error(message: "\(error)")
        }
        #endif
        
        if let uploads = request.postFileUploads, uploads.count > 0 {
            var ary = [[String:Any]]()
            var pathArr = [String]()
            for upload in uploads {
                ary.append([
                    "fieldName": upload.fieldName,
                    "contentType": upload.contentType,
                    "fileName": upload.fileName,
                    "fileSize": upload.fileSize,
                    "tmpFileName": upload.tmpFileName
                    ])
                // move file to webroot
                let thisFile = File(upload.tmpFileName)
                if (thisFile.path != "") {
                    do {
                        
                        let resultPath = fileDir.path + upload.fileName
                        let realPath = "http://www.crios.cn/pictures/" + "\(currentTime)" + upload.fileName
                        let _ = try thisFile.moveTo(path: resultPath, overWrite: true)
                        
                        
                        let sql = DataBaseManager().createTable(tableName: testStr + currentTime)
                        if sql.success {
                            #if os(Linux)
                            let _ = DataBaseManager().insertDatabaseSQL(tableName: testStr + currentTime, key: "path,currentTime", value: "'\(realPath)','\(currentTime)'")
                            #else
                            let _ = DataBaseManager().insertDatabaseSQL(tableName: testStr + currentTime, key: "path,currentTime", value: "'\(resultPath)','\(currentTime)'")
                            #endif
                        }
                        #if os(Linux)
                        pathArr.append(realPath)
                        #else
                        pathArr.append(resultPath)
                        #endif
                        
                    } catch {
                        let successArray: [String:Any] = ["success": 1, "result": "\(error)", "msg": "失败"]
                        Log.error(message: "\(error)")
                        let jsonStr = try successArray.jsonEncodedString()
                        try response.setBody(json: jsonStr)
                        response.completed()
                    }
                }
            }
            do {
                let successArray: [String:Any] = ["success": 1, "result": pathArr, "msg": "成功"]
                let jsonStr = try successArray.jsonEncodedString()
                try response.setBody(json: jsonStr)
                response.completed()
            } catch {
                
                let successArray: [String:Any] = ["success": 1, "result": "后台格式错误", "msg": "成功"]
                let jsonStr = try successArray.jsonEncodedString()
                try response.setBody(json: jsonStr)
                response.completed()
            }
            
        }
        
    }catch{
        Log.error(message: "\(error)")
    }
}

















