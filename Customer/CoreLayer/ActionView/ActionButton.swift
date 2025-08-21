//
//  UIButton.swift
//  Thoab App
//
//  Created by Arvind Valaki on 05/01/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class ActionButton : GradientButton {

    var touchUp: ((_ button: UIButton) -> ())?

    override func awakeFromNib() {
        setupAction()
    }
    
    func setupAction() {
        addTarget(self, action: #selector(touchUp(sender:)), for: [.touchUpInside])
    }
    
    @objc func touchUp(sender: UIButton) {
        touchUp?(sender)
    }
}


