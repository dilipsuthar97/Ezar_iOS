//
//  UINavigationItem.swift
//  GIS-Agent
//
//  Created by Arvind Vlk on 28/07/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import Foundation
import UIKit

var lButton = ActionButton()

extension UINavigationItem {
    
    func leftButton(title: String = "", imgName: String) -> ActionButton {
        lButton = ActionButton(type: .custom)
        lButton.setTitleColor(Theme.white, for: .normal)

        lButton.setImage(UIImage(named: imgName)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        lButton.titleLabel?.font = UIFont.init(name: CustomFont.FuturanBook.rawValue, size: 19.0)
        lButton.layer.cornerRadius = 5
        
        lButton.backgroundColor = UIColor.clear
        lButton.setupAction()
        let lBarButton = UIBarButtonItem(customView: lButton)
        self.leftBarButtonItem = lBarButton
        return lButton
    }
    
    func rightButton(name: String) -> ActionButton {
        let rButton = ActionButton(type: .custom)
        rButton.setImage(UIImage(named: name)?.imageFlippedForRightToLeftLayoutDirection(),
                         for: .normal)
        rButton.setTitleColor(Theme.white, for: .normal)
        rButton.setupAction()
        rButton.titleLabel?.font = UIFont.init(name: CustomFont.FuturanBook.rawValue, size: 19.0)
        rButton.layer.cornerRadius = 5
        rButton.backgroundColor = UIColor.clear
        let rBarButton = UIBarButtonItem(customView: rButton)
        self.rightBarButtonItem = rBarButton
        return rButton
    }
    
    
    func rightButtonTitle(title: String) -> ActionButton {
        let rButton = ActionButton(type: .custom)
        rButton.setTitleColor(Theme.white, for: .normal)
        rButton.setupAction()
        rButton.titleLabel?.font = UIFont(name: CustomFont.FuturanBook.rawValue, size: 19.0)
        rButton.layer.cornerRadius = 5
        rButton.setTitle(" \(title)".localized, for: .normal)
        rButton.backgroundColor = UIColor.clear
        let rBarButton = UIBarButtonItem(customView: rButton)
        self.rightBarButtonItem = rBarButton
        return rButton
    }
}
