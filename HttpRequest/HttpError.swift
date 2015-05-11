//
//  HttpError.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 5/9/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

let HttpErrorRequestKey = "HttpErrorRequestKey" // Key to access NSURLRequest
let HttpErrorDataKey = "HttpErrorDataKey" // Key to access NSData
let HttpErrorBodyKey = "HttpErrorBodyKey" // Key to access string represenation of NSData
let HttpErrorResponseKey = "HttpErrorResponseKey" // Key to access NSURLResponse

public class HttpError: NSError {
    
    var request: NSURLRequest? { return objectForKey(HttpErrorRequestKey) as? NSURLRequest }
    var data: NSData? { return objectForKey(HttpErrorDataKey) as? NSData }
    var body: NSString? { return objectForKey(HttpErrorBodyKey) as? NSString }
    var response: NSURLResponse? { return objectForKey(HttpErrorResponseKey) as? NSURLResponse }
    
    func objectForKey(key: String) -> AnyObject? {
        if let userInfo = userInfo {
            return userInfo[key as NSString]
        } else {
            return nil
        }
    }
    
    init(error: NSError?, request: NSURLRequest?, data: NSData?, response: NSURLResponse?, description: String?) {
        var userInfo = NSMutableDictionary()
        userInfo.safeSetValue(request, forKey: HttpErrorRequestKey)
        userInfo.safeSetValue(data, forKey: HttpErrorDataKey)
        userInfo.safeSetValue(data != nil ? NSString(data: data!, encoding: NSUTF8StringEncoding) : nil, forKey: HttpErrorBodyKey)
        userInfo.safeSetValue(response, forKey: HttpErrorResponseKey)
        userInfo.safeSetValue(description, forKey: NSLocalizedDescriptionKey)
        if let error = error {
            if let errorUserInfo = error.userInfo {
                userInfo.addEntriesFromDictionary(errorUserInfo)
            }
            super.init(domain: error.domain, code: error.code, userInfo: userInfo as [NSObject : AnyObject])
        } else {
            super.init(domain: "HttpRequest.HttpError", code: 0, userInfo: userInfo as [NSObject : AnyObject])
        }
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension HttpError {
    
    convenience init(request: NSURLRequest?, description: String?) {
        self.init(error: nil, request: request, data: nil, response: nil, description: description)
    }
    
}

extension NSMutableDictionary {
    
    func safeSetValue(value: AnyObject?, forKey key: String) {
        if let value: AnyObject = value {
            self[key] = value
        }
    }
    
}
