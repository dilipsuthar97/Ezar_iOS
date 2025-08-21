//
//  CompareValidator.swift
//  GIS-Agent
//
//  Created by Arvind Vlk on 10/10/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import Foundation
import UIKit

open class CompareValidator : Validator {
    open var compareTextField:TextFieldValidatar
    var errorMessage: String?
    
    public init(validationEvent: ValidatorEvents = ValidatorEvents.atEnd, compareTextField:TextFieldValidatar,ErrorMessage:String) {
        self.compareTextField = compareTextField
        self.errorMessage = ErrorMessage
        super.init(validationEvent: validationEvent)
    }
    
    open override func validate(value: String) throws {
        let compareStr = self.compareTextField.text
        if compareStr == value {
        } else {
            INotifications.show(message: errorMessage!)
            throw ValidatorError.textDoNotMatchRegex
        }
    }
}
