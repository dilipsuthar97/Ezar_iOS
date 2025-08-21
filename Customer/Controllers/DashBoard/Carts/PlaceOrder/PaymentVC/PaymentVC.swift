//
//  PaymentVC.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 3/28/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup

class PaymentVC: BaseTableViewController,ButtonActionDelegate {
    
    //MARK:- Variable declaration
    var viewModel : PaymentViewModel = PaymentViewModel()
    var seletedIndex : Int = -1
    var additionalOfflineMethod : OfflineMethods?
    var offline : [OfflineMethods] = []
    var paymentMethodSelected = false
    
    fileprivate enum SectionType {
        case PaymentAmount
        case PaymentReward
        case PaymentMethod
        //case PaymentCardDetails -- UnComment in next Phase
    }
    
    fileprivate struct Section {
        var type: SectionType
    }
    fileprivate var sections : [Section] = [
        Section(type: .PaymentAmount),
        Section(type: .PaymentReward),
        Section(type: .PaymentMethod),
        //Section(type:.PaymentCardDetails) //-- UnComment in next Phase
    ]
    
    var bottomView = ContainerView()
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        customBottonBar()
        self.getPaymentMethodListWebService()
    }
    
    func getPaymentMethodListWebService()
    {
        self.viewModel.getPaymentMethods {
            self.setAdditionalMethod()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setAdditionalMethod()
    {
        if self.viewModel.paymentMethods?.methods?.offline.count ?? 0 > 0
        {
            for (index, methods) in (self.viewModel.paymentMethods?.methods?.offline.enumerated())!
            {
                if methods.code.uppercased().contains("FREE")
                {
                    additionalOfflineMethod = methods
                    self.viewModel.paymentMethods?.methods?.offline.remove(at: index)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Helpers for data & UI
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.Payment.localized
    }
    
    //Setup bottom Bar
    func customBottonBar()  {
        
        var buttonArray : NSMutableArray = []
        
        buttonArray = [TITLE.CONFIRMANDPAY.localized.uppercased()]
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-50, width: (APP_DELEGATE.window?.frame.size.width)!,height: 50)
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    func onClickBottomButton(button: UIButton) {
        
        if button.tag == 0 {
            //Payment Popup
            if seletedIndex != -1
            {
                let paymentMethod = self.viewModel.paymentMethods?.methods?.offline[seletedIndex]
                
                self.viewModel.payment.setValue(paymentMethod?.code, forKey: "code")
                
                self.viewModel.discount.addEntries(from: ["coupon_code": "", "amount":""])
                
                self.viewModel.tax.addEntries(from: ["amount": ""])
                
                //Adding customer details
                let detailArray : NSMutableArray = NSMutableArray()
                
                if let detail = self.viewModel.detailModel{
                    
                    for shippingDetails in detail.shippingMethod?.shoppingDetails ?? []
                    {
                        let detailProduct : NSMutableDictionary = NSMutableDictionary()
                        detailProduct.addEntries(from: ["item_quote_id": shippingDetails.item_quote_id,
                                                        "product_id": shippingDetails.product_id,
                                                        "price":shippingDetails.price,
                                                        "shipping_code":shippingDetails.shipping_code,
                                                        "qty":shippingDetails.qty,
                                                        "reward_points":shippingDetails.reward_points,
                                                        "total_reward_points":shippingDetails.total_reward_points])
                        detailArray.add(detailProduct)
                    }
                    
                    self.viewModel.request_id = detail.shoppingBagItems?.cart_request_status?.request_id ?? 0
                    let method : NSMutableDictionary = NSMutableDictionary()
                    method.addEntries(from: ["title": detail.shippingMethod?.title ?? "", "price":detail.shippingMethod?.price ?? "", "details":detailArray])
                    
                    //.
                    var isoCountryInfo = IsoCountryCodes.searchByName(calling: detail.countryCode )
                    if (isoCountryInfo.alpha2.isEmpty)
                    {
                        isoCountryInfo = IsoCountryCodes.searchByCountryCode(countryCode: detail.country)
                    }
                    
                    let countryCode = isoCountryInfo.alpha2
                    let calling_Code = detail.countryCode == isoCountryInfo.calling ? detail.countryCode : isoCountryInfo.calling
                    
                    
                    let address : NSMutableDictionary = NSMutableDictionary()
                    
                    let streetAddress : String = String(format: "%@ %@", detail.address, detail.street)
                    
                    address.addEntries(from: ["name": detail.name,
                                              "mobile_number":detail.contactNumber,
                                              "country_code" : calling_Code,
                                              "city" : detail.city])
                    address.addEntries(from: ["region":detail.state ,
                                              "country":countryCode])
                    
                    address.addEntries(from: ["is_new":detail.isNewAddress,
                                              "id":detail.addressId])
                    
                    address.addEntries(from: ["is_default":detail.isDefaultAddress,
                                              "country_name":detail.country,
                                              "location_type" : detail.addressType,
                                              "street" : streetAddress,
                                              "delivery_instruction" : detail.instruction])
                    
                    address.addEntries(from: ["latitude":detail.latitude,
                                              "longitude":detail.longitude] )
                    
                    self.viewModel.shipping.addEntries(from: ["address": address, "method": method])
                    
                    self.viewModel.giftWrap = detail.giftWrap
                }
                
                let profile = Profile.loadProfile()
                self.viewModel.customer_id = profile?.id ?? 0
                if let commission = self.viewModel.detailModel?.shoppingBagItems?.DelegateCommission_normal
                {
                    self.viewModel.commissionNormal = commission
                }
                self.viewModel.placeOrder {
                    
                    if self.viewModel.responseCode == 200{
                        if self.viewModel.placeOrderModel?.webview_url != ""{
                            let vc = BankTransferViewController.loadFromNib()
                            if let url = self.viewModel.placeOrderModel?.webview_url{
                             vc.webView_url = url
                            }
                             self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            let controller = PaymentDoneVC.init(nibName: "PaymentDoneVC", bundle: nil)
                            controller.delegate = self
                            controller.contentSizeInPopup = CGSize(width: MAINSCREEN.width - 80, height: 380)
                            controller.placeOrderModel = self.viewModel.placeOrderModel
                            let popupController = STPopupController.init(rootViewController: controller)
                            popupController.transitionStyle = .fade
                            popupController.containerView.backgroundColor = UIColor.clear
                            popupController.backgroundView?.backgroundColor = UIColor.black
                            popupController.backgroundView?.alpha = 0.7
                            popupController.hidesCloseButton = true
                            popupController.navigationBarHidden = true
                            popupController.present(in: self)
                        }
                        
                    }else{
                        INotifications.show(message: ERROR_MSG.kServerError.localized)
                    }
                
                }
                
            }
            else
            {
                INotifications.show(message: TITLE.customer_error_empty_payment_method.localized)
            }
        }
    }
    
    func setupTableView() {
        
        let headerView = UINib.init(nibName: "ShoppingOptionsHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "ShoppingOptionsHeaderView")
        tableView.register(UINib(nibName: RedeemRewadsPointCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: RedeemRewadsPointCell.cellIdentifier())
        tableView.register(UINib(nibName: PaymentMethodCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: PaymentMethodCell.cellIdentifier())
        //tableView.register(UINib(nibName: PaymentCardCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: PaymentCardCell.cellIdentifier())
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        if self.paymentMethodSelected == true{
            self.paymentMethodSelected = false
            self.tableView.reloadData()
        }else{
            self.paymentMethodSelected = true
            self.tableView.reloadData()
            
        }
    }
}
//Payment Done Action Delegate Method
extension PaymentVC : PaymentDoneVCDelegate
{
    func onClickCloseInfoBtn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK:- TableView datasoruce & delegate methods

extension PaymentVC : UITableViewDataSource, UITableViewDelegate {
    
    func addAdditionalPaymentMethod()
    {
        setAdditionalMethod()
        if self.viewModel.rewards_converted_to_currency == self.viewModel.totalPayable, additionalOfflineMethod != nil
        {
            self.seletedIndex = -1
            self.offline = self.viewModel.paymentMethods?.methods?.offline ?? []
            self.viewModel.paymentMethods?.methods?.offline.removeAll()
            self.viewModel.paymentMethods?.methods?.offline.append(additionalOfflineMethod!)
        }
        else if (self.viewModel.paymentMethods?.methods?.offline.count ?? 0) <= 0 && (self.offline.count > 0)
        {
            self.seletedIndex = -1
            self.viewModel.paymentMethods?.methods?.offline = self.offline
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section].type {
            
        case .PaymentMethod :
            return self.viewModel.paymentMethods?.methods?.offline.count ?? 0
        case .PaymentAmount :
            if self.viewModel.detailModel?.shoppingBagItems?.cart_request_status?.is_arrived == "1"{
                return 2
            }else{
                 return 1
            }
        case.PaymentReward :
            if self.paymentMethodSelected == false{
                return 0
            }else{
                 return 1
            }
        default :
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section].type {
            
        case .PaymentAmount:
            
            let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.selectionStyle = .none
           // cell.textLabel?.textColor = Theme.navBarColor
            cell.textLabel?.textColor = UIColor(named: "LabelColor")
//            cell.layer.borderColor = UIColor.lightGray.cgColor
//            cell.layer.borderWidth = 1.0
                
            cell.textLabel?.font = UIFont.init(customFont: CustomFont.CairoBold, withSize: 13
            )
            let detailLabel = UILabel(frame: CGRect(x: 50, y: 0, width: (self.view.frame.size.width / 2), height: 40))
            detailLabel.textColor = Theme.redColor
            detailLabel.textAlignment = .right
            detailLabel.font = UIFont.init(customFont: CustomFont.FuturanHv, withSize: 14)
            cell.accessoryView = detailLabel

            
            if self.viewModel.detailModel?.shoppingBagItems?.cart_request_status?.is_arrived == "1"{

                if indexPath.row == 0{
                    cell.textLabel?.text = TITLE.customer_delegateCharges.localized
                    cell.textLabel?.textColor = UIColor(named: "LabelColor")
                    
                    detailLabel.text = String(format: "%@ %.2@", self.viewModel.detailModel?.shoppingBagItems?.currency_symbol ?? "",self.viewModel.detailModel?.shoppingBagItems?.DelegateCommission_formatted ?? "")
                    return cell
                }else{
                    if self.viewModel.detailModel?.shoppingBagItems?.DelegateCommission_formatted   != ""{
                        cell.textLabel?.text = TITLE.TotalOrderAmount.localized
                        cell.textLabel?.textColor = UIColor(named: "LabelColor")
                        let totalPayble : Double = Double(self.viewModel.detailModel?.totalPayable ?? "0") ?? 0.0
                        let grandTotal : Double = totalPayble - self.viewModel.rewards_converted_to_currency
                        var commissionAddedVal : Double = 0.0

//                        if let commisionVal = self.viewModel.detailModel?.shoppingBagItems?.DelegateCommission_formatted {
//                            commissionAddedVal  = Double(commisionVal)! + grandTotal
//                        }
                        
                        commissionAddedVal = grandTotal
                        
                        detailLabel.text = String(format: "%@ %.2f", self.viewModel.detailModel?.shoppingBagItems?.currency_symbol ?? "",commissionAddedVal )
                        return cell
                    }
                    return cell
                }
            }else{
            
                cell.textLabel?.text = TITLE.TotalOrderAmount.localized
                cell.textLabel?.textColor = UIColor(named: "LabelColor")
                let totalPayble : Double = Double(self.viewModel.detailModel?.totalPayable ?? "0") ?? 0.0
                let grandTotal : Double = totalPayble - self.viewModel.rewards_converted_to_currency
                detailLabel.text = String(format: "%@ %.2f", self.viewModel.detailModel?.shoppingBagItems?.currency_symbol ?? "",grandTotal)
                return cell
            }

        case .PaymentReward:
           
            let cell = tableView.dequeueReusableCell(withIdentifier: RedeemRewadsPointCell.cellIdentifier(), for: indexPath) as! RedeemRewadsPointCell
             cell.selectionStyle = .none

            let customer_reward_points : Double = Double(self.viewModel.paymentMethods?.customer_reward_points ?? "0") ?? 0.0
            let enterPoints = Double(self.viewModel.useRewardPointsText )
            let reward_pointsTotal : Double = customer_reward_points - enterPoints
            cell.rewardValueLbl.text = String(format: "%.2f",reward_pointsTotal)
            
             cell.conversionRateLbl.text = String(format: "%d %@", self.viewModel.paymentMethods?.conversion_rate ?? 0, TITLE.customer_points.localized)
             cell.useRewardsTxtField.delegate = self
             cell.useRewardsTxtField.isEnabled = true
             if self.viewModel.paymentMethods?.customer_reward_points.isEmpty ?? false
             {
                cell.useRewardsTxtField.isEnabled = false
             }
             
             cell.applyBtn.touchUp = { button in
                cell.useRewardsTxtField.resignFirstResponder()
                let enterPointText = cell.useRewardsTxtField.text
                let enterPoints : Double = Double(cell.useRewardsTxtField.text ?? "0") ?? 0
                let customerPoints : Double = Double(self.viewModel.paymentMethods?.customer_reward_points ?? "0") ?? 0.0
                let conversionRate : Double = Double(self.viewModel.paymentMethods?.conversion_rate ?? 0)
                let totalPayble : Double = Double(self.viewModel.detailModel?.totalPayable ?? "0") ?? 0.0
                cell.useRewardsTxtField.text = ""
                if !(enterPointText?.isEmpty ?? true), customerPoints > 0.0, enterPoints <= customerPoints, enterPoints <= (totalPayble*conversionRate)
                {
                    self.viewModel.rewards_converted_to_currency = enterPoints / conversionRate
                    self.viewModel.current_conversion_rate = conversionRate
                    self.viewModel.applied_reward_points = enterPoints
                    self.viewModel.totalPayable = totalPayble
                    self.viewModel.useRewardPointsText = enterPoints
                    self.addAdditionalPaymentMethod()
                }
             }
            return cell

        case .PaymentMethod:
            
            let paymentCell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCell.cellIdentifier(), for: indexPath) as! PaymentMethodCell
            paymentCell.imgView.image = UIImage(named : "unselected_icon")
            if self.seletedIndex == indexPath.row
            {
                paymentCell.imgView.image = UIImage(named : "selectedicon")
            }
            let paymentMethod = self.viewModel.paymentMethods?.methods?.offline[indexPath.row]
            paymentCell.nameLabel.text = paymentMethod?.title
            paymentCell.descriptionLabel.text = paymentMethod?.description
            paymentCell.selectionStyle = .none
            return paymentCell
            
        /*case .PaymentCardDetails:
            
            let cardCell = tableView.dequeueReusableCell(withIdentifier: PaymentCardCell.cellIdentifier(), for: indexPath) as! PaymentCardCell
            cardCell.selectionStyle = .none
            return cardCell*/ //--
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let paymentHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShoppingOptionsHeaderView") as! ShoppingOptionsHeaderView
        
        paymentHeaderView.contentView.backgroundColor = UIColor.white
//        paymentHeaderView.separatorView.isHidden = true
        
        paymentHeaderView.titleLabel.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 15)
        
        paymentHeaderView.titleLabel.textColor =   UIColor(red:156/255, green:156/255, blue:156/255, alpha:1.0)
        
        switch sections[section].type {
        case .PaymentAmount:
            paymentHeaderView.titleLabel.text = TITLE.ORDERAMOUNT.localized.uppercased()
            return paymentHeaderView
            
        case .PaymentMethod :
            paymentHeaderView.titleLabel.text = TITLE.PAYMENTMETHOD.localized.uppercased()
            return paymentHeaderView
            
        case .PaymentReward:
            paymentHeaderView.titleLabel.text = TITLE.rewardPoints.localized.uppercased()
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
           paymentHeaderView.addGestureRecognizer(tapRecognizer)
            return paymentHeaderView
            
        /*case .PaymentCardDetails :
            
            paymentHeaderView.titleLabel.text = TITLE.YOURCARDDETAILS.localized
            return paymentHeaderView*/ // -- UnComment in next Phase
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch sections[indexPath.section].type {
            
        case .PaymentAmount:
            print("")
        case .PaymentReward:
            print("")
        case .PaymentMethod :
            let paymentMethod = self.viewModel.paymentMethods?.methods?.offline[indexPath.row]
            if self.viewModel.rewards_converted_to_currency == self.viewModel.totalPayable
            {
                if paymentMethod?.code.uppercased().contains("FREE") ?? false
                {
                     let cell = tableView.cellForRow(at: indexPath)as! PaymentMethodCell
                    self.paymentMethodSelected = false
                    self.seletedIndex = indexPath.row
                    cell.imgView.image = UIImage(named : "radio_selected")
                     self.tableView.reloadData()
                    
                }
            }
            else
            {
                let cell = tableView.cellForRow(at: indexPath)as! PaymentMethodCell
                self.paymentMethodSelected = false
                self.seletedIndex = indexPath.row
                cell.imgView.image = UIImage(named : "radio_selected")
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].type {
            
        case .PaymentAmount:
            print("")
        case .PaymentReward:
            print("")
        case .PaymentMethod :
            let paymentMethod = self.viewModel.paymentMethods?.methods?.offline[indexPath.row]
            if self.viewModel.rewards_converted_to_currency != self.viewModel.totalPayable
            {
                if !(paymentMethod?.code.uppercased().contains("FREE") ?? false)
                {
                    let cell = tableView.cellForRow(at: indexPath)as! PaymentMethodCell
                    cell.imgView.image = UIImage(named : "radio_unselected")
                   
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
            
        case .PaymentAmount:
            return UITableView.automaticDimension
        case .PaymentReward:
              return 135
           //UITableView.automaticDimension
        case .PaymentMethod :
            return UITableView.automaticDimension
        /*case .PaymentCardDetails :
            return UITableView.automaticDimension*/ //-- UnComment in next Phase
        }
    }
}

extension PaymentVC : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.viewModel.rewards_converted_to_currency > 0.0
        {
            self.viewModel.rewards_converted_to_currency = 0.0
            self.viewModel.applied_reward_points = 0.0
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableView.RowAnimation.none)
            textField.becomeFirstResponder()
        }
    }
}
extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
