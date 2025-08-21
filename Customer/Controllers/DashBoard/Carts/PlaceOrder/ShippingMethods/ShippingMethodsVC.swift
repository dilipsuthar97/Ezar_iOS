//
//  ShippingMethodsVC.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ShippingMethodsVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueBtn: ActionButton!
    @IBOutlet weak var totalAmountLbl: UILabel!
    var viewModel : EditAddressViewModel = EditAddressViewModel()
    var selectedIndex : Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configUI()
        setUpTableView()
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        self.navigationItem.title = TITLE.ShippingMethod.localized
        setLeftButton()
        
        self.totalAmountLbl.text = String(format: "%@ %@", self.viewModel.shoppingBagItems?.currency_symbol ?? "SAR", self.viewModel.shoppingBagItems?.grand_total_formatted ?? "0.0") //-- UnComment If Need to Show Grand Total
        
        self.continueBtn.touchUp = { button in
            let vc = AddressViewController.loadFromNib()
            vc.viewModel.shippingMethod = self.viewModel.shippingMethodList[self.selectedIndex]
            vc.viewModel.shoppingBagItems = self.viewModel.shoppingBagItems
            self.insertAddressField(viewModel: vc.viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func insertAddressField(viewModel : AddressViewModel)
    {
        viewModel.name = self.viewModel.name
        viewModel.addressType = self.viewModel.addressType
        viewModel.address = self.viewModel.address
        viewModel.street = self.viewModel.street
        viewModel.city = self.viewModel.city
        viewModel.state = self.viewModel.state
        viewModel.country = self.viewModel.country
        viewModel.postCode = self.viewModel.postCode
        viewModel.instruction = self.viewModel.instruction
        viewModel.contactNumber = self.viewModel.contactNumber
        viewModel.latitude = self.viewModel.latitude
        viewModel.longitude = self.viewModel.longitude
        viewModel.countryCode = self.viewModel.countryCode
        viewModel.isDefaultAddress = self.viewModel.isDefaultAddress
        viewModel.giftWrap = self.viewModel.giftWrap
        viewModel.isNewAddress = self.viewModel.isNewAddress
    }
    
    
    //MARK:- Helper to set up TableView
    func setUpTableView()
    {
        tableView.register(UINib(nibName: ShippingMethodCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ShippingMethodCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- UITableViewDelegate & DataSource Methods
extension ShippingMethodsVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.shippingMethodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ShippingMethodCell.cellIdentifier(), for: indexPath) as! ShippingMethodCell
        
        let shippingMethod = self.viewModel.shippingMethodList[indexPath.row]
        
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue{
            cell.shippingMethodTitle.text = shippingMethod.title.uppercased()
        }else{
            cell.shippingMethodTitle.text = shippingMethod.title_arabic
        }
        
        cell.shippingMethodDetails.text = "+ \(shippingMethod.currency_symbol) \(shippingMethod.price)"
        cell.radioImageView.image = selectedIndex == indexPath.row ? UIImage.init(named: "selectedicon") : UIImage.init(named: "unselected_icon")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
}
