//
//  ImageCollectionCell.swift
//  MovieApplication
//
//  Created by Baron Lazar on 7/1/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ImageCollectionCell"
    
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addImageView()
    }
    
    private func addImageView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.boundToSuperView(inset: 0)
        self.imageView = imageView
    }
}
