//
//  iconicTests.swift
//  iconicTests
//
//  Created by James Langdon on 7/13/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import XCTest
@testable import iconic

class CryptoTests: XCTestCase {

    func testEncrypt() {
        let encrypted = Crypto.encrypt(MockCryptoData.message, using: MockCryptoData.hash, with: MockCryptoData.secret)
        
        XCTAssertEqual(encrypted, .success(MockCryptoData.expectedHash))
    }
    
    func testEncryptEmptyMessage() {
        let encrypted = Crypto.encrypt("", using: MockCryptoData.hash, with: MockCryptoData.secret)
        
        XCTAssertEqual(encrypted, .failure(Crypto.EncryptionError.emptyMessage))
    }
    
    func testEncryptEmptySecret() {
        let encrypted = Crypto.encrypt(MockCryptoData.message, using: MockCryptoData.hash, with: "")
        
        XCTAssertEqual(encrypted, .failure(Crypto.EncryptionError.emptyKey))
    }
    
}
