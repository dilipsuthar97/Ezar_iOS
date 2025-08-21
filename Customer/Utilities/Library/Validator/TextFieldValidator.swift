//
//  TextFieldValidator.swift
//  Thoab App
//
//  Created by Arvind Valaki on 05/01/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import UIKit

open class TextFieldValidatar: UITextField {
    
    open var validationBlock: (([Error]) -> Void)?
    
    @IBInspectable public var textLength: Int = 30
    public var color: UIColor = UIColor.white
    @IBInspectable public var isMandatory: Bool = true
    

    var validators: [Validator]  = []
    var delegateInterceptor :TextFieldValidatorDelegate?
   
    override open var delegate: UITextFieldDelegate? {
        get {
            return delegateInterceptor?.finalDelegate
        }
        set {
            self.delegateInterceptor = TextFieldValidatorDelegate()
            self.delegateInterceptor?.finalDelegate = newValue
            self.delegateInterceptor?.maxLenth = textLength
            super.delegate = delegateInterceptor
        }
    }
    
    @objc open func placeHolder() {
        
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color.withAlphaComponent(1)])
    }
    
    open func add(validator:Validator) {
        validators.append(validator)
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color.withAlphaComponent(1)])
    }
    
    open func validate() {
        var errors: [Error] = []
        
        for validator in validators {
            do {
                try validator.validate(value: text ?? "")
            } catch {
                let error = error as! ValidatorError
                if error == ValidatorError.noMinInput || error == ValidatorError.noMaxInput {
                    
                }else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.becomeFirstResponder()
                    })
                    errors.append(error)
                }
            }
        }
        
        validationBlock?(errors)
    }
    
    open func isValid() -> Bool {
        if !isMandatory, self.text?.count == 0{
            return true
        }
        
        validate()
        return validators.filter {
            if (try? $0.validate(value: text ?? "")) == nil {
                return true
            }
            
            return false
            }.count == 0
    }
    
    open func resetValidators() {
        validators = []
    }
}

@IBDesignable class CustomTextField: TextFieldValidatar {
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            guard let uiColor = newValue else { return }
            self.color = uiColor
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
            self.perform(#selector(placeHolder), with: uiColor, afterDelay: 0.2)
        }
    }
        
    var textFieldBorderStyle: UITextField.BorderStyle = .roundedRect
    
    // Provides left padding for image
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += 10
        return textRect
    }
    
    // Provides right padding for image
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 10
        return textRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    @IBInspectable var LeftImage: UIImage? = nil {
        didSet {
            addLeftView()
        }
    }
    @IBInspectable var RightImage: UIImage? = nil {
        didSet {
            addRightView()
        }
    }
    
    @IBInspectable var paddingLeft: CGFloat = 10
    @IBInspectable var paddingRight: CGFloat = 10
    
    func addLeftView() {
        
        if let image = LeftImage {
            let viewLeft: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: self.frame.size.height))
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 5, y: self.frame.size.height/2-7.5, width: 15, height: 15))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            viewLeft.addSubview(imageView)
            
//            let lineLbl = UILabel.init(frame: CGRect.init(x: 40, y: 0, width: 1, height: self.frame.size.height))
//            lineLbl.backgroundColor = self.borderColor
//            viewLeft.addSubview(lineLbl)
            
            leftView = viewLeft
            
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    
    func removeRightView() {
        
        self.textColor = UIColor.darkGray.withAlphaComponent(1)
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        paddingRight = 10
    }
    
    func addRightView() {
        
        if let image = RightImage {
            let viewLeft: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: self.frame.size.height))
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height/2-6, width: 15, height: 15))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.isUserInteractionEnabled = true
            viewLeft.addSubview(imageView)
            rightView = viewLeft
            
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
}

