//
//  MockMovieEndpoints.swift
//  MovieApplicationTests
//
//  Created by iAskedYou2nd on 8/26/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

enum MockMovieEndpoints: String {
    case popular = "https://api.themoviedb.org/3/movie/popular?api_key=705f7bed4894d3adc718c699a8ca9a4f&page=1"
}

extension MockMovieEndpoints {
    
    private var fileName: String {
        switch self {
        case .popular:
            return "PopularMovies"
        }
    }
    
    func getPath() throws -> String {
        let bundle = Bundle(for: MovieApplicationTests.self)
        guard let path = bundle.path(forResource: self.fileName, ofType: "json") else {
            throw NSError(domain: "Missing json file", code: 1, userInfo: nil)
        }
        return path
    }
    
    func getData() throws -> Data {
        let path = try self.getPath()
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
    
}
