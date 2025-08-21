//
//  UIDevice.swift
//  Business
//
//  Created by Volkoff on 28/04/22.
//

import Foundation
import UIKit

public extension UIDevice {
     static var identifier: String {
      var systemInfo = utsname()
      uname(&systemInfo)
      
      let machineMirror = Mirror(reflecting: systemInfo.machine)
      let identifier = machineMirror.children.reduce("") { (identifier, element) in
        guard let value = element.value as? Int8, value != 0 else {
          return identifier
        }
        return identifier + String(UnicodeScalar(UInt8(value)))
      }
      return identifier
    }
}

enum ScreenType: String {
    case iPhones_4_4S = "iPhone 4 or iPhone 4S"
    case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
    case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
    case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
    case iPhones_X_XS = "iPhone X or iPhone XS"
    case iPhone_XR = "iPhone XR"
    case iPhone_XSMax = "iPhone XS Max"
    case iPhone_11ProMax = "iPhone 11 Pro Max"
    case iPhone_12ProMax = "iPhone 12 Pro Max"
    case unknown
}


extension UIDevice {
            
    var iPhoneWithFaceID: Bool {
        switch UIDevice.current.screenType {
        case .iPhones_4_4S, .iPhones_5_5s_5c_SE, .iPhones_6_6s_7_8, .iPhones_6Plus_6sPlus_7Plus_8Plus :
            return false
        default:
            return true
        }
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2532:
            return .iPhone_11ProMax
        case 2688:
            return .iPhone_XSMax
        case 2778:
            return .iPhone_12ProMax
        default:
            return .unknown
        }
    }
}
