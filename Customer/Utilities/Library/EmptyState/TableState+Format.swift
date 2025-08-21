//
//  State+Format.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 27/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit
import EmptyStateKit

extension TableState {
    var format: EmptyStateFormat {
        var format = EmptyStateFormat()
        format.buttonColor = Theme.primaryColor
        format.buttonAttributes = [.font: FontType.bold(size: 14), .foregroundColor: UIColor.white]
        format.buttonTopMargin = 20
        format.position = EmptyStatePosition(view: .center, text: .center, image: .top)
        format.animation = EmptyStateAnimation.fade(0.3, 0.3)
        format.verticalMargin = -40
        format.horizontalMargin = 0
        format.imageSize = CGSize(width: 150, height: 150)
        format.buttonShadowRadius = 0
        format.backgroundColor = .clear
        format.titleAttributes = [.font: FontType.bold(size: 26), .foregroundColor: Theme.blackColor]
        format.descriptionAttributes = [.font: FontType.regular(size: 16), .foregroundColor: UIColor.lightGray]
        return format
    }
}
