//
//  MovieNetworkManagerTests.swift
//  MovieApplicationTests
//
//  Created by iAskedYou2nd on 8/26/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import XCTest
@testable import MovieApplication

class MovieNetworkManagerTests: XCTestCase {

    var passingService: MovieService!
    var failingService: MovieService!
    
    override func setUp() {
        super.setUp()
        self.passingService = MovieService(session: MockMovieURLSession(), decoder: JSONDecoder())//NetworkManager(session: MockMovieURLSession(), decoder: JSONDecoder())
        self.failingService = MovieService(session: MockFailingURLSession(), decoder: JSONDecoder())//NetworkManager(session: MockFailingURLSession(), decoder: JSONDecoder())
    }
    
    override func tearDown() {
        self.passingService = nil
        self.failingService = nil
        super.tearDown()
    }

}

extension MovieNetworkManagerTests {
    
    // MARK: - Passing Cases
    
    func testFetchPopularMovies() {
        // Arrange
        var pageResult: PageResult?
        let expectation = XCTestExpectation(description: "Fetch Popular Movies")
        
        // Act
        self.passingService.fetchPopular(with: 1){ (result) in
            switch result {
            case .success(let page):
                pageResult = page
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertNotNil(pageResult)
        XCTAssertEqual(pageResult?.results.count, 20)
    }
    
    // MARK: - Failing Cases
    
    func testCannotFetchImage() {
        // Arrange
        var image: UIImage?
        let expecation = XCTestExpectation(description: "Cannot Fetch Image")
        
        // Act
        self.passingService.fetchImage(urlString: "https://www.myImage.com") { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                image = nil
                expecation.fulfill()
            }
        }
        wait(for: [expecation], timeout: 5.0)
        
        // Assert
        XCTAssertNil(image)
    }
    
    func testCannotFetchPopularMovies() {
        // Arrange
        var pageResult: PageResult?
        let expectation = XCTestExpectation(description: "Fail to fetch popular movies")
        
        // Act
        self.failingService.fetchPopular(with: 1) { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                pageResult = nil
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertNil(pageResult)
    }
    
}
