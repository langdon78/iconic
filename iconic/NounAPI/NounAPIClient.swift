//
//  NounAPIClient.swift
//  iconic
//
//  Created by James Langdon on 7/13/19.
//  Copyright © 2019 corporatelangdon. All rights reserved.
//

import Foundation

class NounAPIClient<Auth: AuthClient> where Auth.Credentials == OAuthCredentials {
    
    var authClient: Auth
    
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
    
    init(authClient: Auth = OAuthClient() as! Auth) {
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
                return
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
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPRequestMethod.get.uppercaseValue
        let credentials = OAuthCredentials(consumerKey: Configuration.NounAPI.apiKey,
                          consumerSecret: Configuration.NounAPI.apiSecret,
                          userKey: nil,
                          userSecret: nil)
        
        request = authClient.createSignedRequest(from: request, credentials: credentials)
        
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
    
    func getImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            print("\(urlString) not valid")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPRequestMethod.get.rawValue
        execute(request) { response in
            switch response {
            case .success(let data): completion(data)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
