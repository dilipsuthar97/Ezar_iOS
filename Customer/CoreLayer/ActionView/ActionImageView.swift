//
//  ActionImageView.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

class ActionImageView: UIImageView {
    var touchUp: ((_ image: UIImageView) -> Void)?

    override func awakeFromNib() {
        setupAction()
    }

    func setupAction() {
        isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 1
        recognizer.addTarget(self, action: #selector(touchUp(sender:)))
        addGestureRecognizer(recognizer)
    }

    @objc func touchUp(sender: UIImageView) {
        touchUp?(sender)
    }
}
