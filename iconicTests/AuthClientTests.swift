//
//  AuthClientTests.swift
//  iconicTests
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import XCTest
@testable import iconic

class AuthClientTests: XCTestCase {
    var authClient: OAuthClient!
    
    override func setUp() {
        authClient = OAuthClient()
    }

    override func tearDown() {
        authClient = nil
    }

    func testSignature() {
        authClient.nonceUUIDString = { return MockRequest.nonce }
        authClient.currentDateString = { return MockRequest.timestamp }
        let components = URLComponents(url: MockRequest.url, resolvingAgainstBaseURL: false)!
        let encrypted = authClient.createSignedRequest(from: components, httpMethod: "GET")
        
        XCTAssertEqual(encrypted, MockRequest.expectedUrl)
    }

}
