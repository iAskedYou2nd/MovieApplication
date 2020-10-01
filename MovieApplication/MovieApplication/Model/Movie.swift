//
//  Movie.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

struct PageResult: Codable {
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    var id: Int
    var posterImage: String
    var title: String
    var rating: Double
    var duration: Int?
    var releaseDate: String
    var overview: String
    var genres: [Genres]?
    var videos: VideoResult?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, videos
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterImage = "poster_path"
        case duration = "runtime"
    }
}

struct Genres: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct VideoResult: Codable {
    var results: [Video]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Video: Codable {
    var id: String
    var key: String
    var name: String
    var site: String
    var size: Int
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case id, key, name, site, size, type
    }
}
