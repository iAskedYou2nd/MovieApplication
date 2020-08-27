//
//  MockMovieURLSessionDataTask.swift
//  MovieApplicationTests
//
//  Created by iAskedYou2nd on 8/26/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import Foundation

typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> ()

final class MockMovieURLSessionDataTask: URLSessionDataTask {
    
    let url: URL
    let completionHandler: DataTaskHandler
    
    init(url: URL, completion: @escaping DataTaskHandler) {
        self.url = url
        self.completionHandler = completion
    }
    
    private func getEndPoint() throws -> MockMovieEndpoints {
        guard let endPoint = MockMovieEndpoints(rawValue: self.url.absoluteString) else {
            throw NSError(domain: "Invalid Mock Endpoint", code: 1, userInfo: nil)
        }
        return endPoint
    }
    
    override func resume() {
        DispatchQueue.global().async {
            do {
                let data = try self.getEndPoint().getData()
                self.completionHandler(data, nil, nil)
            } catch {
                self.completionHandler(nil, nil, error)
            }
        }
    }
    
}

final class MockFailingURLSessionDataTask: URLSessionDataTask {
    
    let url: URL
    let completionHandler: DataTaskHandler
    
    init(url: URL, completion: @escaping DataTaskHandler) {
        self.url = url
        self.completionHandler = completion
    }
    
    override func resume() {
        DispatchQueue.global().async {
            let error = NSError(domain: "Failure for handling test cases", code: 1, userInfo: nil)
            self.completionHandler(nil, nil, error)
        }
    }
}
