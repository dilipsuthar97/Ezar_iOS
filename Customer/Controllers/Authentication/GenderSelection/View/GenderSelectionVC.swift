//
//  GenderSelectionVC.swift
//  Customer
//
//  Created by webwerks on 3/20/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class GenderSelectionVC: BaseViewController {

    //Outlet
    @IBOutlet weak var womenButton: ActionButton!
    @IBOutlet weak var menButton: ActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        if !(LocalDataManager.getGuestUser()){
           registerDeviceTokenForNotification()
        }
    }
    
    func registerDeviceTokenForNotification() {
        if !LocalDataManager.getDeviceTokenRegister() {
            let viewmodel = GenderSelectionViewModel()
            viewmodel.getRegisterDeviceToken {
                print("Check For Success or Failure")
            }
        }
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        setBackButton()
        navigationItem.title = TITLE.SelectGender.localized
        
        womenButton.touchUp = { button in
            self.navigateToViewController(title: TITLE.Women.localized, sender : button)
        }
        
        menButton.touchUp = { button in
            self.navigateToViewController(title: TITLE.Men.localized, sender : button)
        }
    }
    
    func navigateToViewController(title : String, sender : UIButton) {
        LocalDataManager.setSelectedLanguage(LocalDataManager.getSelectedLanguage())
        if sender.tag == 0 {
            LocalDataManager.setGenderSelection(GenderSelection.WOMEN.rawValue)
        } else {
            LocalDataManager.setGenderSelection(GenderSelection.MEN.rawValue)
        }
        
        if LocalDataManager.getProductTypeSelectionFlag() == 1 {
            let vc = SelectSectionVC.loadFromNib()
            vc.rightTitle = title == TITLE.Men.localized ? GenderSelection.MEN : GenderSelection.WOMEN
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            LocalDataManager.setUserSelection(ProductType.CustomMade.rawValue)
            APP_DELEGATE.setHomeView()            
        }
    }
    
    override func onClickLeftButton(button: UIButton) {
        Profile.removeProfile()
        LocalDataManager.setDeviceTokenRegister(false)
        self.navigationController?.popViewController(animated: true)
    }
}
