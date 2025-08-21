//
//  ELVListValidator.swift
//  Pods
//
//  Created by Victor Carmouze on 02/12/2015.
//
//

import Foundation
import UIKit

open class ListValidator : Validator {
    open var correctValues:[String]
    var errorMessage: String?

    public init(validationEvent: ValidatorEvents = ValidatorEvents.perCharacter, correctValues:[String],ErrorMessage:String) {
        self.correctValues = correctValues
        self.errorMessage = ErrorMessage
        super.init(validationEvent: validationEvent)
    }

    open override func validate(value: String) throws {
        guard (self.correctValues.contains(value)) else {
            if value.count < 1 {
                INotifications.show(message: errorMessage!)
            } else {
                INotifications.show(message: errorMessage!)
            }
            
            throw ValidatorError.textNotInList
        }
    }
}

