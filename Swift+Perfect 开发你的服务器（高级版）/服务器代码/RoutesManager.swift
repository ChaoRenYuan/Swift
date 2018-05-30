//
//  RoutesManager.swift
//  TestTemplate
//
//  Created by 任大树 on 2017/12/22.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

class BasicRoutes {
    
    var routes: [Route] {
        return [
            Route(method: .post, uri: "/api/testUploadImage", handler: TestUpload)
        ]
    }
    
    
}

