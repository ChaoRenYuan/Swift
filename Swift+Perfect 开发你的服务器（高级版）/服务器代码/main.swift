import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache

import Foundation

let root = "./webroot"



let server = HTTPServer()
server.serverPort = 8181
server.documentRoot = root

let basic = BasicRoutes()
server.addRoutes(Routes(basic.routes))

/* 另一种方法
 * var routes = Routes()
 * routes.add(method: .post, uri: "/testUpload", handler: TestUpload)
 * server.addRoutes(routes)
 */
do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Netword error thrown: \(err) \(msg)")
}

