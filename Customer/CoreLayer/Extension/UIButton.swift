//
//  UIButton.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

extension UIButton {
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x,
                                        height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width,
                           y: layer.shadowOffset.height)
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
}
