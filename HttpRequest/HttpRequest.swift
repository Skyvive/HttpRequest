//
//  HttpRequest.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 4/18/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

// All the following types that implement DataConvertible can be converted to NSData and vice-versa.
// Implementing DataConvertible on your own unsupported types will return an error.

public protocol DataConvertible {}
extension NSNull: DataConvertible {}
extension NSData: DataConvertible {}
extension NSString: DataConvertible {}
extension NSNumber: DataConvertible {}
extension NSArray: DataConvertible {}
extension NSDictionary: DataConvertible {}
extension NSObject: DataConvertible {}
extension String: DataConvertible {}
extension Array: DataConvertible {} // Must be an array of DataConvertible objects

public class HttpRequest<T: DataConvertible> {
    public typealias CompletionCallback = (HttpResponse<T>?, HttpError<T>?) -> ()
    public typealias SuccessCallback = (HttpResponse<T>) -> ()
    public typealias FailureCallback = (HttpError<T>) -> ()
    public var loggingEnabled = false
    public var method: String = "GET"
    public var basePath: String = ""
    public var relativePath: String = ""
    public var parameters: [String : String] = [String : String]()
    public var headers: [String : String] = [String : String]()
    public var body: DataConvertible?
    public var timeoutInterval: NSTimeInterval?
    public var cachePolicy: NSURLRequestCachePolicy?
    public var completion: CompletionCallback?
    public var success: SuccessCallback?
    public var failure: FailureCallback?
    public init() {}
    public func makeRequest() { makeRequestInternal() }
}
