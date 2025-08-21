//
//  SelectSectionVC.swift
//  Customer
//
//  Created by webwerks on 3/20/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SelectSectionVC: BaseViewController {

    //Outlet
    @IBOutlet weak var readyMadeButton: ActionButton!
    @IBOutlet weak var customMadeButton: ActionButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var readyMadeImgView: UIImageView!
    @IBOutlet weak var customMadeImgView: UIImageView!
    @IBOutlet weak var selectedGenderLabel: UILabel!
    
    var rightTitle : GenderSelection = GenderSelection.MEN
    
    @IBOutlet weak var readyMadeLabel: UILabel!
    @IBOutlet weak var customizedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configUI()
    }
    
    func configUI() {
        
        setNavigationBarHidden(hide: false)
        setLeftButton()
        setRightBarButton(title: GenderSelection.allValues[rightTitle.rawValue - 1])

        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            
            let imageString = GenderSelection.allValues[rightTitle.rawValue - 1].lowercased() == "customer_women" ? "Women_ar" : "Men_arabic"
            
            let readyMadeImg = GenderSelection.allValues[rightTitle.rawValue - 1].lowercased() == "customer_women" ? "women_ready_made_ar" : "men_ready_made_arabic"
            
            let customMadeImg = GenderSelection.allValues[rightTitle.rawValue - 1].lowercased() == "customer_women" ? "Women_custom_made_ar" : "men_custom_made_arabic"
            
            self.selectedImageView.image = UIImage.init(named: imageString)
            self.readyMadeImgView.image = UIImage.init(named: readyMadeImg)
            self.customMadeImgView.image = UIImage.init(named: customMadeImg)
        }else{
            let imageString = GenderSelection.allValues[rightTitle.rawValue - 1].lowercased() == "customer_women" ? "Women" : "Men"
            
             let readyMadeImg = GenderSelection.allValues[rightTitle.rawValue - 1].lowercased() == "customer_women" ? "Women_ready_made" : "men_ready_made"
            
            let customMadeImg = GenderSelection.allValues[rightTitle.rawValue - 1].lowercased() == "customer_women" ? "Women_custom_made" : "men_custom_made"
            
            self.selectedImageView.image = UIImage.init(named: imageString)
            self.readyMadeImgView.image = UIImage.init(named: readyMadeImg)
            self.customMadeImgView.image = UIImage.init(named: customMadeImg)
        }
        

//        self.selectedGenderLabel.text = GenderSelection.allValues[rightTitle.rawValue - 1].localized
        
//        readyMadeLabel.text = TITLE.customer_ready_made.localized
//        customizedLabel.text = TITLE.customer_customized.localized
        
        readyMadeButton.touchUp = { button in
            self.navigateToViewController(title: self.rightTitle, tag: button.tag)
        }
        
        customMadeButton.touchUp = { button in
            self.navigateToViewController(title: self.rightTitle , tag: button.tag)
        }
    }
    
    func navigateToViewController(title: GenderSelection, tag: Int) {
        if tag == 0 {
            LocalDataManager.setUserSelection(ProductType.ReadyMade.rawValue)
        } else {
            LocalDataManager.setUserSelection(ProductType.CustomMade.rawValue)
        }
        APP_DELEGATE.setHomeView()
    }
}
