//
//  UIColor+EMAlertController.swift
//  EMAlertController
//
//  Created by Eduardo Moll on 10/17/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import UIKit

// MARK: - Custom Colors
extension UIColor {
  
  /// Default color of the EMAlertView
  static let emAlertviewColor = UIColor.white
  
  /// Default color of the EMAlertAction
  static let iosBlueColor = UIColor.darkGray
  
  /// Default color of the EMAlertView separator color
  static let emSeparatorColor = UIColor.lightGray.withAlphaComponent(0.5)
  
  /// Default color of the EMAlertAction cancel style
    static let emCancelColor = UIColor(hex: "FF2600")
  
  /// Default color of the EMAlertAction normal style
    static let emActionColor = Theme.greenColor

}
