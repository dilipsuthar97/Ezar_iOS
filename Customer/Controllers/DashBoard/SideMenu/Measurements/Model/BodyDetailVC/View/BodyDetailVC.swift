//
//  BodyDetailVC.swift
//  EZAR
//
//  Created by abc on 18/08/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit

class BodyDetailVC: BaseViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var heightTextField: CustomTextField!
    @IBOutlet weak var weightTextField: CustomTextField!
    @IBOutlet weak var nextButton: ActionButton!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    
    
    var viewModel : BodyFitViewModel = BodyFitViewModel()
    var name = ""
    var height = ""
    var weight = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameView.layer.cornerRadius = 22.5
        self.nameView.layer.masksToBounds = true
        
        self.heightView.layer.cornerRadius = 22.5
        self.heightView.layer.masksToBounds = true
        
        self.weightView.layer.cornerRadius = 22.5
        self.weightView.layer.masksToBounds = true
        
        let profile = Profile.loadProfile()
        name = profile?.name ?? ""

        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue {
            self.nameTextField.textAlignment = NSTextAlignment.left
            self.nameTextField.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            
            self.heightTextField.textAlignment = NSTextAlignment.left
            self.heightTextField.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            
            self.weightTextField.textAlignment = NSTextAlignment.left
            self.weightTextField.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            
//            self.nameTextField.LeftImage = UIImage(named: "UserName_Icon")
//            self.nameTextField.paddingLeft = 30
//            self.nameTextField.paddingRight = 5
//
//            self.heightTextField.LeftImage = UIImage(named: "dress")
//            self.heightTextField.paddingLeft = 30
//            self.heightTextField.paddingRight = 5
//
        } else {
            self.nameTextField.textAlignment = NSTextAlignment.right
            self.nameTextField.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            
            self.heightTextField.textAlignment = NSTextAlignment.right
            self.heightTextField.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            
            self.weightTextField.textAlignment = NSTextAlignment.right
            self.weightTextField.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            
//            self.nameTextField.RightImage = UIImage(named: "UserName_Icon")
//            self.nameTextField.paddingLeft = 5
//            self.nameTextField.paddingRight = 30
//
//            self.heightTextField.RightImage = UIImage(named: "dress")
//            self.heightTextField.paddingLeft = 5
//            self.heightTextField.paddingRight = 30
            
        }
        self.nameTextField.keyboardType = .asciiCapable
        self.heightTextField.addTarget(self, action: #selector(didChangeText(field:)), for: .editingChanged)
        self.weightTextField.addTarget(self, action: #selector(didChangeText(field:)), for: .editingChanged)
        

        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.MeasurementDetail.localized
        setLeftButton()

        heightTextField.addToolBar()
        nameTextField.placeholder = TITLE.customer_name_msg.localized
        heightTextField.placeholder =  TITLE.customer_height_msg.localized
        weightTextField.placeholder =  TITLE.customer_weight_msg.localized
        
        self.nameTextField.text = name
        self.heightTextField.text = height
        self.weightTextField.text = weight
        
        //self.topTitleLabel.text = TITLE.customer_body_detail_msg.localized
        self.nextButton.setTitle(TITLE.NEXT.localized.uppercased(), for: .normal)
        
        nextButton.touchUp = { button in
            if self.nameTextField.text != "" && self.heightTextField.text != "" && self.weightTextField.text != "" {
                COMMON_SETTING.name = self.nameTextField.text ?? ""
                COMMON_SETTING.bodyHeight = self.heightTextField?.text ?? "0"
                COMMON_SETTING.bodyWeight = self.weightTextField?.text ?? "0"
                self.apiCall()
                
            }else{
                INotifications.show(message: TITLE.customer_validation_msg.localized)
            }
        }
    }
    
    @objc func didChangeText(field: UITextField) {
        field.text = field.text?.replacingOccurrences(of: "١", with: "1")
        field.text = field.text?.replacingOccurrences(of: "٢", with: "2")
        field.text = field.text?.replacingOccurrences(of: "٣", with: "3")
        field.text = field.text?.replacingOccurrences(of: "٤", with: "4")
        field.text = field.text?.replacingOccurrences(of: "٥", with: "5")
        field.text = field.text?.replacingOccurrences(of: "٦", with: "6")
        field.text = field.text?.replacingOccurrences(of: "٧", with: "7")
        field.text = field.text?.replacingOccurrences(of: "٨", with: "8")
        field.text = field.text?.replacingOccurrences(of: "٩", with: "9")
        field.text = field.text?.replacingOccurrences(of: "٠", with: "0")
        field.text = field.text?.replacingOccurrences(of: "٫", with: ".")
    }
    
    func apiCall(){
        self.viewModel.getBodyFit {
            let vc = BodyFitVC.loadFromNib()
            vc.viewModel = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
//MARK:- TextFieldDelegte Methods

extension BodyDetailVC :UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.nextField == nil) {
            textField.resignFirstResponder()
        } else {
            textField.nextField?.becomeFirstResponder()
        }
        return true
    }
}
