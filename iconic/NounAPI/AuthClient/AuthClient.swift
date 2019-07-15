//
//  AuthClient.swift
//  iconic
//
//  Created by James Langdon on 7/14/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

protocol AuthClient {
    func createSignedRequest(from urlComponents: URLComponents, httpMethod: String) -> URLRequest
}

/// Handles oAuth1.0 authentication
/// specified by RFC 5849.
/// https://tools.ietf.org/html/rfc5849#section-3.4.2

class OAuthClient: AuthClient {
    
    typealias OAuthQueryParameterValue = String
    typealias OAuthQueryParameters = [OAuthQueryParameterKey: OAuthQueryParameterValue]
    
    enum OAuthQueryParameterKey: String, CaseIterable {
        case oauth_signature_method
        case oauth_timestamp
        case oauth_nonce
        case oauth_version
        case oauth_consumer_key
        case oauth_signature
    }
    
    struct Credentials {
        var consumerKey: String
        var consumerSecret: String
        var userKey: String? = nil
        var userSecret: String? = nil
        var rfc5849FormattedSecret: String {
            // https://tools.ietf.org/html/rfc5849#section-3.4.4
            return "\(consumerSecret)&\(userSecret ?? "")"
        }
    }
    
    var currentDateString: () -> String = {
        return String(Int(Date().timeIntervalSince1970)) }
    
    var nonceUUIDString: () -> String = {
        return UUID().uuidString
    }
    
    let encryptionHandler: EncryptionHandler.Type
    
    init(encryptionHandler: EncryptionHandler.Type = HMACEncryptionHandler.self) {
        self.encryptionHandler = encryptionHandler
    }
    
    private func rfc3986Encode(_ str: String) -> String {
        // https://tools.ietf.org/html/rfc5849#section-3.6
        let unreservedRFC3986 = CharacterSet(charactersIn: "-._~?")
        let allowed = CharacterSet.alphanumerics.union(unreservedRFC3986)
        return str.addingPercentEncoding(withAllowedCharacters: allowed) ?? str
    }
    
    private func defaultOAuthQueryParameters() -> OAuthQueryParameters {
        return [
            .oauth_signature_method: "HMAC-SHA1",
            .oauth_timestamp: currentDateString(),
            .oauth_nonce: nonceUUIDString(),
            .oauth_version: "1.0"
        ]
    }
    
    func preSignatureOAuthQueryItems(key: String) -> [URLQueryItem] {
        var defaultParams = defaultOAuthQueryParameters()
        defaultParams[.oauth_consumer_key] = key
        return defaultParams.map { URLQueryItem(name: $0.key.rawValue, value: $0.value) }
    }
    
    func addOAuthParams(for urlComponents: URLComponents, credentials: Credentials) -> URLComponents {
        var urlComponents = urlComponents
        let oAuthQueryItems = preSignatureOAuthQueryItems(key: credentials.consumerKey)
        if var queryItems = urlComponents.queryItems {
            queryItems.append(contentsOf: oAuthQueryItems)
            urlComponents.queryItems = queryItems
        } else {
            urlComponents.queryItems = oAuthQueryItems
        }
        return urlComponents
    }
    
    func sortParameters(for urlComponents: URLComponents) -> [URLQueryItem]? {
        return urlComponents.queryItems?.sorted { $0.name < $1.name }
    }
    
    func hashString(httpMethod: String, urlComponents: URLComponents) -> String {
        let params = rfc3986Encode(urlComponents.percentEncodedQuery!)
        return "\(httpMethod)&\(rfc3986Encode(urlComponents.baseURLStringWithPath))&\(params)"
    }
    
    func calculateSignature(urlComponents: URLComponents, httpMethod: String, credentials: Credentials) -> String {
        let hashable = hashString(httpMethod: httpMethod, urlComponents: urlComponents)
        let result = encryptionHandler.encrypt(hashable, using: .sha1, with: credentials.rfc5849FormattedSecret)
        
        switch result {
        case .success(let hashed):
            return rfc3986Encode(hashed)
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func addSignature(with hashed: String, to urlComponents: URLComponents) -> URL {
        var urlComponents = urlComponents
        let signatureQueryItem = URLQueryItem(name: OAuthQueryParameterKey.oauth_signature.rawValue, value: hashed)
        urlComponents.queryItems?.append(signatureQueryItem)
        return urlComponents.url!
    }
    
    func createSignedRequest(from urlComponents: URLComponents, httpMethod: String) -> URLRequest {
        let credentials = Credentials(consumerKey: Configuration.NounAPI.apiKey,
                                                 consumerSecret: Configuration.NounAPI.apiSecret,
                                                 userKey: nil,
                                                 userSecret: nil)
        
        var urlComponents = addOAuthParams(for: urlComponents, credentials: credentials)
        urlComponents.queryItems = sortParameters(for: urlComponents) //https://tools.ietf.org/html/rfc5849#section-3.4.1.3.2
        let signature = calculateSignature(urlComponents: urlComponents, httpMethod: httpMethod, credentials: credentials)
        let url = addSignature(with: signature, to: urlComponents)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
    
}
