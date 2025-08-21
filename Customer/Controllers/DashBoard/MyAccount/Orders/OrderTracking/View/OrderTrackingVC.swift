//
//  OrderTrackingVC.swift
//  Customer
//
//  Created by Priyanka Jagtap on 06/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class OrderTrackingVC: BaseViewController {

    var netteloWrapper: NEPhotoTakingWrapper? = nil
    var order : CustomReadyMadeOrder?
    var viewModel    : OrderDetailViewModel = OrderDetailViewModel()
    let refreshControl = UIRefreshControl()
    var detailClassType : DetailClassType = .CHOOSESTYLE
    var productType : String = ""
    var isReturnProduct = false
    var deepLinkorderId = ""
    var measurement_id = ""
    var netteloOpened = false
    
    fileprivate enum SectionType {
        case OrderDetails
        case TrackOrderReview
        case ShoppingAddress
        case PaymentMode
        case ShippingMethod
        case ShoppingProduct
        case ShoppingPriceDetail
    }
    
    fileprivate struct Section {
        var type: SectionType
    }
    fileprivate var sections : [Section] = [
        Section(type: .OrderDetails),
        Section(type: .TrackOrderReview),
        Section(type: .ShoppingAddress),
        Section(type: .PaymentMode),
        Section(type: .ShippingMethod),
        Section(type: .ShoppingProduct),
        Section(type: .ShoppingPriceDetail)
    ]
    
    @IBOutlet weak var tableView: UITableView!

    //MARK : View Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isReturnProduct = false

        configUI()
        getOrderDetailsWS()
    }
    
    func configUI() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.orderTracking.localized
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc func pullToRefresh(refreshControl: UIRefreshControl) {
        getOrderDetailsWS()
        refreshControl.endRefreshing()
    }
    
    func setupTableView() {
        
        //For OrderDetails --
        tableView.register(UINib(nibName: OrderCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: OrderCell.cellIdentifier())
        //For TrackOrderReview --
        tableView.register(UINib(nibName: TrackOrderTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: TrackOrderTableCell.cellIdentifier())
        //For ShoppingAddress --
        tableView.register(UINib(nibName: ShippingAddressCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ShippingAddressCell.cellIdentifier())
        //For PaymentMode --
        tableView.register(UINib(nibName: FilterTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: FilterTableViewCell.cellIdentifier())
        //For ShippingMethod --
        tableView.register(UINib(nibName: FilterTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: FilterTableViewCell.cellIdentifier())
        //For ShoppingProduct --
        //1 - ReadyMade - ReadyMadeCell
        tableView.register(UINib(nibName: ReadyMadeCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ReadyMadeCell.cellIdentifier())
        //2 - Custom Made - TailoreMadeCell
        tableView.register(UINib(nibName: TailoreMadeCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: TailoreMadeCell.cellIdentifier())
        //For ShoppingPriceDetail --
        tableView.register(UINib(nibName: PriceDetailTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: PriceDetailTableCell.cellIdentifier())
        
        //For Header
        let headerView = UINib.init(nibName: "ShoppingOptionsHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "ShoppingOptionsHeaderView")
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
    }
    
    func openNetteloScan(mID: String, new: Bool) {
        netteloWrapper = NEPhotoTakingWrapper.init(delegate: self)
        netteloWrapper?.setConfiguration(["Token" : "_lfiJgxmdkaahy4v2kZ16g",
                                          "SPEECH_LANGAGE" : LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue ? "ar-SA" : "en-GB"])
        
        var userInfo = [String: Any]()
        userInfo["ExternalId"] = mID
        userInfo["FirstName"] = COMMON_SETTING.name
        userInfo["LastName"] = nil
        userInfo["BirthYear"] = nil
        userInfo["Height"] = Int(COMMON_SETTING.bodyHeight)
        userInfo["Weight"] = Int(COMMON_SETTING.bodyWeight)
        userInfo["Gender"] = LocalDataManager.getGenderSelection() == GenderSelection.WOMEN.rawValue ? "F" : "M"
        userInfo["NewCustomer"] = new
        userInfo["Belly"] = 1
        userInfo["Bust"] = nil
        
        netteloWrapper?.setUserInformation(userInfo)
        
        netteloWrapper?.runPreFlight(completion: { error in
            self.netteloOpened = false
            if error != nil {
                print("ERROOR", error?.localizedDescription ?? "")
                
                if error?.localizedDescription == "NE_PREFLIGHT_DUPLICATEID".localized {
                    self.openNetteloScan(mID: mID, new: false)
                } else if error?.localizedDescription == "NE_PREFLIGHT_UNKNOWNUSER".localized {
                    self.openNetteloScan(mID: mID, new: true)
                } else {
                    IProgessHUD.loaderError(error?.localizedDescription ?? "")
                    self.navigationController?.backToViewController(viewController: BodyDetailVC.self)
                }
            } else {
                self.netteloWrapper?.getViewController({ vc in
                    if let vc = vc {
                        //self.player?.pause()
                        self.netteloVC = vc
                        self.navigationController?.present(vc, animated: true)
                    }
                })
            }
        })
    }
    var netteloVC: UIViewController?
}

extension OrderTrackingVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section].type
        {
        case .OrderDetails:
            return 1
        case .TrackOrderReview:
            if self.viewModel.orders?.status_label == "Refunded" || self.viewModel.orders?.status_label == "Closed"{
                return 0
            }else{
                 return 1
            }
        case .ShoppingAddress:
            return 1
        case .PaymentMode:
            return 1
        case .ShippingMethod:
            return 1
        case .ShoppingProduct:
            return self.viewModel.orders?.items.count ?? 0
        case .ShoppingPriceDetail:
            return 1
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch sections[indexPath.section].type
        {
        case .OrderDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.cellIdentifier(), for: indexPath) as! OrderCell
            cell.selectionStyle = .none
            cell.layer.cornerRadius = 10
            cell.lblOrderId.text = String(format: "%d", self.viewModel.orders?.order_increment_id ?? 0000)
            cell.lblOrderstatuc.text = self.viewModel.orders?.status_label.uppercased()
            cell.lblCreatedAt.text = self.viewModel.orders?.created_at
            cell.btnReturnIyem.isHidden = true
            cell.reOrderBtn.isHidden = true
            
            if order?.group != "Tailors", self.viewModel.orders?.items.count ?? 0 > 0
            {
                cell.reOrderBtn.isHidden = false
                cell.reOrderBtn.touchUp = { button in
                    self.readyMadeReOrderAction(index: 0)
                }
            }
                                    
         //   print("status is \(String(describing: self.viewModel.orders?.status.removingPercentEncoding))")
            
            //self.order?.status
            if let status = self.viewModel.orders?.status, status.uppercased().contains(TITLE.customer_delivered_status.localized.uppercased())
            {
                cell.btnReturnIyem.isHidden = false
            }else if self.viewModel.orders?.status == "delivered" {
                cell.btnReturnIyem.isHidden = false
            }
            
            cell.btnReturnIyem.isUserInteractionEnabled = !(self.viewModel.orders?.isAllReturned ?? true)
            cell.btnReturnIyem.setTitle(self.viewModel.orders?.isAllReturned ?? true ? TITLE.return_Item.localized : TITLE.return_Item.localized, for: .normal)
            cell.btnReturnIyem.touchUp = { button in
                let vc : ReturnVC  = ReturnVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                vc.order = self.order
                vc.viewModel = self.viewModel.orders
                
                  if let itemOrderArray = self.viewModel.orders?.items{
                    for itemOrder in itemOrderArray{
                        let itemsCount = itemOrder.qty_ordered - itemOrder.return_req_qty
                        
                        if itemsCount > 0{
                          self.isReturnProduct = true
                        }
                    }
                    if self.isReturnProduct{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        INotifications.show(message: TITLE.customer_return_item_msg.localized)
                    }
                }
            }
            
            return cell
        case .TrackOrderReview:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackOrderTableCell.cellIdentifier(), for: indexPath) as! TrackOrderTableCell
            cell.selectionStyle = .none
            cell.layer.cornerRadius = 10
            cell.orderStatusImage.image = UIImage(named: getImage(status: self.viewModel.orders?.status_label ?? ""))
            cell.needHelpBtn.touchUp = { button in
                let vc : HelpViewController  = HelpViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            if OrderStatus.DELIVERED.rawValue == self.viewModel.orders?.status.uppercased() || OrderStatus.CANCELED.rawValue == self.viewModel.orders?.status.uppercased() {
                cell.cancelBtn.isUserInteractionEnabled = false
                cell.cancelBtn.isEnabled = false
                cell.cancelBtn.alpha = 0.5
            } else {
                cell.cancelBtn.isUserInteractionEnabled = true
                cell.cancelBtn.isEnabled = true
                cell.cancelBtn.alpha = 1.0
            }
            
            cell.updateMeasurementBtn.isHidden = true
            cell.measurementViewHeightConstraint.constant = 0
                
            if self.viewModel.orders?.status == "measurement_attenuation" {//"measurement_attenuation" {
                cell.updateMeasurementBtn.isHidden = false
                cell.measurementViewHeightConstraint.constant = 50
                cell.updateMeasurementBtn.touchUp = { button in
                    
                    if self.netteloOpened == false {
                        self.netteloOpened = true
                        //print("MeasurementID", self.mViewModel.measurementID)
                        //"11803_839"
                        //let netteloMID = "\(self.mViewModel.customer_id)_\(self.mViewModel.measurementID)"
                        let profile = Profile.loadProfile()
                        let measurementID = self.viewModel.orders?.items[indexPath.row].measurements_info?.measurement_id ?? ""
                        //"839"
                        let netteloMID = "\(profile?.id ?? 0)_\(measurementID)"
                        print("netteloMID", netteloMID)
                        ScanBodyViewModel.setTermsConditionsSkipOption(true)
                        self.openNetteloScan(mID: netteloMID, new: false)
                    }
                }
            }
            
            cell.cancelBtn.touchUp = { button in
                if OrderStatus.SHIPPED.rawValue == self.viewModel.orders?.status.uppercased() {
                       INotifications.show(message: TITLE.customer_cancel_item_msg.localized)
                } else {
                    self.viewModel.cancelOrder {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
            
            return cell
        case .ShoppingAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShippingAddressCell.cellIdentifier(), for: indexPath) as! ShippingAddressCell
            cell.selectionStyle = .none
            
            cell.nameLbl.text = self.viewModel.orders?.address?.shipping?.firstname
            cell.defaultLbl.isHidden = self.viewModel.orders?.address?.shipping?.is_default == 1 ? false : true
            let address = String(format: "%@ %@ %@ %@ %@ %@",
                                 self.viewModel.orders?.address?.shipping?.location_name ?? "",
                                 self.viewModel.orders?.address?.shipping?.street ?? "",
                                 self.viewModel.orders?.address?.shipping?.city ?? "",
                                 self.viewModel.orders?.address?.shipping?.region ?? "",
                                 self.viewModel.orders?.address?.shipping?.postcode ?? "",
                                 self.viewModel.orders?.address?.shipping?.country ?? "")
            cell.addressLbl.text = address
            cell.noteLbl.text = self.viewModel.orders?.address?.shipping?.delivery_instruction
            cell.mobileNumberLbl.text = self.viewModel.orders?.address?.shipping?.telephone
           
            cell.addressTypeLbl.touchUp = { button in
            }
            return cell
        case .PaymentMode:
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.cellIdentifier(), for: indexPath) as! FilterTableViewCell
            cell.selectionStyle = .none
            cell.titleLbl.textColor = .black
            cell.titleLbl.text = self.viewModel.orders?.payment_mode
            return cell
        case .ShippingMethod:
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.cellIdentifier(), for: indexPath) as! FilterTableViewCell
            cell.selectionStyle = .none
            cell.titleLbl.textColor = .black
            cell.titleLbl.text = self.viewModel.orders?.ship_and_pay_info?.shipping?.title
            return cell
        case .ShoppingProduct:
            let item = self.viewModel.orders?.items[indexPath.row]
            if order?.group == "Tailors"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: TailoreMadeCell.cellIdentifier(), for: indexPath) as! TailoreMadeCell
                cell.bgView.layer.cornerRadius = 10
               // if self.productType == ProductTypeOrder.readymade.rawValue {
                
                if let measurementInfo = self.viewModel.orders?.items[indexPath.row].measurements_info,let styleInfo = self.viewModel.orders?.items[indexPath.row].style_selection{
                    if measurementInfo.options?.count ?? 0 > 0 && styleInfo.count > 0{
                        cell.mesurementDetailView.isHidden = false
                        cell.styleInfoView.isHidden = false
                    }else{
                        cell.mesurementDetailView.isHidden = true
                        cell.styleInfoView.isHidden = true
                    }
                }else{
                    cell.mesurementDetailView.isHidden = true
                    cell.styleInfoView.isHidden = true
                    
                }
                
                    cell.mesurementDetailBtn.touchUp = { button in
                        let vc : MeasurementDetailsTrackVC  = MeasurementDetailsTrackVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                        if let measurementInfo = self.viewModel.orders?.items[indexPath.row].measurements_info{
                            vc.optionList = measurementInfo
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.styleInfoBtn.touchUp = { button in
                        let vc : StyleInfoVC  = StyleInfoVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                        if let styleInfo = self.viewModel.orders?.items[indexPath.row].style_selection{
                            vc.styleInfo = styleInfo
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
//                }else{
//                    cell.mesurementDetailView.isHidden = true
//                    cell.styleInfoView.isHidden = true
//                }
                
                cell.checkBoxImgView.image = UIImage.init(named: "sewing_machine")
                if let image = item?.image
                {
                    let imageUrlString = URL.init(string: image)
                    cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                }
                cell.reviewItemBtn.titleLabel?.text = ""
               // cell.reviewItemBtn.isUserInteractionEnabled = item?.diff_shipped_refund != 0
                if OrderStatus.DELIVERED.rawValue == self.viewModel.orders?.status.uppercased()
                {
                    if let orderReview = self.viewModel.orders?.items[indexPath.row].order_review,let vendorReview = self.viewModel.orders?.items[indexPath.row].vendor_review ,let delegateReview = self.viewModel.orders?.items[indexPath.row].delegate_review{
                        if orderReview == 1 && vendorReview == 1 && delegateReview == 1 {
                           cell.reviewItemBtn.isUserInteractionEnabled = false
                            cell.reviewItemBtn.titleLabel?.text = TITLE.customer_reviewed.localized
                            cell.reviewItemBtn.setTitle(TITLE.customer_reviewed.localized, for: .normal)
                            
                        }else{
                            cell.reviewItemBtn.isUserInteractionEnabled = item?.diff_shipped_refund != 0
                            cell.reviewItemBtn.titleLabel?.text = item?.diff_shipped_refund == 0 ? TITLE.Returned.localized : TITLE.review_Item.localized
                            cell.reviewItemBtn.setTitle(item?.diff_shipped_refund == 0 ? TITLE.Returned.localized : TITLE.review_Item.localized, for: .normal)
                            
                            cell.reviewItemBtn.touchUp = { button in
                                self.navigateToReviewScreen(reviewType: item?.review_type ?? "", index: indexPath.row)
                            }
                        }
                    }
                }
                cell.itemNameLbl.text = item?.name
                cell.itemQuantityBtn.isHidden = false
                cell.itemQuantityBtn.setTitle(String(format: "%d", item?.qty_ordered ?? 0), for: .normal)
                cell.reviewItemBtn.touchUp = { button in
                    self.navigateToReviewScreen(reviewType: item?.review_type ?? "", index: indexPath.row)
                }
                cell.priceLabel.text = String(format: "%@ %d", self.viewModel.orders?.currency_symbol ?? "", item?.row_total ?? 0)
                cell.reOrderBtn.touchUp = { button in
                    self.customMadeReOrderAction(item: item!)
                }
                                
                
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReadyMadeCell.cellIdentifier(), for: indexPath) as! ReadyMadeCell
                cell.bgView.layer.cornerRadius = 10
                cell.checkBoxImgView.image = UIImage.init(named: "dress")
                if let image = item?.image
                {
                    let imageUrlString = URL.init(string: image)
                    cell.itemImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                }
                cell.reviewItemBtnHeight.constant = 0.0
                cell.reviewItemBtn.titleLabel?.text = ""
                cell.reviewViewHeight.constant = 0.0
                if OrderStatus.DELIVERED.rawValue == self.viewModel.orders?.status.uppercased()
                {
                    cell.reviewViewHeight.constant = 1.0
                    cell.reviewItemBtnHeight.constant = 31.0
                    
                    if let orderReview = self.viewModel.orders?.items[indexPath.row].order_review,let vendorReview = self.viewModel.orders?.items[indexPath.row].vendor_review{
                        if orderReview == 1 && vendorReview == 1  {
                            cell.reviewItemBtn.isUserInteractionEnabled = false
                            cell.reviewItemBtn.titleLabel?.text = TITLE.customer_reviewed.localized
                            cell.reviewItemBtn.setTitle(TITLE.customer_reviewed.localized, for: .normal)
//                            cell.reviewItemBtn.touchUp  = { button in
//                                INotifications.show(message: "Already reviewed this product")
//                            }
                        }else{
                            cell.reviewItemBtn.isUserInteractionEnabled = item?.diff_shipped_refund != 0
                            cell.reviewItemBtn.titleLabel?.text = item?.diff_shipped_refund == 0 ? TITLE.Returned.localized : TITLE.review_Item.localized
                            cell.reviewItemBtn.setTitle(item?.diff_shipped_refund == 0 ? TITLE.Returned.localized : TITLE.review_Item.localized, for: .normal)
                            //cell.reviewItemBtn.isHidden = false
                            cell.reviewItemBtn.touchUp = { button in
                                self.navigateToReviewScreen(reviewType: item?.review_type ?? "", index: indexPath.row)
                            }
                        }
                    }
                }
                cell.itemNameLbl.text = item?.name
                cell.priceLabel.text = String(format: "%@ %d", self.viewModel.orders?.currency_symbol ?? "", item?.row_total ?? 0)
                
                self.setAttributedString(model: item!, cell: cell)
                cell.reviewItemBtn.touchUp = { button in
                    self.navigateToReviewScreen(reviewType: item?.review_type ?? "", index: indexPath.row)
                }
                cell.selectionStyle = .none
                return cell
            }
        case .ShoppingPriceDetail:
            let priceCell = tableView.dequeueReusableCell(withIdentifier: PriceDetailTableCell.cellIdentifier(), for: indexPath) as! PriceDetailTableCell
            priceCell.selectionStyle = .none
            
            let taxAmount = self.viewModel.orders?.tax_amount_formatted ?? ""
            let currencySymbol = self.viewModel.orders?.currency_symbol ?? ""
            
            let totalVat = "(" + String(format: "%d%%", self.viewModel.orders?.vat_in_percent ?? 0)  + ")" + " "
            let amt =  totalVat + currencySymbol + " " + taxAmount
            priceCell.vatLbl.text = amt
            
            priceCell.totalLbl.text = String(format: "%@ %@", self.viewModel.orders?.currency_symbol ?? "", self.viewModel.orders?.subtotal_formatted ?? "")
//                priceCell.subTotalLbl.text = String(format: "%@ %@", self.viewModel.orders?.currency_symbol ?? "", self.viewModel.orders?.subtotal_formatted ?? "")
            priceCell.totalPayableLbl.text = String(format: "%@ %@", self.viewModel.orders?.currency_symbol ?? "", self.viewModel.orders?.grand_total_formatted ?? "")
            priceCell.couponLbl.text = String(format: "%@ %@", self.viewModel.orders?.currency_symbol ?? "", self.viewModel.orders?.discount_amount_formatted ?? "")
//           priceCell.giftHeightConstraints.constant = 0
//           priceCell.giftTopConstraints.constant = 0
           priceCell.deliveryLbl.text = String(format: "%@ %@", self.viewModel.orders?.currency_symbol ?? "", self.viewModel.orders?.shipping_amount_formatted ?? "")
            priceCell.giftTotalLbl.text = String(format: "%@ %@", self.viewModel.orders?.currency_symbol ?? "", self.viewModel.orders?.gift_wrap_total_formatted ?? "")
            
            if self.viewModel.orders?.delegateCommission_normal != 0{
                priceCell.delegateCommisionLbl.text = String(format: "%@ %@", self.viewModel.orders?.currency_symbol ?? "", self.viewModel.orders?.delegateCommission_formatted ?? "")
                priceCell.delegateCommisionHeightConstraints.constant = 25
                priceCell.totalPayableTopConstraints.constant = 10
            }else{
                priceCell.delegateCommisionHeightConstraints.constant = 0
                priceCell.totalPayableTopConstraints.constant = 0
            }
            
            if order?.group == "Tailors"{
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
            
            return priceCell
        }
    }
    
    func readyMadeReOrderAction(index: Int)
    {
        var index = index
        if index < self.viewModel.orders?.items.count ?? 0
        {
            let item = self.viewModel.orders?.items[index]
            self.viewModel.reOrderItem = item
            self.viewModel.addToCartReadyMadeProduct {
                index += 1
                if index < (self.viewModel.orders?.items.count ?? 0)
                {
                    self.readyMadeReOrderAction(index: index)
                }
                else if self.viewModel.reOrderSuccessArray.count > 0 {
                    self.setTabBarIndex(index: 2)
                }
            }
        }
    }
    
    func customMadeReOrderAction(item : ItemList) {
        let vc = SellerDetailVC.loadFromNib()
        vc.classType = .HOMEREQUESTSVC
        vc.bottomBtnTitle = TITLE.chooseStyles.localized
        vc.isRatingAvail = true
        vc.viewModel.product_id = item.product_id
        vc.detailClassType = .CHOOSESTYLE
        vc.viewModel.is_promotion = 1
        COMMON_SETTING.max_capacity = item.qty_ordered
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setAttributedString(model : ItemList, cell : ReadyMadeCell) {
        cell.txtLabel1.isHidden = true
        cell.txtLabel2.isHidden = true
        cell.txtLabel3.isHidden = true
        cell.txtLabel4.isHidden = true
        if model.extra_info?.attributes_info.count == 0
        {
            cell.txtLabel4.isHidden = false
            cell.txtLabel4.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
            let arr = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.extra_info?.attributes_info.count ?? 0 >= 3
        {
            cell.txtLabel1.isHidden = false
            cell.txtLabel2.isHidden = false
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel1.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
            let arr1 = cell.txtLabel1.text?.components(separatedBy: " ")
            cell.txtLabel1.addAttributeText(text: arr1![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel2.text = String(format: "%@: %@", model.extra_info?.attributes_info[0].label ?? "", model.extra_info?.attributes_info[0].value ?? "")
            let arr2 = cell.txtLabel2.text?.components(separatedBy: " ")
            cell.txtLabel2.addAttributeText(text: arr2![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel3.text = String(format: "%@: %@", model.extra_info?.attributes_info[1].label ?? "", model.extra_info?.attributes_info[1].value ?? "")
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = String(format: "%@: %@", model.extra_info?.attributes_info[2].label ?? "", model.extra_info?.attributes_info[2].value ?? "")
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.extra_info?.attributes_info.count == 2
        {
            cell.txtLabel1.isHidden = true
            cell.txtLabel2.isHidden = false
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel2.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
            let arr2 = cell.txtLabel2.text?.components(separatedBy: " ")
            cell.txtLabel2.addAttributeText(text: arr2![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel3.text = String(format: "%@: %@", model.extra_info?.attributes_info[0].label ?? "", model.extra_info?.attributes_info[0].value ?? "")
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = String(format: "%@: %@", model.extra_info?.attributes_info[1].label ?? "", model.extra_info?.attributes_info[1].value ?? "")
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
        else if model.extra_info?.attributes_info.count == 1
        {
            cell.txtLabel1.isHidden = true
            cell.txtLabel2.isHidden = true
            cell.txtLabel3.isHidden = false
            cell.txtLabel4.isHidden = false
            
            cell.txtLabel3.text = "\(TITLE.customer_quantity_colon.localized) \(model.qty_ordered)"
            let arr3 = cell.txtLabel3.text?.components(separatedBy: " ")
            cell.txtLabel3.addAttributeText(text: arr3![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
            
            cell.txtLabel4.text = String(format: "%@: %@", model.extra_info?.attributes_info[0].label ?? "", model.extra_info?.attributes_info[0].value ?? "")
            let arr4 = cell.txtLabel4.text?.components(separatedBy: " ")
            cell.txtLabel4.addAttributeText(text: arr4![0], textColor: UIColor(hex: "333333"), isUnderLine: false)
        }
    }
    
    func getImage(status : String) -> String
    {
        switch status.uppercased()
        {
        case OrderStatus.NONE.rawValue:
            return "track_b"
        case OrderStatus.PENDING.rawValue:
            return "track_a"
        case OrderStatus.PROCESSING.rawValue:
            return "track_b"
        case OrderStatus.SHIPPED.rawValue:
            return "track_c"
        case OrderStatus.DELIVERED.rawValue:
            return "track_d"
        default:
            return "track_b"
        }
    }
    
    func  navigateToReviewScreen(reviewType : String , index : Int) {
        let vc = ReviewViewController.loadFromNib()
        vc.isFromOrderTracking = true
        vc.viewModel.anyObject = order as AnyObject
        
        if let orderReview = self.viewModel.orders?.items[index].order_review,let vendorReview = self.viewModel.orders?.items[index].vendor_review ,let delegateReview = self.viewModel.orders?.items[index].delegate_review{
            
            COMMON_SETTING.orderReview = orderReview
            COMMON_SETTING.vendorReview = vendorReview
            COMMON_SETTING.delegateReview = delegateReview
            
            if order?.group == "Tailors"{
                COMMON_SETTING.productType = ProductType.CustomMade.rawValue
            }else{
                COMMON_SETTING.productType = ProductType.ReadyMade.rawValue
            }
            
            COMMON_SETTING.sellerId = self.viewModel.orders?.items[index].vendor_id ?? ""
            COMMON_SETTING.delegateId = self.viewModel.orders?.delegate_id ?? 0
            
            if orderReview == 0 {
                vc.viewModel.review_type = reviewType
                vc.viewModel.key_id = "product_id"
                vc.viewModel.value_id = self.viewModel.orders?.items[index].product_id ?? 0
                vc.viewModel.order_item_id = self.viewModel.orders?.items[index].order_item_id ?? 0
                vc.viewModel.review_id = self.viewModel.orders?.items[index].rating_and_reviews?.review_id ?? 0
                vc.initializeArray(reviewQuestions: reviewType.uppercased() == "F" ? self.viewModel.orders?.review_format?.fabric ?? [] : self.viewModel.orders?.review_format?.product ?? [])
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if vendorReview == 0 {
                vc.viewModel.review_type = ReviewType.Seller.rawValue
                vc.viewModel.key_id = "seller_id"
                vc.viewModel.value_id = Int(self.viewModel.orders?.items[index].vendor_id ?? "") ?? 0
                
                vc.initializeArray(reviewQuestions: self.viewModel.orders?.review_format?.seller ?? [])
                self.navigationController?.pushViewController(vc, animated: true)
            }else if delegateReview == 0 {
                if let delegateId = self.viewModel.orders?.delegate_id {
                    if delegateId != 0{
                        vc.viewModel.review_type = ReviewType.Delegate.rawValue
                        vc.viewModel.key_id = "delegate_id"
                        vc.viewModel.value_id = self.viewModel.orders?.delegate_id ?? 0
                        vc.initializeArray(reviewQuestions: self.viewModel.orders?.review_format?.delegate ?? [])
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        INotifications.show(message: TITLE.customer_delegate_msg.localized)
                    }
                }
            }else{
                vc.viewModel.review_type = reviewType
                vc.viewModel.key_id = "product_id"
                vc.viewModel.value_id = self.viewModel.orders?.items[index].product_id ?? 0
                vc.viewModel.order_item_id = self.viewModel.orders?.items[index].order_item_id ?? 0
                vc.viewModel.review_id = self.viewModel.orders?.items[index].rating_and_reviews?.review_id ?? 0
                vc.initializeArray(reviewQuestions: reviewType.uppercased() == "F" ? self.viewModel.orders?.review_format?.fabric ?? [] : self.viewModel.orders?.review_format?.product ?? [])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let optionsHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ShoppingOptionsHeaderView") as! ShoppingOptionsHeaderView
        
        switch sections[section].type
        {
        case .OrderDetails:
            return nil
        case .TrackOrderReview:
            optionsHeaderView.titleLabel.text = TITLE.TRACKORDER.localized.uppercased()
            return optionsHeaderView
        case .ShoppingAddress:
            optionsHeaderView.titleLabel.text = TITLE.ShippingAddress.localized.uppercased()
            return optionsHeaderView
        case .PaymentMode:
            optionsHeaderView.titleLabel.text = TITLE.customer_payment_mode.localized.uppercased()
            return optionsHeaderView
        case .ShippingMethod:
            optionsHeaderView.titleLabel.text = TITLE.ShippingMethod.localized.uppercased()
            return optionsHeaderView
        case .ShoppingProduct:
            optionsHeaderView.titleLabel.text = TITLE.ITEM.localized.uppercased()
            return optionsHeaderView
        case .ShoppingPriceDetail:
            optionsHeaderView.titleLabel.text = TITLE.PRICEDETAILS.localized.uppercased()
            return optionsHeaderView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return sections[section].type == .OrderDetails ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch sections[indexPath.section].type
        {
        case .OrderDetails:
            return UITableView.automaticDimension
        case .TrackOrderReview:
            return UITableView.automaticDimension
        case .ShoppingAddress:
            return UITableView.automaticDimension
        case .PaymentMode:
            return UITableView.automaticDimension
        case .ShippingMethod:
            return UITableView.automaticDimension
        case .ShoppingProduct:
            return 235//UITableView.automaticDimension 
        case .ShoppingPriceDetail:
            return UITableView.automaticDimension
        }
    }
}

extension OrderTrackingVC {
    
    func getOrderDetailsWS() {
        if deepLinkorderId == "" {
            self.viewModel.orderId = order?.order_id ?? 0
        } else {
            self.viewModel.orderId = Int(deepLinkorderId) ?? 0
        }
        
        viewModel.GetOrderDetailsAPI {
            if self.viewModel.orders?.status == OrderStatus.DELIVERED.rawValue
            {
                var returnedItems : [Int] = []
                for item in self.viewModel.orders?.items ?? []
                {
                    if item.diff_shipped_refund == 0
                    {
                        returnedItems.append(item.diff_shipped_refund)
                    }
                }
                self.viewModel.orders?.isAllReturned = returnedItems.count > 0
            }
            self.tableView.reloadData()
        }
    }
}

extension OrderTrackingVC: NEPhotoTakingDelegate {
    
    func leaving(withReason key: String!) {
        print("LeaveError", key ?? "")
        
        if key == "USER_QUIT" {
            self.netteloVC?.dismiss(animated: true)
        } else if key == "UPLOADING_SEQUENCE" {
            IProgessHUD.show()
        } else if key == "UPLOAD_ERROR" {
            IProgessHUD.dismiss()
            let alert = UIAlertController(title: "", message: key.localizer, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: { _ in
                self.netteloVC?.dismiss(animated: true)
                self.navigationController?.backToViewController(viewController: BodyDetailVC.self)
            }))
            self.present(alert, animated: true)
        } else if key == "UPLOAD_DONE" {
            
            self.viewModel.status = "measurement_attenuation"
            self.viewModel.updateMeasurement {
                IProgessHUD.dismiss()
                self.navigationController?.popToRootViewController(animated: true)
                self.netteloVC?.dismiss(animated: true)
                
            } /*{
                IProgessHUD.dismiss()
                self.netteloVC?.dismiss(animated: true)
                
                if COMMON_SETTING.backToM {
                    COMMON_SETTING.backToM = false
                    self.navigationController?.backToViewController(viewController: MeasurementVC.self)
                } else {
                    self.navigationController?.backToViewController(viewController: ShoppingBagVC.self)
                }
            }*/
        }
    }
}
