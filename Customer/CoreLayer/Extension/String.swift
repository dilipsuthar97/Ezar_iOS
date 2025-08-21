//
//  StringExtension.swift
//  GIS-Agent
//
//  Created by Akshaykumar Maldhure on 8/4/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//

import UIKit

extension String {
        
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height + 20
    }
    
    func stringByRemovingAll(characters: [Character]) -> String {
        return String(self.filter({ !characters.contains($0) }))
    }
    
    func trimmingCharacters() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces) 
    }
    
    func stringByRemovingAll(subStrings: [String]) -> String {
        var resultString = self
        _ = subStrings.map {
            resultString = resultString.replacingOccurrences(of: $0, with: "")
        }
        
        return resultString
    }
    
    
    func removeSpecialCharsFromString() -> String {
        
        let okayChars : Set<Character> =
            Set("1234567890")
        return String(self.trimmingCharacters().filter {okayChars.contains($0) })
    }
    
    func htmlAttributedString(fontSize: CGFloat = 12) -> NSAttributedString? {
        let fontName = UIFont.init(customFont: .ElMessiriR, withSize: 12)
        let string = self.appending(String(format: "<style>body{font-family: '%@'; font-size:%fpx;}</style>", fontName!, fontSize))
        guard let data = string.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        
        guard let html = try? NSMutableAttributedString (
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
  
    var localized: String {
        return Localizator.sharedInstance.localize(string: self)
    }
    
    var localizer: String {
        return NSLocalizedString(self, comment: "")
    }
    
    //Convert htmt into string
    func getStringFromHtml() -> String {
         return replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
}


extension String {
    var isNotEmpty: Bool {
        if self ==  "" {
            return false
        }
        
        if self.count > 0 {
            return true
        }
        
        return false
    }
    
    public subscript(safe index: Self.Index) -> Iterator.Element? {
        (startIndex ..< endIndex).contains(index) ? self[index] : nil
    }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

