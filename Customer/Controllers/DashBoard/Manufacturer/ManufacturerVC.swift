//
//  ManufacturerVC.swift
//  Customer
//
//  Created by webwerks on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlacePicker
import STPopup

class ManufacturerVC: BaseViewController, customToolBarDelegate {
    
    let viewModel : SearchViewModel = SearchViewModel()
    var homeViewModel : HomeRequestsViewModel = HomeRequestsViewModel()
    var selectedIndex : Int = 0
    var isPromotion : Bool = false
    var txtFieldDateReference : UITextField?
    var txtFieldThobe : UITextField?
    var txtFieldLocation: UITextField?
    var txtFieldQuantity: UITextField?
    var autocompleteController = GMSAutocompleteViewController()
    var locationName : String = ""
    let datePikcer:UIDatePicker = UIDatePicker()
    
    let categoryDropDown = DropDown()
    
    @IBOutlet weak var tableView: UITableView!

    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        categoryDropDown.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
        categoryDropDown.customCellConfiguration = nil
    }
    
    fileprivate enum SectionType {
        case ManufacturerSearchCriteria
        case ManufacturerAdvertiser
    }
    
    fileprivate struct Section {
        var type: SectionType
    }
    
    fileprivate var sections : [Section] = [
        Section(type: .ManufacturerSearchCriteria),
        Section(type: .ManufacturerAdvertiser)
    ]
    
    var latitude = CONSTANT.latitude
    var longitude = CONSTANT.longitude
    
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocation()
        setupUI()
        setupTableView()
        categoryDropDown.dismissMode = .onTap
        categoryDropDown.direction = .any
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setUpLocation(){
        LocationGetter.sharedInstance.initLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            LocationGetter.sharedInstance.startUpdatingLocation()
        }
        LocationGetter.sharedInstance.delegate = self
    }
    
    func setupCategoryDropDown(parentView : CustomTextField,productType : UILabel) {
        categoryDropDown.anchorView = parentView
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: parentView.bounds.height)
        if categoryDropDown.dataSource.count > 0 {
            categoryDropDown.dataSource.removeAll()
        }
        for model in homeViewModel.homeCategoryList?.categories ?? [] {
            categoryDropDown.dataSource.append(model.name)
        }
        
        // Action triggered on selection
        categoryDropDown.selectionAction = { [weak self] (index, item) in
             parentView.text = item
             productType.text = "Design your \(item.lowercased()) From Home"
            self?.viewModel.category_id = self?.homeViewModel.homeCategoryList?.categories[index].id ?? 0
            self?.selectedIndex = index
            self?.tableView.reloadSections(IndexSet(integersIn: 1...1), with: UITableView.RowAnimation.top)
        }
    }
        
    func setupUI(){
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.search_manufacturer.localized
        setLeftButton()
        
        COMMON_SETTING.max_capacity = Int(self.viewModel.max_capacity) ?? 15
        datePikcer.preferredDatePickerStyle = .wheels
        datePikcer.minimumDate = Date().third_DayFormToday
        datePikcer.datePickerMode = .date
        datePikcer.date = Date().third_DayFormToday
        datePikcer.locale = Locale.init(identifier: LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "en" : "ar")
        
    }
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: ManufacturerSearchCriteriaCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ManufacturerSearchCriteriaCell.cellIdentifier())
        tableView.register(UINib(nibName: ManufacturerAdvertiseCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ManufacturerAdvertiseCell.cellIdentifier())

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    @objc func showDatePicker() {
        
        datePikcer.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let rect = CGRect(x: 0, y: datePikcer.frame.origin.y, width: self.view.frame.size.width, height: 44)
        let toolBar =  CustomToolBar.sharedInstance().createToolbarframe(rect)
        CustomToolBar.sharedInstance().delegate = self
        txtFieldDateReference?.inputAccessoryView = toolBar
        txtFieldDateReference?.inputView=datePikcer
        txtFieldDateReference?.becomeFirstResponder()
        CustomToolBar.sharedInstance()?.done.setTitle(TITLE.done.localized, for: .normal)
    }
    
    @objc func datePickerValueChanged(sender: Any) -> Void {
        txtFieldDateReference?.text =  COMMON_SETTING.getStringDate(withDate: (sender as? UIDatePicker)!.date as Date? ?? Date())
        COMMON_SETTING.selectedDeliveryDate = txtFieldDateReference?.text ?? ""
    }
   
    func doneButtonPress() {
        if (self.txtFieldDateReference?.text?.isEmpty)!{
            txtFieldDateReference?.text =  COMMON_SETTING.getStringDate(withDate: Date().third_DayFormToday)
            
        }
        COMMON_SETTING.selectedDeliveryDate = txtFieldDateReference?.text ?? ""
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtFieldLocation?.resignFirstResponder()
    }
}

//MARK: - UITableViewDataSource

extension ManufacturerVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch sections[section].type {
        case .ManufacturerSearchCriteria :
            return 1
        case .ManufacturerAdvertiser :
            return self.homeViewModel.homeCategoryList?.categories.count ?? 0 > selectedIndex ? self.homeViewModel.homeCategoryList?.categories[selectedIndex].advertisement.count ?? 0 : 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section].type {
        case .ManufacturerSearchCriteria:
            
            let searchCriteriaCell = tableView.dequeueReusableCell(withIdentifier: ManufacturerSearchCriteriaCell.cellIdentifier(), for: indexPath) as! ManufacturerSearchCriteriaCell
            searchCriteriaCell.selectionStyle = .none
            if let profile = Profile.loadProfile(){
                searchCriteriaCell.lblUserName.text = "\(TITLE.Hello.localized) \(profile.name)".capitalized
            }
            searchCriteriaCell.txtFieldDeliveryDate.delegate = self
            searchCriteriaCell.txtFieldThoab.delegate = self
            searchCriteriaCell.txtFieldQuantity.delegate = self
            searchCriteriaCell.txtFieldLocation.delegate = self
            self.txtFieldThobe = searchCriteriaCell.txtFieldThoab
            self.txtFieldLocation = searchCriteriaCell.txtFieldLocation
            self.txtFieldDateReference = searchCriteriaCell.txtFieldDeliveryDate
            self.txtFieldDateReference?.text =  COMMON_SETTING.getStringDate(withDate: datePikcer.date)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showDatePicker))
            tapGesture.cancelsTouchesInView = false
            tapGesture.delegate = self
            searchCriteriaCell.txtFieldDeliveryDate.rightView?.addGestureRecognizer(tapGesture)
            searchCriteriaCell.txtFieldThoab.text = self.viewModel.categoryName
            searchCriteriaCell.lblproductType.text = "\(TITLE.customer_design_title.localized) \(self.viewModel.categoryName.lowercased()) \(TITLE.customer_properties.localized)"
            
            if !isPromotion {
                self.setupCategoryDropDown(parentView: searchCriteriaCell.txtFieldThoab,productType: searchCriteriaCell.lblproductType)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showCategoryList))
                tapGesture.cancelsTouchesInView = false
                tapGesture.delegate = self
                searchCriteriaCell.txtFieldThoab.addGestureRecognizer(tapGesture)
            }
            
            //Text Aligment For TextField
            COMMON_SETTING.getTextFieldAligment(textField: searchCriteriaCell.txtFieldThoab)
            COMMON_SETTING.getTextFieldAligment(textField: searchCriteriaCell.txtFieldDeliveryDate)
            COMMON_SETTING.getTextFieldAligment(textField: searchCriteriaCell.txtFieldQuantity)
            COMMON_SETTING.getTextFieldAligment(textField: searchCriteriaCell.txtFieldLocation)
            
            searchCriteriaCell.btnSearch.touchUp = { button in
                var qty  = Int(searchCriteriaCell.txtFieldQuantity.text ?? "0") ?? 0
                if LocalDataManager.getSelectedLanguage() != LanguageSelection.ENGLISH.rawValue {
                    qty = Int(searchCriteriaCell.txtFieldQuantity.text?.replacedArabicDigitsWithEnglish ?? "0") ?? 0
                }
                
                searchCriteriaCell.txtFieldQuantity.text = qty <= 0 ? "" : searchCriteriaCell.txtFieldQuantity.text
                if searchCriteriaCell.txtFieldThoab.isValid(), searchCriteriaCell.txtFieldDeliveryDate.isValid(), searchCriteriaCell.txtFieldQuantity.isValid()  {
                    if searchCriteriaCell.txtFieldLocation.text?.count != 0 {
                        self.view.endEditing(true)
                        IProgessHUD.show()
                        self.viewModel.delivery_date = searchCriteriaCell.txtFieldDeliveryDate.text ?? ""
                        self.viewModel.qty = qty
                        if LocalDataManager.getSelectedLanguage() != LanguageSelection.ENGLISH.rawValue {
                            let dateValue = COMMON_SETTING.getDateFormString(withString: searchCriteriaCell.txtFieldDeliveryDate.text ?? "")
                            let englishDateString = COMMON_SETTING.getEnglishStringDate(withDate: dateValue)
                            self.viewModel.delivery_date = englishDateString
                        }
                        
                        if self.viewModel.qty > Int(self.viewModel.max_capacity) ?? 15 {
                            INotifications.show(message: "\(TITLE.Max.localized) \(Int(self.viewModel.max_capacity) ?? 15) \(TITLE.Quantity.localized)")
                            return
                        }
                        self.searchWebservice()
                    } else {
                        INotifications.show(message: TITLE.customer_error_empty_location.localized)
                    }
                }
            }
            return searchCriteriaCell
            
        case .ManufacturerAdvertiser:
            let advertiseCell = tableView.dequeueReusableCell(withIdentifier: ManufacturerAdvertiseCell.cellIdentifier(), for: indexPath) as! ManufacturerAdvertiseCell
            advertiseCell.selectionStyle = .none
            advertiseCell.selectionStyle = .none
           
            let advertisementModel = self.homeViewModel.homeCategoryList?.categories[selectedIndex].advertisement[indexPath.row]
            let imageUrlString = URL.init(string: advertisementModel?.promotionImageUrl ?? "")
            advertiseCell.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "profile"), options: .continueInBackground, progress: nil, completed: nil)
            return advertiseCell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
        case .ManufacturerSearchCriteria :
            return UITableView.automaticDimension
        case .ManufacturerAdvertiser :
            return 220
        }
    }
    
    @objc func showCategoryList() {
        self.categoryDropDown.show()
    }
}

//MARK:- Tap gesture
extension ManufacturerVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}


//MARK:- UITextFieldDelegate
extension ManufacturerVC : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            self.txtFieldDateReference = textField
            self.showDatePicker()
        case 2:
            self.txtFieldQuantity = textField
        case 3:
            self.txtFieldLocation = textField
            customPlacesVcPresent()
            break
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.txtFieldQuantity?.resignFirstResponder()
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField.keyboardType == .numberPad && string != "" {
                let numberStr: String = string
                let formatter: NumberFormatter = NumberFormatter()
                formatter.locale = Locale(identifier: "EN")
                if let final = formatter.number(from: numberStr) {
                    textField.text =  "\(textField.text ?? "")\(final)"
                }
                return false
            }
            return true
        }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldThobe {            
            return false
        } else {
            return true
        }
    }
        
    func customPlacesVcPresent() {
        let vc = CustomMapVC.loadFromNib()
        vc.contentSizeInPopup = CGSize(width: self.view.frame.width, height:self.view.frame.height)
        vc.delegate = self
        vc.latitude = self.latitude
        vc.longitude = self.longitude
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
extension ManufacturerVC : CustomMapVCDelegate {
    func getLocationData(_ lat: Double, _ long: Double,
                         _ name: String?,
                         _ address: String?) {
        self.dismiss(animated: true, completion: nil)
        if address == "" {
            self.txtFieldLocation?.text = String(format: "%@", name ?? "")
        } else {
            self.txtFieldLocation?.text = String(format: "%@", address ?? "")
        }
        self.viewModel.latitude = lat
        self.viewModel.longitude = long
    }
}

//MARK: - LocationGetterDelegate
extension ManufacturerVC : LocationGetterDelegate {
    
    func didUpdateLocation(_ location: CLLocation) {
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        self.viewModel.latitude = location.coordinate.latitude
        self.viewModel.longitude = location.coordinate.longitude
        
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        location.fetchCityAndCountry { city, country, locality, pinCode, error  in
            guard let city = city, let country = country,let locality = locality,let pinCode = pinCode, error == nil else { return }
            print( city + ", " + locality + ", " + country)
            self.locationName = String(format: "%@ %@ %@ %@", city , locality ,country ,pinCode)
            
            if !self.locationName.isEmpty{
                 self.txtFieldLocation?.text = self.locationName
            }else{
                self.txtFieldLocation?.text = ""
            }
           
        }
        LocationGetter.sharedInstance.delegate = nil
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ locality:  String?, _ pinCode:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.name, $0?.first?.country, $0?.first?.locality, $0?.first?.postalCode, $1) }
    }
}

//MARK: - API CALL
extension ManufacturerVC {
    func searchWebservice() {
        self.viewModel.current_page = 1
        self.viewModel.order_by = ""
        self.viewModel.search_String = ""
        self.viewModel.applyFilterArray.removeAll()
        self.viewModel.getSearchData {
            let vc = ManufacturerListVC.loadFromNib()
            vc.searchViewModel = self.viewModel
            vc.searchViewModel?.is_promotion = self.isPromotion ? 1 : 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
