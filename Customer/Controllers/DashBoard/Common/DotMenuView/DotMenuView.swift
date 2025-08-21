//
//  DotMenuView.swift
//  Customer
//
//  Created by webwerks on 4/30/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup
protocol DotMenuViewDelegate{
    
    func onClickCloseInfoBtn()
    func getGenderSelectionAction(isFemale : Bool)
    func getProductTypeSelectionAction(isCustomMade : Bool)
    func getLanguageSelectionAction(isArabic : Bool)
}

class DotMenuView: UIView {
    
    var delegate: DotMenuViewDelegate? = nil
    
    @IBOutlet weak var languageImgView: UIImageView!
    @IBOutlet weak var genderImgView: UIImageView!
    @IBOutlet weak var rcMadeImgView: UIImageView!
    
    
    @IBOutlet weak var englishBtnAction: ActionButton!
    @IBOutlet weak var arabicBtnAction: ActionButton!
    @IBOutlet weak var maleBtnAction: ActionButton!
    @IBOutlet weak var femaleBtnAction: ActionButton!
    @IBOutlet weak var readyMadeBtnAction: ActionButton!
    @IBOutlet weak var customMadeBtnAction: ActionButton!
    
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var readymadeLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var customLbl: UILabel!
    
    //MARK : View
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.frame = CGRect(x: 0, y: 0, width: MAINSCREEN.width, height: MAINSCREEN.height)
        
        self.englishLabel.text = TITLE.English.localized
        self.arabicLabel.text = TITLE.Arabic.localized
        self.readymadeLbl.text = TITLE.customer_ready_made.localized
        self.customLbl.text = TITLE.customer_custom_made.localized
        
        self.femaleLbl.text = TITLE.customer_female.localized
        self.maleLbl.text = TITLE.customer_male.localized
        
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue{
           self.customLbl.textAlignment = .right
        }else{
            self.customLbl.textAlignment = .left
        }
        
        let isArabic : Bool = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? false : true
        let lImageName : String = isArabic ? "arab" : "english"
        self.languageImgView.image = UIImage.init(named: lImageName)?.imageFlippedForRightToLeftLayoutDirection()
        
        let isFemale : Bool = LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue ? false : true
        let gImageName : String = isFemale ? "female" : "male"
        self.genderImgView.image = UIImage.init(named: gImageName)?.imageFlippedForRightToLeftLayoutDirection()

        let isCustomMade : Bool = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue ? false : true
        let rcImageName : String = isCustomMade ? "custom" : "ready_made"
        self.rcMadeImgView.image = UIImage.init(named: rcImageName)?.imageFlippedForRightToLeftLayoutDirection()
        
        self.englishBtnAction.touchUp = { button in
            self.changeLanguage(isArabic: false)
        }
        
        self.arabicBtnAction.touchUp = { button in
            self.changeLanguage(isArabic: true)
        }
        
        self.readyMadeBtnAction.touchUp = { button in
            self.changeProductType(isCustomMade: false)
        }

        self.customMadeBtnAction.touchUp = { button in
           self.changeProductType(isCustomMade: true)
        }

        self.maleBtnAction.touchUp = { button in
            self.changeGenderSelection(isFemale: false)
        }

        self.femaleBtnAction.touchUp = { button in
            self.changeGenderSelection(isFemale: true)
        }
    }
    
    func changeProductType(isCustomMade : Bool)
    {
        LocalDataManager.setUserSelection(isCustomMade ? ProductType.CustomMade.rawValue : ProductType.ReadyMade.rawValue)
        self.delegate?.getProductTypeSelectionAction(isCustomMade: isCustomMade)
    }
    
    func changeGenderSelection(isFemale : Bool)
    {
        LocalDataManager.setGenderSelection(isFemale ? GenderSelection.WOMEN.rawValue : GenderSelection.MEN.rawValue)
        self.delegate?.getGenderSelectionAction(isFemale: isFemale)
    }
    
    func changeLanguage(isArabic : Bool)
    {
        COMMON_SETTING.lang = isArabic ? "ar" : "en"
        LocalDataManager.setSelectedLanguage(isArabic ? LanguageSelection.ARABIC.rawValue : LanguageSelection.ENGLISH.rawValue)
        self.delegate?.getLanguageSelectionAction(isArabic: isArabic)
    }
}
