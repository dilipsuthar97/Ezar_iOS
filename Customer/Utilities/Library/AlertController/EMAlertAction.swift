//
//  EMAlertAction.swift
//  EMAlertController
//
//  Created by Eduardo Moll on 10/14/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import UIKit

public enum EMAlertActionStyle: Int {
  case normal
  case cancel
  case defults
}

/// An action that can be taken when the user taps a button in an EMAlertController
open class EMAlertAction: UIButton {
  
  // MARK: - Properties
  internal var action: (() -> Void)?
  
  public var title: String? {
    willSet {
      setTitle(newValue, for: .normal)
    }
  }
  
  public var titleColor: UIColor? {
    willSet {
      setTitleColor(newValue, for: .normal)
    }
  }
  
  public var titleFont: UIFont? {
    willSet {
      self.titleLabel?.font = newValue
    }
  }
  
  public var actionBackgroundColor: UIColor? {
    willSet {
      backgroundColor = newValue
    }
  }

  // MARK: - Initializers
  required public  init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public init(title: String, titleColor: UIColor) {
    super.init(frame: .zero)
    
    self.setTitle(title, for: .normal)
    self.setTitleColor(titleColor, for: .normal)
  }
  
  public convenience init(title: String, style: EMAlertActionStyle, action: (() -> Void)? = nil) {
    self.init(type: .system)
    
    self.action = action
    self.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    
      switch style {
      case .normal:
          backgroundColor = UIColor.white
          setTitle(title: title, forStyle: .normal)
      case .cancel:
          backgroundColor = Theme.redColor
          setTitle(title: title, forStyle: .cancel)
      case .defults:
          backgroundColor = Theme.primaryColor
          setTitle(title: title, forStyle: .defults)
      }
  }
}

internal extension EMAlertAction {
  
  fileprivate func setTitle(title: String, forStyle: EMAlertActionStyle) {
    self.setTitle(title, for: .normal)
    addSeparator()
    
    switch forStyle {
    case .normal:
        borderWidth = 1
        borderColor = Theme.redColor
        setTitleColor(Theme.redColor, for: .normal)
        titleFont = FontType.medium(size: 16)
    case .cancel:
        borderWidth = 1
        borderColor = Theme.redColor
        setTitleColor(UIColor.white, for: .normal)
        titleFont = FontType.medium(size: 16)
    case .defults:
        borderWidth = 1
        borderColor = Theme.primaryColor
        setTitleColor(UIColor.white, for: .normal)
        titleFont = FontType.medium(size: 16)
    }
  }
  
  fileprivate func addSeparator() {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.backgroundColor = UIColor.clear
    
    self.addSubview(separator)
    
    separator.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
    separator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    separator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
  }
  
  @objc func actionTapped(sender: EMAlertAction) {
    self.action?()
  }
}
