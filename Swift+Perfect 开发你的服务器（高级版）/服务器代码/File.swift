//
//  File.swift
//  TestTemplate
//
//  Created by 任大树 on 2017/12/22.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectMustache

class UploadHandler: MustachePageHandler {
    func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        #if DEBUG
            print("UploadHandler got request")
        #endif
        var values = MustacheEvaluationContext.MapType()
        let request = contxt.webRequest
        
        #if os(Linux)
            guard let parentPath = Dir.workingDir.parentDir?.path  else {
                return
            }
            let fileDir = Dir(parentPath + "usr/local/sources/pictures/" + "user110")
            do {
                try fileDir.create()
            } catch {
                print(error)
            }
        #else
            let fileDir = Dir(Dir.workingDir.path + "files")
            do {
                try fileDir.create()
            } catch {
                print(error)
            }
        #endif
        
        
        if let uploads = request.postFileUploads, uploads.count > 0 {
            var ary = [[String:Any]]()
            
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
                do {
                    let _ = try thisFile.moveTo(path: fileDir.path + upload.fileName, overWrite: true)
                } catch {
                    print(error)
                }
                
            }
            values["files"] = ary
            values["count"] = ary.count
        }
        
        let params = request.params()
        if params.count > 0 {
            var ary = [[String:Any]]()
            
            for (name, value) in params {
                ary.append([
                    "paramName":name,
                    "paramValue":value
                    ])
            }
            values["params"] = ary
            values["paramsCount"] = ary.count
        }
        
        values["title"] = "Upload Enumerator"
        contxt.extendValues(with: values)
        do {
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
}



