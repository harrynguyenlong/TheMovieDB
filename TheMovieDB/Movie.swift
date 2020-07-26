//
//  Movie.swift
//  TheMovieDB
//
//  Created by Nguyen, Long on 7/24/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var backdropPath: String?
    var title: String?
    var originalTitle: String?
    var posterPath: String?
    var overview: String?
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
}
