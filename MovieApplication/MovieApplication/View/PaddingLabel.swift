//
//  PaddingLabel.swift
//  MovieApplication
//
//  Created by iAskedYou2nd on 8/28/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    var padding: CGFloat
    
    convenience init(text: String) {
        self.init(padding: 4)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5
    }
    
    required init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var cSize = super.intrinsicContentSize
            cSize.height += padding * 2
            cSize.width += padding * 2
            return cSize
        }
    }
    
}
