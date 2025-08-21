//
//  ShoppingBagVC.swift
//  Customer
//
//  Created by webwerks on 22/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup
import CoreLocation
import GooglePlacePicker
import PanModal
import EmptyStateKit

class ShoppingBagVC: BaseViewController {
    
    //MARK:- Variable declaration
    var viewModel : ShoppingBagViewModel = ShoppingBagViewModel()
    var fabrciSelectedIndex : Int = -1
    var requestType : String = ""
    var broadCastType : Bool?
    //    var autocompleteController = GMSAutocompleteViewController()
    var viewModelStyle : CuffStyleViewModel = CuffStyleViewModel()
    var searchViewModel         : SearchViewModel?
    
    @IBOutlet weak var tableView: UITableView!
        
    var shoppingItems = ["Zion Dark Gray Cotton Thobe"]

    var shoppingOptions = [TITLE.ApplyCoupon]
    var selectedGiftWrap : Int = 0
    var isCouponExpanded : Bool = false
    var totalPriceWithGiftWrap : Double =  0.0
    var totalGrandTotal : String =  "0.0"
    var totalGrandNormal : Double =  0.0
    var indexForShoppingItem : Int = 0
    var latitude = 0.0
    var longitude = 0.0
    var measurementStatus : Int = 0
    
    
    fileprivate enum SectionType {
        case ShoppingItems
        case ShoppingOptions
        case ShoppingPrices
        case ShoppingPlaceOrder
    }
    
    fileprivate struct Section {
        var type: SectionType
    }
    
    fileprivate var sections : [Section] = [
        Section(type: .ShoppingItems),
        Section(type: .ShoppingOptions),
        Section(type: .ShoppingPrices),
        Section(type: .ShoppingPlaceOrder)
    ]
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        addPullToRefresh()
        setupNavigation()
        setupEmptyStateView()

        if COMMON_SETTING.isRootViewController {
            self.shoppingBagDetailsWS()
        } else {
            COMMON_SETTING.isRootViewController = true
        }
    }
    
    func setupUI() {
        setUpLocation()
    }
    
    func setupNavigation() {
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.ShoppingBag.localized
    }
        
    override func onClickLeftButton(button: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setUpLocation() {
        LocationGetter.sharedInstance.initLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            LocationGetter.sharedInstance.startUpdatingLocation()
        }
        LocationGetter.sharedInstance.delegate = self
    }

    func setupTableView() {
        //For Custom made
        tableView.register(UINib(nibName: ShoppingItemsCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ShoppingItemsCell.cellIdentifier())
        
        //For Readymade
        tableView.register(UINib(nibName: ShoppingReadyMadeCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ShoppingReadyMadeCell.cellIdentifier())
        
        //For Options
        tableView.register(UINib(nibName: ShoppingOptionsCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ShoppingOptionsCell.cellIdentifier())
        
        //For Price Detail
        tableView.register(UINib(nibName: PriceDetailTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: PriceDetailTableCell.cellIdentifier())
        
        //For Header
        let headerNib = UINib.init(nibName: "ShoppingItemHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ShoppingItemHeaderView")
        let headerView = UINib.init(nibName: "ShoppingOptionsHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "ShoppingOptionsHeaderView")
        let headerViewPlaceOrder = UINib.init(nibName: "ShoppingPlaceOrderHeaderView", bundle: Bundle.main)
        tableView.register(headerViewPlaceOrder, forHeaderFooterViewReuseIdentifier: "ShoppingPlaceOrderHeaderView")
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
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
    
    @objc
    func checkFabricAction(indexPath: Int) {
        COMMON_SETTING.isRootViewController = false
        fabrciSelectedIndex = indexPath
        
        let vc = SelectFabricVC.loadFromNib()
        vc.delegate = self
        
        vc.broadcast_request_id = self.viewModel.shoppingBagItems?.broadcast_request_id
        vc.request_id = self.viewModel.shoppingBagItems?.cart_request_status?.request_id
        vc.fabric_status = self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath].item_request_status?.fabric
        presentPanModal(vc)
    }
    
    @objc
    func checkMeasurementAction(indexPath: Int) {
        COMMON_SETTING.isRootViewController = false
        fabrciSelectedIndex = indexPath
        
        let vc = SelectMeasurementVC.loadFromNib()
        vc.delegate = self
        
        vc.broadcast_request_id = self.viewModel.shoppingBagItems?.broadcast_request_id
        vc.request_id = self.viewModel.shoppingBagItems?.cart_request_status?.request_id
        vc.measurement_status = self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath].item_request_status?.measurement
        presentPanModal(vc)
    }
}

//MARK: - LocationGetterDelegate
extension ShoppingBagVC : LocationGetterDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

//MARK: - UITableViewDataSource
extension ShoppingBagVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.shoppingBagItems?.shoppingBagItemList.count == 0 || self.viewModel.shoppingBagItems?.shoppingBagItemList.count == nil {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch sections[section].type {
        case .ShoppingItems :
            return self.viewModel.shoppingBagItems?.shoppingBagItemList.count ?? 0
        case .ShoppingOptions :
            return shoppingOptions.count
        case .ShoppingPrices :
            return 1
        case .ShoppingPlaceOrder :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].type {
            
        case .ShoppingItems:
            self.indexForShoppingItem = indexPath.row
            return returnCellForShoppingBag(indexPath: indexPath)
            
        case .ShoppingOptions:
            let optionsCell = tableView.dequeueReusableCell(withIdentifier: ShoppingOptionsCell.cellIdentifier(), for: indexPath) as! ShoppingOptionsCell
            optionsCell.selectionStyle = .none
            optionsCell.titleLabel.text = shoppingOptions[indexPath.row].localized
            optionsCell.accessoryView = nil
            optionsCell.imgView.isHidden = false
            optionsCell.couponHeightConstraints.constant = 0
            optionsCell.couponCodeView.isHidden = true
            optionsCell.couponCodeTxt.addToolBar()
            optionsCell.couponCodeTxt.placeholder = TITLE.customer_coupon_code.localized
            optionsCell.applyButton.setTitle(TITLE.customer_apply.localized
                                             , for: .normal)
            
            if indexPath.row == 0 {
                optionsCell.giftWrapImgView.isHidden = true
                optionsCell.imgView.image = UIImage(named : "sideArrow")?.imageFlippedForRightToLeftLayoutDirection()
                
                if isCouponExpanded{
                    optionsCell.couponCodeView.isHidden = false
                    optionsCell.couponHeightConstraints.constant = 45
                    optionsCell.imgView.image = UIImage(named : "downarrow")
                    if let item = self.viewModel.shoppingBagItems{
                        //optionsCell.couponCodeTxt.text = ""
                        optionsCell.applyButton.setTitle(TITLE.customer_apply.localized, for: .normal)
                        optionsCell.couponCodeTxt.isUserInteractionEnabled = true
                        if item.coupon_applied == 1{
                            optionsCell.couponCodeTxt.text = item.coupon_code
                            optionsCell.couponCodeTxt.isUserInteractionEnabled = false
                            optionsCell.applyButton.setTitle(TITLE.customer_remove.localized
                                                             , for: .normal)
                        }
                    }
                }
                
                optionsCell.applyButton.touchUp = {button in
                    self.view.endEditing(true)
                    if let item = self.viewModel.shoppingBagItems{
                        if item.coupon_applied == 1 {
                            //remove coupon API
                            self.viewModel.is_remove = 1
                            self.viewModel.quoteId = item.quote_id
                            self.viewModel.couponCode = optionsCell.couponCodeTxt.text ?? ""
                            self.viewModel.quoteId = item.quote_id
                            self.viewModel.applyCouponWS {
                                self.shoppingBagDetailsWS()
                            }
                        } else {
                            if optionsCell.couponCodeTxt.isValid(){
                                self.viewModel.is_remove = 0
                                self.viewModel.quoteId = item.quote_id
                                self.viewModel.couponCode = optionsCell.couponCodeTxt.text ?? ""
                                self.viewModel.quoteId = item.quote_id
                                self.viewModel.applyCouponWS {
                                    self.shoppingBagDetailsWS()
                                }
                            }
                        }
                    }
                }
            } else {
                optionsCell.imgView.isHidden = true
                optionsCell.giftWrapImgView.isHidden = true
                optionsCell.giftWrapImgView.image = UIImage(named : "unselected_icon")
                if selectedGiftWrap == 1 {
                    optionsCell.giftWrapImgView.image = UIImage(named : "selectedicon")
                }
                var option =  shoppingOptions[indexPath.row].localized
                if let item = self.viewModel.shoppingBagItems{
                    option  += " : " + item.currency_symbol + " " +  "\(item.gift_wrap_item_price)" + " \(TITLE.customer_per_item.localized)"
                }
                optionsCell.titleLabel.text = option
            }
            return optionsCell
            
        case .ShoppingPrices:
            let priceCell = tableView.dequeueReusableCell(withIdentifier: PriceDetailTableCell.cellIdentifier(), for: indexPath) as! PriceDetailTableCell
            priceCell.selectionStyle = .none
            
            if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                priceCell.styleChargesHeight.constant = 25
                priceCell.styleChargesTxtHeight.constant = 25
                priceCell.styleChargesLbl.isHidden = false
                priceCell.styleChargesTxtLbl.isHidden = false
                priceCell.styleChargesTop.constant = 10
            }else{
                priceCell.styleChargesHeight.constant = 0
                priceCell.styleChargesTxtHeight.constant = 0
                priceCell.styleChargesLbl.isHidden = true
                priceCell.styleChargesTxtLbl.isHidden = true
                priceCell.styleChargesTop.constant = 0
            }
            if let item = self.viewModel.shoppingBagItems {
                if item.cart_request_status?.is_arrived == "1" {
                    priceCell.delegateCommisionLbl.text = item.currency_symbol + " " + item.DelegateCommission_formatted
                    priceCell.delegateCommisionHeightConstraints.constant = 25
                    priceCell.totalPayableTopConstraints.constant = 10
                } else {
                    priceCell.delegateCommisionHeightConstraints.constant = 0
                    priceCell.totalPayableTopConstraints.constant = 0
                }
                //                priceCell.vatTxtLbl.isHidden = true
                //                priceCell.vatLbl.isHidden = true
                priceCell.totalLbl.text = item.currency_symbol + " " + item.subtotal_formatted
                //                priceCell.subTotalLbl.text = item.currency_symbol + " " + item.subtotal_formatted
                
                if let styleCharges = self.viewModel.shoppingBagItems?.total_style_charges_formatted{
                    priceCell.styleChargesLbl.text =  item.currency_symbol + " " + styleCharges
                }
                
                
                priceCell.vatLbl.text = "(" + String(format: "%.2f%%", self.viewModel.shoppingBagItems?.vat_in_percent ?? 0) + ")" + " " + item.currency_symbol + " " + item.tax_amount_formatted
                
                //   priceCell.vatPriceValLbl.text = item.currency_symbol + " " + item.tax_amount_formatted
                
                priceCell.totalPayableLbl.text = item.currency_symbol + " " + item.grand_total_formatted
                
                priceCell.couponLbl.text = item.currency_symbol + " " + "0.00"//TITLE.ApplyCoupon.localized
                
                if item.coupon_applied == 1{
                    priceCell.couponLbl.text = item.currency_symbol + " " + item.discount_amount_formatted
                }
                
                if selectedGiftWrap == 1{
                    priceCell.giftHeightConstraints.constant = 25
                    priceCell.giftTopConstraints.constant = 10
                    
                    priceCell.giftTotalLbl.text = item.currency_symbol + " " + item.gift_wrap_total_formatted
                    
                    totalPriceWithGiftWrap = item.gift_wrap_grand_total_normal//item.grand_total_normal + item.gift_wrap_total_normal
                    
                    priceCell.totalPayableLbl.text = item.currency_symbol + " " + "\(totalPriceWithGiftWrap)"
                    
                }else{
                    priceCell.giftHeightConstraints.constant = 0
                    priceCell.giftTopConstraints.constant = 0
                    
                    priceCell.totalPayableLbl.text = item.currency_symbol + " " + item.grand_total_formatted
                    
                    totalGrandTotal = item.grand_total_formatted
                    totalGrandNormal  = item.grand_total_normal
                }
            }
            
            return priceCell
            
        case .ShoppingPlaceOrder:
            return UITableViewCell()
        }
    }
    
    func returnCellForShoppingBag(indexPath: IndexPath) -> UITableViewCell {
        
        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingItemsCell.cellIdentifier(), for: indexPath) as! ShoppingItemsCell
            cell.selectionStyle = .none
            
            if let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath.row]{
                
                cell.invalidImgView.isHidden = true
                cell.itemNameLbl.text = shoppingBagItem.title
                cell.itemDetailLbl.text = shoppingBagItem.category_name
                cell.styleChargesLabel.text = "\(TITLE.customer_style_charges.localized) :" + " " + shoppingBagItem.currency_symbol + " " + String(shoppingBagItem.style_charges)
                cell.itemQuantityBtn.setTitle(String(describing:shoppingBagItem.qty), for: .normal)
                
                cell.itemEditBtn.isEnabled = true
                cell.itemFavBtn.isEnabled = true
                if shoppingBagItem.valid_Status != 1
                {
                    if !(self.viewModel.invalidProductList.contains(indexPath.row))
                    {
                        self.viewModel.invalidProductList.append(indexPath.row)
                    }
                    cell.itemEditBtn.isEnabled = false
                    cell.itemFavBtn.isEnabled = false
                    cell.invalidImgView.isHidden = false
                }
                cell.isMeasureSelectedImgView.isHidden = false
                cell.isFabricSelectedImgView.isHidden = false
                cell.selectFabricButton.isEnabled = true
                cell.selectFabricButton.tag = indexPath.row
                
                self.measurementStatus = shoppingBagItem.measurement_status
                
                if shoppingBagItem.measurement_id.isEmpty
                {
                    if !(self.viewModel.selectMeasurementList.contains(indexPath.row)){
                        self.viewModel.selectMeasurementList.append(indexPath.row)
                        // self.viewModel.selectMeasurementList
                        
                    }
                    cell.isMeasureSelectedImgView.isHidden = true
                }
                
                //                    else if !shoppingBagItem.measurement_id.isEmpty && shoppingBagItem.measurement_status == 1{
                //                        cell.isMeasureSelectedImgView.isHidden = false
                //                        cell.isMeasureSelectedImgView.image = UIImage(named: "Select")
                //                    }else{
                //                        cell.isMeasureSelectedImgView.isHidden = false
                //                        cell.isMeasureSelectedImgView.image = UIImage(named: "pending")
                //
                //                }
                
                
                if (shoppingBagItem.fabric_Detail?.fabric_id.isEmpty) ?? true && (shoppingBagItem.fabric_Detail?.fabric_offline != 1)
                {
                    if !(self.viewModel.selectFabricList.contains(indexPath.row)){
                        self.viewModel.selectFabricList.append(indexPath.row)
                    }
                    cell.isFabricSelectedImgView.isHidden = true
                }
                if shoppingBagItem.fabric_included == "1"
                {
                    cell.isFabricSelectedImgView.isHidden = false
                }
                let imageUrlString = URL.init(string: "")
                cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                if !(shoppingBagItem.image.isEmpty)
                {
                    let imageUrlString = URL.init(string: shoppingBagItem.image)
                    cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                }
                
                cell.priceLabel.text = shoppingBagItem.currency_symbol + " " + shoppingBagItem.display_price_formatted
                
                cell.selectFabricButton.touchUp = { button in
                    if shoppingBagItem.fabric_included == "1" {
                        INotifications.show(message: TITLE.customer_fabric_included.localized)
                    } else {
                        if shoppingBagItem.valid_Status != 1 {
                            INotifications.show(message: TITLE.customer_invalid_product.localized)
                            return
                        }
                        self.checkFabricAction(indexPath: indexPath.row)
                    }
                }
                
                
                cell.itemInfoBtn.touchUp = { button in
                    //itemInfo
                }
                
                cell.itemEditBtn.touchUp = { button in
                    
                    if shoppingBagItem.styles.count > 0 {
                        let alert = UIAlertController(title: TITLE.edit_product.localized, message: TITLE.edit_this_product.localized, preferredStyle: .alert)
                        
                        let yesActtion = UIAlertAction(title: TITLE.yes.localized, style: .default) { (alert) in
                            let vc = CuffStyleVC.loadFromNib()
                            let productId = shoppingBagItem.iProduct_id != 0 ? shoppingBagItem.iProduct_id : Int(shoppingBagItem.sProduct_id) ?? 0
                            vc.viewModel.product_id = productId
                            vc.viewModel.category_Name = shoppingBagItem.category_name
                            vc.viewModel.price = shoppingBagItem.price_formatted
                            vc.viewModel.specialPrice = shoppingBagItem.special_price_formatted
                            vc.viewModel.model_type = Int(shoppingBagItem.model_type)!
                            vc.viewModel.item_quote_id = shoppingBagItem.item_quote_id
                            for i in 0...shoppingBagItem.styles.count - 1 {
                                vc.optionIdArray.append(shoppingBagItem.styles[i].child_id)
                            }
                            COMMON_SETTING.deliveryDate = shoppingBagItem.delivery_date
                            COMMON_SETTING.quantity =  shoppingBagItem.qty
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                        let cancelAction = UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
                        alert.addAction(yesActtion)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        
                        let alert = UIAlertController(title: TITLE.edit_product.localized, message: TITLE.edit_this_product.localized, preferredStyle: .alert)
                        
                        let yesActtion = UIAlertAction(title: TITLE.yes.localized, style: .default) { (alert) in
                            let vc = CuffStyleVC.loadFromNib()
                            let productId = shoppingBagItem.iProduct_id != 0 ? shoppingBagItem.iProduct_id : Int(shoppingBagItem.sProduct_id) ?? 0
                            vc.viewModel.reward_points = String(shoppingBagItem.reward_points)
                            vc.viewModel.product_id = productId
                            vc.viewModel.category_Name = shoppingBagItem.category_name
                            vc.viewModel.price = shoppingBagItem.price_formatted
                            vc.viewModel.specialPrice = shoppingBagItem.special_price_formatted
                            vc.viewModel.model_type = Int(shoppingBagItem.model_type)!
                            COMMON_SETTING.deliveryDate = shoppingBagItem.delivery_date
                            COMMON_SETTING.quantity =  shoppingBagItem.qty
                            
                            vc.viewModel.item_quote_id = shoppingBagItem.item_quote_id
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                        let cancelAction = UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
                        alert.addAction(yesActtion)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                cell.itemDeleteBtn.touchUp = { button in
                    let quoteId = self.viewModel.shoppingBagItems?.quote_id ?? "0"
                    self.deleteProduct(itemQuoteId: shoppingBagItem.item_quote_id,
                                       indexpath: indexPath,
                                       qouteId: quoteId)
                    return
                }
                
                cell.itemFavBtn.isSelected = shoppingBagItem.is_favourite == 1
                
                cell.itemFavBtn.touchUp = { button in
                    self.viewModel.product_Id = shoppingBagItem.iProduct_id == 0 ? Int(shoppingBagItem.sProduct_id) ?? 0 : shoppingBagItem.iProduct_id
                    self.viewModel.category_name = shoppingBagItem.category_name
                    self.viewModel.quoteId = self.viewModel.shoppingBagItems?.quote_id ?? ""
                    self.viewModel.qty = shoppingBagItem.qty
                    
                    var styleDic : [NSMutableDictionary] = [NSMutableDictionary]()
                    for model in shoppingBagItem.styles
                    {
                        styleDic.append(["parent_id": model.parent_id, "child_id":model.child_id])
                    }
                    let jsonString : String = COMMON_SETTING.json(from: styleDic) ?? ""
                    let params = COMMON_SETTING.addToWishListParameters(self.viewModel.product_Id,
                                                                         category_name: shoppingBagItem.category_name,
                                                                         style: jsonString,
                                                                         qty: shoppingBagItem.qty,
                                                                         price:   String(shoppingBagItem.price_normal),
                                                                         special_price: String(shoppingBagItem.special_price_normal),
                                                                         delivery_date: shoppingBagItem.delivery_date,
                                                                         item_quote_id: "",
                                                                         quote_id:  "",
                                                                         avlOptionArray: [],
                                                                         category_id: 0,
                                                                         is_promotion: 0)
                    if button.isSelected{
                        self.viewModel.removeFromWishList {
                            button.isSelected = false
                        }
                    }else{
                        self.viewModel.addToWishlist(params) {
                            button.isSelected = true
                            self.shoppingBagDetailsWS()
                        }
                    }
                }
                cell.selectMeasurementButton.tag = indexPath.row
                
                cell.selectMeasurementButton.touchUp = { button in
                    if shoppingBagItem.valid_Status != 1
                    {
                        INotifications.show(message: TITLE.customer_invalid_product.localized)
                        return
                    }
                    self.checkMeasurementAction(indexPath: indexPath.row)
                }
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingReadyMadeCell.cellIdentifier(), for: indexPath) as! ShoppingReadyMadeCell
            cell.selectionStyle = .none
            
            if let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath.row]{
                
                cell.invalidImgView.isHidden = true
                cell.itemNameLbl.text = shoppingBagItem.title
                cell.itemDetailLbl.text = shoppingBagItem.category_name
                self.setAttributedString(model: shoppingBagItem, cell: cell)
                //cell.itemQuantityBtn.setTitle(String(describing:shoppingBagItem.qty), for: .normal)
                cell.priceLabel.text = shoppingBagItem.currency_symbol + " " + shoppingBagItem.display_price_formatted
                
                cell.itemEditBtn.isEnabled = true
                cell.itemFavBtn.isEnabled = true
                if shoppingBagItem.valid_Status != 1
                {
                    if !(self.viewModel.invalidProductList.contains(indexPath.row))
                    {
                        self.viewModel.invalidProductList.append(indexPath.row)
                    }
                    cell.itemEditBtn.isEnabled = false
                    cell.itemFavBtn.isEnabled = false
                    cell.invalidImgView.isHidden = false
                }
                
                if !(shoppingBagItem.image.isEmpty)
                {
                    let imageUrlString = URL.init(string: shoppingBagItem.image)
                    cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                }
                
                cell.itemEditBtn.touchUp = { button in                    
                    let alert = UIAlertController(title: TITLE.edit_product.localized, message: TITLE.edit_this_product.localized, preferredStyle: .alert)
                    
                    let yesActtion = UIAlertAction(title: TITLE.yes.localized, style: .default) { (alert) in
                        let vc = SellerDetailVC.loadFromNib()
                        
                        let productId : Int = shoppingBagItem.iProduct_id != 0 ? shoppingBagItem.iProduct_id : Int(shoppingBagItem.sProduct_id) ?? 0
                        vc.classType = .SHOPPINGBAGVC
                        vc.viewModel.product_id = productId
                        vc.detailClassType = .READYMADE
                        COMMON_SETTING.deliveryDate = shoppingBagItem.delivery_date
                        vc.viewModel.quotedId = (self.viewModel.shoppingBagItems?.quote_id) ?? ""
                        vc.viewModel.item_quote_id = (self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath.row].item_quote_id) ?? ""
                        vc.viewModel.attributesInfo = (self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath.row].attributes_info) ?? []
                        COMMON_SETTING.quantity =  shoppingBagItem.qty
                        vc.viewModel.qty = shoppingBagItem.qty
                        vc.editQty = true;
                        
                        vc.viewModel.category_id = Int(shoppingBagItem.category_id) ?? 0;
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    let cancelAction = UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
                    alert.addAction(yesActtion)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                
                cell.itemDeleteBtn.touchUp = { button in
                    
                    let alert = UIAlertController(title: TITLE.delete_product.localized, message: TITLE.delete_this_product.localized, preferredStyle: .alert)
                    
                    let yesActtion = UIAlertAction(title: TITLE.yes.localized, style: .default) { (alert) in
                        let quoteId = self.viewModel.shoppingBagItems?.quote_id ?? "0"
                        self.deleteCartItemWS(itemQuoteId: shoppingBagItem.item_quote_id, indexpath: indexPath, qouteId: quoteId)
                    }
                    let cancelAction = UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
                    alert.addAction(yesActtion)
                    alert.addAction(cancelAction)
                    DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true, completion: nil)
                    })
                }
                cell.itemFavBtn.isSelected = shoppingBagItem.is_favourite == 1
                cell.itemFavBtn.touchUp = { button in
                    
                    self.viewModel.product_Id = shoppingBagItem.iProduct_id == 0 ? Int(shoppingBagItem.sProduct_id) ?? 0 : shoppingBagItem.iProduct_id
                    self.viewModel.category_name = shoppingBagItem.category_name
                    self.viewModel.quoteId = self.viewModel.shoppingBagItems?.quote_id ?? ""
                    self.viewModel.qty = shoppingBagItem.qty
                    
                    var styleDic : [NSMutableDictionary] = [NSMutableDictionary]()
                    for model in shoppingBagItem.styles
                    {
                        styleDic.append(["parent_id": model.parent_id, "child_id":model.child_id])
                    }
                    let jsonString : String = COMMON_SETTING.json(from: styleDic) ?? ""
                    var selectedOptionArray : [[String : String]] = []
                    for model in shoppingBagItem.attributes_info
                    {
                        let formatedKey : String = "super_attribute[\(model.option_id)]"
                        let value : String = String(format: "%d", model.option_value)
                        let dictionary : [String : String] = [formatedKey:value]
                        selectedOptionArray.append(dictionary)
                    }
                    let params = COMMON_SETTING.addToWishListParameters(self.viewModel.product_Id,
                                                                         category_name: shoppingBagItem.category_name,
                                                                         style: jsonString,
                                                                         qty: shoppingBagItem.qty,
                                                                         price: String(shoppingBagItem.price_normal),
                                                                         special_price: String(shoppingBagItem.special_price_normal),
                                                                         delivery_date: shoppingBagItem.delivery_date,
                                                                         item_quote_id: "",
                                                                         quote_id:  "",
                                                                         avlOptionArray: selectedOptionArray,
                                                                         category_id: 0,
                                                                         is_promotion: 0)
                    
                    if button.isSelected{
                        self.viewModel.removeFromWishList {
                            button.isSelected = false
                        }
                    } else {
                        self.viewModel.addToWishlist(params) {
                            button.isSelected = true
                            self.shoppingBagDetailsWS()
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func setAttributedString(model: ShoppingBagItemList,
                             cell: ShoppingReadyMadeCell) {
        if model.attributes_info.count == 0 {
            cell.txtLabel4.isHidden = false
            cell.txtLabel4.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty)"
            let arr = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.attributes_info.count >= 3 {
            cell.txtLabel1.isHidden = false
            cell.txtLabel2.isHidden = false
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel1.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty)"
            let arr1 = cell.txtLabel1.text?.components(separatedBy: " ")
            cell.txtLabel1.addAttributeText(text: arr1![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel2.text = "\(model.attributes_info[0].label): \(model.attributes_info[0].value)"
            let arr2 = cell.txtLabel2.text?.components(separatedBy: " ")
            cell.txtLabel2.addAttributeText(text: arr2![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel3.text = "\(model.attributes_info[1].label): \(model.attributes_info[1].value)"
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = "\(model.attributes_info[2].label): \(model.attributes_info[2].value)"
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.attributes_info.count == 2 {
            cell.txtLabel1.isHidden = true
            cell.txtLabel2.isHidden = false
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel2.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty)"
            let arr2 = cell.txtLabel2.text?.components(separatedBy: " ")
            cell.txtLabel2.addAttributeText(text: arr2![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel3.text = "\(model.attributes_info[0].label): \(model.attributes_info[0].value)"
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = "\(model.attributes_info[1].label): \(model.attributes_info[1].value)"
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.attributes_info.count == 1
        {
            cell.txtLabel1.isHidden = true
            cell.txtLabel2.isHidden = true
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel3.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty)"
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = "\(model.attributes_info[0].label): \(model.attributes_info[0].value)"
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].type {
        case .ShoppingItems:
            break
            
        case .ShoppingOptions:
            if indexPath.row == 0 {
                //Apply coupon
                if isCouponExpanded == true{
                    isCouponExpanded = false
                }else{
                    isCouponExpanded = true
                }
                tableView.reloadData()
            } else {
                if selectedGiftWrap == 0 {
                    selectedGiftWrap = 1
                }else{
                    selectedGiftWrap = 0
                }
                tableView.reloadData()
            }
            break
        case .ShoppingPlaceOrder:
            break
        case .ShoppingPrices:
            break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let optionsHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShoppingOptionsHeaderView") as! ShoppingOptionsHeaderView
        
        optionsHeaderView.contentView.backgroundColor = UIColor.white
        
        switch sections[section].type
        
        {
            
        case .ShoppingItems:
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShoppingItemHeaderView") as! ShoppingItemHeaderView
            headerView.contentView.backgroundColor = UIColor.white
            
            headerView.itemsLabel.text = "\(TITLE.ITEM.localized) (0)"
            headerView.totalLabel.text = TITLE.customer_item_total_initial.localized
            
            if let item = self.viewModel.shoppingBagItems{
                let count : Int = item.total_items
                let subTotal : String = item.subtotal_formatted
                headerView.itemsLabel.text = "\(TITLE.ITEM.localized) (\(count))"
                headerView.totalLabel.text = "\(TITLE.Total.localized)  \(item.currency_symbol) \(subTotal)"
            }
            return headerView
            
        case .ShoppingOptions :
            optionsHeaderView.titleLabel.text = TITLE.OPTIONS.localized.uppercased()
            return optionsHeaderView
            
        case .ShoppingPrices :
            optionsHeaderView.titleLabel.text = TITLE.PRICEDETAILS.localized.uppercased()
            return optionsHeaderView
            
        case .ShoppingPlaceOrder :
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShoppingPlaceOrderHeaderView") as! ShoppingPlaceOrderHeaderView
            headerView.contentView.backgroundColor = UIColor.white
            
            
            if let item = self.viewModel.shoppingBagItems{
                
                if selectedGiftWrap == 1{
                    
                    
                    totalPriceWithGiftWrap = item.grand_total_normal + item.gift_wrap_total_normal
                    
                    headerView.itemCodeLbl.text = item.currency_symbol + " " + item.gift_wrap_grand_total_formatted
                }else{
                    headerView.itemCodeLbl.text = item.currency_symbol + " " + item.grand_total_formatted
                }
            }
            
            headerView.placeOrderBtn.backgroundColor = Theme.lightGray
            headerView.placeOrderBtn.setTitle(TITLE.customer_place_order.localized, for: .normal)
            headerView.continueLbl.text = TITLE.ContinueShopping.localized
            if self.viewModel.invalidProductList.count == 0 && self.viewModel.selectMeasurementList.count == 0 && self.viewModel.selectFabricList.count == 0 && self.viewModel.shoppingBagItems?.shoppingBagItemList.count != 0 && self.viewModel.shoppingBagItems?.shoppingBagItemList.count != nil {
            }
            
            headerView.placeOrderBtn.touchUp = { [weak self] button in
                if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                    if self?.viewModel.shoppingBagItems?.shoppingBagItemList.count != 0 && self?.viewModel.shoppingBagItems?.shoppingBagItemList.count != nil {
                        if self?.viewModel.invalidProductList.count == 0 && self?.viewModel.selectMeasurementList.count == 0 && self?.viewModel.selectFabricList.count == 0 &&  self?.viewModel.shoppingBagItems?.shoppingBagItemList[self?.indexForShoppingItem ?? 0].styles.count ?? 0 > 0 {

                            let vc = SaveAddressVC.loadFromNib()
                            if let totalPrice = self?.totalPriceWithGiftWrap, totalPrice != 0.0 && self?.selectedGiftWrap == 1{
                                self?.viewModel.shoppingBagItems?.grand_total_formatted = "\(totalPrice)"
                                self?.viewModel.shoppingBagItems?.grand_total_normal  = totalPrice
                            }else{
                                if let grandTotal = self?.totalGrandTotal{
                                    self?.viewModel.shoppingBagItems?.grand_total_formatted = grandTotal
                                }
                                if let grandNormal = self?.totalGrandNormal{
                                    self?.viewModel.shoppingBagItems?.grand_total_normal  = grandNormal
                                }
                            }
                            
                            vc.latitude = self?.latitude ?? 0.0
                            vc.longitude = self?.longitude ?? 0.0
                            vc.shoppingBagItems = self?.viewModel.shoppingBagItems
                            vc.giftWrapSelected = self?.selectedGiftWrap ?? 0
                            vc.hidesBottomBarWhenPushed = true
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                        else if (self?.viewModel.shoppingBagItems?.shoppingBagItemList[self?.indexForShoppingItem ?? 0].styles.count ?? 0 <= 0){
                            INotifications.show(message:TITLE.customer_style_msg.localized)
                        }
                        else if self?.viewModel.selectFabricList.count != 0{
                            INotifications.show(message:TITLE.customer_select_fabric_to_proceed.localized )
                        }else if self?.viewModel.selectMeasurementList.count != 0{
                            INotifications.show(message:TITLE.customer_select_measurement_to_proceed.localized )
                        }
                        else
                        {
                            let messageString = self?.viewModel.invalidProductList.count != 0 ? TITLE.customer_remove_invalid_product.localized : TITLE.customer_select_measurement_to_proceed.localized
                            INotifications.show(message: messageString)
                        }
                    }
                }else{
                    if self?.viewModel.invalidProductList.count == 0{
                        let vc = SaveAddressVC.loadFromNib()
                        if let totalPrice = self?.totalPriceWithGiftWrap, totalPrice != 0.0 && self?.selectedGiftWrap == 1{
                            self?.viewModel.shoppingBagItems?.grand_total_formatted = "\(totalPrice)"
                            
                            self?.viewModel.shoppingBagItems?.grand_total_normal  = totalPrice
                        }else{
                            if let grandTotal = self?.totalGrandTotal{
                                self?.viewModel.shoppingBagItems?.grand_total_formatted = grandTotal
                            }
                            if let grandNormal = self?.totalGrandNormal{
                                self?.viewModel.shoppingBagItems?.grand_total_normal  = grandNormal
                            }
                        }
                        vc.shoppingBagItems = self?.viewModel.shoppingBagItems
                        vc.giftWrapSelected = self?.selectedGiftWrap ?? 0
                        vc.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        INotifications.show(message: TITLE.customer_invalid_product.localized)
                    }
                }
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            headerView.continueLbl.isUserInteractionEnabled = true
            headerView.continueLbl.addGestureRecognizer(tapGesture)
            //headerView.continueLbl.addAttributeText(text: TITLE.ContinueShopping.localized,textColor : UIColor(red:51/255, green:51/255, blue:51/255, alpha:1.0))
            headerView.continueLbl.layer.borderWidth = 2
            headerView.continueLbl.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
            headerView.continueLbl.layer.cornerRadius = 25
            return headerView
        }
    }
    
    //    func checkValidationForSelection(indexPath : Int) {
    //        if self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath].fabric_included == "1"{
    //            INotifications.show(message: TITLE.customer_select_fabric_to_proceed.localized)
    //        }else if self.viewModel.shoppingBagItems?.shoppingBagItemList[indexPath].measurement_id.isEmpty == true {
    //            INotifications.show(message: TITLE.customer_select_measurement_to_proceed.localized)
    //        }else{
    //
    //        }
    //    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section].type {
        case .ShoppingItems:
            return 40
        case .ShoppingOptions,.ShoppingPrices:
            return 45
        case .ShoppingPlaceOrder:
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
        case .ShoppingItems:
            return LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue ? 171 : UITableView.automaticDimension
        case .ShoppingOptions:
            return UITableView.automaticDimension
        case  .ShoppingPrices:
            return UITableView.automaticDimension
        case .ShoppingPlaceOrder:
            return UITableView.automaticDimension
        }
    }
    
    func deleteProduct(itemQuoteId: String,
                       indexpath: IndexPath, qouteId: String) {
        
        let alert = EMAlertController(image: UIImage(named: "Delete"),
                                      title: "customer_delete_product".localized,
                                      message: "customer_delete_this_product".localized)
        let action1 = EMAlertAction(title: "delete".localized, style: .cancel){
            self.deleteCartItemWS(itemQuoteId: itemQuoteId,
                                  indexpath: indexpath,
                                  qouteId: qouteId)
        }
        let action2 = EMAlertAction(title: "cancel".localized, style: .normal)
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - SELECT FABRIC
extension ShoppingBagVC : SelectFabricViewDelegate {
    
    func onClickReloadView() {
        self.shoppingBagDetailsWS()
    }
    
    func onClickFabricTableViewCell(index: Int) {
        guard let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[fabrciSelectedIndex] else {
            return
        }
        
        if index == SelectFabricStatus.fabricOnline.key {
            let vc  = ChooseFabricVC.loadFromNib()
            vc.viewModel.delivery_date = (shoppingBagItem.delivery_date)
            vc.viewModel.quoteId = (self.viewModel.shoppingBagItems?.quote_id) ?? ""
            vc.viewModel.minFabricRequired = shoppingBagItem.min_fabric_required
            
            vc.viewModel.itemQuoteId = (shoppingBagItem.item_quote_id)
            vc.viewModel.qty = (shoppingBagItem.qty)
            vc.viewModel.fabric_offline = 0
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if index == SelectFabricStatus.myOwnFabric.key {
            self.viewModel.product_Id = shoppingBagItem.iProduct_id != 0 ? (shoppingBagItem.iProduct_id) : Int((shoppingBagItem.sProduct_id) ) ?? 0
            self.viewModel.quoteId = (self.viewModel.shoppingBagItems?.quote_id) ?? ""
            self.viewModel.itemQuoteId = (shoppingBagItem.item_quote_id)
            let profile = Profile.loadProfile()
            self.viewModel.customer_id = profile?.id ?? 0
            self.viewModel.fabric_offline = 1
            self.viewModel.qty = (shoppingBagItem.qty)
            self.viewModel.delivery_date = (shoppingBagItem.delivery_date)
            self.viewModel.applyFabricOffline {
                self.shoppingBagDetailsWS()
            }
            return
        }
        
        if index == SelectFabricStatus.contactDelegate.key {
            let fabric_status = shoppingBagItem.item_request_status?.fabric ?? ""
            let broadCast_id = self.viewModel.shoppingBagItems?.broadcast_request_id ?? 0
            let request_id = self.viewModel.shoppingBagItems?.cart_request_status?.request_id ?? 0
            
            if fabric_status.isEmpty,
               (request_id == 0 && broadCast_id == 0) {
                self.selectBroadCastVC(delegateRequestType: .fabric)
                return
            }
            
            if broadCast_id != 0 && request_id == 0 {
                INotifications.show(message: TITLE.customer_request_already_broadcasted.localized)
                return
            }
            
            if fabric_status.isEmpty, request_id != 0 {
                requestDelegate(delegateRequestType: .fabric)
                return
            }
            
            
            if fabric_status == RequestDelegateStatus.pending.key {
                pendingRequestDelegate(delegate_status: fabric_status,
                                       delegateRequestType: .fabric)
                return
            }
            
            if fabric_status == RequestDelegateStatus.approved.key {
                approvedRequestDelegate(delegate_status: fabric_status,
                                        delegateRequestType: .fabric)
            }
        }
    }
    
    func selectBroadCastVC(delegateRequestType: DelegateRequestType) {
        self.requestType = delegateRequestType.key
        self.delay(0.2) {
            COMMON_SETTING.isRootViewController = false
        }
        let vc = SelectBroadCastVC.loadFromNib()
        vc.delegate = self
        presentPanModal(vc)
    }
    
    func requestDelegate(delegateRequestType: DelegateRequestType) {
        guard let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[fabrciSelectedIndex] else {
            return
        }

        guard let data = self.viewModel.shoppingBagItems?.cart_request_status else {
            return
        }

        let item_quote_id = shoppingBagItem.item_request_status?.quote_item_id ?? ""
        var request_instruction = data.request_instruction
        request_instruction?.mobileNumber = data.mobile_number

        let vc = EditAddressVC.loadFromNib()
        vc.viewModel.requestDelegateModel.latitude = data.latitude
        vc.viewModel.requestDelegateModel.longitude = data.longitude
        vc.viewModel.requestDelegateModel.quote_id = item_quote_id
        vc.viewModel.requestDelegateModel.request_id = data.request_id
        vc.viewModel.requestDelegateModel.mobile_number = data.mobile_number
        vc.viewModel.requestDelegateModel.countryCode = data.country_code
        vc.viewModel.requestDelegateModel.setRequestFor(item_quote_id: item_quote_id, type: delegateRequestType.key)
        vc.viewModel.requestDelegateModel.setRequestInformation(location_name: (request_instruction?.location_name) ?? "", location_type: (request_instruction?.location_type) ?? "", instructions: (request_instruction?.instructions) ?? "")
        vc.isRequestDelegate = true
        vc.request_instruction = request_instruction
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pendingRequestDelegate(delegate_status: String,
                          delegateRequestType: DelegateRequestType) {
        guard let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[fabrciSelectedIndex] else {
            return
        }

        guard let data = self.viewModel.shoppingBagItems?.cart_request_status else {
            return
        }

        let item_quote_id = shoppingBagItem.item_request_status?.quote_item_id ?? ""
        var request_instruction = data.request_instruction
        request_instruction?.mobileNumber = data.mobile_number

        let vc = DelegateDetailVC.loadFromNib()
        vc.viewModel.request_Id = data.request_id
        vc.viewModel.requestDelegateModel.request_id = data.request_id
        vc.viewModel.requestDelegateModel.latitude = data.latitude
        vc.viewModel.requestDelegateModel.longitude = data.longitude
        vc.viewModel.mobileNumber = data.mobile_number
        vc.viewModel.countryCode = data.country_code
        vc.viewModel.requestDelegateModel.setRequestFor(item_quote_id: item_quote_id, type: delegateRequestType.key)
        vc.viewModel.requestDelegateModel.setRequestInformation(location_name: (request_instruction?.location_name) ?? "", location_type: (request_instruction?.location_type) ?? "", instructions: (request_instruction?.instructions) ?? "")
        vc.viewModel.requestDelegateModel.delegate_status = delegate_status
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func approvedRequestDelegate(delegate_status: String,
                          delegateRequestType: DelegateRequestType) {
        guard let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[fabrciSelectedIndex] else {
            return
        }

        guard let data = self.viewModel.shoppingBagItems?.cart_request_status else {
            return
        }

        let item_quote_id = shoppingBagItem.item_request_status?.quote_item_id ?? ""
        var request_instruction = data.request_instruction
        request_instruction?.mobileNumber = data.mobile_number
        let latitude = Double(data.latitude) ?? 0.0
        let longitude = Double(data.longitude) ?? 0.0

        let vc = DelegateDetailVC.loadFromNib()
        vc.viewModel.origin_lat = latitude
        vc.viewModel.origin_lon = longitude
        vc.viewModel.request_Id = data.request_id
        vc.viewModel.requestDelegateModel.request_id = data.request_id
        vc.viewModel.requestDelegateModel.latitude = data.latitude
        vc.viewModel.requestDelegateModel.longitude = data.longitude
        vc.viewModel.requestDelegateModel.setRequestFor(item_quote_id: item_quote_id, type: delegateRequestType.key)
        vc.viewModel.mobileNumber = data.mobile_number
        vc.viewModel.countryCode = data.country_code
        vc.viewModel.requestDelegateModel.setRequestInformation(location_name: (request_instruction?.location_name) ?? "", location_type: (request_instruction?.location_type) ?? "", instructions: (request_instruction?.instructions) ?? "")
        vc.viewModel.requestDelegateModel.delegate_status = delegate_status
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
}

//MARK: - TAKE Measurement
extension ShoppingBagVC : SelectMeasurementViewDelegate {
    
    func onClickRefreshView() {
        self.shoppingBagDetailsWS()
    }
    
    func onClickMeasurementTableCell(index: Int) {
        guard let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[fabrciSelectedIndex] else {
            return
        }
        
        let product_id = shoppingBagItem.iProduct_id != 0 ? shoppingBagItem.iProduct_id : Int(shoppingBagItem.sProduct_id) ?? 0
        let item_quote_id = shoppingBagItem.item_quote_id
        
        if index == SelectMeasurementStatus.previousMeasurement.key {
            let vc = MeasurementVC.loadFromNib()
            COMMON_SETTING.measurement_id = ""
            vc.viewModel.product_id = product_id
            vc.viewModel.item_quote_id = item_quote_id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
                
        if index == SelectMeasurementStatus.scanBody.key {
            let vc = BodyDetailVC.loadFromNib()
            COMMON_SETTING.measurement_id = ""
            COMMON_SETTING.productIDScanBody = product_id
            COMMON_SETTING.itemQuoteID = item_quote_id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if index == SelectMeasurementStatus.tailorMeasurement.key {
            let vc = MyTailorMeasurementVC.loadFromNib()
            COMMON_SETTING.measurement_id = ""
            vc.viewModel.product_id = product_id
            vc.viewModel.item_quote_id = item_quote_id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if index == SelectMeasurementStatus.requestDelegate.key {
            let measurement_status = shoppingBagItem.item_request_status?.measurement ?? ""
            let broadCast_id = self.viewModel.shoppingBagItems?.broadcast_request_id ?? 0
            let request_id = self.viewModel.shoppingBagItems?.cart_request_status?.request_id ?? 0
            
            if measurement_status.isEmpty,
               (request_id == 0 && broadCast_id == 0) {
                self.selectBroadCastVC(delegateRequestType: .measurement)
                return
            }
            
            if broadCast_id != 0 && request_id == 0 {
                INotifications.show(message: TITLE.customer_request_already_broadcasted.localized)
                return
            }
            
            if measurement_status.isEmpty, request_id != 0 {
                requestDelegate(delegateRequestType: .measurement)
                return
            }
            
            
            if measurement_status == RequestDelegateStatus.pending.key {
                pendingRequestDelegate(delegate_status: measurement_status,
                                       delegateRequestType: .measurement)
                return
            }
            
            if measurement_status == RequestDelegateStatus.approved.key {
                approvedRequestDelegate(delegate_status: measurement_status,
                                        delegateRequestType: .measurement)
            }
        }
    }
}

//MARK: - BROADCAST
extension ShoppingBagVC : SelectBrodCastViewDelegate {
    func onClickBrodCastView(_ type: Bool) {
        self.broadCastType = type
        self.customPlacesVcPresent()
    }
}

// MARK: - addPullToRefresh
extension ShoppingBagVC {
    private func addPullToRefresh() {
        tableView.es.addPullToRefresh {
            self.shoppingBagDetailsWS()
        }
    }
}

// MARK: - EmptyStateDelegate

extension ShoppingBagVC: EmptyStateDelegate {
    private func setupEmptyStateView() {
        tableView.emptyState.format = TableState.noCart.format
        tableView.emptyState.delegate = self
    }

    private func reloadTableView() {
        tableView.emptyState.hide()
        tableView.es.stopPullToRefresh()
        if self.viewModel.shoppingBagItems?.shoppingBagItemList.count == 0 || self.viewModel.shoppingBagItems?.shoppingBagItemList.count == nil {
            tableView.emptyState.show(TableState.noCart)
        }
        tableView.reloadData()
    }

    func emptyState(emptyState _: EmptyState, didPressButton _: UIButton) {}
}

//MARK: - CustomMapVCDelegate
extension ShoppingBagVC : CustomMapVCDelegate {
    func getLocationData(_ lat: Double, _ long: Double, _ name: String?, _ address: String?) {
        self.dismiss(animated: true, completion: nil)
        
        let shoppingBagItem = self.viewModel.shoppingBagItems?.shoppingBagItemList[fabrciSelectedIndex]
        if let data = self.viewModel.shoppingBagItems?.cart_request_status {
            let vc = EditAddressVC.loadFromNib()
            let item_quote_id : String = requestType.uppercased() == "FABRIC" ? (shoppingBagItem?.item_request_status?.quote_item_id) ?? "" : shoppingBagItem?.item_quote_id ?? ""
            var request_instruction = data.request_instruction
            request_instruction?.mobileNumber = data.mobile_number
            var productId : String = shoppingBagItem?.sProduct_id ?? ""
            if productId.isEmpty{
                productId = String(format: "%d", shoppingBagItem?.iProduct_id ?? 0)
            }
            let latitude : String = String(format: "%.4f", lat)
            let longitude : String = String(format: "%.4f", long)
            vc.lat = latitude
            vc.long = longitude
            vc.productID = productId
            vc.quoteID = shoppingBagItem?.quote_id ?? ""
            vc.customerAddress = address ?? "No Address"
            vc.viewModel.requestDelegateModel.latitude = latitude
            
            vc.viewModel.requestDelegateModel.longitude = longitude
            vc.viewModel.requestDelegateModel.customerAddress = address ?? "No Address"
            vc.viewModel.requestDelegateModel.quote_id = item_quote_id
            vc.viewModel.requestDelegateModel.request_id = data.request_id
            vc.viewModel.requestDelegateModel.mobile_number = data.mobile_number
            vc.viewModel.requestDelegateModel.countryCode = data.country_code
            vc.viewModel.requestDelegateModel.setRequestFor(item_quote_id: item_quote_id, type: requestType)
            vc.broadCastViewModel.requestDelegateModel.setRequestFor(item_quote_id: item_quote_id, type: requestType)
            vc.viewModel.requestDelegateModel.productId = productId
            vc.isRequestDelegate = true
            vc.isfromBroadCast = self.broadCastType
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - API CALL
extension ShoppingBagVC {
    
    func shoppingBagDetailsWS() {
        self.viewModel.invalidProductList.removeAll()
        self.viewModel.selectMeasurementList.removeAll()
        self.viewModel.selectFabricList.removeAll()
        let profile = Profile.loadProfile()
        self.viewModel.customer_id = profile?.id ?? 0
        self.viewModel.getShoppingBagDetails {
            self.reloadTableView()
        }
    }
    
    //delete cart item
    func deleteCartItemWS(itemQuoteId : String,
                          indexpath : IndexPath, qouteId : String) {
        let profile = Profile.loadProfile()
        self.viewModel.customer_id = profile?.id ?? 0
        self.viewModel.itemQuoteId = itemQuoteId
        self.viewModel.quoteId = qouteId
        
        self.viewModel.deleteCartItem {
            self.viewModel.shoppingBagItems?.shoppingBagItemList.remove(at: indexpath.row)
            if self.viewModel.invalidProductList.contains(indexpath.row) {
                let indexValue : Int = self.viewModel.invalidProductList.index(of: indexpath.row) ?? 0
                self.viewModel.invalidProductList.remove(at: indexValue)
            }
            if self.viewModel.selectMeasurementList.contains(indexpath.row) {
                let indexValue : Int = self.viewModel.selectMeasurementList.index(of: indexpath.row) ?? 0
                self.viewModel.selectMeasurementList.remove(at: indexValue)
            }
            if self.viewModel.selectFabricList.contains(indexpath.row) {
                let indexValue : Int = self.viewModel.selectFabricList.index(of: indexpath.row) ?? 0
                self.viewModel.selectFabricList.remove(at: indexValue)
            }
            self.shoppingBagDetailsWS()
        }
    }
}



