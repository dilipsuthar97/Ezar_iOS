//
//  INNotificationData.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

public struct INotificationData {
    let title: String
    let description: String?
    let image: UIImage?
    let delay: TimeInterval
    let completionHandler: (() -> Void)?

    public init(title: String = "", description: String? = nil, image: UIImage? = nil, delay: TimeInterval = 5.0, completionHandler: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.image = image
        self.delay = delay
        self.completionHandler = completionHandler
    }
}
