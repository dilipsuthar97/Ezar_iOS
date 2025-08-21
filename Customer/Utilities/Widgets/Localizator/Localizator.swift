
//
//  Localizator.swift
//  GIS-Agent
//
//  Created by Akshaykumar Maldhure on 8/7/17.
//  Copyright © 2017 GIS-Agent. All rights reserved.
//


import Foundation

class Localizator {
    
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary = NSDictionary()
    
    func readFile() -> NSDictionary
    {
        var dic = NSDictionary()
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            let plistFile = directoryContents.filter{ $0.pathExtension == "plist" }
            if plistFile.count > 0
            {
               dic = NSDictionary.init(contentsOf: plistFile[0]) ?? NSDictionary()
            }
        } catch {
            print(error.localizedDescription)
        }
        return dic
    }
    
    func changeTheValueOflocalizableDictionary()
    {
        self.localizableDictionary = {
            return returnLocalizeDictionary()
        }()
        
        /** -- -- UnComment When CSV files are Ready --
         self.localizableDictionary = {
            let dic = readFile()
            if dic.count > 0
            {
                return dic
            }
            else
            {
                return returnLocalizeDictionary()
            }
        }()
        **/
    }
    
    func localize(string: String) -> String {
        
        guard let localizedString =  localizableDictionary.value(forKey: string) as? String else {
            print("Missing translation for: \(string)")
            return ""
        }
        return localizedString
        
       /****** -- UnComment When CSV files are Ready --
       // print("***********Localization Key - \(string) ************")
        guard let localizedString = localizableDictionary.value(forKey: string) as? String else {
            let dic = returnLocalizeDictionary()
            guard let localizedString = dic.value(forKey: string) as? String else {
              //  print("***********Localization Value - \("") ************")
                return ""
            }
          //  print("***********Localization Value - \(localizedString) ************")
            return localizedString
        }
       // print("***********Localization Value - \(localizedString) ************")
        return localizedString
         ******/
    }
    
    func returnLocalizeDictionary() -> NSDictionary
    {
        var dic : NSDictionary = NSDictionary()
        let currntLanguage = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar"
        if let path = Bundle.main.path(forResource: currntLanguage, ofType: "lproj") {
            dic = NSDictionary(contentsOfFile: path + "/Localizable.plist") ?? NSDictionary()
        }
        return dic
    }
}
