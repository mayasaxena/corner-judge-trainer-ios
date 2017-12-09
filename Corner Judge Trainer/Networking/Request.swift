//
//  Request.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/6/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

private var ISLOCAL = true

enum Request {

    static let domainBase = ISLOCAL ? "0.0.0.0:8080/" : "corner-judge.herokuapp.com/"

    static let baseURLString = "http://\(domainBase)"

    struct HeaderKey {
        static let accept = "Accept"
        static let contentType = "Content-Type"
        static let appKey = "AppKey"
    }

    case getMatches

    var method: HTTPMethod {
        switch self {
        case .getMatches:
            return .GET
        }
    }

    var urlRequest: Foundation.URLRequest {
        guard let url = Foundation.URL(string: Request.baseURLString) else { fatalError("Could not create URL") }
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: HeaderKey.accept)
        request.setValue("application/json", forHTTPHeaderField: HeaderKey.contentType)
        request.httpMethod = method.rawValue
        request.httpBody = nil

        return request as URLRequest
    }
}
