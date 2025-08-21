//
//  ELVPatternValidator.swift
//  Pods
//
//  Created by Victor Carmouze on 02/12/2015.
//
//

import Foundation
import UIKit

public enum ValidatorRegex : String {
    case mail = "(^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$)"
    case alphaNumeric = "(^[a-zA-Z0-9]*$)"
    case numeric = "(^[0-9]*$)"
    case phone = "(\\(?\\d{3}\\)?-? *\\d{3}-? *-?\\d{4}$)"
    case decimal = "(^[0-9]*,?([0-9]{1,2})?$)"
    case decimalReal = "(^-?[0-9]*,?([0-9]{1,2})?$)"
    case countryCode = "(^\\+[0-9]\\d{1,3}$)"
    case limit = "(^.{0,30}$)"
    case otpLimit = "(^.{1,4}$)"
    case userNameLimit = "(^.{3,10}$)"
    case userName = "([A-Za-z0-9]{5,30})"
    case password = "(^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$)"
  
    case dob = "(^(0[1-9]|[12][0-9]|3[01])[- /.](Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[- /.](19|20)\\d\\d$)"
    case oneortwodigit = "(^[0-9]{1,2}$)"
    case notEmpty = "(^(?!\\s*$).+)"
    case oldPassword = "(^.{6,15}$)"
    case name = "([^`~!@#$%^&*()-+=0-9{}\\]\\[|:;\"'<>,?\\/]+)"
    case price = "^[1-9]\\d*(\\.\\d+)?$"
    case alphanumericWithDashUnderscore = "^[a-zA-Z0-9-_]+$"
    case newPassword = "(^.{6,12}$)"
    //case alphabets = "(^[a-zA-Z ]*$)"
   
    case alphabets = "^[A-Za-zء-ي ]+$"
}

open class PatternValidator : Validator {
    var internalExpression: NSRegularExpression?
    var errorMessage: String?
    var emptyMessage: String?

    public init (validationEvent: ValidatorEvents = .atEnd, pattern: ValidatorRegex, ErrorMessage:String, EmptyMessage:String) {
        do {
            errorMessage = ErrorMessage
            emptyMessage = EmptyMessage

            try self.internalExpression = NSRegularExpression(pattern: pattern.rawValue, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            print(error)
        }

        super.init(validationEvent: validationEvent)
    }

    
    public init (validationEvent: ValidatorEvents = .atEnd, pattern: ValidatorRegex, EmptyMessage:String) {
        do {
            emptyMessage = EmptyMessage
            
            try self.internalExpression = NSRegularExpression(pattern: pattern.rawValue, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            print(error)
        }
        
        super.init(validationEvent: validationEvent)
    }
    
    public init (validationEvent: ValidatorEvents = .atEnd, customPattern: String) {
        do {
            self.internalExpression = try NSRegularExpression(pattern: customPattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            print(error)
        }

        super.init(validationEvent: validationEvent)
    }

    open override func validate(value: String) throws {
        guard let internalExpression = self.internalExpression,
            internalExpression.numberOfMatches(in: value, options: .reportProgress, range: NSMakeRange(0, value.count)) > 0 else {
                if value.count < 1 {
                    INotifications.show(message: emptyMessage!)
                } else {
                    INotifications.show(message: errorMessage!)
                }
                
                throw ValidatorError.textDoNotMatchRegex
        }
    }
}
