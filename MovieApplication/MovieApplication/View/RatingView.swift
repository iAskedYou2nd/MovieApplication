//
//  RatingView.swift
//  MovieApplication
//
//  Created by Baron Lazar on 6/30/20.
//  Copyright © 2020 Baron Lazar. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    var circleLayer: CAShapeLayer?
    var outlineLayer: CAShapeLayer? {
        didSet {
            guard let old = oldValue, let new = self.outlineLayer else { return }
            self.circleLayer?.replaceSublayer(old, with: new)
        }
    }
    var percentage: Double = 0.0 {
        didSet {
            self.updateLabel()
            switch self.percentage {
            case let val where val >= 50.0:
                self.color = .customGreen
            case let val where val < 50.0 && val >= 25.0:
                self.color = .yellow
            default:
                self.color = .red
            }
        }
    }
    var color: UIColor = .customGreen
    var percentLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .black
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUp() {
        let pLabel = UILabel(lines: 1, alignment: .center)
        self.addSubview(pLabel)
        pLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.percentLabel = pLabel
        
        let circleLayer = CAShapeLayer()
        let outlineLayer = CAShapeLayer()
        circleLayer.addSublayer(outlineLayer)
        self.circleLayer = circleLayer
        self.outlineLayer = outlineLayer
        
        self.layer.addSublayer(circleLayer)
    }
    
    private func updateLabel() {
        let rating = String(Int(self.percentage))
        let attrString = NSMutableAttributedString()
        
        let numAttr = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18) as Any,
                       NSAttributedString.Key.foregroundColor: UIColor.white]
        let numAttrString = NSAttributedString(string: rating, attributes: numAttr)
        attrString.append(numAttrString)
        
        let percentAttr = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 10) as Any,
                           NSAttributedString.Key.baselineOffset: 5,
                           NSAttributedString.Key.foregroundColor: UIColor.white]
        let percentAttrString = NSAttributedString(string: "%", attributes: percentAttr)
        
        attrString.append(percentAttrString)
        self.percentLabel?.attributedText = attrString
    }
    
    override func layoutSubviews() {
        
        let rect = CGRect(x: self.frame.width/4, y: self.frame.height/4, width: 50, height: 50)
        let circlePath = UIBezierPath(ovalIn: rect)
        self.circleLayer?.path = circlePath.cgPath
        self.circleLayer?.fillColor = UIColor.clear.cgColor
        self.circleLayer?.strokeColor = UIColor.lightGray.cgColor
        self.circleLayer?.lineWidth = 5.0

        let centerPoint = CGPoint(x: rect.size.width/2 + rect.origin.x,
                                  y: rect.size.height/2 + rect.origin.y)
        let radi = rect.size.height/2

        let outlinePath: UIBezierPath = UIBezierPath(arcCenter: centerPoint,
                                                     radius: radi,
                                                     startAngle: CGFloat(-0.5 * .pi),
                                                     endAngle: CGFloat(1.5 * .pi),
                                                     clockwise: true)

        let outlineLayer = CAShapeLayer()
        outlineLayer.path = outlinePath.cgPath
        outlineLayer.strokeStart = 0.0
        outlineLayer.strokeEnd = CGFloat(self.percentage / 100)
        outlineLayer.strokeColor = self.color.cgColor
        outlineLayer.fillColor = UIColor.clear.cgColor
        outlineLayer.lineWidth = 5.0
        self.outlineLayer = outlineLayer
    }
    
}
