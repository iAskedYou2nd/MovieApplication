//
//  PopularMovieCell.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class PopularMovieCell: UITableViewCell {
    
    static let reuseIdentifier = "PopularMovieCell"
    
    var moviePosterView: UIImageView?
    var titleLabel: UILabel?
    var releaseDateLabel: UILabel?
    var durationLabel: UILabel?
    var ratingView: RatingView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    private func setUp() {
        self.contentView.backgroundColor = .black
        
        let hStackView = UIStackView(axis: .horizontal, alignment: .center, spacing: 8)
        let vStackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 0)
        
        let tLabel = UILabel(lines: 0, alignment: .left)
        tLabel.setAttrString(text: "Title Label Kamen Rider Heisei", isBold: true)
        tLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let rdLabel = UILabel(lines: 0, alignment: .left)
        rdLabel.setAttrString(text: "Release Date Label", isBold: false)
        
        let dLabel = UILabel(lines: 0, alignment: .left)
        dLabel.setAttrString(text: "Duration Label", isBold: false)
        
        let mpView = UIImageView(image: UIImage(named: "Default.jpeg"))
        mpView.contentMode = .scaleAspectFit
        mpView.translatesAutoresizingMaskIntoConstraints = false
        
        let rView = RatingView()
        
        vStackView.addArrangedSubview(tLabel)
        vStackView.addBufferView(constant: 4)
        vStackView.addArrangedSubview(rdLabel)
        vStackView.addArrangedSubview(dLabel)
        
        mpView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mpView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        rView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        rView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        hStackView.addArrangedSubview(mpView)
        hStackView.addArrangedSubview(vStackView)
        hStackView.addArrangedSubview(rView)
        
        self.addSubview(hStackView)
        hStackView.boundToSuperView(inset: 8)
        
        self.moviePosterView = mpView
        self.titleLabel = tLabel
        self.releaseDateLabel = rdLabel
        self.durationLabel = dLabel
        self.ratingView = rView
    }

}
