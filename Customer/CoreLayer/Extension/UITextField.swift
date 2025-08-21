//
//  CustomTextField.swift
//  GIS-Agent
//
//  Created by Arvind Vlk on 25/07/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyNextField: String = ""

extension UITextField {
    
    func addToolBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = Theme.navBarColor
        let lButton = ActionButton(type: .custom)
        lButton.setTitle(TITLE.done.localized, for: .normal)
        lButton.titleLabel?.font = UIFont(customFont: .FuturanBook, withSize: 14)
        lButton.setTitleColor(Theme.navBarColor, for: .normal)
        lButton.layer.cornerRadius = 5
        lButton.backgroundColor = UIColor.clear
        lButton.addTarget(self, action: #selector(donePressed), for: [.touchUpInside])
        lButton.sizeToFit()
        let lBarButton = UIBarButtonItem(customView: lButton)

        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, lBarButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }
    
    func addToolBarWithButton(title:String) -> ActionButton {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = Theme.navBarColor
        
        let lButton = ActionButton(type: .custom)
        lButton.setTitle(title, for: .normal)
        lButton.titleLabel?.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 14)
        
        lButton.setTitleColor(Theme.navBarColor, for: .normal)
        lButton.layer.cornerRadius = 5
        lButton.backgroundColor = UIColor.clear
        lButton.setupAction()
        lButton.sizeToFit()
       // lButton.addTarget(self, action: #selector(donePressed), for: [.touchUpInside])
        
        let lBarButton = UIBarButtonItem(customView: lButton)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, lBarButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
        return lButton
    }

    
    @objc func donePressed(){
        self.endEditing(true)
    }
    
    @IBOutlet var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

