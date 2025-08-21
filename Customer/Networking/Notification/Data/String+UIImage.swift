//
//  String+UIImage.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import UIKit

public extension String {
    func image(size: CGSize) -> UIImage? {
        let size = size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()

        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: size.height - 8)])

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
