//
//  NetworkDispatcher.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/24/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

public enum NetworkErrors: Error {
    case badInput
    case noData
}

public class NetworkingDispatcher: Dispatcher {
    
    private var environment: Environment
    private var urlSession: URLSession
    
    public required init(environment: Environment, urlSession: URLSession) {
        self.environment = environment
        self.urlSession = urlSession
    }
    
    public func execute(request: Request, completionHandler: @escaping (Response) -> ()) throws {
        let rq = try self.prepareURLRequest(for: request)

        self.urlSession.dataTask(with: rq) { (data, response, error) in
            let response = Response((r: response as? HTTPURLResponse, data: data, error: error), for: request)
            completionHandler(response)
        }.resume()
    }
    
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        
        let full_url = "\(environment.host)/\(request.path)"
        
        let endcodeString = full_url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        var url_request = URLRequest(url: URL(string: endcodeString!)!)
        
        switch request.parameters {
        case .body(let params)?:
            
            if let params = params as? [String: String] {
                let data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                url_request.httpBody = data
                
            } else {
                throw NetworkErrors.badInput
            }
        case .url(let params)?:
            
            if let params = params as? [String: String] {
                let query_params = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                guard var components = URLComponents(string: endcodeString!) else {
                    throw NetworkErrors.badInput
                }
                components.queryItems = query_params
                url_request.url = components.url
            } else {
                throw NetworkErrors.badInput
            }
            
        default:
            ()
        }
        
        environment.headers.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        url_request.httpMethod = request.method.rawValue
        
        print(url_request)
        
        return url_request
    }
    
}
