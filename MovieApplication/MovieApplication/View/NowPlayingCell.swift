//
//  NowPlayingCell.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

protocol CellSelectedDelegate {
    func navigateToDetail(with index: Int, viewModel: ViewModelDataSource?)
    func presentAlert(error: NetworkError)
}

class NowPlayingCell: UITableViewCell {
    
    static let reuseIdentifier = "NowPlayingCell"
    
    var collectionView: UICollectionView?
    var delegate: CellSelectedDelegate?
    var movieViewModel: ViewModelType? {
        didSet {
            self.setUpVM()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    private func setUpUI() {
        
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
    
    private func setUpVM() {
        self.movieViewModel?.bind(uiHandler: {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.delegate?.presentAlert(error: error)
            }
        }
        
        self.movieViewModel?.fetchMovies()
    }
    
    func setDelegate(delegate: CellSelectedDelegate) {
        self.delegate = delegate
    }
    
    func setViewModel(viewModel: ViewModelType) {
        self.movieViewModel = viewModel
    }
    
}

extension NowPlayingCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.movieViewModel?.fetchIndividualFilm(index: indexPath.item) {
            self.delegate?.navigateToDetail(with: indexPath.item, viewModel: self.movieViewModel)
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
        return self.movieViewModel?.count ?? 0
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
        self.movieViewModel?.fetchImage(index: index) { (image) in
            DispatchQueue.main.async {
                cell.imageView?.image = image ?? UIImage(named: "Default.jpeg")
            }
        }
    }
    
}
