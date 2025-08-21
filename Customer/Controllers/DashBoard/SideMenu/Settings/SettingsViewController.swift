//
//  SettingsViewController.swift
//  Customer
//
//  Created by webwerks on 15/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import SafariServices

class SettingsViewController: BaseTableViewController {
    
    //MARK: - Variable declaration
    var changePasswordView : ChangePasswordView!
    var changeLanguageView : ChangeLanguageView!
    var language : String = LanguageSelection.allValues[LocalDataManager.getSelectedLanguage() - 1]
    var settings = [TITLE.ChangePassword, TITLE.ChangeLanguage, TITLE.DeleteAccount]
    //[TITLE.ChangePassword, TITLE.ChangeLanguage,TITLE.EnableYourPushNotifications,TITLE.EnableYourGPSLocation]
    let viewModel : SettingsViewModel = SettingsViewModel()
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helpers for data & UI
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.Settings.localized
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: FilterTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: FilterTableViewCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
    }
    
    //MARK:- Button events
    
    @objc func switchValueChanged(_ sender: UISwitch){
        print(sender.tag)
    }
    
    func openDeleteAccountPage(){
        let profile = Profile.loadProfile()
        let params = "?id=\(profile?.id ?? 0)&xname=\(profile?.name ?? "")&token=\(keys.headerPassword)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://alnaseej.com.sa/en/delete?\(params)") {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
    }
}
//MARK:- TableView datasoruce & delegate methods

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.cellIdentifier(), for: indexPath) as! FilterTableViewCell
        cell.titleLbl?.textColor = Theme.darkGray
        cell.selectionStyle = .none
        cell.titleLbl?.text = settings[indexPath.row].localized
        
        switch indexPath.row {
            
        case 1:
            
            let accessoryTextFieldView = UITextField(frame: CGRect(x: 50, y: 0, width: (self.view.frame.size.width / 2), height: 20))
            accessoryTextFieldView.textColor = Theme.darkGray
            accessoryTextFieldView.delegate = self
            accessoryTextFieldView.tag = indexPath.row
           
            accessoryTextFieldView.autocorrectionType = .no
            accessoryTextFieldView.text = language.localized
            accessoryTextFieldView.rightViewMode = .always
            accessoryTextFieldView.rightView = UIImageView(image: UIImage(named: "downarrow"))
            accessoryTextFieldView.semanticContentAttribute = COMMON_SETTING.getRTLOrLTRAligment()
            accessoryTextFieldView.textAlignment = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? .right : .left
            accessoryTextFieldView.isEnabled = false
            cell.accessoryView = accessoryTextFieldView
            accessoryTextFieldView.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 14)
            return cell
            
        case 2:
            cell.titleLbl.textColor = .systemRed
            
//        case 2,3:
//
//            let switchView : UISwitch = UISwitch(frame: CGRect.zero)
//            switchView.addTarget(self, action: #selector(self.switchValueChanged), for: .valueChanged)
//            cell.accessoryView = switchView
//            switchView.tag = indexPath.row
//            let deviceToken = LocalDataManager.getDeviceToken()
//            if indexPath.row == 2
//            {
//                switchView.isOn = (!(deviceToken.isEmpty) && deviceToken != "")
//            }
            return cell
            
        default:
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            if !LocalDataManager.getIsSocialUser() {
                self.view.alpha = 0.4
                self.changePasswordView = Bundle.main.loadNibNamed("ChangePasswordView", owner: ChangePasswordView.self, options: nil)![0] as! ChangePasswordView
                self.changePasswordView.setUpUpdateButton()
                self.changePasswordView.setUpTableView()
                self.changePasswordView.delegate = self
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.removeChangePWView))
                tapGesture.cancelsTouchesInView = false
                tapGesture.delegate = self
                
                self.changePasswordView?.addGestureRecognizer(tapGesture)
                
                self.view.window?.addSubview(self.changePasswordView)
            }
            else{
                COMMON_SETTING.showAlertMessage(ERROR_MSG.InvalidAcess, message: TITLE.social_user_cant_change_password.localized, currentVC: self)
            }
        }
        else if indexPath.row == 1
        {
            // Do what you want
            self.view.alpha = 0.4
            self.changeLanguageView = Bundle.main.loadNibNamed("ChangeLanguageView", owner: changeLanguageView.self, options: nil)![0] as! ChangeLanguageView
            self.changeLanguageView.selectedIndex = self.language == TITLE.English.localized ? 0 : 1
            self.changeLanguageView.setUpUpdateButton()
            self.changeLanguageView.setUpTableView()
            self.changeLanguageView.delegate = self
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.removeChangeLView))
            tapGesture.cancelsTouchesInView = false
            tapGesture.delegate = self
            
            self.changeLanguageView?.addGestureRecognizer(tapGesture)
            
            self.view.window?.addSubview(self.changeLanguageView)
        } else if indexPath.row == 2 {
            
            let alert = UIAlertController(title: TITLE.DeleteAccount.localized, message: TITLE.DeleteAccountMsg.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: .default, handler: { _ in
                self.openDeleteAccountPage()
            }))
            alert.addAction(UIAlertAction(title: TITLE.no.localized, style: .cancel))
            present(alert, animated: true)
        }
    }
    
}

//MARK:- Change Password Delegate Method
extension SettingsViewController : ChangePasswordViewDelegate
{
    func onUpdateButtonClick(oldPassword: String, newPassword: String, email: String) {
        
        self.changePasswordWebService(oldPassword: oldPassword, newPassword: newPassword,email : email)
    }
}

//MARK:- Change Language Delegate Method
extension SettingsViewController : ChangeLanguageViewDelegate {
    func onUpdateButtonClick(selectedLanguage: Int) {
        self.view.alpha = 1.0
        self.changeLanguageView.removeFromSuperview()
        let languageStr = LanguageSelection.allValues[LocalDataManager.getSelectedLanguage() - 1]
        if self.language != languageStr {
            self.language = languageStr
            COMMON_SETTING.lang = languageStr == TITLE.English ? "en" : "ar"
            LocalDataManager.setSelectedLanguage(languageStr == TITLE.English ? LanguageSelection.ENGLISH.rawValue : LanguageSelection.ARABIC.rawValue)
            let isArabic = languageStr == TITLE.English ? false : true
            EzarApp.setLanguageRootViewController(isArabic: isArabic)
        }
    }
}

//MARK:- Textfield delegate methods
extension SettingsViewController : UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("begin textField")
        return true
    }
}

//MARK: Webservice call

extension SettingsViewController {
    
    func changePasswordWebService(oldPassword : String, newPassword : String,email : String){
        
        self.viewModel.email = email
        self.viewModel.old_password = oldPassword
        self.viewModel.new_password = newPassword
        
        self.viewModel.changePassword { (response) in
            
//            INotifications.show(message: response.message!)

            if !response.status! {
                INotifications.show(message: response.message!)
            }
                
            else{
                IProgessHUD.loaderSuccess(response.message!)
                self.removeChangePWView()
                self.navigationController?.popViewController(animated: true)
            }

        }

    }
    
    @objc func removeChangePWView() {
        self.view.alpha = 1.0
        self.changePasswordView?.removeFromSuperview()
    }
    
    @objc func removeChangeLView() {
        self.view.alpha = 1.0
        self.changeLanguageView?.removeFromSuperview()
    }
    
}

//MARK:- Tap gesture

extension SettingsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view === self.changePasswordView || touch.view === self.changeLanguageView {
            return true
        }
        return false
    }
}

