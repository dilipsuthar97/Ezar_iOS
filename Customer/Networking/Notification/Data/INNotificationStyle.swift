//
//  INNotificationStyle.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

public struct INNotificationStyle {
    let cornerRadius: CGFloat?
    let backgroundColor: UIColor?
    let titleColor: UIColor?
    let descriptionColor: UIColor?
    let imageSize: CGSize?

    public init(cornerRadius: CGFloat? = nil,
                backgroundColor: UIColor? = nil,
                titleColor: UIColor? = nil,
                descriptionColor: UIColor? = nil,
                imageSize: CGSize? = nil) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.descriptionColor = descriptionColor
        self.imageSize = imageSize
    }
}
