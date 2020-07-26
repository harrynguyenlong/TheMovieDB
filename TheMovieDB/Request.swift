//
//  Request.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/24/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

public enum DataType {
    case JSON
    case Data
}

public protocol Request {
    
    var path : String { get }
    
    var method : HTTPMethod { get }
    
    var parameters : RequestParams? { get }
    
    var headers : [String: String]? { get }
    
    var dataType : DataType { get }
}

public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
    case both(body : [String: Any]?, url : [String: Any]?)
}
