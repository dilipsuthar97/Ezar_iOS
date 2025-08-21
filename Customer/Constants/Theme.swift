//
//  Theme.swift
//  Homekooc
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

public struct Theme {
    static let primaryColor = UIColor(hex: "5CACB2")
    static let primaryBGColor = UIColor(hex: "D4EBED")
    static let bgColor = UIColor(hex: "F8F8F8")
    static let bgDarkColor = UIColor(hex: "E5E5E5")
    static let kBorderColor = UIColor(hex: "E3E2E8")

    static let redColor = UIColor(hex: "F13F51")
    static let yellowColor = UIColor(hex: "FFA807")
    static let greenColor = UIColor(hex: "3CB371")
    static let greenBgColor = UIColor(hex: "C7F6CA")

    static let orageColor = UIColor(hex: "FF9500")
    static let orageBgColor = UIColor(hex: "F8E2C3")
    static let brown = UIColor(hex: "AF6845")
    static let blue = UIColor(hex: "#0071c5")

    static let blackColor = UIColor(hex: "1C1C2A")
    static let darkGray = UIColor.darkGray
    static let lightGray = UIColor.lightGray
    static let white = UIColor.white

    static let navBarColor = UIColor(hex: "1E1920")
    static let priceColor = UIColor(hex: "D0D0D0")    
    
    static let darkShimmerColor = UIColor(hex: "F1F1F1")
    static let lightShimmerColor = UIColor(hex: "F8F8F8")
}

public struct FontType {

    public static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: CustomFont.FuturanBook.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: CustomFont.FuturanM.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    public static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: CustomFont.FuturanBold.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    public static func heavy(size: CGFloat) -> UIFont {
        return UIFont(name: CustomFont.FuturanHv.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    public static func italic(size: CGFloat) -> UIFont {
        return UIFont(name: CustomFont.FuturanBookI.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    public static func italicMedium(size: CGFloat) -> UIFont {
        return UIFont(name: CustomFont.FuturanMI.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    public static func italicBold(size: CGFloat) -> UIFont {
        return UIFont(name: CustomFont.FuturanBoldI.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
