//
//  WebService+Implementation.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 5/9/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

extension WebService {
    
    func loadSettingsIntoRequest<T>(httpRequest: HttpRequest<T>) {
        httpRequest.basePath = absolutePath
        httpRequest.headers = allHeaders
        httpRequest.parameters = allParameters
        httpRequest.loggingEnabled = isLoggingEnabled
        httpRequest.cachePolicy = requestCachePolicy
    }
    
    private var absolutePath: String {
        if let superclass = superclass {
            return superclass().absolutePath + path
        } else {
            return ""
        }
    }
    
    private var allHeaders: [String: String] {
        if let superclass = superclass {
            var allHeaders = superclass().allHeaders
            for (key, value) in headers {
                allHeaders[key] = value
            }
            return allHeaders
        } else {
            return [String: String]()
        }
    }
    
    private var allParameters: [String: String] {
        if let superclass = superclass {
            var allParameters = superclass().allParameters
            for (key, value) in parameters {
                allParameters[key] = value
            }
            return allParameters
        } else {
            return [String: String]()
        }
    }
    
    private var isLoggingEnabled: Bool {
        if let superclass = superclass where loggingEnabled == nil {
            return superclass().isLoggingEnabled
        } else {
            return loggingEnabled ?? false
        }
    }
    
    private var requestCachePolicy: NSURLRequestCachePolicy? {
        if let superclass = superclass where loggingEnabled == nil {
            return superclass().requestCachePolicy
        } else {
            return cachePolicy ?? nil
        }
    }
    
    private var superclass: WebService.Type? {
        get {
            return (self.dynamicType as AnyClass).superclass() as? WebService.Type
        }
    }
    
}