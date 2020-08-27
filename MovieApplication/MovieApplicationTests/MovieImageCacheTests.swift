//
//  MovieImageCacheTests.swift
//  MovieApplicationTests
//
//  Created by iAskedYou2nd on 8/26/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import XCTest
@testable import MovieApplication

class MovieImageCacheTests: XCTestCase {

    var key: String!
    var data: Data!
    var cache: ImageCache!
    
    override func setUp() {
        super.setUp()
        self.key = "Key"
        self.data = UIImage(named: "Default")?.jpegData(compressionQuality: 1.0)
        self.cache = ImageCache()
    }
    
    override func tearDown() {
        self.key = nil
        self.data = nil
        self.cache = nil
        super.tearDown()
    }

}

extension MovieImageCacheTests {
    
    func testCacheIsEmpty() {
        // Arrange
        var data: Data?
        
        // Act
        data = self.cache.get(url: self.key)
        
        // Assert
        XCTAssertNil(data)
    }
    
    func testCacheCanGetAndSet() {
        // Arrange
        var data: Data?
        
        // Act
        self.cache.set(data: self.data, url: self.key)
        data = self.cache.get(url: self.key)
        
        // Assert
        XCTAssertEqual(data, self.data)
    }
    
}
