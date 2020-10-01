//
//  MovieServiceRequests.swift
//  MovieApplication
//
//  Created by iAskedYou2nd on 8/27/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

enum MovieServiceRequest {
    case nowPlayingMovies
    case popularMovies(Int)
    case individualMovie(Int)
    case movieImage(String)
    case youtubeVideo(String)
    
    var url: URL? {
        switch self {
        case .popularMovies(let page):
            return MovieServiceParams.createPopularMoviesURL(for: page)
        case .nowPlayingMovies:
            return MovieServiceParams.createNowPlayingURL()
        case .individualMovie(let identifier):
            return MovieServiceParams.createMovieURL(for: identifier)
        case .movieImage(let posterPath):
            return MovieServiceParams.createMovieImageURL(for: posterPath)
        case .youtubeVideo(let videoKey):
            return MovieServiceParams.createYoutubeURL(for: videoKey)
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
    case videosQuery = "&append_to_response=videos"
    // YouTube
    case youtubeBaseURL = "https://www.youtube.com/embed/"
    case embededQuery = "?feature=oembed"
    
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
            + MovieServiceParams.apiKey.rawValue
            + MovieServiceParams.videosQuery.rawValue)
    }
    
    static func createMovieImageURL(for posterPath: String) -> URL? {
        return URL(string: MovieServiceParams.imageBaseURL.rawValue
            + "\(posterPath)")
    }
    
    static func createYoutubeURL(for videoKey: String) -> URL? {
        return URL(string: MovieServiceParams.youtubeBaseURL.rawValue
            + "\(videoKey)"
            + MovieServiceParams.embededQuery.rawValue)
    }
}

