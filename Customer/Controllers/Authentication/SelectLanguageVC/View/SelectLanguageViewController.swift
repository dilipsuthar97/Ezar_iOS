//
//  SelectLanguageViewController.swift
//  Customer
//
//  Created by Shruti Gupta on 1/11/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class SelectLanguageViewController: UIViewController {
    
    //MARK: Variable Declaration
    @IBOutlet weak var englishButton: ActionButton!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var arabicButton: ActionButton!
    
    //MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()

    }
    
    func configUI() {
        setNavigationBarHidden(hide: true)
        self.englishButton.setTitle(TITLE.English.localized, for: .normal)
        self.arabicButton.setTitle(TITLE.Arabic.localized, for: .normal)//.setTitle(TITLE.Arabic.localized.uppercased(), for: .normal)
        self.languageLbl.text = TITLE.customer_selectLanguage.localized
        englishButton.isSelected = false
        arabicButton.isSelected = true
        
    }
    
    @IBAction func langSelectionBtn(sender : UIButton) {
       
        if  sender == englishButton {
            englishButton.isSelected = true
            arabicButton.isSelected = false
            englishButton.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
            englishButton.layer.borderWidth = 1
            arabicButton.layer.borderColor = UIColor.clear.cgColor
            arabicButton.layer.borderWidth = 0
        
        } else if sender == arabicButton {
            englishButton.isSelected = false
            arabicButton.isSelected = true
            englishButton.layer.borderColor = UIColor.clear.cgColor
            englishButton.layer.borderWidth = 0
            arabicButton.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
            arabicButton.layer.borderWidth = 1
        }
    }
    
    @IBAction func confirmBtnAction(sender : UIButton) {
        
        if englishButton.isSelected {
            COMMON_SETTING.lang =  "en"
            LocalDataManager.setSelectedLanguage(LanguageSelection.ENGLISH.rawValue)
            EzarApp.setLanguageRootViewController(isArabic: false)
            EzarApp.setRootViewController(type: OnboardingsViewController.self)
        } else {
            COMMON_SETTING.lang =  "ar"
            LocalDataManager.setSelectedLanguage(LanguageSelection.ARABIC.rawValue)
            EzarApp.setLanguageRootViewController(isArabic: true)
            EzarApp.setRootViewController(type: OnboardingsViewController.self)
        }
    }
}
