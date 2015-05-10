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
        GET<[Contact]>("https://sapi.sendoutcards.com/v1/contacts")
            .logging(true)
            .parameters(["simple":"true"])
            .headers(["Authorization":"Token a77a499e306b3ea41f574a185522556a8146d76f"])
            .success { (response) -> () in
                println("Response Time: \(response.responseTime)")
                for contact in response.object {
                    println("\(contact.id) - " + contact.firstName + " " + contact.lastName + " - " + contact.companyName)
                }
                expectation.fulfill()
            }.failure { (error) -> () in
                println(error.localizedDescription)
                XCTAssert(false, "Returned an error")
                expectation.fulfill()
            }
        waitForExpectationsWithTimeout(100.0, handler: nil)
    }
    
}

class Contact: NSObject, MapsUnderscoreCaseToCamelCase, ValidateImplicitlyUnwrappedOptionals {
    var id: NSNumber!
    var firstName: String!
    var lastName: String!
    var companyName: String!
}
