//
//  GradientButton.swift
//  Flurtee
//
//  Created by Chetan Chaudhari on 6/15/22.
//

import Foundation
import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    @IBInspectable var topColor: UIColor = .clear {
        didSet {
            updateButton()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .clear {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateButton()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateButton() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [topColor, bottomColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.9)
            layer.endPoint = CGPoint (x: 0.9, y: 1)
        } else {
            layer.startPoint = CGPoint(x: 0.9, y: 0.9)
            layer.endPoint = CGPoint (x: 0.9, y: 1)
        }
    }

}
