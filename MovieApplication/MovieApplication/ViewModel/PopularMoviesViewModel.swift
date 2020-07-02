//
//  PopularMoviesViewModel.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class PopularMoviesViewModel {
    
    var currentPage: PageResult?
    var movies: [Movie] = [] {
        didSet {
            // If pagination update, reload, otherwise do not
            guard oldValue.count != self.movies.count else { return }
            self.update?()
        }
    }
    
    private var service: MovieService
    private var imageCache: ImageCache
    private var update: (() -> ())?
    
    init(service: MovieService = MovieService(), cache: ImageCache = ImageCache.sharedCache) {
        self.service = service
        self.imageCache = cache
    }
    
    func bind(handler: @escaping ()->()) {
        self.update = handler
    }
    
    func fetchMovies() {
        let pageNum = (self.currentPage?.page ?? 0) + 1
        guard pageNum <= self.currentPage?.totalPages ?? 1 else { return }
        self.service.fetchPopular(with: pageNum, completion: { [weak self] (result) in
            switch result {
            case .success(let page):
                self?.movies.append(contentsOf: page.results)
                self?.currentPage = page
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func fetchIndividualFilm(index: Int, completion: @escaping (String)->()) {
        if let _ = self.movies[index].duration {
            completion(self.duration(index: index))
            return
        }
        
        self.service.fetchMovie(id: self.movies[index].id) { (result) in
            switch result {
            case .success(let movie):
                self.movies[index] = movie
                completion(self.duration(index: index))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchImage(index: Int, completion: @escaping (UIImage?)->()) {
        let urlString = self.fullImageURLString(for: index)
        if let data = self.imageCache.get(url: urlString) {
            completion(UIImage(data: data))
            return
        }
        completion(nil)
        self.service.fetchImage(urlString: urlString, completion: { (result) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(nil)
                    return
                }
                self.imageCache.set(data: data, url: urlString)
                completion(UIImage(data: data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

extension PopularMoviesViewModel: ViewModelType {
    
    var count: Int {
        return self.movies.count
    }
    
    func title(index: Int) -> String {
        return self.movies[index].title
    }
    
    func releaseDate(index: Int) -> String {
        return self.movies[index].releaseDate.dateFormatting()
    }
    
    func duration(index: Int) -> String {
        return String(self.movies[index].duration ?? 0).timeLengthFormatting()
    }
    
    func overView(index: Int) -> String {
        return self.movies[index].overview
    }
    
    func genres(index: Int) -> [String] {
        return self.movies[index].genres?.compactMap{ $0.name } ?? []
    }
    
    func image(index: Int) -> UIImage? {
        guard let data = self.imageCache.get(url: self.fullImageURLString(for: index)) else {
            return UIImage(named: "Default.jpeg")
        }
        return UIImage(data: data)
    }
    
    func rating(index: Int) -> Double {
        return self.movies[index].rating * 10
    }
    
    func fullImageURLString(for index: Int) -> String {
        return MovieServiceConstants.imageBaseURL + self.movies[index].posterImage
    }
    
}
