//
//  HttpRequest+SwiftArray.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 4/21/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

extension HttpRequest {
    
    func typeIsSwiftArray(type: Any) -> Bool {
        return "\(type)".hasPrefix("Swift.Array")
    }
    
    func arrayForData(data: NSData, inout error: NSError?) -> T? {
        if let genericType = genericTypeForArray(T) {
            if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSArray {
                let array = NSMutableArray()
                for object in jsonArray {
                    if let dictionary = object as? NSDictionary {
                        if let object = objectWithType(genericType, dictionary: dictionary, error: &error) {
                            array.addObject(object)
                        } else {
                            return nil
                        }
                    } else {
                        error = HttpError(request: self, description: "Error: Non-dictionary object in JSON array. Unable to convert to NSObject.")
                        return nil
                    }
                }
                return array as? T
            } else {
                return nil
            }
        } else {
            error = HttpError(request: self, description: "Error: Unable to find array element type T, must a valid NSObject subclass.")
            return nil
        }
    }
    
    func dataFromArray(array: DataConvertible) -> NSData? {
        if let array = array as? NSArray {
            let jsonArray = NSMutableArray()
            for object in array {
                if let object = object as? NSObject {
                    jsonArray.addObject(JsonSerializer.dictionaryFrom(object))
                }
            }
            return NSJSONSerialization.dataWithJSONObject(jsonArray, options: nil, error: nil)
        } else {
            return nil
        }
    }
    
    private func genericTypeForArray(type: Any) -> NSObject.Type? {
        if let opening = "\(type)".rangeOfString("<", options: nil, range: nil, locale: nil),
            let close = "\(type)".rangeOfString(">", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) {
                return NSClassFromString("\(type)".substringWithRange(Range<String.Index>(start: opening.endIndex, end: close.startIndex))) as? NSObject.Type
        } else {
            return nil
        }
    }
    
}