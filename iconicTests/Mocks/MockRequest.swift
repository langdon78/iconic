//
//  MockRequest.swift
//  iconicTests
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

struct MockRequest {
    static var url = URL(string: "http://api.thenounproject.com/icon/400")!
    static var nonce = "ybem0BwAn16"
    static var timestamp = "1563113839"
    static var key = "not_so_secret_public_key"
    static var expectedSignatureValue = "Djdf7LcK7UzWFf4tRpNyNib5468="
    static var expectedUrl = URLRequest(url: URL(string: "http://api.thenounproject.com/icon/400?oauth_consumer_key=11a594cb4861485c8599d411fb4cc7c1&oauth_nonce=ybem0BwAn16&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1563113839&oauth_version=1.0&oauth_signature=TiKXPIqElArbt5G74QToolgvAHw%253D")!)
}
