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

    var viewModel: ViewModelType
    var delegate: DismissDetailDelegate
    var index: Int
    
    var genreStacks: [UIStackView] = []
    var vStack: UIStackView?
    
    init(viewModel: ViewModelType, index: Int, delegate: DismissDetailDelegate) {
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
        
        let tLabel = UILabel(lines: 0, alignment: .center)
        tLabel.setAttrString(text: self.viewModel.title(index: self.index), isBold: true)
        
        let releaseDurationLabel = UILabel(lines: 0, alignment: .center)
        let string = self.viewModel.releaseDate(index: index) + " - " + self.viewModel.duration(index: index)
        releaseDurationLabel.setAttrString(text: string, isBold: false)
        
        let overViewLabel = UILabel(lines: 0, alignment: .left)
        overViewLabel.setAttrString(text: "Overview", isBold: true)
        
        let overViewDetailLabel = UILabel(lines: 0, alignment: .left)
        overViewDetailLabel.setAttrString(text: self.viewModel.overView(index: index), isBold: false)
                        
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(tLabel)
        vStackView.addArrangedSubview(releaseDurationLabel)
        vStackView.addArrangedSubview(overViewLabel)
        vStackView.addArrangedSubview(overViewDetailLabel)
        genreStacks.forEach{
            vStackView.addArrangedSubview($0)
        }
                
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(vStackView)
        scrollView.isScrollEnabled = true
        self.view.addSubview(scrollView)
        
        scrollView.boundToSuperView(inset: 24)
        vStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        vStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -48).isActive = true
        
        self.vStack = vStackView
    }
    
    private func setUpGenres() {
        var hStackArray: [UIStackView] = []
        var width: CGFloat = 0.0
        var hStack = UIStackView(axis: .horizontal, alignment: .leading, spacing: 5)
        hStackArray.append(hStack)
        self.viewModel.genres(index: index).forEach{
            let label = PaddingLabel(text: $0)
            width += label.intrinsicContentSize.width + 5
            if width >= self.view.frame.width - 20 {
                hStack.addArrangedSubview(UIView(bufferAxis: .horizontal))
                width = 0.0
                hStack = UIStackView(axis: .horizontal, alignment: .leading, spacing: 3)
                hStackArray.append(hStack)
            }
            hStack.addArrangedSubview(label)
        }
        hStack.addArrangedSubview(UIView(bufferAxis: .horizontal))
        
        self.genreStacks = hStackArray
    }
    
    private func resetGenres() {
        genreStacks.forEach{
            $0.removeFromSuperview()
        }
        
        self.setUpGenres()
        genreStacks.forEach{
            self.vStack?.addArrangedSubview($0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.resetGenres()
    }
    
    @objc
    func exitDetail(sender: Any) {
        self.delegate.dismissDetail()
    }
    
}
