//
//  URLComponents+ext.swift
//  iconic
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

extension URLComponents {
    var baseURLStringWithPath: String {
        guard let url = url else { return "" }
        var formattedScheme = ""
        if let scheme = url.scheme {
            formattedScheme = scheme + "://"
        }
        return "\(formattedScheme)\(url.host ?? "")\(url.path)"
    }
}
