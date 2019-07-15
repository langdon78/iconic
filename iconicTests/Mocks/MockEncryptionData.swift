//
//  MockAuthData.swift
//  iconicTests
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation
@testable import iconic

struct MockEncryptionData {
    static var message: String = "This message will self-destruct in 5 seconds. Good luck."
    static var secret = "top_secret_key"
    static var hash = HashAlgorithmType.sha1
    static var expectedHash = "yAuVhKW3HUEmwbIDBH8CPPt0GRk="
}
