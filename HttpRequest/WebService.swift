//
//  WebService.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 5/9/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

/// Base web service. Subclass and override configureService() to use.
public class WebService {
    
    public var path: String = ""
    public var headers: [String: String?] = [String: String?]()
    public var parameters: [String: String?] = [String: String?]()
    public var loggingEnabled: Bool?
    public var timeoutInterval: NSTimeInterval?
    public var cachePolicy: NSURLRequestCachePolicy?
    public func configureService() {}
    required public init() {
        configureService()
    }
    
}