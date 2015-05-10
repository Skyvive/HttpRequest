//
//  HttpResponse.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 4/18/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

public class HttpResponse<T: DataConvertible> {
    
    public let object: T
    public let headers: [String : String]
    public let statusCode: Int
    public let responseTime: NSTimeInterval
    public let request: HttpRequest<T>
    public let urlResponse: NSHTTPURLResponse
    
    public init(object: T, responseTime: NSTimeInterval, request: HttpRequest<T>, urlResponse: NSHTTPURLResponse) {
        self.object = object
        self.headers = HttpResponse.headersFromUrlResponse(urlResponse)
        self.statusCode = urlResponse.statusCode
        self.responseTime = responseTime
        self.request = request
        self.urlResponse = urlResponse
    }
    
    class func headersFromUrlResponse(urlResponse: NSHTTPURLResponse) -> [String : String] {
        var headers = [String : String]()
        for (key, value) in urlResponse.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers[key] = value
            }
        }
        return headers
    }
    
}