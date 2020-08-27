//
//  MovieModelTests.swift
//  MovieApplicationTests
//
//  Created by iAskedYou2nd on 8/26/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import XCTest
@testable import MovieApplication

class MovieModelTests: XCTestCase {
    
    var decoder: JSONDecoder!
    
    override func setUp() {
        super.setUp()
        self.decoder = JSONDecoder()
    }

    override func tearDown() {
        self.decoder = nil
        super.tearDown()
    }

}

extension MovieModelTests {
    
    func testCanDecodePageResult() {
        // Arrange
        let dataResult = Result {
            try MockMovieEndpoints.popular.getData()
        }
        var data: Data?
        
        // Act
        data = try? dataResult.get()
        let pageResult = try? decoder.decode(PageResult.self, from: data!)
        
        // Assert
        XCTAssertNotNil(pageResult)
    }
    
}
