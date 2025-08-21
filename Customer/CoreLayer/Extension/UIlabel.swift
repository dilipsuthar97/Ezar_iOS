//
//  UIlabel.swift
//  Thoab App
//
//  Created by Arvind Valaki on 15/01/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func addAttributeText(text: String, textColor : UIColor, isUnderLine: Bool? = true) {
        let range = (self.text! as NSString).range(of: text)
        let attribute = NSMutableAttributedString.init(string: self.text!)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        if isUnderLine! {
            attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        self.attributedText = attribute
    }
    
    
    func set(html: String) {
        if let htmlData = html.data(using: .unicode) {
            do {
                let kattributedText = try NSAttributedString(data: htmlData,
                                                             options: [.documentType: NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil)
                let yourAttrStr = NSMutableAttributedString(attributedString: kattributedText)
                yourAttrStr.enumerateAttribute(.font, in: NSMakeRange(0, yourAttrStr.length), options: .init(rawValue: 0)){
                    (value, range, stop) in
                    let resizedFont = UIFont(name: "FuturaBT-Book", size: 15.0)
                    yourAttrStr.addAttribute(.font, value: resizedFont as Any, range: range)
                }
                self.attributedText = yourAttrStr
                
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
    
    func setHTML(html: String) {
        do {
            let attributedString: NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            self.attributedText = attributedString
        } catch {
            self.text = html
        }
    }
}


