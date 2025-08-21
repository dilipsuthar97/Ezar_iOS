//
//  UIView.swift
//  GIS-Agent
//
//  Created by Arvind Vlk on 27/07/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonActionDelegate {
    func onClickBottomButton(button: UIButton)
}


class ContainerView: UIView {
    var delegate : ButtonActionDelegate?
    var buttonArray : NSMutableArray = []
    var buttonTitle : String = ""
    var substractValue : CGFloat = 70.0
    var isCustomBottom : Bool = false
    
    override func draw(_ rect: CGRect) {
        let screenSize: CGRect = UIScreen.main.bounds
        let width: CGFloat
        width = screenSize.width - 20
        self.clipsToBounds = true
        if !isCustomBottom
        {
            let buttonWidth = Int(width / CGFloat(buttonArray.count))+1
            
            if #available(iOS 11.0, *) {
                let bottomPadding : CGFloat = (window?.safeAreaInsets.bottom) ?? 0.0
                let fHeight = MAINSCREEN.height == 812 ? substractValue + bottomPadding : substractValue
                self.frame = CGRect(x: 10, y: (APP_DELEGATE.window?.frame.size.height)! - fHeight, width: (APP_DELEGATE.window?.frame.size.width)!-20,height: substractValue)
            } else {
                // Fallback on earlier versions
                self.frame = CGRect(x: 10, y: (APP_DELEGATE.window?.frame.size.height)!-substractValue, width: (APP_DELEGATE.window?.frame.size.width)!-20,height: substractValue)
            }
            
            let count : Int = buttonArray.count
            
            for index in 0 ..< count {
                let button = GradientButton(type: .custom)
                button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: 50)
                button.topColor = UIColor(named: "dark_gradient")!
                button.bottomColor = UIColor(named: "light_gradient")!
                button.layer.cornerRadius = 25

                button.tag = index
                button.backgroundColor = Theme.navBarColor
                
                button.titleLabel?.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 15)
                button.setTitle(buttonArray[index] as? String, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(ContainerView.buttonPressed(_:)), for: .touchUpInside)
                self.addSubview(button)
                
                if index >= 1  {
                    let lbl = UILabel(frame: CGRect(x: index * buttonWidth, y: 0, width: 1, height: 50))
                    lbl.backgroundColor = UIColor.lightGray
                    self.addSubview(lbl)
                }
            }
        }
        else
        {
            if #available(iOS 11.0, *) {
                let bottomPadding : CGFloat = (window?.safeAreaInsets.bottom) ?? 0.0
                let fHeight = MAINSCREEN.height == 812 ? substractValue + bottomPadding : substractValue
                self.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)! - fHeight, width: UIScreen.main.bounds.size.width,height: substractValue)
            } else {
                // Fallback on earlier versions
                self.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-substractValue, width: (APP_DELEGATE.window?.frame.size.width)!,height: substractValue)
            }
            
            let productFooterView = Bundle.main.loadNibNamed("ReadyMadeAddToCart", owner: ReadyMadeAddToCart.self, options: nil)![0] as! ReadyMadeAddToCart
            if buttonTitle == TITLE.addToCart.localized{
                productFooterView.addToCartImageView.isHidden = false
            }else{
                productFooterView.addToCartImageView.isHidden = true
            }
            productFooterView.addToCartLbl.text = buttonTitle.uppercased()
            productFooterView.addToCartBtn.touchUp = { button in
                button.tag = 12
                self.delegate?.onClickBottomButton(button: button)
            }
            
            self.addSubview(productFooterView)
        }
    }
    
    @objc func buttonPressed(_ sender: AnyObject) {
        self.delegate?.onClickBottomButton(button: sender as! UIButton)
    }
}
