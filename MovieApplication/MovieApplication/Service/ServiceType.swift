//
//  ServiceType.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

//typealias PageResultHandler = (Result<PageResult, NetworkError>) -> ()
//typealias MovieDetailHandler = (Result<Movie, NetworkError>) -> ()
typealias ImageHandler = (Result<Data?, NetworkError>) -> ()

protocol ServiceType {
    func fetch<T>(url: URL?, completion: @escaping (Result<T, NetworkError>) -> ()) where T: Codable
    func fetch(url: URL?, completion: @escaping ImageHandler)
//    func fetchNowPlaying(completion: @escaping PageResultHandler)
//    func fetchPopular(with page: Int, completion: @escaping PageResultHandler)
//    func fetchMovie(id: Int, completion: @escaping MovieDetailHandler)
//    func fetchImage(urlString: String, completion: @escaping ImageHandler)
}
