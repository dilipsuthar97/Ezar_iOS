//
//  UINavigationBar.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

extension UINavigationBar {
    func transparentNavigationBar(color: UIColor = .clear) {
        let apperance = UINavigationBar.appearance()
        apperance.setBackgroundImage(UIImage.imageWithColor(color: .darkGray),
                                     for: .default)
        apperance.shadowImage = UIImage.imageWithColor(color: .darkGray)
        apperance.isTranslucent = true
        apperance.backgroundColor = UIColor(white: 1, alpha: 0)
        apperance.backgroundColor = color
        apperance.shadowImage = UIImage.imageWithColor(color: color)
    }
}
