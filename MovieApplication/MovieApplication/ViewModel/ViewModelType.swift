//
//  ViewModelType.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

// TODO: Unify VMs to one and check for protocol extensions

protocol ViewModelDataSource {
    var count: Int { get }
    func title(index: Int) -> String
    func releaseDate(index: Int) -> String
    func duration(index: Int) -> String
    func overView(index: Int) -> String
    func genres(index: Int) -> [String]
    func image(index: Int) -> UIImage?
    func rating(index: Int) -> Double
}

protocol ViewModelType: ViewModelDataSource {
    func bind(uiHandler: @escaping () -> (), errorHandler: @escaping (NetworkError) -> ())
    func fetchMovies()
    func fetchIndividualFilm(index: Int, completion: @escaping () -> ())
    func fetchImage(index: Int, completion: @escaping (UIImage?) -> ())
}

enum ViewModelState {
    case popular
    case nowPlaying
}

