//
//  iconicTests.swift
//  iconicTests
//
//  Created by James Langdon on 7/13/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import XCTest
@testable import iconic

class EncryptionTests: XCTestCase {
    let encryptionHandler: EncryptionHandler.Type = HMACEncryptionHandler.self

    func testEncrypt() {
        let encrypted = encryptionHandler.encrypt(MockEncryptionData.message, using: MockEncryptionData.hash, with: MockEncryptionData.secret)
        
        XCTAssertEqual(encrypted, .success(MockEncryptionData.expectedHash))
    }
    
    func testEncryptEmptyMessage() {
        let encrypted = encryptionHandler.encrypt("", using: MockEncryptionData.hash, with: MockEncryptionData.secret)
        
        XCTAssertEqual(encrypted, .failure(EncryptionError.emptyMessage))
    }
    
    func testEncryptEmptySecret() {
        let encrypted = encryptionHandler.encrypt(MockEncryptionData.message, using: MockEncryptionData.hash, with: "")
        
        XCTAssertEqual(encrypted, .failure(EncryptionError.emptyKey))
    }
    
}
