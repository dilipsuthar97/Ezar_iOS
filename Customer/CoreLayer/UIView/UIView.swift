//
//  UIView.swift
//  GIS-Agent
//
//  Created by Arvind Vlk on 27/07/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        set(radius) {
            layer.cornerRadius = radius
            layer.masksToBounds = radius > 0
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        set(borderWidth) {
            layer.borderWidth = borderWidth
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        set(color) {
            layer.borderColor = color?.cgColor
        }
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
}


public extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }

    func fadeIn(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }

    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        clipsToBounds = true
        layer.masksToBounds = true
    }
}
