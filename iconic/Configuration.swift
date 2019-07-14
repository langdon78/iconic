//
//  Configuration.swift
//  iconic
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

/// App configuration using variables
/// defined in .xcconfig files, referenced in
/// the bundle's info.plist at build time

struct Configuration {
    // To get sytnthesized string values
    // for the respective cases, used
    // uppercase styling to match config
    // variable naming convention
    private enum Key: String {
        typealias RawValue = String
        
        case NOUN_URL_SCHEME
        case NOUN_BASE_URL
        case NOUN_API_CONSUMER_KEY
        case NOUN_API_CONSUMER_SECRET
    }
    
    // Access info.plist env variables from .xcconfig
    static private func value<T>(for key: String) -> T {
        guard let value = Bundle.main.infoDictionary?[key] as? T else {
            fatalError("Invalid or missing Info.plist key: \(key)")
        }
        return value
    }
    
    // Helper
    static private func value<T>(for key: Configuration.Key) -> T {
        return value(for: key.rawValue)
    }
    
    struct NounAPI {
        static var baseURL: URL {
            let url = URL(string: value(for: .NOUN_URL_SCHEME) + "://" + value(for: .NOUN_BASE_URL))!
            return url
        }
        
        static var apiKey: String {
            return value(for: .NOUN_API_CONSUMER_KEY)
        }
        
        static var apiSecret: String {
            return value(for: .NOUN_API_CONSUMER_SECRET)
        }
        
        private init() {}
    }
    
    private init() {}
}
