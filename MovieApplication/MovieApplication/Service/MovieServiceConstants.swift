//
//  MovieServiceConstants.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

// TODO: Maybe Convert to URL params through an enum or url extension
//struct MovieServiceConstants {
//    static let baseURL = "https://api.themoviedb.org/3/movie/"
//    static let apiKey = "?api_key=705f7bed4894d3adc718c699a8ca9a4f"
//    static let nowPlaying = "now_playing"
//    static let popular = "popular"
//    static let pageQuery = "&page="
//    // w500 is the size. Test with different sizes
//    static let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
//}

enum MovieServiceRequest {
    case popularMovies
    case nowPlayingMovies
    case individualMovie
    case movieImage
    
    func getURL(for query: Any?) -> URL? {
        switch self {
        case .popularMovies:
            guard let page = query as? Int else { return nil }
            return MovieServiceParams.createPopularMoviesURL(for: page)
        case .nowPlayingMovies:
            return MovieServiceParams.createNowPlayingURL()
        case .individualMovie:
            guard let identifier = query as? Int else { return nil }
            return MovieServiceParams.createMovieURL(for: identifier)
        case .movieImage:
            guard let posterPath = query as? String else { return nil }
            return MovieServiceParams.createMovieImageURL(for: posterPath)
        }
    }
    
}

private enum MovieServiceParams: String {
    case baseURL = "https://api.themoviedb.org/3/movie/"
    case apiKey = "?api_key=705f7bed4894d3adc718c699a8ca9a4f"
    case nowPlaying = "now_playing"
    case popular = "popular"
    case pageQuery = "&page="
    // w500 is the size. Test with different sizes
    case imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    static func createNowPlayingURL() -> URL? {
        return URL(string: MovieServiceParams.baseURL.rawValue
            + MovieServiceParams.nowPlaying.rawValue
            + MovieServiceParams.apiKey.rawValue)
    }
    
    static func createPopularMoviesURL(for page: Int) -> URL? {
        return URL(string: MovieServiceParams.baseURL.rawValue
            + MovieServiceParams.popular.rawValue
            + MovieServiceParams.apiKey.rawValue
            + MovieServiceParams.pageQuery.rawValue
            + "\(page)")
    }
    
    static func createMovieURL(for identifier: Int) -> URL? {
        return URL(string: MovieServiceParams.baseURL.rawValue
            + "\(identifier)"
            + MovieServiceParams.apiKey.rawValue)
    }
    
    static func createMovieImageURL(for posterPath: String) -> URL? {
        return URL(string: MovieServiceParams.imageBaseURL.rawValue
            + "\(posterPath)")
    }
}
