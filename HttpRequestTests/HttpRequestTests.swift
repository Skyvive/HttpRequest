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
        ContactsService.getContacts.success { (response) -> () in
            for contact in response.object {
                println("\(contact.id) - " + contact.firstName + " " + contact.lastName + " - " + contact.companyName)
            }
            expectation.fulfill()
        }.failure { (error) -> () in
            XCTAssert(false, "Returned an error: \(error.localizedDescription)")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(100.0, handler: nil)
    }
    
}

typealias Number = NSNumber

extension NSObject: MapsUnderscoreCaseToCamelCase, ValidateImplicitlyUnwrappedOptionals {}

class Contact: NSObject {
    var id: Number!
    var firstName: String!
    var lastName: String!
    var title: String!
    var companyName: String!
    var birthday: String?
    var anniversary: String?
    var defaultAddress: Address?
    var emails = [Email]()
    var phoneNumbers = [PhoneNumber]()
}

class Address: NSObject {
    var id: Number!
    var address1: String!
    var address2: String!
    var city: String!
    var state: String!
    var postalCode: String!
    var country: String!
}

class Email: NSObject {
    var id: Number!
    var email: String!
}

class PhoneNumber: NSObject {
    var id: Number!
    var phoneNumber: String!
}

class BaseService: WebService {
    
    override func configureService() {
        loggingEnabled = true
        path = "https://sapi.sendoutcards.com/v1"
        headers = ["Authorization":"Token a77a499e306b3ea41f574a185522556a8146d76f", "Content-Type":"application/json"]
    }
    
}

class ContactsService: BaseService {
    
    override func configureService() {
        path = "/contacts"
    }
    
    class var getContacts: GET<[Contact]> {
        return GET<[Contact]>(self).parameters(["simple":"true"])
    }
    
    class func getContact(id: Number) -> GET<Contact> {
        return GET<Contact>(self).path("/" + id.stringValue)
    }
    
    class func updateContact(contact: Contact) -> PUT<Contact> {
        return PUT<Contact>(self).path("/" + contact.id.stringValue).body(contact)
    }
    
}
