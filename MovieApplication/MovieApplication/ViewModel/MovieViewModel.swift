//
//  MovieViewModel.swift
//  MovieApplication
//
//  Created by iAskedYou2nd on 8/27/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class MovieViewModel: ViewModelType {
    
    private var state: ViewModelState
    private var currentPage: PageResult?
    private var movies: [Movie] = [] {
        didSet {
            guard oldValue.count != self.movies.count else { return }
            self.update?()
        }
    }
        
    private var service: MovieService
    private var imageCache: ImageCache
    private var update: (() -> ())?
    private var errorUpdate: ((NetworkError) -> ())?
    
    init(state: ViewModelState, service: MovieService = MovieService(), cache: ImageCache = ImageCache.sharedCache) {
        self.state = state
        self.service = service
        self.imageCache = cache
    }
    
    func bind(uiHandler: @escaping () -> (), errorHandler: @escaping (NetworkError) -> ()) {
        self.update = uiHandler
        self.errorUpdate = errorHandler
    }
    
    func fetchMovies() {
        
        var url: URL?
        if self.state == .popular {
            let pageNum = (self.currentPage?.page ?? 0) + 1
            guard pageNum <= self.currentPage?.totalPages ?? 1 else { return }
            url = MovieServiceRequest.popularMovies.getURL(for: pageNum)
        } else {
            url = MovieServiceRequest.nowPlayingMovies.getURL(for: nil)
        }
        
        self.service.fetch(url: url) { [weak self] (result: Result<PageResult, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let page):
                self.movies.append(contentsOf: page.results)
                self.currentPage = page
            case .failure(let error):
                print(error.localizedDescription)
                self.errorUpdate?(error)
            }
        }
    }
    
    func fetchIndividualFilm(index: Int, completion: @escaping () -> ()) {
        if let _ = self.movies[index].duration {
            completion()
            return
        }
        let url = MovieServiceRequest.individualMovie.getURL(for: self.movies[index].id)
        
        self.service.fetch(url: url) { [weak self] (result: Result<Movie, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                self.movies[index] = movie
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.errorUpdate?(error)
            }
        }
    }
    
    func fetchImage(index: Int, completion: @escaping (UIImage?) -> ()) {
        let urlString = self.fullImageURLString(for: index)
        if let data = self.imageCache.get(url: urlString) {
            completion(UIImage(data: data))
            return
        }
        
        let url = MovieServiceRequest.movieImage.getURL(for: self.movies[index].posterImage)
        self.service.fetch(url: url) { [weak self] (result) in
             guard let self = self else { return }
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
                           self.errorUpdate?(error)
                       }
        }
    }
}

extension MovieViewModel: ViewModelDataSource {
        
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
        return MovieServiceRequest
        .movieImage
        .getURL(for: self.movies[index].posterImage)?
        .absoluteString ?? ""
    }
    
}
