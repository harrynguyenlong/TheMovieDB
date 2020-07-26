//
//  MainViewControllerLogicControllerTests.swift
//  TheMovieDBTests
//
//  Created by Nguyen, Long on 7/26/20.
//  Copyright © 2020 Nguyen, Long. All rights reserved.
//

import Foundation
import XCTest
@testable import TheMovieDB


class MainViewControllerLogicControllerTests: XCTestCase {
    var mainVCLgicViewController: MainViewControllerLogicController?
    var session: URLSession?
    var mockedDispatcher: Dispatcher?
    let evrment = Environment(name: "Test", host: Constant.MOVIE_HOSTNAME)

    override func tearDown() {
        session = nil
        mockedDispatcher = nil
        mainVCLgicViewController = nil
    }
    
    func testMainViewControllerGetMoviesSuccess() {
        let json = """
        {
            "results": [
                {
                    "popularity": 158.069,
                    "vote_count": 227,
                    "video": false,
                    "poster_path": "/jHo2M1OiH9Re33jYtUQdfzPeUkx.jpg",
                    "id": 385103,
                    "adult": false,
                    "backdrop_path": "/fKtYXUhX5fxMxzQfyUcQW9Shik6.jpg",
                    "original_language": "en",
                    "original_title": "Scoob!",
                    "genre_ids": [
                        12,
                        16,
                        35,
                        9648,
                        10751
                    ],
                    "title": "Scoob!",
                    "vote_average": 7.8,
                    "overview": "In Scooby-Doo’s greatest adventure yet, see the never-before told story of how lifelong friends Scooby and Shaggy first met and how they joined forces with young detectives Fred, Velma, and Daphne to form the famous Mystery Inc. Now, with hundreds of cases solved, Scooby and the gang face their biggest, toughest mystery ever: an evil plot to unleash the ghost dog Cerberus upon the world. As they race to stop this global “dogpocalypse,” the gang discovers that Scooby has a secret legacy and an epic destiny greater than anyone ever imagined.",
                    "release_date": "2020-07-08"
                }
            ]
        }
        """
        
        let jsonData = json.data(using: .utf8)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=71aae5ac0de6a3b943179fb75b5b8da0")!
        URLProtocolMock.testURLs = [url: jsonData!]
        URLProtocolMock.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
        mockedDispatcher = NetworkingDispatcher(environment: self.evrment, urlSession: session!)
        
        self.mainVCLgicViewController = MainViewControllerLogicController(getMovieService: GetMoviesService(dispatcher: mockedDispatcher!))
        
        self.mainVCLgicViewController?.getMovies(completionHandler: { (state) in
            switch state {
                case .loading, .failed(_):
                    XCTFail("Should not happen!")
                case .presenting(let movies):
                    XCTAssertTrue(movies.count == 1)
            }
        })
    }
}
