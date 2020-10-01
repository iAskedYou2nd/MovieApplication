//
//  ViewModelType.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

enum ViewModelState {
    case popular
    case nowPlaying
}

protocol ViewModelType {
    var movies: [Movie] { get }
    var service: ServiceType { get }
    var imageCache: ImageCache { get }
    func bind(uiHandler: @escaping () -> (), errorHandler: @escaping (NetworkError) -> ())
    func fetchMovies()
    func fetchIndividualFilm(index: Int, completion: @escaping () -> ())
    func fetchImage(index: Int, completion: @escaping (UIImage?) -> ())
}

extension ViewModelType {
    
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
    
    func videos(index: Int) -> [Video] {
        return self.movies[index].videos?.results ?? []
    }
    
    internal func fullImageURLString(for index: Int) -> String {
        return MovieServiceRequest
        .movieImage(self.movies[index].posterImage)
        .url?
        .absoluteString ?? ""
    }
    
}

