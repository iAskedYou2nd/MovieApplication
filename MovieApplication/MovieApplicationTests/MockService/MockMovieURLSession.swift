//
//  MockMovieURLSession.swift
//  MovieApplicationTests
//
//  Created by iAskedYou2nd on 8/26/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

final class MockMovieURLSession: URLSession {
    
    override init() { }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockMovieURLSessionDataTask(url: url, completion: completionHandler)
    }
    
}

final class MockFailingURLSession: URLSession {
    
    override init() { }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockFailingURLSessionDataTask(url: url, completion: completionHandler)
    }
    
}
