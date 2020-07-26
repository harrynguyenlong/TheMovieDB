//
//  Response.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/24/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

public enum Response {
    case json(_: [String: Any])
    case data(_: Data)
    case error(_: Int?, _: Error?)
    
    init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        guard 200...299 ~= Int(response.r!.statusCode), response.error == nil else {
            self = .error(response.r?.statusCode, response.error)
            return
        }
        
        guard let data = response.data else {
            self = .error(response.r?.statusCode, NetworkErrors.noData)
            return
        }
        
        
        switch request.dataType {
        case .Data:
            self = .data(data)
        case .JSON:
            self = .json( try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any])
        }
    }
}
