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
    internal var movies: [Movie] = [] {
        didSet {
            guard oldValue.count != self.movies.count else { return }
            self.update?()
        }
    }
        
    internal var service: ServiceType
    internal var imageCache: ImageCache
    private var update: (() -> ())?
    private var errorUpdate: ((NetworkError) -> ())?
    
    init(state: ViewModelState, service: ServiceType = MovieService(), cache: ImageCache = ImageCache.sharedCache) {
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
            url = MovieServiceRequest.popularMovies(pageNum).url
        } else {
            url = MovieServiceRequest.nowPlayingMovies.url        }
        
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
        let url = MovieServiceRequest.individualMovie(self.movies[index].id).url
        
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
        
        let url = MovieServiceRequest.movieImage(self.movies[index].posterImage).url
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
