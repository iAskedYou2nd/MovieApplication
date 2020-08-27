//
//  ServiceType.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

typealias ImageHandler = (Result<Data?, NetworkError>) -> ()

protocol ServiceType {
    func fetch<T>(url: URL?, completion: @escaping (Result<T, NetworkError>) -> ()) where T: Codable
    func fetch(url: URL?, completion: @escaping ImageHandler)
}
