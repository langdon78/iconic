//
//  NounAPIClient.swift
//  iconic
//
//  Created by James Langdon on 7/13/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

class NounAPIClient {
    
    var authClient: AuthClient
    
    enum HTTPRequestMethod: String {
        case get
        case post
        case put
        
        var uppercaseValue: String {
            return rawValue.uppercased()
        }
    }
    
    enum Path: String {
        case collections
        case recentUploads = "recent_uploads"
        case icons
    }
    
    enum NetworkResponseError: Error {
        case unknown(URLResponse?)
    }
    
    init(authClient: AuthClient = OAuthClient()) {
        self.authClient = authClient
    }
    
    func resource(for path: Path) -> URL {
        return Configuration.NounAPI.baseURL.appendingPathComponent(path.rawValue)
    }
    
    func add(path: Path, to url: URL) -> URL {
        var url = url
        url.appendPathComponent(path.rawValue)
        return url
    }
    
    func execute(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlSession = URLSession.shared.dataTask(with: request) { (data, response, error)  in
            if let error = error {
                completion(.failure(error))
                return
            } else if let data = data {
                completion(.success(data))
            }
            completion(.failure(NetworkResponseError.unknown(response)))
        }
        urlSession.resume()
    }
    
    func recentUploads(limit: Int? = nil, page: Int? = nil, completion: @escaping (Result<RecentUploads, Error>) -> Void) {
        var url = resource(for: .icons)
        url = add(path: .recentUploads, to: url)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let limit = limit {
            components.queryItems = [URLQueryItem(name: "limit", value: String(limit))]
            if let page = page {
                components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
            }
        }
        
        let request = authClient.createSignedRequest(from: components,
                                                     httpMethod: HTTPRequestMethod.get.uppercaseValue)

        execute(request) { (response: Result<Data, Error>) in
            switch response {
            case .success(let data):
                let decoder = JSONDecoder.init()
                do {
                    let uploads = try decoder.decode(RecentUploads.self, from: data)
                    completion(.success(uploads))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
