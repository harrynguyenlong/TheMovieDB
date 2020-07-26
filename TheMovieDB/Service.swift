//
//  Service.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/24/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

public protocol Service {
    associatedtype output
    
    var request: Request { get }
    
    var dispatcher: Dispatcher { get }
    
    func execute(completionHandler: @escaping (output) -> (), failureBlock: @escaping (Error?) -> ())
}
