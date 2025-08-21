//
//  TextFieldValidatorDelegate.swift
//  Thoab App
//
//  Created by Arvind Valaki on 05/01/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import UIKit

open class TextFieldValidatorDelegate: NSObject, UITextFieldDelegate {
    
    var finalDelegate: UITextFieldDelegate?
    var maxLenth: Int = 0
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.autocorrectionType = .yes
        textField.autocorrectionType = .no
        return finalDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        finalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType != UIReturnKeyType.next  {
            textField.resignFirstResponder()
        }
        
        return finalDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return finalDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let textField = textField as? TextFieldValidatar {
            
            var errors: [Error] = []
            textField.validators.forEach {
                do {
                    try $0.validate(value: textField.text ?? "")
                } catch {
                    
                   // let txt = textField as? CustomTextField
                  //  txt?.RightImage = #imageLiteral(resourceName: "down_Black")
                   // txt?.paddingRight = 40
                    //txt?.addRightView()
                    textField.textColor = UIColor.red.withAlphaComponent(0.5)
                    errors.append(error)
                }
            }
            
            textField.validationBlock?(errors)
            finalDelegate?.textFieldDidEndEditing?(textField)
        }
    }
    
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let txt = textField as? CustomTextField
        txt?.removeRightView()

        if let textField = textField as? TextFieldValidatar,
            let textString = textField.text as NSString? {
            
            let fullString = textString.replacingCharacters(in: range, with:string)
            
            if fullString.count > maxLenth {
                return false
            }
            
            var textFieldHasChanged = false
            
            for validator in textField.validators {
                if (validator.validationEvent.contains(.perCharacter) || validator.validationEvent.contains(.allowBadCharacters)) {
                    do {
                        textFieldHasChanged = true
                        try validator.validate(value: fullString)
                    } catch {
                        if !validator.validationEvent.contains(.allowBadCharacters) {
                            textField.validationBlock?([error])
                        }
                        return !(validator.validationEvent.contains(.allowBadCharacters))
                    }
                }
            }
            
            if (textFieldHasChanged) {
                textField.validationBlock?([])
            }
        }
        
        return (finalDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)) ?? true
    }
}

