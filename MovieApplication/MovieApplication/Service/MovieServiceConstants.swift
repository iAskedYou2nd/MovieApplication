//
//  MovieServiceConstants.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

// TODO: Maybe Convert to URL params through an enum or url extension
struct MovieServiceConstants {
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "?api_key=705f7bed4894d3adc718c699a8ca9a4f"
    static let nowPlaying = "now_playing"
    static let popular = "popular"
    static let pageQuery = "&page="
    // w500 is the size. Test with different sizes
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
}
