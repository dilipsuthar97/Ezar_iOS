
//
//  UIFont+Custom.swift
//
//  Created by Fernando Ortiz on 10/1/16.
//  Copyright © 2016 Fernando Martín Ortiz. All rights reserved.
//

import UIKit

enum CustomFont: String {
    case FuturanBook    = "FuturaBT-Book"  //Futura Bk BT
    case FuturanBookI    = "FuturaBT-BookItalic"
    case FuturanM       = "Futura-Medium" //Futura Md BT Medium
    case FuturanMI      = "Futura-MediumItalic"
    case FuturanBold    = "FuturaBT-Bold"
    case FuturanBoldI    = "FuturaBT-BoldItalic"
    case FuturanHv       = "FuturaBT-Heavy"

    case ElMessiriB    = "ElMessiri-Bold"
    case ElMessiriR   = "ElMessiri-Regular"
    case ElMessiriM   = "ElMessiri-Medium"
    case ElMessiriSB   = "ElMessiri-SemiBold"

    case UbuntuL   = "Ubuntu-Light"
    case UbuntuB   = "Ubuntu-Bold"
    case UbuntuM   = "Ubuntu-Medium"
    case UbuntuMI   = "Ubuntu-MediumItalic"
    case UbuntuR   = "Ubuntu-Regular"
   // case FuturanR      = "FuturaCondMedium"
    
    case CairoBlack      = "Cairo Black 900"
    case CairoBold    = "Cairo Bold 700"
    case CairoExtraLight    = "Cairo ExtraLight 275"
    case CairoLight       = "Cairo Light 300"
    case CairoRegular  = "Cairo Regular 400"
    case CairoSemiBold = "Cairo SemiBold"
}

extension UIFont {
    convenience init?(customFont: CustomFont, withSize size: CGFloat) {
        self.init(name: customFont.rawValue, size: size)
    }
}

extension UIFont {
    @nonobjc class var kTextStyle: UIFont {
        return UIFont(name: "ElMessiri-Regular", size: 15.0)!
    }
}
