//
//  CountryCode.swift
//  Thoab App
//
//  Created by webwerks on 4/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class CountryCode: NSObject
{
    var countryCodeArray = [[String:String]]()
    var countryCodes = [String]()
    let fileName : String = "country_codes"
    
    init(isContryCode : Bool)
    {
        
        if let url = Bundle.main.url(forResource: self.fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let array = object as? NSArray {
                    for dictionary in array
                    {
                        if let dic : NSDictionary = dictionary as? NSDictionary {
                            self.countryCodeArray.append([dic.allKeys[0] as! String : dic.allValues[0] as! String, dic.allKeys[1] as! String : dic.allValues[1] as! String, dic.allKeys[2] as! String : dic.allValues[2] as! String])
                            
                            
                            let dial_Code : String? = dic["dial_code"] as? String ?? ""
                            let countryCode : String? = dic["code"] as? String ?? ""
                            let countryName : String? = dic["name"] as? String ?? ""
                            let dialCode_C_Code : String = isContryCode ? dial_Code! + " " + countryCode! : countryName!
                            if dial_Code == "+966"
                            {
                            self.countryCodes.insert(dialCode_C_Code, at: 0)
                               
                               self.countryCodeArray.insert([dic.allKeys[0] as! String : dic.allValues[0] as! String, dic.allKeys[1] as! String : dic.allValues[1] as! String, dic.allKeys[2] as! String : dic.allValues[2] as! String], at: 0)
                              
                            }
                            self.countryCodes.append(dialCode_C_Code)
                            
                        }
                    }
                    
                }
            } catch {
                print("Error!! Unable to parse  \(self.fileName).json")
            }
        }
    }
}
