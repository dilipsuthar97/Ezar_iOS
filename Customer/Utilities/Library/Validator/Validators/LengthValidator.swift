//
//  ELVLengthValidator.swift
//  Pods
//
//  Created by Victor Carmouze on 01/12/2015.
//
//

import Foundation
import UIKit

open class MaxValidator : Validator {
    let minTextField:TextFieldValidatar!
    var errorMessage: String?
    
    public init(validationEvent: ValidatorEvents = ValidatorEvents.atEnd, minTextField: TextFieldValidatar,ErrorMessage:String) {
        self.minTextField = minTextField
        self.errorMessage = ErrorMessage
        super.init(validationEvent: validationEvent)
    }
    
    open override func validate(value: String) throws {
        
        let chrts = (value as NSString).floatValue
        let min = (self.minTextField.text! as NSString).floatValue
   
        if (value != "" && self.minTextField.text == "") || (value == "" && self.minTextField.text != ""){
            return
        }
        guard chrts >= min , value != "" else {
            INotifications.show(message: errorMessage!)
            throw ValidatorError.textTooLong
        }
    }
}

open class MinValidator : Validator {
    let maxTextField:TextFieldValidatar!
    var errorMessage: String?
    
    public init(validationEvent: ValidatorEvents = ValidatorEvents.atEnd, maxTextField: TextFieldValidatar,ErrorMessage:String) {
        self.maxTextField = maxTextField
        self.errorMessage = ErrorMessage
        super.init(validationEvent: validationEvent)
    }
    
    open override func validate(value: String) throws {
        
        let chrts = (value as NSString).floatValue
        let max = (self.maxTextField.text! as NSString).floatValue
        
    
        
        if (value != "" && self.maxTextField.text == "") || (value == "" && self.maxTextField.text != ""){
            return
        }
        guard chrts <= max , value != "" else {
            INotifications.show(message: errorMessage!)
            throw ValidatorError.textTooLong
        }
    }
}

open class LenghtValidator : Validator {
    let min:Int
    let max:Int
    var errorMessage: String?

    public init(validationEvent: ValidatorEvents, min: Int = 0, max: Int = NSIntegerMax,ErrorMessage:String) {
        self.max = max
        self.min = min
        self.errorMessage = ErrorMessage
        super.init(validationEvent: validationEvent)
    }
    
    open override func validate(value: String) throws {
        let chrts = value.count
        
        guard chrts <= max && chrts >= min else {
            INotifications.show(message: errorMessage!)
            throw ValidatorError.textTooLong
        }
    }
}


open class MinLengthValidator : Validator {
    let min:Int
    var errorMessage: String?
    
    public init(validationEvent: ValidatorEvents, min: Int = 0,ErrorMessage:String) {
        self.min = min
        self.errorMessage = ErrorMessage
        super.init(validationEvent: validationEvent)
    }
    
    open override func validate(value: String) throws {
        let chrts = value.count
        
        guard chrts >= min else {
            INotifications.show(message: errorMessage!)
            throw ValidatorError.textTooLong
        }
    }
}

