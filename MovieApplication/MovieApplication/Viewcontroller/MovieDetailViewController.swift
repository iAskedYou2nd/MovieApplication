//
//  MovieDetailViewController.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

protocol DismissDetailDelegate {
    func dismissDetail()
}

class MovieDetailViewController: UIViewController {

    var viewModel: ViewModelDataSource
    var delegate: DismissDetailDelegate
    var index: Int
    
    init(viewModel: ViewModelDataSource, index: Int, delegate: DismissDetailDelegate) {
        self.viewModel = viewModel
        self.index = index
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should not happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        let button = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(self.exitDetail(sender:)))
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                                       NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 24) as Any], for: .normal)
        
        self.navigationItem.setRightBarButton(button, animated: false)
        
        self.setUp()
    }
    
    private func setUp() {
        let vStackView = UIStackView(axis: .vertical, alignment: .fill, spacing: 8)
        
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.viewModel.image(index: self.index)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let tLabel = UILabel(lines: 0, alignment: .center)
        tLabel.setAttrString(text: self.viewModel.title(index: self.index), isBold: true)
        
        let releaseDurationLabel = UILabel(lines: 0, alignment: .center)
        let string = self.viewModel.releaseDate(index: index) + " - " + self.viewModel.duration(index: index)
        releaseDurationLabel.setAttrString(text: string, isBold: false)
        
        let overViewLabel = UILabel(lines: 0, alignment: .left)
        overViewLabel.setAttrString(text: "Overview", isBold: true)
        
        let overViewDetailLabel = UILabel(lines: 0, alignment: .left)
        overViewDetailLabel.setAttrString(text: self.viewModel.overView(index: index), isBold: false)
        
        let genresLabel = UILabel(lines: 0, alignment: .left)
        let genresAttrString = NSMutableAttributedString(string: "")
        self.viewModel.genres(index: index).forEach{
            let attr = NSAttributedString(string: "\($0)", attributes: [NSAttributedString.Key.backgroundColor: UIColor.white])
            genresAttrString.append(attr)
            genresAttrString.append(NSAttributedString(string: " "))
        }
        genresLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        genresAttrString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, genresAttrString.length))
        genresLabel.attributedText = genresAttrString

        let bView = UIView(frame: .zero)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.setContentHuggingPriority(.defaultLow, for: .vertical)
        bView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(tLabel)
        vStackView.addArrangedSubview(releaseDurationLabel)
        vStackView.addArrangedSubview(overViewLabel)
        vStackView.addArrangedSubview(overViewDetailLabel)
        vStackView.addArrangedSubview(genresLabel)
        vStackView.addArrangedSubview(bView)
        
        self.view.addSubview(vStackView)
        vStackView.boundToSuperView(inset: 24)
    }
    
    @objc
    func exitDetail(sender: Any) {
        self.delegate.dismissDetail()
    }
    
}
