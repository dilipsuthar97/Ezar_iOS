//
//  MyTailorMeasurementVC.swift
//  EZAR
//
//  Created by The Appineers on 22/02/23.
//  Copyright © 2023 Thoab App. All rights reserved.
//

import UIKit

class MyTailorMeasurementVC: BaseViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var detailTextViewPlaceHolderLbl: UILabel!
    @IBOutlet weak var saveButton: ActionButton!
    
    var viewModel : MyTailorMeasurementViewModel = MyTailorMeasurementViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        let userProfile = Profile.loadProfile()
        self.viewModel.customer_id = userProfile?.id ?? 0
        saveButton.touchUp = { button in
            if self.detailTextView.text != "" {
                self.viewModel.measurement_id = "0"
                self.viewModel.note = self.detailTextView.text
                self.updatePreviousMeasurementWS()
            } else {
                INotifications.show(message: TITLE.customer_tailor_details_validation_msg.localized)
            }
        }                        
        // Do any additional setup after loading the view.
    }

    func setUpUI() {
        detailTextView.delegate = self
        setLeftButton()
        self.navigationItem.title = TITLE.MyTailorDetail.localized
        
        self.topTitleLabel.text = TITLE.customer_tailor_measurement_title.localized
        self.detailTextViewPlaceHolderLbl.text = TITLE.customer_tailor_measurement_placeholder.localized
        self.saveButton.setTitle(TITLE.SAVE.localized.uppercased(), for: .normal)
//        self.title = "Previous Measurement"
        
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue {
            self.detailTextView.textAlignment = NSTextAlignment.left
            self.detailTextView.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            self.topTitleLabel.textAlignment = NSTextAlignment.left
            self.topTitleLabel.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
            self.detailTextViewPlaceHolderLbl.textAlignment = NSTextAlignment.left
            self.detailTextViewPlaceHolderLbl.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        } else {
            self.detailTextView.textAlignment = NSTextAlignment.right
            self.detailTextView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            self.topTitleLabel.textAlignment = NSTextAlignment.right
            self.topTitleLabel.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
            self.detailTextViewPlaceHolderLbl.textAlignment = NSTextAlignment.right
            self.detailTextViewPlaceHolderLbl.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        
    }
    
    func updatePreviousMeasurementWS() {
        
        self.viewModel.updateMeasurementForCartProduct {
            self.navigationController?.popViewController(animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//UITextfield delegate and set number of text count in textview
extension MyTailorMeasurementVC: UITextViewDelegate {
    
    /// Method is called when textview text changes
    ///
    /// - Parameter textView: TextView
    func textViewDidChange(_ textView: UITextView) {
        detailTextViewPlaceHolderLbl.isHidden = !detailTextView.text.isEmpty
    }
}
