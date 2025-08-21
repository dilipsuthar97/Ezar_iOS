//
//  ChangePasswordVC.swift
//  Customer
//
//  Created by webwerks on 4/9/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

protocol ChangePasswordViewDelegate
{
    func onUpdateButtonClick(oldPassword : String, newPassword : String, email : String)
}

class ChangePasswordView: UIView {

    //MARK:- Required Variable
    var delegate : ChangePasswordViewDelegate!
    @IBOutlet weak var tableView: UITableView!
    var bottomView = ContainerView()
    @IBOutlet weak var titleLabel: UILabel!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.frame = CGRect(x: 0, y: 0, width: MAINSCREEN.width, height: MAINSCREEN.height)
    }
    
    var txtFieldOldPassword : String = ""
    var txtFieldNewPassword : String = ""
    var txtFieldEmail : String = ""

    
    //MARK:- Helpers for data & UI
    func setUpUpdateButton()
    {
        var buttonArray : NSMutableArray = []
        buttonArray = [TITLE.UPDATE.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        
        self.bottomView.buttonArray = buttonArray
        self.addSubview(self.bottomView)
    }
   
    
    //MARK:- Helper to set up TableView
    func setUpTableView()
    {
        self.titleLabel.text = TITLE.ChangePassword.localized

        tableView.register(UINib(nibName: ChangePasswordCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ChangePasswordCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK:- TButton Action delegate method
extension ChangePasswordView : ButtonActionDelegate {
    func onClickBottomButton(button: UIButton)
    {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell: ChangePasswordCell = self.tableView.cellForRow(at: indexPath) as! ChangePasswordCell
        
        if cell.oldPasswordTxtField.isValid(), cell.newPasswordTxtField.isValid()
        {
            self.txtFieldOldPassword = cell.oldPasswordTxtField.text ?? ""
            self.txtFieldNewPassword = cell.newPasswordTxtField.text ?? ""
            self.txtFieldEmail = cell.emailTxtField.text ?? ""
            
            self.delegate.onUpdateButtonClick(oldPassword: self.txtFieldOldPassword, newPassword: self.txtFieldNewPassword, email: self.txtFieldEmail)
        }
    }
}

//MARK:- UITable Delegate & DataSource
extension ChangePasswordView : UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChangePasswordCell.cellIdentifier(), for: indexPath) as! ChangePasswordCell
        cell.selectionStyle = .none
        
        cell.oldPasswordTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased()))
     
        
        cell.newPasswordTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Password.localized.lowercased()))

        cell.newPasswordTxtField.add(validator: MinLengthValidator.init(validationEvent: ValidatorEvents.none, min : 6,ErrorMessage : MESSAGE.passwordLimit.localized))
        
        // cell.emailTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.mail, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Email.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Email.localized.lowercased()))
        
        cell.emailTxtField.isUserInteractionEnabled = false
        
        let profile = Profile.loadProfile()
        cell.emailTxtField.text = profile?.email
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
}
