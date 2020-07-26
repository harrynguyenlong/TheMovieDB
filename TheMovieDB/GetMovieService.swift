//
//  GetMovieService.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/26/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

class GetMoviesService: Service {
    var dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    var request: Request {
        return MovieRequest.nowPlaying
    }
    
    func execute(completionHandler: @escaping ([Movie]) -> (), failureBlock: @escaping (Error?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                     
                    do {
                        let result = json["results"]
                        let data = try JSONSerialization.data(withJSONObject: result as Any, options: .prettyPrinted)
                        let movies = try JSONDecoder().decode([Movie].self, from: data)
                        completionHandler(movies)
                    } catch let err {
                        failureBlock(err)
                    }
    
                case .error(_, let error):
                    failureBlock(error)
                default:
                    ()
                }
            })
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    typealias output = [Movie]
}
