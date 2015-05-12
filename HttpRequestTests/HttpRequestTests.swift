//
//  HttpRequestTests.swift
//  HttpRequestTests
//
//  Created by Bradley Hilton on 4/19/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import XCTest
import HttpRequest

class HttpRequestTests: XCTestCase {
    
    func testGetContacts() {
        var expectation = self.expectationWithDescription("Get Contacts")
        waitForExpectationsWithTimeout(100.0, handler: nil)
    }
    
}
