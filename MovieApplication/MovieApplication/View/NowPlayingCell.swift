//
//  NowPlayingCell.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

protocol CellSelectedDelegate {
    func navigateToDetail(with index: Int, viewModel: ViewModelType)
    func presentAlert(error: NetworkError)
}

class NowPlayingCell: UITableViewCell {
    
    static let reuseIdentifier = "NowPlayingCell"
    
    var collectionView: UICollectionView?
    var delegate: CellSelectedDelegate?
    var nowPlayingViewModel: NowPlayingMoviesViewModel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.nowPlayingViewModel = NowPlayingMoviesViewModel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        self.nowPlayingViewModel = NowPlayingMoviesViewModel()
        super.init(coder: coder)
        self.setUp()
    }
    
    private func setUp() {
        self.nowPlayingViewModel.bind(uiHandler: {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.delegate?.presentAlert(error: error)
            }
        }
        self.nowPlayingViewModel.fetchMovies()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.delegate = self
        cView.dataSource = self
        cView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: ImageCollectionCell.reuseIdentifier)
        
        self.contentView.addSubview(cView)
        cView.boundToSuperView(inset: 0)
        self.collectionView = cView
    }
    
    func setDelegate(delegate: CellSelectedDelegate) {
        self.delegate = delegate
    }
    
}

extension NowPlayingCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.nowPlayingViewModel.fetchIndividualFilm(index: indexPath.item) {
            self.delegate?.navigateToDetail(with: indexPath.item, viewModel: self.nowPlayingViewModel)
        }
    }
}

extension NowPlayingCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
}

extension NowPlayingCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nowPlayingViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCell.reuseIdentifier, for: indexPath) as? ImageCollectionCell else  {
            return UICollectionViewCell()
        }
        cell.imageView?.image = UIImage(named: "Default.jpeg")
        self.setImage(cell: cell, index: indexPath.item)
        return cell
    }
    
    private func setImage(cell: ImageCollectionCell, index: Int) {
        self.nowPlayingViewModel.fetchImage(index: index) { (image) in
            DispatchQueue.main.async {
                cell.imageView?.image = image ?? UIImage(named: "Default.jpeg")
            }
        }
    }
    
}
