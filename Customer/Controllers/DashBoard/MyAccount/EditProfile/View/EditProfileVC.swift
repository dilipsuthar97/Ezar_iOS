//
//  EditProfileVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 22/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class EditProfileVC: BaseViewController,CustomPickerControlllerDelegate,ButtonActionDelegate{

    @IBOutlet weak var nameTxtField: CustomTextField!
    @IBOutlet weak var cityTxtField: CustomTextField!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var contactTxtField: CustomTextField!
    @IBOutlet weak var countryTxtField: CustomTextField!
    @IBOutlet weak var dobTxtField: CustomTextField!
    @IBOutlet weak var codeTxt: CustomTextField!

    var bottomView = ContainerView()
    var customPicker : CustomImagePickerController!
    let picker = Picker()
    var datepicker = UIDatePicker()
    let formater = DateFormatter()
    let countryCode = CountryCode.init(isContryCode: true)
    var selectedCode : String = "+966"
    var viewModel : EditProfileViewModel = EditProfileViewModel()
  
    @IBOutlet weak var profileImgView: UIImageView!{
        didSet{
          profileImgView.layer.masksToBounds = true
            profileImgView.layer.cornerRadius = profileImgView.frame.width/2
            profileImgView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var editPicBtn: ActionButton!{
        didSet{
            editPicBtn.layer.masksToBounds = true
            editPicBtn.layer.cornerRadius = editPicBtn.frame.width/2
        }
    }
    
    //MARK : View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupValidations()
        customBottomBar()
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.editProfile.localized
        
        self.nameTxtField.placeholder = TITLE.Name.localized
        self.dobTxtField.placeholder = TITLE.customer_date_of_birth.localized
        self.emailTxtField.placeholder = TITLE.customer_email_address_star.localized
        self.codeTxt.placeholder = TITLE.countryCode.localized
        self.contactTxtField.placeholder = TITLE.phoneNumber.localized
        self.countryTxtField.placeholder = TITLE.Country.localized
            self.cityTxtField.placeholder = TITLE.City.localized
       
        self.contactTxtField.addToolBar()
        self.codeTxt.addToolBar()

        if countryCode.countryCodes.count > 0 {
            self.codeTxt.text = (self.countryCode.countryCodes[0])
        }
        
        picker.backgroundColor = .white
        codeTxt.inputView = picker
        
        self.picker.setPickerView(with: self.countryCode.countryCodes, status: true, selectedItem: { (option, row) in
            self.codeTxt.text = (self.countryCode.countryCodes[row])
            let detail = self.countryCode.countryCodeArray[row]
            self.selectedCode = detail["dial_code"] ?? "+966"
        })
        
        
        let profile = Profile.loadProfile()
       
        self.nameTxtField.text = profile?.name
        self.emailTxtField.text = profile?.email
        self.contactTxtField.text = profile?.mobileNo
        self.dobTxtField.text = profile?.dob
        self.cityTxtField.text = profile?.city
        self.countryTxtField.text = profile?.country
        self.codeTxt.text = profile?.country_code

        if let imageUrl = profile?.profileImg, !(imageUrl.isEmpty)
        {
            let imageUrlString = URL.init(string: imageUrl)
            self.profileImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder_user"), options: .continueInBackground, progress: nil, completed: nil)
        }
        
        //date picker
        formater.dateFormat = dateFormate
        
        self.dobTxtField.inputView = datepicker
        datepicker.backgroundColor = UIColor.white
        datepicker.datePickerMode = UIDatePicker.Mode.date
        datepicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: UIControl.Event.valueChanged)
        datepicker.maximumDate = Date()
        self.dobTxtField.addToolBarWithButton(title: TITLE.done.localized).touchUp = { button in
            self.dobTxtField.endEditing(true)
            self.dobTxtField.text = self.formater.string(from: self.datepicker.date)
        }
    }
    
    func customBottomBar(){
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.UPDATE.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    @objc func datePickerChanged(picker : UIDatePicker)  {
        self.dobTxtField.text = formater.string(from: picker.date)
    }
    
    func setupValidations() {
       
        emailTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.mail, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.Email.localized.lowercased(), EmptyMessage: MESSAGE.notEmpty.localized + TITLE.Email.localized.lowercased()))
        
//          contactTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.phone, ErrorMessage:  MESSAGE.invalidName.localized + TITLE.phoneNumber.localized, EmptyMessage: MESSAGE.invalidName.localized + TITLE.phoneNumber.localized))
        
         contactTxtField.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.notEmpty.localized + TITLE.phoneNumber.localized, EmptyMessage: MESSAGE.notEmpty.localized + TITLE.phoneNumber.localized))
        }
    
    func onClickBottomButton(button: UIButton) {
        if self.emailTxtField.isValid(){
            self.editProfileWebsevice()
        }
    }
    

    @IBAction func onClickEditPic(_ sender: Any) {
        
        customPicker = CustomImagePickerController()
        customPicker.delegate = self
        customPicker.openGalery(withController: self )
    }
    
    //Update Profile Picture
    func finishedWithSelectedImage(withImage: UIImage){
        self.profileImgView.image = withImage
    }
}

//MARK:- TextFieldDelegte Methods

extension EditProfileVC :UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == codeTxt {
            if countryCode.countryCodes.count > 0 {
                self.codeTxt.text = (self.countryCode.countryCodes[0])
            }
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.nextField == nil) {
            textField.resignFirstResponder()
        } else {
            textField.nextField?.becomeFirstResponder()
        }
        return true
    }
}

//MARK: Webservice Call

extension EditProfileVC {
  
    func editProfileWebsevice() {
        
        let profile = Profile.loadProfile()
        
        self.viewModel.name = self.nameTxtField.text!.trimmingCharacters()
        self.viewModel.customerId = profile?.id ?? 0
        self.viewModel.email = self.emailTxtField.text!.trimmingCharacters()
        self.viewModel.mobileNumber = self.contactTxtField.text!.trimmingCharacters()
        
       
        let dateValue = COMMON_SETTING.getDateFormString(withString: self.dobTxtField.text ?? "")
        let englishDateString = COMMON_SETTING.getEnglishStringDate(withDate: dateValue)
        
        self.viewModel.dateOfBirth = englishDateString//self.dobTxtField.text!.trimmingCharacters()
        
        
        self.viewModel.city = self.cityTxtField.text!.trimmingCharacters()
        self.viewModel.country = self.countryTxtField.text!.trimmingCharacters()
        self.viewModel.countryCode = selectedCode
        
        
        var images : [MultipartFile] = []
        if let image = self.profileImgView.image{
            let image = image.wxCompress(type: .session)
            images.append(MultipartFile(data: (image.png!), name: "profile_image"))
         }
        
        self.viewModel.profileImage = images
        self.viewModel.editProfileWS { }
    }
}
