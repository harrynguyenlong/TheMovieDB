//
//  Environment.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/24/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

public struct Environment {
    public var name: String
    
    public var host: String
    
    public var headers: [String: Any] = [:]
    
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    public init(name: String, host: String) {
        self.name = name
        self.host = host
    }
}

public protocol Dispatcher {
    init(environment: Environment, urlSession: URLSession)
    
    func execute(request: Request, completionHandler: @escaping (Response) -> ()) throws
}
