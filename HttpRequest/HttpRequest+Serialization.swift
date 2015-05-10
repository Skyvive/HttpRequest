//
//  HttpRequest+Serialization.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 4/21/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

extension HttpRequest {
    
    var dataBody: NSData? {
        get {
            if let body = body {
                if typeIsSwiftArray(body) {
                    return dataFromArray(body)
                }
                switch (body) {
                case let null as NSNull: return nil
                case let data as NSData: return data
                case let string as NSString: return string.dataUsingEncoding(NSUTF8StringEncoding)
                case let number as NSNumber: return number.stringValue.dataUsingEncoding(NSUTF8StringEncoding)
                case let array as NSArray: return NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
                case let dictionary as NSDictionary: return NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil)
                case let object as NSObject: return NSJSONSerialization.dataWithJSONObject(JsonSerializer.dictionaryFrom(object), options: nil, error: nil)
                case let string as String: return string.dataUsingEncoding(NSUTF8StringEncoding)
                default: return nil
                }
            } else {
                return nil
            }
        }
    }
    
}