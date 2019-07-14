//
//  Crypto.swift
//  iconic
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation
import CommonCrypto

/// Handles cryptographic hashing
/// using supported methods from
/// CommonCrypto library (i.e. MD5, SHA1 etc.)
class Crypto {
    struct HashAlgorithm {
        private(set) var length: Int32
        private(set) var key: UInt32
        private var lengthInt: Int {
            return Int(length)
        }
        var allocated: [UInt8] {
            return [UInt8](repeating: 0, count: lengthInt)
        }
        
        init(length: Int32, key: Int) {
            self.length = length
            self.key = CCHmacAlgorithm(key)
        }
    }
    
    enum HashAlgorithmType {
        case md5
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512
        
        var algorithm: HashAlgorithm {
            switch self {
            case .md5: return HashAlgorithm(length: CC_MD5_DIGEST_LENGTH, key: kCCHmacAlgMD5)
            case .sha1: return HashAlgorithm(length: CC_SHA1_DIGEST_LENGTH, key: kCCHmacAlgSHA1)
            case .sha224: return HashAlgorithm(length: CC_SHA224_DIGEST_LENGTH, key: kCCHmacAlgSHA224)
            case .sha256: return HashAlgorithm(length: CC_SHA256_DIGEST_LENGTH, key: kCCHmacAlgSHA256)
            case .sha384: return HashAlgorithm(length: CC_SHA384_DIGEST_LENGTH, key: kCCHmacAlgSHA384)
            case .sha512: return HashAlgorithm(length: CC_SHA512_DIGEST_LENGTH, key: kCCHmacAlgSHA512)
            }
        }
    }
    
    enum EncryptionError: Error {
        case emptyMessage
        case emptyKey
    }

    /// Function to calculate a hash-based message authentication code (HMAC)
    ///
    /// - Parameters:
    ///   - message: the message to be encrypted
    ///   - using: hash function used (one of: .sha1, .md5, .sha224, .sha256, .sha384, .sha512, .sha224)
    ///   - with: the key or secret
    /// - Returns: the HMAC encrypted string or EncryptionError
    
    static func encrypt(
            _ message:  String,
            using hash: HashAlgorithmType,
            with key:   String
        ) -> Result<String, EncryptionError>  {
        guard !message.isEmpty else { return .failure(.emptyMessage) }
        guard !key.isEmpty else { return .failure(.emptyKey) }
        
        var result = hash.algorithm.allocated
        CCHmac(hash.algorithm.key, key, key.count, message, message.count, &result)
        return .success(Data(result).base64EncodedString())
    }
}
