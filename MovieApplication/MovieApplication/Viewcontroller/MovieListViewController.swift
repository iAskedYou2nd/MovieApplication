//
//  MovieListViewController.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    var popularViewModel: PopularMoviesViewModel
    var tableView: UITableView?
    
    init(popViewModel: PopularMoviesViewModel = PopularMoviesViewModel(), npViewModel: NowPlayingMoviesViewModel = NowPlayingMoviesViewModel()) {
        self.popularViewModel = popViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This shouldn't happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        
        self.popularViewModel = PopularMoviesViewModel()
        self.popularViewModel.bind {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        self.popularViewModel.fetchMovies()
        self.navigationItem.title = "MOVIES"
        self.navigationController?.navigationBar.backgroundColor = .black
    }
    
    private func setUpTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(NowPlayingCell.self, forCellReuseIdentifier: NowPlayingCell.reuseIdentifier)
        tableView.register(PopularMovieCell.self, forCellReuseIdentifier: PopularMovieCell.reuseIdentifier)
        
        self.view.addSubview(tableView)
        tableView.boundToSuperView(inset: 0)
        self.tableView = tableView
    }
    
}
