 //
//  Localizer.swift
//  Languages
//
//  Created by AA on 9/26/16.
//  Copyright © 2016 AA. All rights reserved.
//

import UIKit
//Foundation

class Localizer {
    class func DoTheExchange() {
        ExchangeMethodsForClass(Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.customLocalizedStringForkey(_:value:table:)))
        
        ExchangeMethodsForClass(UIApplication.self, originalSelector:
            #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector:
            #selector(getter: UIApplication.Custom_UIUserInterfaceLayoutDirection))
    }
}

extension Bundle {
    @objc func customLocalizedStringForkey(_ key:String, value: String? , table tableName:String) -> String {
        
        let currntLanguage = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar"
     //   print(currntLanguage)
        var bundle = Bundle()
        
        if let path = Bundle.main.path(forResource: currntLanguage, ofType: "lproj") {
            bundle = Bundle(path:path)!
        } else {
            let path = Bundle.main.path(forResource: "Base", ofType:"lproj")!
            
            bundle = Bundle(path: path)!
        }
        
        return bundle.customLocalizedStringForkey(key, value: value, table: tableName)
    }
}

extension UIApplication {
    
    
    
    @objc var Custom_UIUserInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            
            if Language.currentLanguage() == "ar"{
                direction = .rightToLeft
            }
            
            return direction
        }
    }
}
//37:40

func ExchangeMethodsForClass(_ className:AnyClass, originalSelector: Selector,
                             overrideSelector:Selector) {
    
    print("class: \(className), or: \(originalSelector)")
    let originalMethod: Method = class_getInstanceMethod(className, originalSelector)!
    let overrideMethod: Method = class_getInstanceMethod(className, overrideSelector)!
    
    //33:9
    
    if class_addMethod(className, originalSelector,
                       method_getImplementation(overrideMethod),
                       method_getTypeEncoding(overrideMethod)) {
        class_replaceMethod(className, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod)
    }
    
}
