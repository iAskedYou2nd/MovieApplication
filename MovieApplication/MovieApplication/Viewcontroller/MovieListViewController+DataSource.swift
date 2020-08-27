//
//  MovieListViewController+DataSource.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

extension MovieListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Playing now" : "Most popular"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? 150 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.movieViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NowPlayingCell.reuseIdentifier, for: indexPath) as? NowPlayingCell else {
                return UITableViewCell()
            }
            cell.setDelegate(delegate: self)
            cell.setViewModel(viewModel: MovieViewModel(state: .nowPlaying))
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularMovieCell.reuseIdentifier, for: indexPath) as? PopularMovieCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel?.setAttrString(text: self.movieViewModel.title(index: indexPath.row), isBold: true)
            cell.releaseDateLabel?.setAttrString(text: self.movieViewModel.releaseDate(index: indexPath.row), isBold: false)
            cell.ratingView?.percentage = self.movieViewModel.rating(index: indexPath.row)
            self.setImage(cell: cell, index: indexPath.row)
            self.getDetails(cell: cell, index: indexPath.row)
            
            return cell
        }
    }
    
    private func setImage(cell: PopularMovieCell, index: Int) {
        self.movieViewModel.fetchImage(index: index) { (image) in
            DispatchQueue.main.async {
                cell.moviePosterView?.image = image ?? UIImage(named: "Default.jpeg")
            }
        }
    }
    
    private func getDetails(cell: PopularMovieCell, index: Int) {
        self.movieViewModel.fetchIndividualFilm(index: index) {
            DispatchQueue.main.async {
                cell.durationLabel?.setAttrString(text: self.movieViewModel.duration(index: index), isBold: false)
            }
        }
    }
}

extension MovieListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastCellIndexPath = IndexPath(row: self.movieViewModel.count - 1, section: 1)
        guard indexPaths.contains(lastCellIndexPath) else { return }
        self.movieViewModel.fetchMovies()
    }
    
}
