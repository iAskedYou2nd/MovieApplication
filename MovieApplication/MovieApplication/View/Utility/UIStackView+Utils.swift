//
//  UIStackView+Utils.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, alignment: Alignment, spacing: CGFloat) {
        self.init()
        
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addBufferView(constant: CGFloat) {
        let view = UIView()

        if self.axis == .vertical {
            view.heightAnchor.constraint(equalToConstant: constant).isActive = true
        } else {
            view.widthAnchor.constraint(equalToConstant: constant).isActive = true
        }
        
        self.addArrangedSubview(view)
    }
    
}
