//
//  HttpRequest+Deserialization.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 4/21/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

extension HttpRequest {
    
    func objectForData(data: NSData?, inout error: NSError?) -> T? {
        if let data = data {
            if typeIsSwiftArray(T) {
                return arrayForData(data, error: &error)
            }
            switch (T.self) {
            case is NSNull.Type: return NSNull() as? T
            case is NSData.Type: return data as? T
            case is String.Type: fallthrough
            case is NSString.Type: return NSString(data: data, encoding: NSUTF8StringEncoding) as? T
            case is NSNumber.Type: return jsonObjectWithData(data, error: &error)
            case is NSDictionary.Type: return jsonObjectWithData(data, error: &error)
            case is NSArray.Type: return jsonObjectWithData(data, error: &error)
            case is NSObject.Type: return deserializedObjectForData(data, error: &error)
            default:
                error = HttpError(request: nil, description: "Error: Type \(T.self) is unsupported")
                return nil
            }
        } else {
            switch (T.self) {
            case is NSNull.Type: return NSNull() as? T
            default:
                error = HttpError(request: nil, description: "Error: No data returned by request. If expecting no body, set request type T as NSNull.")
                return nil
            }
        }
    }
    
    private func jsonObjectWithData<T>(data: NSData, inout error: NSError?) -> T? {
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as? T
    }
    
    private func deserializedObjectForData(data: NSData, inout error: NSError?) -> T? {
        if let type = T.self as? NSObject.Type,
            let dictionary: NSDictionary = jsonObjectWithData(data, error: &error) {
                return objectWithType(type, dictionary: dictionary, error: &error) as? T
        } else {
            return nil
        }
    }
    
    func objectWithType(type: NSObject.Type, dictionary: NSDictionary, inout error: NSError?) -> NSObject? {
        let object = type()
        if JsonSerializer.validateDictionary(dictionary, forObject: object) {
            JsonSerializer.loadDictionary(dictionary, intoObject: object)
            if JsonSerializer.validateObject(object) {
                return object
            } else {
                error = HttpError(request: nil, description: "Failed to deserialize required property keys: \(JsonSerializer.requiredKeysMissingFromObject(object))")
                return nil
            }
        } else {
            error = HttpError(request: nil, description: "Required JSON keys are missing from dictionary: \(JsonSerializer.requiredKeysMissingFromDictionary(dictionary, forObject: object))")
            return nil
        }
    }
    
}
