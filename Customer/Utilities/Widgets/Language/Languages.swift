//
//  Languages.swift
//  Languages
//
//  Created by AA on 10/9/16.
//  Copyright © 2016 AA. All rights reserved.
//

import Foundation
class Language {

    class func currentLanguage() -> String {
        let def = UserDefaults.standard
        
        let langs = def.object(forKey: "AppleLanguages") as! NSArray
        let firstLang = langs.firstObject as! String
            
        return firstLang
    }
   // 40:13
    class func setAppleLanguage(_ lang:String) {
        let def = UserDefaults.standard
        
        def.set([lang, currentLanguage()], forKey: "AppleLanguages")
        def.synchronize()
    }    
}
