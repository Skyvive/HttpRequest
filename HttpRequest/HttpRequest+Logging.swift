//
//  HttpRequest+Logging.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 5/9/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation


extension HttpRequest {
    
    func logRequest(request: NSURLRequest) {
        if let method = request.HTTPMethod,
            let url = request.URL?.absoluteString where loggingEnabled {
            println("\n---> \(method) \(url)")
            printHeaderFields(request.allHTTPHeaderFields)
            printBody(request.HTTPBody)
            println("---> END " + bytesDescription(request.HTTPBody))
        }
    }
    
    func logResponse(response: NSURLResponse?, request: NSURLRequest, responseTime: NSTimeInterval, data: NSData?) {
        if let method = request.HTTPMethod,
            let url = request.URL?.absoluteString,
            let response = response as? NSHTTPURLResponse where loggingEnabled {
                println("\n<--- \(method) \(url) (\(response.statusCode), \(responseTimeDescription(responseTime)))")
                printHeaderFields(response.allHeaderFields)
                printBody(data)
                println("<--- END " + bytesDescription(data))
        }
    }
    
    func responseTimeDescription(responseTime: NSTimeInterval) -> NSString {
        return NSString(format: "%0.2fs", responseTime)
    }
    
    func printHeaderFields(headerFields: [NSObject : AnyObject]?) {
        if let headerFields = headerFields {
            for (field, value) in headerFields {
                println("\(field): \(value)")
            }
        }
    }
    
    func printBody(data: NSData?) {
        if let body = data,
            let bodyString = NSString(data: body, encoding: NSUTF8StringEncoding) where bodyString.length > 0 {
                println(bodyString)
        }
    }
    
    func bytesDescription(data: NSData?) -> String {
        return "(\(data != nil ? data!.length : 0) bytes)"
    }
    
}