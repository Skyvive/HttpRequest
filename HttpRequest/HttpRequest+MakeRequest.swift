//
//  HttpRequest-Internal.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 4/19/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

extension HttpRequest {
    
    func makeRequestInternal() {
        if let request = request {
            logRequest(request)
            let startTime = NSDate()
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                let responseTime = NSDate().timeIntervalSinceDate(startTime)
                self.logResponse(response, request: request, responseTime: responseTime, data: data)
                if error != nil {
                    self.throwError(HttpError(error: error, request: request, data: data, response: response, description: nil))
                } else if let response = response as? NSHTTPURLResponse where response.statusCode >= 200 && response.statusCode < 300 {
                    var error: NSError?
                    if let object = self.objectForData(data, error: &error) {
                        let httpResponse = HttpResponse(object: object, responseTime: responseTime, request: self, urlResponse: response)
                        self.completion?(httpResponse, nil)
                        self.success?(httpResponse)
                    } else if let error = error {
                        self.throwError(HttpError(error: error, request: request, data: data, response: response, description: nil))
                    } else {
                        self.throwError(HttpError(error: nil, request: request, data: data, response: response, description: "Failed for to deserialize data. Request type T may be unsupported."))
                    }
                } else {
                    self.throwError(HttpError(error: error, request: request, data: data, response: response, description: "Failed for unknown reason: status code does not fall between 200-299"))
                }
            })
        }
    }
    
    func throwError(error: HttpError) {
        self.completion?(nil, error)
        self.failure?(error)
    }
    
    var request: NSURLRequest? {
        get {
            if let url = url {
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = method
                request.allHTTPHeaderFields = headers
                request.HTTPBody = dataBody
                request.timeoutInterval = timeoutInterval ?? request.timeoutInterval
                request.cachePolicy = cachePolicy ?? request.cachePolicy
                return request
            } else {
                self.throwError(HttpError(request: nil, description: "Failed to create request. Something may be wrong with request url: " + urlString))
                return nil
            }
        }
    }
    
    var url: NSURL? {
        get {
            return NSURL(string: urlString)
        }
    }
    
    var urlString: String {
        get {
            let path = basePath + relativePath
            if (parameters.count == 0) {
                return path
            } else {
                let components = NSURLComponents(string: path)
                var queryItems: [NSURLQueryItem] = components?.queryItems as? [NSURLQueryItem] ?? [NSURLQueryItem]()
                for (name, value) in parameters {
                    queryItems.append(NSURLQueryItem(name: name, value: value))
                }
                components?.queryItems = queryItems
                return components?.string?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) ?? path
            }
        }
    }
    
}