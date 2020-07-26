//
//  MainViewControllerViewModel.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/26/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

class MainViewControllerLogicController {
    private let getMovieService: GetMoviesService
    
    init(getMovieService: GetMoviesService) {
        self.getMovieService = getMovieService
    }
    
    func getMovies(completionHandler: @escaping (MainViewControllerViewState) -> ()) {
        self.getMovieService.execute(completionHandler: { (movies) in
            completionHandler(.presenting(movies))
        }) { (error) in
            completionHandler(.failed(error!))
        }
    }
}
