//
//  MovieRequest.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/26/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

public enum MovieRequest: Request {
    case nowPlaying
    
    public var path: String {
        switch self {
            case .nowPlaying:
                return "now_playing"
        }
    }
    
    public var method: HTTPMethod  {
        switch self {
            case .nowPlaying:
                return .get
        }
    }
    
    public var parameters: RequestParams? {
        switch self {
            case .nowPlaying:
                return RequestParams.url(["api_key" : "71aae5ac0de6a3b943179fb75b5b8da0"])
        }
    }
    
    public var headers: [String : String]? {
        switch self {
            default:
            return nil
        }
    }
    
    public var dataType: DataType {
        switch self {
        default:
            return .JSON
        }
    }
}
