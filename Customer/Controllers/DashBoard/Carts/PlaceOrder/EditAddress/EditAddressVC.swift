//
//  EditAddressVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 12/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker
import STPopup

class EditAddressVC: BaseViewController,CLLocationManagerDelegate {

    //MARK -- Required VAriable
    var bottomView = ContainerView()
    @IBOutlet weak var tableView: UITableView!
    var footerView : UIView!
    
    var nameTxtField : UITextField?
    var addressTxtField : UITextField?
    var streetTxtField : UITextField?
    var postCodeTxtField : UITextField?
    var cityTxtField : UITextField?
    var stateTxtField : UITextField?
    var countryTxtField : UITextField?
    var contactNumberTxtField : UITextField?
    var addressTypeTxtField : UITextField?
    var countryCodeTxtField : UITextField?
    
    var instructionTxtView : UITextView = UITextView()
    
    var viewModel : EditAddressViewModel = EditAddressViewModel()
    var broadCastViewModel : BroadCastViewModel = BroadCastViewModel()
    var request_instruction : RequestInstruction?
    
    let picker = Picker()
    let countryPicker = Picker()
    let typePicker = Picker()
    let countryCode = CountryCode.init(isContryCode: false)
    let addressTypePicker = [TITLE.Home.localized,TITLE.office.localized,TITLE.other.localized]
    var isRequestDelegate : Bool = false
    var isFromPlaceorder : Bool = false
    var lat : String = ""
    var long  : String = ""
    var productID : String = ""
    var quoteID : String = ""
    var customerAddress : String = ""
    let selectedCountryCode = CountryCode.init(isContryCode: true)
    var isfromBroadCast : Bool?
    var autocompleteController = GMSAutocompleteViewController()
   // var isFromSellerDetail = false
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryCodeTxtField?.delegate = self
        configUI()
        setUpLocation()
        customBottonBar()
        setUpTableView()
        if !isRequestDelegate{
           // getPlacePickerView()
          //  getPlacesInAuToComplete()
            customPlacesVcPresent()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customBottonBar()
        setUpTableView()
        setUpLocation()
    }
    func setUpLocation(){
        LocationGetter.sharedInstance.initLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            LocationGetter.sharedInstance.startUpdatingLocation()
        }
        LocationGetter.sharedInstance.delegate = self

    }
    func configUI() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.Address.localized
        
        let profile = Profile.loadProfile()
        if let name = profile?.name{
            self.viewModel.name = name
        }
       
        if let countrycode = profile?.country_code{
            self.viewModel.countryCode = countrycode
        }
        
        if let mobile = profile?.mobileNo{
            self.viewModel.contactNumber = mobile
        }
    
        if request_instruction != nil{
            self.viewModel.name = (request_instruction?.location_name) ?? ""
            self.viewModel.contactNumber = (request_instruction?.mobileNumber) ?? ""
            self.viewModel.instruction = (request_instruction?.instructions) ?? ""
            self.viewModel.addressType = (request_instruction?.location_type) ?? ""
           
        }
        
        self.countryPicker.setPickerView(with: self.countryCode.countryCodes, status: true, selectedItem: { (option, row) in
            self.countryTxtField?.text = (self.countryCode.countryCodes[row])
            self.viewModel.country = self.countryTxtField?.text ?? ""
        })
        
        self.typePicker.setPickerView(with: self.addressTypePicker, status: true, selectedItem: { (option, row) in
            self.addressTypeTxtField?.text = (self.addressTypePicker[row])
            self.viewModel.addressType = self.addressTypeTxtField?.text ?? ""
        })

        self.picker.setPickerView(with: self.selectedCountryCode.countryCodes, status: true, selectedItem: { (option, row) in
            self.countryCodeTxtField?.text = (self.selectedCountryCode.countryCodes[row])
            let detail = self.selectedCountryCode.countryCodeArray[row]
            self.viewModel.countryCode = detail["dial_code"] ?? ""
        })
        
 
        if isFromPlaceorder{
        if let countrycode = profile?.country_code{
            self.viewModel.countryCode = countrycode
        }
        
        if let mobile = profile?.mobileNo{
            self.viewModel.contactNumber = mobile
        }
        }else{
        if !self.viewModel.requestDelegateModel.countryCode.isEmpty{
            self.viewModel.countryCode = self.viewModel.requestDelegateModel.countryCode
            }
        }
    }
    
    //MARK:- Setup bottom Bar
    func customBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.SAVE.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 10, y: (APP_DELEGATE.window?.frame.size.height)!-90, width: (APP_DELEGATE.window?.frame.size.width)!,height: 55)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    //MARK:- Helper to set up TableView
    func setUpTableView()
    {
        tableView.register(UINib(nibName: EditAddressCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: EditAddressCell.cellIdentifier())
        
        tableView.register(UINib(nibName: ContactCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ContactCell.cellIdentifier())
        
        tableView.register(UINib(nibName: DeliveryInstructionCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: DeliveryInstructionCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK:- Custom Bottom Bar Delegate Method
extension EditAddressVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.editAddressFieldList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.cellIdentifier(), for: indexPath) as! ContactCell
            let entryString = self.viewModel.editAddressFieldList[indexPath.row]
            cell.contactLbl.text = TITLE.ContactNumber.localized
            cell.contactTextField.text = entryString
            cell.contactTextField.placeholder = entryString
            cell.contactTextField.tag = indexPath.row
            cell.contactTextField.delegate = self
            cell.codeTextField.inputView = picker
            cell.codeTextField.delegate = self
            cell.codeTextField.addToolBar()
            cell.codeTextField.tag = indexPath.row
            countryCodeTxtField = cell.codeTextField
            cell.codeTextField.text = self.viewModel.countryCode

            self.valueOfCell(cell.contactTextField, importantLbl: cell.importantLbl)
            
            return cell
        }
        if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryInstructionCell.cellIdentifier(), for: indexPath) as! DeliveryInstructionCell
            cell.inputTextView.delegate = self
            cell.inputTextView.tag = indexPath.row
            cell.inputTextView.text = self.viewModel.instruction
            instructionTxtView = cell.inputTextView
            if isFromPlaceorder{
            self.viewForFooterInTableView()
            }
            return cell
        }
       
        let cell = tableView.dequeueReusableCell(withIdentifier: EditAddressCell.cellIdentifier(), for: indexPath) as! EditAddressCell
       // cell.inputTextField.textColor = .black
//        cell.inputTextField.placeHolderColor = Theme.lightGray
        let entryString = self.viewModel.editAddressFieldList[indexPath.row]
        cell.textFiledName.text = entryString
        cell.inputTextField.placeholder = entryString
        cell.inputTextField.tag = indexPath.row
        cell.inputTextField.delegate = self
        cell.importantLbl.isHidden = true
        cell.inputTextField.RightImage = (indexPath.row == 3 || indexPath.row == 5) ? UIImage.init(named: "downarrow") : UIImage.init(named: "")
        self.valueOfCell(cell.inputTextField, importantLbl: cell.importantLbl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 2 ? 195 : 82
    }
    
    func valueOfCell(_ textField: UITextField, importantLbl : UILabel) {
        
        COMMON_SETTING.getTextFieldAligment(textField: textField)
       
        switch textField.tag
        {
        case 0:
            textField.text = self.viewModel.name
            nameTxtField = textField
            if isRequestDelegate{
                importantLbl.isHidden = true
            }else{
                importantLbl.isHidden = false
            }
            
            break
        case 1:
            textField.addToolBar()
            
            textField.text = self.viewModel.contactNumber
            contactNumberTxtField = textField
//            if isRequestDelegate{
//                importantLbl.isHidden = true
//            }else{
                importantLbl.isHidden = false
//            }
            break
        //case 2: This is for Instruction TextView
        case 3:
            textField.addToolBar()
            textField.text = self.viewModel.addressType
            addressTypeTxtField = textField
            break
        case 4:
            textField.text = self.viewModel.state
            importantLbl.isHidden = false
            stateTxtField = textField
            break
        case 5:
            textField.addToolBar()
            textField.text = self.viewModel.country
            importantLbl.isHidden = false
            countryTxtField = textField
           // countryCodeTxtField = textField
            break
        case 6:
            textField.text = self.viewModel.address
            addressTxtField = textField
            break
        case 7:
            textField.text = self.viewModel.street
            streetTxtField = textField
            importantLbl.isHidden = true
            break
        case 8:
            textField.addToolBar()
            textField.text = self.viewModel.postCode
            postCodeTxtField = textField
            importantLbl.isHidden = false
            break
        case 9:
            textField.text = self.viewModel.city
            cityTxtField = textField
            importantLbl.isHidden = false
            break
        default:
            break
        }
    }
    
    
    
    func viewForFooterInTableView()
    {
        if self.footerView == nil
        {
            self.footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 10, height: 40))
            //  footerView.backgroundColor = UIColor.black
            COMMON_SETTING.configViewForRTL(view: self.footerView
            )
            let lButton = ActionButton(type: .custom)
            lButton.setImage(UIImage.init(named: "checkbox_unselected"), for: .normal)
            lButton.setTitleColor(Theme.white, for: .normal)
            lButton.setupAction()
            lButton.titleLabel?.font = UIFont.init(name: CustomFont.FuturanBook.rawValue, size: 16.0)
            lButton.layer.cornerRadius = 5
            lButton.backgroundColor = UIColor.clear
            lButton.frame = CGRect.init(x: 20, y: 10, width: 35, height: 35)
            lButton.sizeToFit()
            self.footerView.addSubview(lButton)
            COMMON_SETTING.setRTLforButton(button: lButton)
            
            lButton.touchUp = { button in
                if lButton.currentImage == UIImage.init(named: "checkbox_unselected")
                {
                    lButton.setImage(UIImage.init(named: "checkbox_selected"), for: .normal)
                    self.viewModel.isDefaultAddress = 1
                }
                else
                {
                    lButton.setImage(UIImage.init(named: "checkbox_unselected"), for: .normal)
                    self.viewModel.isDefaultAddress = 0
                }
            }
            
            
            let defaultLabel = UILabel.init(frame: CGRect(x: lButton.frame.origin.x + lButton.frame.size.width + 10, y: 0, width: 150, height: 40))
            defaultLabel.textColor = Theme.navBarColor
             COMMON_SETTING.setRTLforLabel(label: defaultLabel)
//
//            let isArabic : Bool = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? false : true
//            defaultLabel.textAlignment = isArabic ? .right : .left

            if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
                defaultLabel.textAlignment = .right
            }else{
                defaultLabel.textAlignment = .left
            }
            
            defaultLabel.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 13)
            defaultLabel.text = TITLE.customer_default_address.localized
            self.footerView.addSubview(defaultLabel)
            self.tableView.tableFooterView = footerView
            
        }
    }
    
//    func getPlacePickerView() {
//
//        let config = GMSPlacePickerConfig(viewport: nil)
//        let placePicker = GMSPlacePickerViewController(config: config)
//        placePicker.delegate = self
//        present(placePicker, animated: false, completion: nil)
//    }
//
//    //MARK:-PlacesInAuToComplete
//    func getPlacesInAuToComplete(){
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
//    }
    
    //MARK:-customPlaces
    func customPlacesVcPresent(){
        let vc = CustomMapVC.loadFromNib()
        vc.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        vc.delegate = self
        vc.latitude =  self.latitude
        vc.longitude =  self.longitude
        
        let popupController = STPopupController.init(rootViewController: vc)
        popupController.transitionStyle = .fade
        popupController.containerView.backgroundColor = UIColor.clear
        popupController.backgroundView?.backgroundColor = Theme.lightGray
        popupController.backgroundView?.alpha = 0.8
        popupController.hidesCloseButton = true
        popupController.navigationBarHidden = true
        popupController.present(in: self)
    }
}

//MARK:- CustomMapVCDelegate
extension EditAddressVC : CustomMapVCDelegate{
    func getLocationData(_ lat: Double, _ long: Double, _ name: String?, _ address: String?) {
        self.dismiss(animated: true, completion: nil)
        
        self.viewModel.latitude =  String(describing: lat)
        self.viewModel.longitude = String(describing: long)
        
//        self.viewModel.address = String(format: "%@", name ?? "")
//        self.viewModel.postCode = String(format: "%@", name ?? "")
//        self.viewModel.street = String(format: "%@", address ?? "")
//        self.viewModel.city = String(format: "%@", name ?? "")
//        self.viewModel.state = String(format: "%@", name ?? "")
//        self.viewModel.country = String(format: "%@", name ?? "")
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // postalCode
            if let postalCode = placeMark.postalCode  {
                print(postalCode)
                self.viewModel.postCode = postalCode
            }
            
            // Location name
//            if let locationName = placeMark.name  {
//                print(locationName)
//                self.viewModel.address = locationName
//            }
            print(name ?? "" , address ?? "")
            self.viewModel.address = (name ?? "") + (address ?? "")
            
            
            //State
            if let state = placeMark.administrativeArea {
                print(state)
                self.viewModel.state = state
            }
            
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
                self.viewModel.street = street
            }
            
            //city
            if let city = placeMark.locality {
                print(city)
                self.viewModel.city = city
            }
            
            // Country
            if let country = placeMark.country {
                print(country)
                self.viewModel.country = country
            }
            
            if self.viewModel.state.isEmpty
            {
                self.viewModel.editAddressFieldList.append(TITLE.State.localized)
            }
            if self.viewModel.country.isEmpty
            {
                self.viewModel.editAddressFieldList.append(TITLE.Country.localized)
            }
            self.tableView.reloadData()
        })
        
       
    }
}

//extension EditAddressVC : GMSPlacePickerViewControllerDelegate
//{
//    // GMSPlacePickerViewControllerDelegate and implement this code.
//    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
//
//        viewController.dismiss(animated: true, completion: nil)
//
//        self.viewModel.latitude =  String(describing: place.coordinate.latitude)
//
//        self.viewModel.longitude = String(describing: place.coordinate.longitude)
//
//        self.viewModel.address = String(format: "%@", place.name ?? "")
//        self.viewModel.street = String(format: "%@", place.formattedAddress ?? "")
//
//
//       // self.viewModel.latitude = place.coordinate.latitude
//       // self.viewModel.longitude = place.coordinate.longitude
//
//        for component in place.addressComponents ?? []
//        {
//            if component.type.uppercased() == "LOCALITY" || component.type.uppercased() == "CITY"
//            {
//                self.viewModel.city = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.city, with: "")
//            }
//            else if component.type.uppercased() == "ADMINISTRATIVE_AREA_LEVEL_1"
//            {
//                self.viewModel.state = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.state, with: "")
//            }
//            else if component.type.uppercased() == "POSTAL_CODE"
//            {
//                self.viewModel.postCode = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.postCode, with: "")
//            }
//            else if component.type.uppercased() == "COUNTRY"
//            {
//                self.viewModel.country = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.country, with: "")
//            }
//            else if component.type.uppercased() == "NEIGHBORHOOD"
//            {
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: component.name, with: "")
//            }
//            else if component.type == "sublocality_level_3"
//            {
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: component.name, with: "")
//            }
//            else if component.type == "sublocality_level_2"
//            {
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: component.name, with: "")
//            }
//        }
//        self.viewModel.street = self.viewModel.street.replacingOccurrences(of: ",", with: "")
//
//        if self.viewModel.state.isEmpty
//        {
//            self.viewModel.editAddressFieldList.append(TITLE.State.localized)
//        }
//        if self.viewModel.country.isEmpty
//        {
//            self.viewModel.editAddressFieldList.append(TITLE.Country.localized)
//        }
//        tableView.reloadData()
//    }
//
//    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
//
//        viewController.dismiss(animated: true, completion: nil)
//    }
//}
//
////MARK:-GMSAutocompleteViewControllerDelegate
//extension EditAddressVC : GMSAutocompleteViewControllerDelegate{
//
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//
//        viewController.dismiss(animated: true, completion: nil)
//
//        self.viewModel.latitude =  String(describing: place.coordinate.latitude)
//
//        self.viewModel.longitude = String(describing: place.coordinate.longitude)
//
//        self.viewModel.address = String(format: "%@", place.name ?? "")
//        self.viewModel.street = String(format: "%@", place.formattedAddress ?? "")
//
//
//        // self.viewModel.latitude = place.coordinate.latitude
//        // self.viewModel.longitude = place.coordinate.longitude
//
//        for component in place.addressComponents ?? []
//        {
//            if component.type.uppercased() == "LOCALITY" || component.type.uppercased() == "CITY"
//            {
//                self.viewModel.city = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.city, with: "")
//            }
//            else if component.type.uppercased() == "ADMINISTRATIVE_AREA_LEVEL_1"
//            {
//                self.viewModel.state = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.state, with: "")
//            }
//            else if component.type.uppercased() == "POSTAL_CODE"
//            {
//                self.viewModel.postCode = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.postCode, with: "")
//            }
//            else if component.type.uppercased() == "COUNTRY"
//            {
//                self.viewModel.country = component.name
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: self.viewModel.country, with: "")
//            }
//            else if component.type.uppercased() == "NEIGHBORHOOD"
//            {
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: component.name, with: "")
//            }
//            else if component.type == "sublocality_level_3"
//            {
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: component.name, with: "")
//            }
//            else if component.type == "sublocality_level_2"
//            {
//                self.viewModel.street = self.viewModel.street.replacingOccurrences(of: component.name, with: "")
//            }
//        }
//        self.viewModel.street = self.viewModel.street.replacingOccurrences(of: ",", with: "")
//
//        if self.viewModel.state.isEmpty
//        {
//            self.viewModel.editAddressFieldList.append(TITLE.State.localized)
//        }
//        if self.viewModel.country.isEmpty
//        {
//            self.viewModel.editAddressFieldList.append(TITLE.Country.localized)
//        }
//        tableView.reloadData()
//
//    }
//
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//    }
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        print(error.localizedDescription)
//    }
//}

//MARK:- LocationGetter Delegate Methods
extension EditAddressVC : LocationGetterDelegate {
    
    func didUpdateLocation(_ location: CLLocation) {
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
    }
    
}

//MARK:- UITextView Delegate Methods
extension EditAddressVC: UITextViewDelegate, UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag
        {
        case 0: //Name
            textField.keyboardType = .asciiCapable
            break
        case 1: //Contact Number
            if textField == contactNumberTxtField{
                if #available(iOS 10.0, *) {
                    textField.keyboardType = .asciiCapableNumberPad
                } else {
                    textField.keyboardType = .numberPad
                }
            }else{
                picker.backgroundColor = .white
                textField.inputView = picker
            }
            break
        case 3: //Location
            //textField.keyboardType = .asciiCapable
            typePicker.backgroundColor = .white
            textField.inputView = typePicker
            break
        case 4: //State
            textField.keyboardType = .asciiCapable
            break
        case 5: //Country
            //textField.keyboardType = .asciiCapable
            countryPicker.backgroundColor = .white
            textField.inputView = countryPicker
            break
        case 6: //Address
            textField.keyboardType = .asciiCapable
            break
        case 7: // Street
            textField.keyboardType = .asciiCapable
            break
        case 8: //PostCode
            if #available(iOS 10.0, *) {
                textField.keyboardType = .asciiCapableNumberPad
            } else {
                textField.keyboardType = .numberPad
            }
            break
        case 9: //City
            textField.keyboardType = .asciiCapable
            break
        default:
            break
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag
        {
        case 0:
            self.viewModel.name = newString
            break
        case 1:
            if textField == contactNumberTxtField{
//                if newString.count <= 10
//                {
                    self.viewModel.contactNumber = newString
                //}
                //return newString.count <= 10
            }else{
                 self.viewModel.countryCode = newString
            }
            
        case 3:
            self.viewModel.addressType = newString
            break
        case 4:
            self.viewModel.state = newString
            break
        case 5:
            self.viewModel.country = newString
            break
        case 6:
            self.viewModel.address = newString
            break
        case 7:
            self.viewModel.street = newString
            break
        case 8:
            if newString.count <= 6
            {
                self.viewModel.postCode = newString
            }
            return newString.count <= 6
        case 9:
            self.viewModel.city = newString
            break
        
        default:
            break
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryTxtField {
            if countryCode.countryCodes.count > 0 && self.countryTxtField?.text?.isEmpty ?? false {
                self.countryTxtField?.text = (self.countryCode.countryCodes[0])
                self.viewModel.country = self.countryTxtField?.text ?? ""
            }
        }
        else if textField == addressTypeTxtField {
            if addressTypePicker.count > 0 && self.addressTypeTxtField?.text?.isEmpty ?? false {
                self.addressTypeTxtField?.text = (self.addressTypePicker[0])
                self.viewModel.addressType = self.addressTypeTxtField?.text ?? ""
            }
        }
        else if textField == countryCodeTxtField  {
            if self.selectedCountryCode.countryCodes.count > 0 && self.countryCodeTxtField?.text?.isEmpty ?? false {
                
                self.countryCodeTxtField?.text = (self.selectedCountryCode.countryCodes[0])
                let detail = self.selectedCountryCode.countryCodeArray[0]
                self.viewModel.countryCode = detail["dial_code"] ?? ""
                
//                self.countryCodeTxtField?.text = (self.selectedCountryCode.countryCodes[0])
//                self.viewModel.countryCode = self.countryCodeTxtField?.text ?? ""
            }
        }
            
        else
        {
            textField.becomeFirstResponder()
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        instructionTxtView = textView
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        performAction(textField)
        return true
    }
    
    func performAction(_ textField: UITextField) {
        //action events
        let value = textField.tag + 1
        switch value
        {
        case 1:
            contactNumberTxtField?.becomeFirstResponder()
            break
        case 2:
            instructionTxtView.becomeFirstResponder()
            break
        case 3:
            addressTypeTxtField?.becomeFirstResponder()
            break
        case 4:
            stateTxtField?.becomeFirstResponder()
            break
        case 5:
            countryTxtField?.becomeFirstResponder()
            break
        case 6:
            addressTxtField?.becomeFirstResponder()
            break
        case 7:
            streetTxtField?.becomeFirstResponder()
            break
        case 8:
            postCodeTxtField?.becomeFirstResponder()
            break
        case 9:
            cityTxtField?.becomeFirstResponder()
            break
        default:
            stateTxtField?.becomeFirstResponder()
            break
        }
    }
}

//MARK:- Custom Bottom Bar Delegate Method
extension EditAddressVC : ButtonActionDelegate
{
    func onClickBottomButton(button: UIButton) {
        
        if self.viewModel.countryCode.isEmptyString()
        {
            INotifications.show(message: "\(MESSAGE.invalidName.localized) \(TITLE.countryCode.localized)")
            return
        }
            
        else if self.viewModel.contactNumber.isEmptyString()
        {
            INotifications.show(message: "\(MESSAGE.notEmpty.localized) \(TITLE.ContactNumber.localized.lowercased())")
            return
        }
        
        if self.isfromBroadCast == true{
   
            self.broadCastViewModel.mobileNumber = self.contactNumberTxtField?.text ?? ""
            self.broadCastViewModel.countryCode = self.countryCodeTxtField?.text ?? ""
            self.broadCastViewModel.latitude = self.lat
            self.broadCastViewModel.longitude = self.long
            self.broadCastViewModel.product_id = self.productID
            self.broadCastViewModel.quoteID = self.quoteID
            self.broadCastViewModel.address = self.customerAddress
             if request_instruction != nil{
                 self.broadCastViewModel.request_instruction = (request_instruction?.instructions) ?? ""
            }
     
            broadCastViewModel.getBroadCastList {
                if COMMON_SETTING.isFromSellerRequest == false{
                    INotifications.show(message: "your_request_has_been_sent".localized, type: .success)
                }
                self.setTabBarIndex(index: 2)
            }
        } else {
            let profile = Profile.loadProfile()
            self.viewModel.customer_id = profile?.id ?? 0
            self.viewModel.instruction = instructionTxtView.text ?? ""
            
            if isRequestDelegate
            {
                if self.viewModel.requestDelegateModel.request_id != 0 {
                    let vc = DelegateDetailVC.loadFromNib()
                    vc.viewModel.requestDelegateModel = self.viewModel.requestDelegateModel
                    vc.viewModel.requestDelegateModel.setRequestInformation(location_name: self.viewModel.name, location_type: self.viewModel.addressType, instructions: self.viewModel.instruction)
                    vc.viewModel.requestDelegateModel.countryCode = self.viewModel.countryCode
                    vc.viewModel.requestDelegateModel.mobile_number = self.viewModel.contactNumber
                    vc.viewModel.request_Id = self.viewModel.requestDelegateModel.request_id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    let vc = NearestDelegateVC.loadFromNib()
                    vc.viewModel.requestDelegateModel = self.viewModel.requestDelegateModel
                    vc.viewModel.requestDelegateModel.setRequestInformation(location_name: self.viewModel.name, location_type: self.viewModel.addressType, instructions: self.viewModel.instruction)
                    vc.viewModel.requestDelegateModel.countryCode = self.viewModel.countryCode
                    vc.viewModel.requestDelegateModel.mobile_number = self.viewModel.contactNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return
            }
            
            
            if self.viewModel.name.isEmptyString()
            {
                INotifications.show(message: "\(MESSAGE.invalidName.localized) \(TITLE.Name.localized)")
                return
            }
            else if self.viewModel.state.isEmptyString()
            {
                INotifications.show(message: "\(MESSAGE.invalidName.localized) \(TITLE.State.localized)")
                return
            }
                
            else if self.viewModel.country.isEmptyString()
            {
                INotifications.show(message: "\(MESSAGE.invalidName.localized) \(TITLE.Country.localized)")
                return
            }
            
            self.viewModel.getShippingMethods {
                let vc = ShippingMethodsVC.loadFromNib()
                vc.viewModel = self.viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension String {
    func isEmptyString() -> Bool {
        let regex = try! NSRegularExpression(pattern: ValidatorRegex.notEmpty.rawValue, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) == nil
    }
    
    func isInValidePhoneNumber() -> Bool
    {
        let regex = try! NSRegularExpression(pattern: ValidatorRegex.phone.rawValue, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) == nil
    }
}

//extension CLLocation {
//    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
//        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
//    }
    
    
//}
