//
//  MobileNumberPopupVC.swift
//  EZAR
//
//  Created by abc on 08/09/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit

class MobileNumberPopupVC: UIViewController {

    
    @IBOutlet weak var mobileTxt: CustomTextField!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var cancelButton: ActionButton!
    @IBOutlet weak var submitBtn: ActionButton!
    @IBOutlet weak var codeTxt: CustomTextField!
    
    var viewModel : EditProfileViewModel = EditProfileViewModel()
    
    let picker = Picker()
    let countryCode = CountryCode.init(isContryCode: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTxt.addToolBar()
        self.mobileLabel.text = TITLE.customer_mobile_number.localized
        self.submitBtn.setTitle(TITLE.Submit.localized.uppercased(), for: .normal)
        self.mobileTxt.placeholder =  TITLE.customer_mobile_number.localized
        self.codeTxt.placeholder = TITLE.Country.localized
        codeTxt.addToolBar()
        
        if countryCode.countryCodes.count > 0 {
            self.codeTxt.text = (self.countryCode.countryCodes[0])
        }
               
               picker.backgroundColor = .white
               codeTxt.inputView = picker
             
        self.picker.setPickerView(with: self.countryCode.countryCodes, status: true, selectedItem: { (option, row) in
            self.codeTxt.text = (self.countryCode.countryCodes[row])
        })
        
        submitBtn.touchUp = { button in
            if self.mobileTxt.text != "" && self.codeTxt.text != ""{
                self.editProfileWebsevice()
            }else{
             INotifications.show(message:MESSAGE.notEmpty.localized + TITLE.customer_mobile_number.localized )
            }
        }
    }

}

//MARK: Webservice Call

extension MobileNumberPopupVC {
  
    func editProfileWebsevice() {
        
        let profile = Profile.loadProfile()
        
        self.viewModel.name = profile?.name ?? ""
        self.viewModel.customerId = profile?.id ?? 0
        self.viewModel.email = profile?.email ?? ""
        self.viewModel.mobileNumber = self.mobileTxt.text ?? ""
        self.viewModel.dateOfBirth = profile?.dob ?? ""
        self.viewModel.city = profile?.city ?? ""
        self.viewModel.country = profile?.country ?? ""
        self.viewModel.countryCode = self.codeTxt.text ?? ""
        
        self.viewModel.profileImage = []
        self.viewModel.editProfileWS {
           // INotifications.show(message: "Account information updated successfully.")
           self.dismiss(animated: true, completion: nil)
        }
    }
}
