//
//  HttpRequestBuilder.swift
//  HttpRequest
//
//  Created by Bradley Hilton on 4/18/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

public class HttpRequestBuilder<T: DataConvertible> {
    
    public typealias CompletionCallback = (HttpResponse<T>?, HttpError<T>?) -> ()
    public typealias SuccessCallback = (HttpResponse<T>) -> ()
    public typealias FailureCallback = (HttpError<T>) -> ()
    
    let httpRequest: HttpRequest<T>
    var hasMadeRequest = false
    
    init(method: String, basePath: String) {
        httpRequest = HttpRequest<T>()
        httpRequest.method = method
        httpRequest.basePath = basePath
    }
    
    public func logging(loggingEnabled: Bool) -> Self {
        httpRequest.loggingEnabled = loggingEnabled
        return self
    }
    
    public func path(path: String) -> Self {
        httpRequest.relativePath += path
        return self
    }
    
    public func parameters(parameters: [String : String?]) -> Self {
        for (key, value) in parameters {
            httpRequest.parameters[key] = value
        }
        return self
    }
    
    public func headers(headers: [String : String?]) -> Self {
        for (key, value) in headers {
            httpRequest.headers[key] = value
        }
        return self
    }
    
    public func body(body: DataConvertible?) -> Self {
        httpRequest.body = body
        return self
    }
    
    public func timeout(timeoutInterval: NSTimeInterval?) -> Self {
        httpRequest.timeoutInterval = timeoutInterval
        return self
    }
    
    public func cache(cachePolicy: NSURLRequestCachePolicy?) -> Self {
        httpRequest.cachePolicy = cachePolicy
        return self
    }
    
    public func completion(completion: CompletionCallback) -> Self {
        httpRequest.completion = completion
        makeRequest()
        return self
    }
    
    public func success(success: SuccessCallback) -> Self {
        httpRequest.success = success
        makeRequest()
        return self
    }
    
    public func failure(failure: FailureCallback) -> Self {
        httpRequest.failure = failure
        makeRequest()
        return self
    }
    
    private func makeRequest() {
        if (!hasMadeRequest) {
            httpRequest.makeRequest()
            hasMadeRequest = true
        }
    }
    
}

public class GET<T: DataConvertible>: HttpRequestBuilder<T> {
    
    public init(_ basePath: String) {
        super.init(method: "GET", basePath: basePath)
    }
    
}

public class POST<T: DataConvertible>: HttpRequestBuilder<T> {
    
    public init(_ basePath: String) {
        super.init(method: "POST", basePath: basePath)
    }
    
}

public class PUT<T: DataConvertible>: HttpRequestBuilder<T> {
    
    public init(_ basePath: String) {
        super.init(method: "PUT", basePath: basePath)
    }
    
}

public class PATCH<T: DataConvertible>: HttpRequestBuilder<T> {
    
    public init(_ basePath: String) {
        super.init(method: "PATCH", basePath: basePath)
    }
    
}

public class DELETE<T: DataConvertible>: HttpRequestBuilder<T> {
    
    public init(_ basePath: String) {
        super.init(method: "DELETE", basePath: basePath)
    }
    
}