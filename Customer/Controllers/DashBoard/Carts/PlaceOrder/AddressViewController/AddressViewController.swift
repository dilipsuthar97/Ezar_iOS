//
//  AddressViewController.swift
//  Customer
//
//  Created by Priyanka Jagtap on 28/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class AddressViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    var viewModel : AddressViewModel = AddressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePayableAmount()
        setupUI()
        setupTableView()
    }
    
    func calculatePayableAmount()
    {
        let amount : Double = Double((self.viewModel.shoppingBagItems?.grand_total_normal ?? 0.0)) 
        self.viewModel.deliveryCharges = self.viewModel.shippingMethod?.price ?? 0
        let payableAmount = amount + Double(self.viewModel.deliveryCharges)
        self.viewModel.totalPayable = String(format: "%.2f", Double(payableAmount))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setBackButton()
        navigationItem.title = TITLE.Address.localized
        priceLabel.text = String(format: "%@ %@", self.viewModel.shoppingBagItems?.currency_symbol ?? "", self.viewModel.totalPayable)
    }
    
    override func onClickLeftButton(button: UIButton) {
        let vc = COMMON_SETTING.popToAnyController(type: ShoppingBagVC.self, fromController: self)
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    func setupTableView() {
        
        //Address Cell
        tableView.register(UINib(nibName: AddressTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: AddressTableCell.cellIdentifier())
        
        //Delivery Date cell
         tableView.register(UINib(nibName: DeliveryDateTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: DeliveryDateTableCell.cellIdentifier())
        
        //Order detail cell
        tableView.register(UINib(nibName: OrderDetailTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: OrderDetailTableCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
       tableView.tableFooterView = UIView()
    }
    
    @IBAction func onClickContinue(_ sender: UIButton) {
        
        let vc : PaymentVC  = PaymentVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
        
        vc.viewModel.detailModel = self.viewModel
        self.navigationController?.pushViewController(vc, animated: true)
        
        //INotifications.show(message: "Please add a new address")
    }
}

extension AddressViewController : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableCell.cellIdentifier(), for: indexPath) as! AddressTableCell
        cell.selectionStyle = .none
        
            
            cell.nameLbl.text = self.viewModel.name
            cell.addressTypeLbl.isHidden = self.viewModel.addressType.isEmpty
        
        cell.addressTypeLbl.setTitle(self.viewModel.addressType, for: .normal)
       
        cell.addressLbl.text = "\(self.viewModel.address) \(self.viewModel.street) \(self.viewModel.city) \(self.viewModel.state) \(self.viewModel.country) \(self.viewModel.postCode)"
            
            if !self.viewModel.instruction.isEmpty{
                cell.noteLbl.text = self.viewModel.instruction
            }
          
            cell.defaultLbl.isHidden = viewModel.isDefaultAddress == 1 ? false : true
            
            cell.noteLblTitle.isHidden = (cell.noteLbl.text?.isEmpty) ?? true
            let range = (cell.noteLbl.text! as NSString).range(of: cell.noteLbl.text ?? "")
            let underlineAttriString = NSMutableAttributedString(string: cell.noteLbl.text!, attributes: nil)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14.0), range: range)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "BorderColor"), range: range)
            
            let range1 = (cell.noteLbl.text! as NSString).range(of: "Notes")
            underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "1", range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range1)
            
            let range3 = (cell.noteLbl.text! as NSString).range(of: "Terms & Conditions")
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range3)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0), range: range3)
            cell.noteLbl.attributedText = underlineAttriString
            
            cell.mobileNumberLbl.text = self.viewModel.contactNumber
            let range11 = (cell.mobileNumberLbl.text! as NSString).range(of: cell.mobileNumberLbl.text ?? "")
            let underlineAttriString11 = NSMutableAttributedString(string: cell.mobileNumberLbl.text!, attributes: nil)
            underlineAttriString11.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14.0), range: range)
            underlineAttriString11.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "BorderColor"), range: range)
            
            let range12 = (cell.mobileNumberLbl.text! as NSString).range(of: "Notes")
            underlineAttriString11.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "1", range: range12)
            underlineAttriString11.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range12)
            
            let range13 = (cell.mobileNumberLbl.text! as NSString).range(of: "Terms & Conditions")
            underlineAttriString11.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "LabelColor"), range: range13)
            underlineAttriString11.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0), range: range13)
            cell.mobileNumberLbl.attributedText = underlineAttriString11
            
            cell.addNewAddress.touchUp = { button in
                self.navigateToEditAddressScreen()
            }
            
            cell.editAddress.touchUp = { button in
                self.navigateToEditAddressScreen()
            }
        return cell
        }else if indexPath.section == 1{
        let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDateTableCell.cellIdentifier(), for: indexPath) as! DeliveryDateTableCell
            cell.selectionStyle = .none
            //cell.imgView.image = UIImage(named : "Select")?.imageFlippedForRightToLeftLayoutDirection()
           
           if let item = self.viewModel.shippingMethod{
            cell.deliveryTitle.text = item.title
            
            cell.deliveryDetailLbl.text = String(format: "\(TITLE.customer_price.localized) %@ %d", item.currency_symbol , item.price)
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailTableCell.cellIdentifier(), for: indexPath) as! OrderDetailTableCell
            cell.selectionStyle = .none
           
           if let item = self.viewModel.shoppingBagItems {
            cell.itemCountLbl.text = "\(item.total_items) \(TITLE.ITEM.localized)"
            
            let currency = item.currency_symbol
           
            cell.totalOrderLbl.text = "\(currency) \(item.grand_total_formatted)"
            
            cell.deliveryTypeLbl.text = self.viewModel.deliveryCharges == 0 ? TITLE.customer_free.localized : String(format: "%@ %.2f", self.viewModel.shippingMethod?.currency_symbol ?? currency,Double(self.viewModel.deliveryCharges))
            
            cell.totalPayableLbl.text = String(format: "%@ %@", currency,self.viewModel.totalPayable)
            }
            return cell
        }
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 79
        }
        return UITableView.automaticDimension
    }
    
    func navigateToEditAddressScreen()
    {
        let vc = EditAddressVC.loadFromNib()
        vc.viewModel.cart_item_collection = self.viewModel.product_id_list
        vc.viewModel.shoppingBagItems = self.viewModel.shoppingBagItems
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

