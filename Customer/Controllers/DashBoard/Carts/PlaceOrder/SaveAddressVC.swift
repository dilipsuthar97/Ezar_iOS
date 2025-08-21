//
//  SaveAddressVC.swift
//  Customer
//
//  Created by webwerks on 7/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import CoreLocation

class SaveAddressVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTitle: UILabel!
    var shoppingBagItems : ShoppingBagItem?
    var footerView : UIView!
    var viewModel : SaveAddressViewModel? = nil
    var selectedIndex : Int = -1
    var editViewModel : EditAddressViewModel = EditAddressViewModel()
    var giftWrapSelected : Int = 0
    var latitude = 0.0
    var longitude = 0.0
    //Ankita
    var showImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel = SaveAddressViewModel.init(apiClient: SaveAddressAPIClient())
        self.setUpTableView()
        setupUI()
        self.fetchSavedAddresses()
    }

    func setupUI(){
        setNavigationBarHidden(hide: false)
        setUpLocation()
        setBackButton()
        navigationItem.title = TITLE.customer_delivery_address.localized
    }
    
    func setUpLocation(){
        LocationGetter.sharedInstance.initLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            LocationGetter.sharedInstance.startUpdatingLocation()
        }
        LocationGetter.sharedInstance.delegate = self
    }
    
    override func onClickLeftButton(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Helper to set up TableView
    func setUpTableView()
    {
        tableView.register(UINib(nibName: SaveAddressCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SaveAddressCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func fetchSavedAddresses()
    {
        self.viewModel?.getAddress {
            if self.viewModel?.addressList.count ?? 0 <= 0
            {
                self.headerTitle.text = TITLE.address_not_available.localized
                self.view.addSubview(self.viewForFooterInTableView(yPosition: 135))
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    @IBAction func btnAddNewAddressAction(_ sender: Any) {
        let vc = EditAddressVC.loadFromNib()
        for model in (self.shoppingBagItems?.shoppingBagItemList) ?? []
        {
            let productId : String = model.iProduct_id == 0 ? model.sProduct_id : "\(model.iProduct_id)"
            vc.viewModel.cart_item_collection.append(productId)
        }
        vc.viewModel.giftWrap = self.giftWrapSelected
        
        vc.viewModel.shoppingBagItems = self.shoppingBagItems
        vc.isFromPlaceorder = true
        vc.latitude = self.latitude
        vc.longitude = self.longitude
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- UITableViewDelegate & DataSource Methods
extension SaveAddressVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.addressList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SaveAddressCell.cellIdentifier(), for: indexPath) as! SaveAddressCell
        cell.selectionStyle = .none
        
        if let address = self.viewModel?.addressList[indexPath.row]{
            cell.customerName.text = address.name
            
            cell.addressLbl.text = "\(String(describing: address.street)) \(address.city) \(address.region) \(address.country_name) \(address.postcode)"
            
            if !address.delivery_instruction.isEmpty{
                cell.detailLbl.text = "\(TITLE.customer_notes.localized) \(address.delivery_instruction)"
                let range = (cell.detailLbl.text! as NSString).range(of: cell.detailLbl.text ?? "")
                let underlineAttriString = NSMutableAttributedString(string: cell.detailLbl.text!, attributes: nil)
                underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14.0), range: range)
                underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "BorderColor"), range: range)
                
                let range1 = (cell.detailLbl.text! as NSString).range(of: "Notes")
                underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "1", range: range1)
                underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range1)
                
                let range3 = (cell.detailLbl.text! as NSString).range(of: "Terms & Conditions")
                underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range3)
                underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0), range: range3)
                
                cell.detailLbl.attributedText = underlineAttriString
                
            }
            
            cell.mobileNumber.text = "\(TITLE.customer_mobile.localized) \(address.mobile_number)"
            let range = (cell.mobileNumber.text! as NSString).range(of: cell.mobileNumber.text ?? "")
            
            let underlineAttriString = NSMutableAttributedString(string: cell.mobileNumber.text!, attributes: nil)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14.0), range: range)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "BorderColor"), range: range)
            
            let range1 = (cell.mobileNumber.text! as NSString).range(of: "Mobile")
            underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "1", range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range1)
            
            let range3 = (cell.mobileNumber.text! as NSString).range(of: "Terms & Conditions")
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range3)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0), range: range3)
            
            cell.mobileNumber.attributedText = underlineAttriString
            
            COMMON_SETTING.setRTLforLabelDirection(label: cell.mobileNumber)
            
            if selectedIndex == -1{
                
                selectedIndex = address.is_default == 1 ? indexPath.row : -1
            }
            
            //cell.radioImageView.image = selectedIndex == indexPath.row ? UIImage.init(named: "radio_selected") : UIImage.init(named: "radio_unselected")
            
            cell.removeAddressBtn.touchUp = { button in
                self.viewModel?.address_id = address.address_id
                
                self.viewModel?.removeAddress {
                    self.fetchSavedAddresses()
                }
            }
        }
        
        if showImageIndex == indexPath.row {
            cell.shadowview.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
            cell.shadowview.layer.borderWidth = 1
        } else {
            cell.shadowview.layer.borderColor = UIColor.clear.cgColor
            cell.shadowview.layer.borderWidth = 0
        }
        // self.tableView.tableFooterView = self.viewForFooterInTableView(yPosition: 0.0)
        return cell
    }
    
    func viewForFooterInTableView(yPosition : CGFloat) -> UIView
    {
        if self.footerView == nil
        {
            self.footerView = UIView(frame: CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.size.width, height: 40))
            self.footerView.backgroundColor = Theme.blackColor
            
            let lButton = ActionButton(type: .custom)
            lButton.setTitleColor(Theme.white, for: .normal)
            lButton.setupAction()
            lButton.titleLabel?.font = UIFont.init(name: CustomFont.FuturanBook.rawValue, size: 16.0)
            lButton.layer.cornerRadius = 5
            lButton.backgroundColor = UIColor.clear
            lButton.frame = CGRect.init(x: (UIScreen.main.bounds.size.width/2) - 100, y: 4, width: 200, height: 32)
            //lButton.sizeToFit()
            lButton.titleLabel?.textAlignment = .center
            lButton.setTitle(TITLE.addNewAddress.localized, for: .normal)
            self.footerView.addSubview(lButton)
            
            lButton.touchUp = { button in
                let vc = EditAddressVC.loadFromNib()
                for model in (self.shoppingBagItems?.shoppingBagItemList) ?? []
                {
                    let productId : String = model.iProduct_id == 0 ? model.sProduct_id : "\(model.iProduct_id)"
                    vc.viewModel.cart_item_collection.append(productId)
                }
                vc.viewModel.giftWrap = self.giftWrapSelected
                
                vc.viewModel.shoppingBagItems = self.shoppingBagItems
                vc.isFromPlaceorder = true
                vc.latitude = self.latitude
                vc.longitude = self.longitude
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return self.footerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Ankita
        self.showImageIndex = indexPath.row
        
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
        let profile = Profile.loadProfile()
        self.editViewModel.customer_id = profile?.id ?? 0
        self.editViewModel.shoppingBagItems = self.shoppingBagItems
        
        if let address = self.viewModel?.addressList[indexPath.row]{
            
            self.editViewModel.isNewAddress = 0
            self.editViewModel.addressId = address.address_id
            self.editViewModel.name = address.name
            self.editViewModel.street = address.street
            self.editViewModel.postCode = address.postcode
            self.editViewModel.city = address.city
            self.editViewModel.state = address.region
            self.editViewModel.country = address.country
            self.editViewModel.countryCode = address.country_code
            self.editViewModel.contactNumber = address.mobile_number
            self.editViewModel.addressType = address.location_type
            self.editViewModel.instruction = address.delivery_instruction
            self.editViewModel.longitude = address.longitude
            self.editViewModel.latitude = address.latitude
            self.editViewModel.countryName = address.country_name
            self.editViewModel.isDefaultAddress = address.is_default
            self.editViewModel.isNewAddress = address.is_new
            self.editViewModel.addressId = address.address_id
            self.editViewModel.giftWrap = self.giftWrapSelected
            
            
            self.editViewModel.getShippingMethods {
                let vc = ShippingMethodsVC.loadFromNib()
                vc.viewModel = self.editViewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//MARK:- LocationGetter Delegate Methods
extension SaveAddressVC : LocationGetterDelegate {
    
    func didUpdateLocation(_ location: CLLocation) {
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
    }
    
}
