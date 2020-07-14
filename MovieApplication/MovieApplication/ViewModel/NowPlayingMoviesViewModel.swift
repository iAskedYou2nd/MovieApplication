//
//  NowPlayingMoviesViewModel.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class NowPlayingMoviesViewModel {
  
    var service: MovieService
    var imageCache: ImageCache
    var update: (() -> ())?
    var errorUpdate: ((NetworkError) -> ())?
    var movies: [Movie] = [] {
        didSet {
            self.update?()
        }
    }
    
    init(service: MovieService = MovieService(), cache: ImageCache = ImageCache.sharedCache) {
        self.service = service
        self.imageCache = cache
    }
    
    func bind(uiHandler: @escaping ()->(), errorHandler: @escaping (NetworkError)->()) {
        self.update = uiHandler
        self.errorUpdate = errorHandler
    }
    
    func fetchMovies() {
        self.service.fetchNowPlaying { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let page):
                self.movies = page.results
            case .failure(let error):
                print(error.localizedDescription)
                self.errorUpdate?(error)
            }
        }
    }
    
    func fetchIndividualFilm(index: Int, completion: @escaping ()->()) {
        if let _ = self.movies[index].duration {
            completion()
            return
        }
        
        self.service.fetchMovie(id: self.movies[index].id) { [weak self] (result) in
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
        guard index < self.movies.count else {
            completion(nil)
            return
        }
        let urlString = self.fullImageURLString(for: index)
        if let data = self.imageCache.get(url: urlString) {
            print("Cache")
            completion(UIImage(data: data))
            return
        }
        completion(nil)
        self.service.fetchImage(urlString: urlString, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else {
                    self.errorUpdate?(NetworkError.badData)
                    return
                }
                print("Network")
                self.imageCache.set(data: data, url: urlString)
                completion(UIImage(data: data))
            case .failure(let error):
                print(error.localizedDescription)
                self.errorUpdate?(error)
            }
        })
    }
    
}

extension NowPlayingMoviesViewModel: ViewModelType {
    
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
