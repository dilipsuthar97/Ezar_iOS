//
//  SellerDetailVC.swift
//  Customer
//
//  Created by webwerks on 3/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import STPopup
import IQKeyboardManagerSwift
import GooglePlacePicker
import PanModal

protocol SellerDetailVCDelegate : AnyObject {
    func getSelectedID(vandorID: String , categoryID : Int , isSortFilterApply : Bool)
}

class SellerDetailVC: BaseViewController {
    
    //MARK: - Variable declaration
    var viewModel : SellerViewModel = SellerViewModel()
    var viewModelSubcategory : SubCategoryViewModel = SubCategoryViewModel()
    var bottomView = ContainerView()
    var bottomBtnTitle : String = TITLE.selectModel.localized
    var isRatingAvail : Bool = false
    var detailClassType : DetailClassType = .CHOOSESTYLE
    lazy var footerView : UIView = UIView()
    var totalCount : String = ""
    var quantityTxtField : CustomTextField?
    var deliveryDateLbl: UILabel?
    var deliveryDateTxtFiled: CustomTextField?
    var isFromCategoryType =  false
    weak var delegate: SellerDetailVCDelegate?
    
    var lat = 0.0
    var long = 0.0
    var editQty = false
    var isFromSelectModelRootVC = false
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var productSizeView : ProductSizeView!
    var testController : UIViewController!
    var videoUrl : String = ""
    var startFrom = TITLE.customer_start_from.localized
    var selectedDeliveryDate = ""
    var isFromCustomMade : Bool = false
    var isTappedLikeDislikeBtn = false
    //
    var viewModelStyle : CuffStyleViewModel = CuffStyleViewModel()
    var viewModelShoppingBag : ShoppingBagViewModel = ShoppingBagViewModel()
    var isRequestButtonTapped: Bool = false
    var broadCastType : Bool?
    var requestType : String = ""
    var counter = 0
    
    let nearestViewModel : NearestDelegateViewModel = NearestDelegateViewModel()
    var classType : ClassType = .NONE
    var reviewIdDictionary : [NSMutableDictionary] = [[:]]
    
    //MARK: - View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        getWebserviceCall()
        setupTableView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLocation()
        setupNavigation()
    }
    
    private func setupNavigation() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.ezar.localized.uppercased()
        
        var image = "Heart"
        if self.viewModel.vendorDetail?.is_favourite == 1 {
            image = "FavG_Filled"
        }
        
        setRightButtonsArray(buttonArray: [image, "share_Icon"])
    }
    
    override func onClickRightButton(button: UIButton) {
        if button.tag == 0 {
            if LocalDataManager.getGuestUser() {
                self.showLoginPopup()
                return
            }
            let params = COMMON_SETTING.addToWishListParameters(
                self.viewModel.vendorDetail?.id ?? 0,
                category_name: self.viewModel.vendorDetail?.categories ?? "",
                style: "",
                qty: COMMON_SETTING.quantity,
                price: self.viewModel.vendorDetail?.price ?? "",
                special_price: self.viewModel.vendorDetail?.special_price ?? "",
                delivery_date: COMMON_SETTING.deliveryDate,
                item_quote_id: "",
                quote_id: "",
                avlOptionArray: self.viewModel.avlOptionArray,
                category_id: self.viewModel.category_id,
                is_promotion: self.viewModel.is_promotion)
            
            if self.detailClassType == .CHOOSESTYLE ||
                self.detailClassType == .ADDTOCART ||
                self.detailClassType == .ADDTOBAG {
                if self.viewModel.vendorDetail?.is_favourite == 0 {
                    self.viewModel.vendorDetail?.is_favourite = 1
                    self.viewModel.addToWishlist(params) {
                        self.viewModel.vendorDetail?.is_favourite = 1
                        self.setupNavigation()
                    }
                } else {
                    self.viewModel.vendorDetail?.is_favourite = 0
                    self.viewModel.removeFromWishList {
                        self.viewModel.vendorDetail?.is_favourite = 0
                        self.setupNavigation()
                    }
                }
            }
            else {
                self.nearestViewModel.isSeller = 1
                self.nearestViewModel.vendorId = self.viewModel.vendor_id
                
                if self.viewModel.vendorDetail?.is_favourite == 1{
                    self.nearestViewModel.is_favourite = 0
                    self.nearestViewModel.addToFavourite {
                        self.viewModel.vendorDetail?.is_favourite = 0
                        self.setupNavigation()
                    }
                }else{
                    self.nearestViewModel.is_favourite = 1
                    self.nearestViewModel.addToFavourite {
                        self.viewModel.vendorDetail?.is_favourite = 1
                        self.setupNavigation()
                    }
                }
            }
        }
        else {
            let title = (TITLE.customer_store_msg.localized) + " " + (self.viewModel.vendorDetail?.name ?? "")
            self.shareDetails(title, productDescription: self.viewModel.vendorDetail?.description ?? "")
        }
    }
    
    func setUpLocation() {
        LocationGetter.sharedInstance.initLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            LocationGetter.sharedInstance.startUpdatingLocation()
        }
        LocationGetter.sharedInstance.delegate = self
    }
    
    func setupUI(){
        //self.navigationController?.navigationBar.isHidden = true
        var buttonArray : NSMutableArray = []
        if self.detailClassType == .CHOOSESTYLE {
            buttonArray = [self.bottomBtnTitle.uppercased()]
            bottomView.frame = CGRect.zero
            bottomView.backgroundColor = UIColor.clear
        }else if self.viewModel.is_promotion  == 1{
            if self.detailClassType == .ADDTOCART{
                if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                    buttonArray = [self.bottomBtnTitle.uppercased()]
                }else{
                    if self.viewModel.vendorDetail?.all_options.count == 0 {
                        self.bottomView.buttonTitle = TITLE.addToCart.localized
                        buttonArray = [self.bottomBtnTitle.uppercased()]
                    }else{
                        self.bottomView.buttonTitle = TITLE.customer_configure_product.localized
                        buttonArray = [self.bottomBtnTitle.uppercased()]
                    }
                }
            }else{
                buttonArray = [self.bottomBtnTitle.uppercased()]
            }
        }else{
            if self.viewModel.vendorDetail?.all_options.count == 0 {
                self.bottomView.buttonTitle = TITLE.addToCart.localized
                buttonArray = [self.bottomBtnTitle.uppercased()]
            }else{
                self.bottomView.buttonTitle = TITLE.customer_configure_product.localized
                buttonArray = [self.bottomBtnTitle.uppercased()]
            }
        }
        
        self.bottomView.delegate = self
        self.bottomView.frame = CGRect(x: 0, y: (APP_DELEGATE.window?.frame.size.height)!-80, width: (UIScreen.main.bounds.size.width),height: 50)
        self.bottomView.isCustomBottom = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue
        self.bottomView.buttonArray = buttonArray
        self.view.addSubview(self.bottomView)
    }
    
    func setUpChooseStyle() {
        if self.viewModel.is_promotion == 1 {
            let qty : Int = Int(self.quantityTxtField?.text ?? "1") ?? 1
            self.quantityTxtField?.text = qty <= 0 ? "" : self.quantityTxtField?.text
            if (self.quantityTxtField?.isValid()) ?? false, self.deliveryDateTxtFiled?.isValid() ?? false {
                COMMON_SETTING.quantity = Int(self.quantityTxtField?.text ?? "0") ?? 0
                if selectedDeliveryDate == "" {
                    if let date = self.viewModel.vendorDetail?.delivery_date{
                        COMMON_SETTING.deliveryDate = date
                    }
                } else {
                    COMMON_SETTING.deliveryDate = selectedDeliveryDate
                    if LocalDataManager.getSelectedLanguage() != LanguageSelection.ENGLISH.rawValue {
                        let dateValue = COMMON_SETTING.getDateFormString(withString: selectedDeliveryDate)
                        let englishDateString = COMMON_SETTING.getEnglishStringDate(withDate: dateValue)
                        COMMON_SETTING.deliveryDate = englishDateString
                    }
                }
                
                let vc = CuffStyleVC.loadFromNib()
                vc.viewModel.reward_points = self.viewModel.vendorDetail?.reward_points ?? ""
                vc.viewModel.product_id = self.viewModel.product_id
                vc.viewModel.category_Name = self.viewModel.vendorDetail?.categories ?? ""
                vc.viewModel.price = self.viewModel.vendorDetail?.price_incl_tax ?? ""
                vc.viewModel.specialPrice = self.viewModel.vendorDetail?.special_price ?? ""
                vc.viewModel.model_type = Int((self.viewModel.vendorDetail?.model_type) ?? "0") ?? 0
                vc.viewModel.is_promotion = self.viewModel.is_promotion
                self.navigationController?.pushViewController(vc, animated: false)
            }
        } else {
            let vc =   CuffStyleVC.loadFromNib()
            vc.viewModel.reward_points = self.viewModel.vendorDetail?.reward_points ?? ""
            vc.viewModel.product_id = self.viewModel.product_id
            vc.viewModel.category_Name = self.viewModel.vendorDetail?.categories ?? ""
            vc.viewModel.price = self.viewModel.vendorDetail?.price_incl_tax ?? ""
            vc.viewModel.specialPrice = self.viewModel.vendorDetail?.special_price ?? ""
            vc.viewModel.model_type = Int((self.viewModel.vendorDetail?.model_type) ?? "0") ?? 0
            vc.viewModel.is_promotion = self.viewModel.is_promotion
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: SellerImageCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerImageCell.cellIdentifier())
        tableView.register(UINib(nibName: SellerReviewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerReviewCell.cellIdentifier())
        tableView.register(UINib(nibName: self.getCellIdentifierString(), bundle: nil), forCellReuseIdentifier: self.getCellIdentifierString())
        tableView.register(UINib(nibName: SellerDetailQDDCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerDetailQDDCell.cellIdentifier())
        
        let headerView = UINib.init(nibName: "SellerDetailHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "SellerDetailHeaderView")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getCellIdentifierString() -> String {
        switch detailClassType {
        case .CHOOSESTYLE:
            return SellerDetailCell.cellIdentifier()
        case .ADDTOBAG:
            return ChooseFabricDetailCell.cellIdentifier()
        case .ADDTOCART:
            IQKeyboardManager.shared.enable = true
            return SellerDetailQDDCell.cellIdentifier()
        case .READYMADE:
            return SellerDetailCell.cellIdentifier()
        }
    }
}

//MARK:- TButton Action delegate method
extension SellerDetailVC : ButtonActionDelegate,
                           customToolBarDelegate, ProductSizeViewDelegate {
    
    func onClickBottomButton(button: UIButton) {
        if button.tag == 11 {
            
        } else if button.tag == 12 {
            let qty : Int = Int(self.quantityTxtField?.text ?? "0") ?? 0
            self.quantityTxtField?.text = qty <= 0 ? "" : self.quantityTxtField?.text
            COMMON_SETTING.quantity = qty
            
            if (self.quantityTxtField?.isValid()) ?? false {
                let count = self.viewModel.vendorDetail?.all_options.count
                if count == 0 {
                    self.readyMadeProductAPIs()
                } else {
                    self.view.alpha = 0.4
                    self.productSizeView = Bundle.main.loadNibNamed("ProductSizeView", owner: ProductSizeView.self, options: nil)![0] as? ProductSizeView
                    self.productSizeView.viewModel = self.viewModel
                    self.productSizeView.setUpUpdateButton()
                    self.productSizeView.setUpTableView()
                    self.productSizeView.delegate = self
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.removeProductSizeView))
                    tapGesture.cancelsTouchesInView = false
                    tapGesture.delegate = self
                    self.productSizeView?.addGestureRecognizer(tapGesture)
                    self.view.window?.addSubview(self.productSizeView)
                }
            } else {
                INotifications.show(message: TITLE.customer_nonZero_Quantity.localized)
            }
        } else {
            switch self.bottomBtnTitle {
            case TITLE.selectModel.localized:
                self.bottomView.frame = CGRect.zero
                self.bottomView.backgroundColor = UIColor.clear
                break
            case TITLE.chooseStyles.localized:
                if button.tag == 0 {
                    if self.viewModel.is_promotion == 1 {
                        let qty : Int = Int(self.quantityTxtField?.text ?? "1") ?? 1
                        self.quantityTxtField?.text = qty <= 0 ? "" : self.quantityTxtField?.text
                        if (self.quantityTxtField?.isValid()) ?? false,
                           self.deliveryDateTxtFiled?.isValid() ?? false {
                            COMMON_SETTING.quantity = Int(self.quantityTxtField?.text ?? "0") ?? 0
                            
                            if selectedDeliveryDate == "" {
                                if let date = self.viewModel.vendorDetail?.delivery_date{
                                    COMMON_SETTING.deliveryDate = date
                                }
                            }else{
                                COMMON_SETTING.deliveryDate = selectedDeliveryDate
                                
                                if LocalDataManager.getSelectedLanguage() != LanguageSelection.ENGLISH.rawValue {
                                    let dateValue = COMMON_SETTING.getDateFormString(withString: selectedDeliveryDate)
                                    let englishDateString = COMMON_SETTING.getEnglishStringDate(withDate: dateValue)
                                    COMMON_SETTING.deliveryDate = englishDateString
                                }
                            }
                            
                            let vc = CuffStyleVC.loadFromNib()
                            vc.viewModel.reward_points = self.viewModel.vendorDetail?.reward_points ?? ""
                            vc.viewModel.product_id = self.viewModel.product_id
                            vc.viewModel.category_Name = self.viewModel.vendorDetail?.categories ?? ""
                            vc.viewModel.price = self.viewModel.vendorDetail?.price_incl_tax ?? ""
                            vc.viewModel.specialPrice = self.viewModel.vendorDetail?.special_price ?? ""
                            vc.viewModel.model_type = Int((self.viewModel.vendorDetail?.model_type) ?? "0") ?? 0
                            vc.viewModel.is_promotion = self.viewModel.is_promotion
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    } else {
                        let vc = CuffStyleVC.loadFromNib()
                        vc.viewModel.reward_points = self.viewModel.vendorDetail?.reward_points ?? ""
                        vc.viewModel.product_id = self.viewModel.product_id
                        vc.viewModel.category_Name = self.viewModel.vendorDetail?.categories ?? ""
                        vc.viewModel.price = self.viewModel.vendorDetail?.price_incl_tax ?? ""
                        vc.viewModel.specialPrice = self.viewModel.vendorDetail?.special_price ?? ""
                        vc.viewModel.model_type = Int((self.viewModel.vendorDetail?.model_type) ?? "0") ?? 0
                        vc.viewModel.is_promotion = self.viewModel.is_promotion
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                } else {
                    if !(LocalDataManager.getGuestUser()) {
                        let userProfile = Profile.loadProfile()
                        self.viewModelStyle.customer_id = (userProfile?.id) ?? 0
                        if self.viewModel.is_promotion == 1 {
                            if selectedDeliveryDate == "" {
                                if let date = self.viewModel.vendorDetail?.delivery_date{
                                    self.viewModelStyle.delivery_date = date
                                }
                            } else {
                                self.viewModelStyle.delivery_date = selectedDeliveryDate
                            }
                            
                            if self.quantityTxtField?.text == "" {
                                self.viewModelStyle.quantity = "\(COMMON_SETTING.quantity)"
                            } else {
                                self.viewModelStyle.quantity = self.quantityTxtField?.text ?? ""
                            }
                        } else {
                            self.viewModelStyle.delivery_date = COMMON_SETTING.deliveryDate
                            self.viewModelStyle.quantity = "\(COMMON_SETTING.quantity)"
                        }
                        
                        self.viewModelStyle.product_id = self.viewModel.product_id
                        self.viewModelStyle.category_Name = self.viewModel.vendorDetail?.categories ?? ""
                        self.viewModelStyle.price = self.viewModel.vendorDetail?.price_incl_tax ?? ""
                        self.viewModelStyle.specialPrice = self.viewModel.vendorDetail?.special_price ?? ""
                        self.viewModelStyle.item_quote_id = ""
                        self.viewModelStyle.reward_points = self.viewModel.vendorDetail?.reward_points ?? ""
                        self.viewModelShoppingBag.quoteId = ""
                        self.viewModelShoppingBag.customer_id = (userProfile?.id) ?? 0
                        
                        if isRequestButtonTapped ==  false {
                            self.viewModelStyle.setProductDetails {
                                if self.viewModelStyle.responseCode == 200{
                                    self.isRequestButtonTapped = true
                                    self.viewModelShoppingBag.getShoppingBagDetails {
                                    }
                                    let vc = SelectBroadCastVC.loadFromNib()
                                    vc.delegate = self
                                    self.presentPanModal(vc)
                                }
                            }
                        } else {
                            if self.viewModelStyle.responseCode == 200{
                                let vc = SelectBroadCastVC.loadFromNib()
                                vc.delegate = self
                                self.presentPanModal(vc)
                            }
                        }
                    } else {
                        let alert = UIAlertController(title: TITLE.customer_login_required.localized, message: TITLE.customer_guest_alert.localized, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: .default, handler:{ action in
                            let vc = LoginViewController.loadFromNib()
                            vc.isFromUserGuest = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }))
                        alert.addAction(UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                break
            case TITLE.addToCart.localized:
                if self.classType == .SELECTMODELROOTVC ||
                    self.classType == .SELECTMODELVC {
                    self.viewModel.addToCart {
                        self.setTabBarIndex(index: 2)
                    }
                }
                else if (self.quantityTxtField?.isValid()) ?? false, self.deliveryDateTxtFiled?.isValid() ?? false {
                    COMMON_SETTING.quantity = Int(self.quantityTxtField?.text ?? "0") ?? 0
                    IQKeyboardManager.shared.enable = false
                    IQKeyboardManager.shared.enableAutoToolbar = false
                    let vc = CuffStyleVC.loadFromNib()
                    vc.viewModel.reward_points = self.viewModel.vendorDetail?.reward_points ?? ""
                    vc.viewModel.product_id = self.viewModel.product_id
                    vc.viewModel.category_Name = self.viewModel.vendorDetail?.categories ?? ""
                    vc.viewModel.price = self.viewModel.vendorDetail?.price_incl_tax ?? ""
                    vc.viewModel.specialPrice = self.viewModel.vendorDetail?.special_price ?? ""
                    vc.viewModel.model_type = Int((self.viewModel.vendorDetail?.model_type) ?? "0") ?? 0
                    vc.controller = self
                    //vc.sendProductDetails()
                }
                break
            case TITLE.choose.localized:
                self.viewModel.applyFabricOffline {
                    self.navigationController?.backToViewController(viewController: ShoppingBagVC.self)
                }
                break
            default:
                break
            }
        }
    }
    
    //MARK: - customPlacesVcPresent
    func customPlacesVcPresent() {
        let vc = CustomMapVC.loadFromNib()
        vc.contentSizeInPopup = CGSize(width: self.view.frame.width, height:self.view.frame.height)
        vc.delegate = self
        vc.latitude = self.lat
        vc.longitude = self.long
        let popupController = STPopupController.init(rootViewController: vc)
        popupController.transitionStyle = .fade
        popupController.containerView.backgroundColor = UIColor.clear
        popupController.backgroundView?.backgroundColor = Theme.lightGray
        popupController.backgroundView?.alpha = 0.8
        popupController.hidesCloseButton = true
        popupController.navigationBarHidden = true
        popupController.present(in: self)
    }
    
    
    func updateButtonClick(selectedOptionArray: [[String : String]]) {
        self.removeProductSizeView()
        self.viewModel.avlOptionArray = selectedOptionArray
        self.readyMadeProductAPIs()
    }
    
    func readyMadeProductAPIs() {
        if !(self.viewModel.item_quote_id.isEmpty) && !(self.viewModel.quotedId.isEmpty) {
            self.viewModel.updateReadyMadeProduct {
                if self.editQty == true {
                    self.setTabBarIndex(index: 2)
                }
            }
        } else {
            if !(LocalDataManager.getGuestUser()) {
                self.viewModel.addToCartReadyMadeProduct {
                    self.setTabBarIndex(index: 2)
                }
            } else {
                self.showLoginPopup()
            }
        }
    }
    
    @objc func removeProductSizeView() {
        self.view.alpha = 1.0
        if self.productSizeView?.sizeChartView.isHidden == false{
            self.productSizeView.sizeChartView.isHidden = true
            self.productSizeView.bottomView.isHidden = false
        } else {
            self.productSizeView?.removeFromSuperview()
        }
    }
    
    @objc func removeVideoView() {
        self.view.alpha = 1.0
        self.testController?.dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker() {
        let datePikcer:UIDatePicker = UIDatePicker()
        datePikcer.preferredDatePickerStyle = .wheels
        datePikcer.minimumDate = Date().third_DayFormToday
        datePikcer.datePickerMode = .date
        datePikcer.date = Date().third_DayFormToday
        datePikcer.locale = Locale.init(identifier: "en")
        datePikcer.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        let rect = CGRect(x: 0, y: datePikcer.frame.origin.y, width: self.view.frame.size.width, height: 44)
        let toolBar = CustomToolBar.sharedInstance().createToolbarframe(rect)
        CustomToolBar.sharedInstance().delegate = self
        deliveryDateTxtFiled?.inputAccessoryView = toolBar
        deliveryDateTxtFiled?.inputView=datePikcer
        CustomToolBar.sharedInstance()?.done.setTitle(TITLE.done.localized, for: .normal)
    }
    
    @objc func datePickerValueChanged(sender: Any) -> Void {
        self.deliveryDateTxtFiled?.text =  COMMON_SETTING.getStringDate(withDate: (sender as? UIDatePicker)?.date as Date? ?? Date(), formate: "dd MMMM yyyy")
        
        selectedDeliveryDate =  COMMON_SETTING.getStringDate(withDate: (sender as? UIDatePicker)?.date as Date? ?? Date())
        
        if self.viewModel.is_promotion == 1 {
            selectedDeliveryDate = COMMON_SETTING.getStringDate(withDate: (sender as? UIDatePicker)?.date as Date?  ?? Date(), formate: dateFormate)
        }
    }
    
    func doneButtonPress() {
        if (self.deliveryDateTxtFiled?.text?.isEmpty)!{
            self.deliveryDateTxtFiled?.text =  COMMON_SETTING.getStringDate(withDate: Date().third_DayFormToday, formate: "dd MMMM yyyy")
            selectedDeliveryDate =  COMMON_SETTING.getStringDate(withDate: Date().third_DayFormToday)
            
            if self.viewModel.is_promotion == 1
            {
                selectedDeliveryDate = COMMON_SETTING.getStringDate(withDate: Date().third_DayFormToday, formate: dateFormate)
            }
        }
        self.view.endEditing(true)
    }
}

//MARK:- TableView datasoruce & delegate methods
extension SellerDetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return viewModel.reviewList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SellerImageCell.cellIdentifier(),
                                                         for: indexPath) as! SellerImageCell
                cell.selectionStyle = .none
                if let item = self.viewModel.vendorDetail?.storeData{
                    cell.bannerImageList = item.banners
                    cell.logoUrl = item.logo
                    cell.playButton.setImage(UIImage(named : "play_Icon")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
                    cell.ratingView.isHidden = !self.isRatingAvail
                    if let review = self.viewModel.vendorDetail?.reviewRatings{
                        if review.rating != "0"{
                            cell.ratingView.isHidden = false
                            cell.ratingStar.value = COMMON_SETTING.getTheStarRatingValue(rating: review.rating)
                        }
                        else{
                            cell.ratingView.isHidden = true
                        }
                    } else {
                        cell.ratingView.isHidden = true
                    }
                    
                    if !item.video.isEmpty{
                        cell.playButton.isHidden = false
                        self.videoUrl = item.video
                    } else {
                        cell.playButton.isHidden =  true
                    }
                }
                
                if detailClassType == .CHOOSESTYLE ||
                    detailClassType == .ADDTOCART ||
                    detailClassType == .ADDTOBAG {
                    if let item = self.viewModel.vendorDetail{
                        cell.bannerImageList = item.images
                        if !item.video.isEmpty{
                            cell.playButton.isHidden = false
                            self.videoUrl = item.video
                        } else {
                            cell.playButton.isHidden = true
                        }
                        
                        if let review = item.reviewRatings{
                            if !review.rating.isEmpty{
                                cell.ratingView.isHidden = false
                                cell.ratingStar.value = COMMON_SETTING.getTheStarRatingValue(rating: review.rating)
                            }
                            else{
                                cell.ratingView.isHidden = true
                            }
                        }
                    }
                }
                cell.collectionView.reloadData()
                cell.playButton.touchUp = { button in
                    self.playButtonClicked()
                }
                return cell
            }
            return getCellForDetailView(tableView: tableView, indexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SellerReviewCell.cellIdentifier(), for: indexPath) as! SellerReviewCell
        let item = viewModel.reviewList[indexPath.row]
        
        cell.likeLabel.text = String(format: "%d", keyValue(review_id: item.review_id ?? -1, checkValue: 1, removeValue: -1) ? item.like + 1 : item.like)
        cell.unlikeLabel.text = String(format: "%d", keyValue(review_id: item.review_id ?? -1, checkValue: 0, removeValue: -1) ? item.dislike + 1 : item.dislike)
        
        if item.display_review == 1{
            cell.titleLabel.text = item.title
            cell.detailLabel.text = item.reivew
            cell.titleLabel.isHidden = false
            cell.detailLabel.isHidden = false
        } else {
            cell.titleLabel.isHidden = true
            cell.detailLabel.isHidden = true
        }
        
        if item.display_rating == 1{
            cell.ratingView.isHidden = false
            if !item.rating.isEmpty{
                cell.ratingLbl.text =  item.rating
            }
        } else {
            cell.ratingView.isHidden = true
        }
        cell.nameLabel.text = item.name
        cell.dateLabel.text = item.date
        if item.certified_buyer{
            cell.certifiedImgView.image = UIImage(named : "tick_yellow")
            cell.cerifiedBLabel.isHidden = false
        } else {
            cell.certifiedImgView.image = UIImage(named : "")
            cell.cerifiedBLabel.isHidden = true
        }
        
        if item.customer_up_vote == "1"{
            cell.likeBtn.isUserInteractionEnabled = false
            cell.dislikeBtn.isUserInteractionEnabled = true
        }else if item.customer_up_vote == "0"{
            cell.likeBtn.isUserInteractionEnabled = true
            cell.dislikeBtn.isUserInteractionEnabled = false
        }else{
            cell.likeBtn.isUserInteractionEnabled = true
            cell.dislikeBtn.isUserInteractionEnabled = true
        }
        
        cell.likeBtn.touchUp = { button in
            if !(LocalDataManager.getGuestUser()){
                self.viewModel.review_id = item.review_id
                self.viewModel.upVote = 1
                let value = self.getReviewType()
                self.viewModel.reivewType = value.0
                if !(self.keyValue(review_id: item.review_id ?? -1,
                                   checkValue: 1,
                                   removeValue: 0)) {
                    self.viewModel.setReviewLikeDislike {
                        let dic : NSMutableDictionary = [item.review_id ?? 0 : self.viewModel.upVote ?? -1]
                        self.reviewIdDictionary.append(dic)
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            } else {
                self.showLoginPopup()
            }
        }
        
        cell.dislikeBtn.touchUp = { button in
            if !(LocalDataManager.getGuestUser()) {
                self.viewModel.review_id = item.review_id
                self.viewModel.upVote = 0
                self.viewModel.reivewType = self.getReviewType().0
                if !(self.keyValue(review_id: item.review_id ?? -1,
                                   checkValue: 0,
                                   removeValue: 1)) {
                    self.viewModel.setReviewLikeDislike {
                        let dic : NSMutableDictionary = [item.review_id ?? 0 : self.viewModel.upVote ?? -1]
                        self.reviewIdDictionary.append(dic)
                        
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    
                }
            }else{
                self.showLoginPopup()
            }
        }
        cell.selectionStyle = .none
        self.viewForFooterInTableView()
        return cell
    }
    
    func keyValue(review_id : Any, checkValue : Int, removeValue : Int) -> Bool {
        let id : Int = review_id as! Int
        let check = self.reviewIdDictionary.contains([id : checkValue])
        for (index, dic) in self.reviewIdDictionary.enumerated() {
            if let value : Int = dic[id] as? Int, value == removeValue {
                if index < self.reviewIdDictionary.count{
                    self.reviewIdDictionary.remove(at: index)
                }
            }
        }
        return check
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        
        if viewModel.reviewList.count > 0 {
            let optionsHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SellerDetailHeaderView") as! SellerDetailHeaderView
            optionsHeaderView.headerTitleLabel.text = TITLE.comments_by_others.localized
            optionsHeaderView.headerTitleLabel.textColor = UIColor.black
            return optionsHeaderView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 1 {
            return UITableView.automaticDimension
        }
        
        return MAINSCREEN.height - (MAINSCREEN.height/3)//UITableView.automaticDimension
    }
    
    func viewForFooterInTableView() {
        if self.footerView == nil {
            self.footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-10, height: 40))
            self.tableView.tableFooterView = footerView
            
            let showMoreLabel = UILabel(frame: CGRect(x: self.footerView.frame.size.width - 170, y: 0, width: 160, height: 40))
            showMoreLabel.textColor = UIColor(named: "BorderColor")!
            showMoreLabel.text = TITLE.customer_see_all_reviews.localized
            showMoreLabel.textAlignment = .right
            showMoreLabel.font = UIFont.init(customFont: CustomFont.FuturanBook, withSize: 13)
            showMoreLabel.addAttributeText(text: TITLE.customer_see_all_reviews.localized,textColor : UIColor(named: "BorderColor")!)
            showMoreLabel.isUserInteractionEnabled = true
            
            
            let lButton = ActionButton(type: .custom)
            lButton.setupAction()
            lButton.backgroundColor = UIColor.clear
            lButton.frame = CGRect(x: self.footerView.frame.size.width - 170, y: 0, width: 160, height: 40)
            
            lButton.touchUp = { button in
                let vc : ReviewListVC  = ReviewListVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                let value = self.getReviewType()
                vc.viewModel.reivewType = value.0
                
                vc.Id = value.1
                vc.viewModel.total_reviews = self.viewModel.vendorDetail?.reviewRatings?.reviews?.total ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            self.footerView.addSubview(showMoreLabel)
            self.footerView.addSubview(lButton)
        }
    }
    
    func getReviewType() -> (String, Int) {
        var reviewType = ""
        var id : Int = 0
        switch classType {
        case .PRODUCTSVC:
            reviewType = self.viewModel.vendorDetail?.review_type ?? "p"
            id = self.viewModel.product_id
        case .CHOOSEFABRICVC:
            reviewType = "f"
            id = self.viewModel.product_id
        case .HOMEREQUESTSVC:
            reviewType = "p"
            id = self.viewModel.product_id
        case .MANUFACTURESEARCHLISTVC:
            reviewType = "s"
            if let entity_id = self.viewModel.vendorDetail?.entity_id{
                id = Int(entity_id) ?? 0
            }
        case .SELECTMODELROOTVC:
            reviewType = "p"
            id = self.viewModel.product_id
        default:
            reviewType = "p"
            id = self.viewModel.product_id
            break
        }
        return (reviewType, id)
    }
    
    func getCellForDetailView(tableView : UITableView,
                              indexPath: IndexPath) -> UITableViewCell {
        if detailClassType == .ADDTOBAG {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChooseFabricDetailCell.cellIdentifier(), for: indexPath) as! ChooseFabricDetailCell
            
            if let item = self.viewModel.vendorDetail{
                cell.selectionStyle = .none
                cell.fabricName.text = item.name
                
                if let detail = item.description, detail != ""{
                    cell.details.text = detail.getStringFromHtml()
                }
                
                cell.actualPriceLbl.text = String(format: "%@ %@",(item.currency_symbol) , (item.price_incl_tax) )
                cell.rewardPointsLbl.text = String(format: "%@ %@ %@", TITLE.customer_you_will_get.localized ,item.reward_points, TITLE.rewardPoints.localized)
                cell.actualPriceLbl.textColor = Theme.priceColor
                let special_price : Double = Double((item.special_price) ) ?? 0
                
                if !item.per_off.isEmpty || !item.special_price.isEmpty{
                    
                    cell.specialPriceLbl.text = String(format: "%@ %@",(item.currency_symbol), (item.special_price))
                    
                    cell.perOffLbl.text = "\(item.per_off)\(TITLE.customer_off.localized)"
                    
                    cell.actualPriceLbl.textColor = Theme.lightGray
                }
                
                cell.cancelLineLbl.isHidden = special_price == 0.0
                
                cell.asPerPriceLbl.text = "\(TITLE.customer_price_is.localized) \(item.price_type)"
                
                cell.minReqPriceLbl.text = "\(TITLE.customer_min_fabric_required.localized) \(self.viewModel.minFabricReq)"
                
            }
            if let item = self.viewModel.vendorDetail{
                if !item.product_pdf.isEmpty{
                    cell.fabricInfoBtn.setTitle(TITLE.customer_DownloadPdf.localized, for: .normal)
                }else{
                    cell.fabricInfoBtn.setTitle(TITLE.customer_info_plus.localized, for: .normal)
                }
            }
            
            cell.fabricInfoBtn.touchUp = { button in
                if let item = self.viewModel.vendorDetail,!item.info.isEmpty{
                    self.showInfoPopup(info: item.info, pdfURl: item.product_pdf)
                }else{
                    INotifications.show(message: TITLE.product_info_not_available.localized)
                }
            }
            
            return cell
        }
        else if detailClassType == .CHOOSESTYLE {
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerDetailCell.cellIdentifier(), for: indexPath) as! SellerDetailCell
            
            
            cell.selectionStyle = .none
            if let item = self.viewModel.vendorDetail{
                
                cell.titleLabel.text = item.name
                cell.thobeTypeLabel.text = item.categories
                
                if let detail = item.description, detail != ""{
                    cell.descriptionLabel.text = detail.getStringFromHtml()
                }
                
                cell.actualPriceLbl.text = String(format: "%@ %@",(item.currency_symbol) , (item.price_incl_tax) )
                cell.rewardPointLbl.text = String(format: "%@ %@ %@",
                                                  TITLE.customer_you_will_get.localized,
                                                  item.reward_points,
                                                  TITLE.rewardPoints.localized)
                cell.actualPriceLbl.textColor = Theme.priceColor
                
                let special_price : Double = Double((item.special_price) ) ?? 0
                
                if !item.per_off.isEmpty || !item.special_price.isEmpty{
                    
                    cell.specialPriceLbl.text = String(format: "%@ %@",(item.currency_symbol), (item.special_price))
                    
                    cell.perOffLabel.text = "\(item.per_off)\(TITLE.customer_off.localized)"
                    
                    cell.actualPriceLbl.textColor = Theme.lightGray
                }
                cell.cancelLineLabel.isHidden = special_price == 0.0
            }
            
            if let item = self.viewModel.vendorDetail{
                if !item.product_pdf.isEmpty{
                    cell.infoButton.setTitle(TITLE.customer_DownloadPdf.localized, for: .normal)
                }else{
                    cell.infoButton.setTitle(TITLE.customer_info_plus.localized, for: .normal)
                }
            }
            
            cell.infoButton.touchUp = { button in
                if let item = self.viewModel.vendorDetail,!item.info.isEmpty || item.info.isEmpty && !item.product_pdf.isEmpty{
                    self.showInfoPopup(info: item.info, pdfURl: item.product_pdf)
                }else{
                    INotifications.show(message: TITLE.product_info_not_available.localized)
                }
            }
            return cell
        }
        else if detailClassType == .ADDTOCART {
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerDetailQDDCell.cellIdentifier(), for: indexPath) as! SellerDetailQDDCell
            
            if LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue{
                cell.soldByView.isHidden = false
                cell.soldByViewHeight.constant = 28
            }else{
                cell.soldByView.isHidden = true
                cell.soldByViewHeight.constant = 0
            }
            cell.selectionStyle = .none
            if let item = self.viewModel.vendorDetail {
                cell.vendorNameButton.setTitle(item.vendor_name, for: .normal)
                cell.vendorNameButton.touchUp = { button in
                    
                    if self.isFromCategoryType == true {
                        if self.classType == .PRODUCTSVC{
                            self.delegate?.getSelectedID(vandorID:item.vendor_id , categoryID: 0, isSortFilterApply: false)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            let vc = ProductsVC.loadFromNib()
                            vc.vendarID = item.vendor_id
                            vc.viewModel.category_id = self.viewModel.category_id; self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        if self.classType == .PRODUCTSVC{
                            self.delegate?.getSelectedID(vandorID:item.vendor_id , categoryID: 0, isSortFilterApply: false)
                            self.navigationController?.popViewController(animated: true)
                        }else {
                            let vc = ProductsVC.loadFromNib()
                            vc.vendarID = item.vendor_id
                            vc.viewModel.category_id = self.viewModel.category_id; self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                
                self.quantityTxtField = cell.quatityTxtFiled
                self.quantityTxtField?.delegate = self
                
                if let qty = self.viewModel.vendorDetail?.qty_promotion{
                    cell.quatityTxtFiled.text = qty
                }else{
                    cell.quatityTxtFiled.text = "1"
                }
                
                if editQty == true{
                    if self.viewModel.qty != 0{
                        cell.quatityTxtFiled.text = String(self.viewModel.qty)
                    }else{
                        cell.quatityTxtFiled.text = "0"
                    }
                    
                    if self.viewModel.qty != 0{
                        self.counter = self.viewModel.qty
                    }else{
                        self.counter = 1
                    }
                    
                    cell.plusButton.touchUp = { button in
                        self.counter += 1
                        cell.quatityTxtFiled.text = String(self.counter)
                    }
                    
                    cell.minusButton.touchUp = { button in
                        if self.counter > 1{
                            self.counter -= 1
                        }
                        cell.quatityTxtFiled.text = String(self.counter)
                    }
                } else {
                    if self.viewModel.vendorDetail?.qty_promotion == "" || self.viewModel.vendorDetail?.qty_promotion == "0"{
                        self.counter = 1
                        cell.quatityTxtFiled.text = String(self.counter)
                    }else{
                        self.counter = Int(self.viewModel.vendorDetail?.qty_promotion ?? "0") ?? 0
                        cell.quatityTxtFiled.text = String(self.counter)
                    }
                    
                    cell.plusButton.touchUp = { button in
                        self.counter += 1
                        cell.quatityTxtFiled.text = String(self.counter)
                    }
                    
                    cell.minusButton.touchUp = { button in
                        if self.counter > 1{
                            self.counter -= 1
                        }
                        cell.quatityTxtFiled.text = String(self.counter)
                    }
                }
                
                if let deliveryDate = self.viewModel.vendorDetail?.delivery_date{
                    cell.deliveryDateTxtFiled.text = deliveryDate
                    COMMON_SETTING.deliveryDate = deliveryDate
                }
                
                self.deliveryDateTxtFiled = cell.deliveryDateTxtFiled
                self.deliveryDateTxtFiled?.delegate = self
                
                let isReadyMade : Bool = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue
                cell.dateView.isHidden = isReadyMade
                cell.dateViewHeight.constant = isReadyMade ? 0 : 30
                
                cell.titleLabel.text = item.name
                cell.thobeTypeLabel.text = item.categories
                
                if let detail = item.description, detail != ""{
                    cell.descriptionLabel.text = detail.getStringFromHtml()
                }
                cell.actualPriceLbl.text = String(format: "%@ %@",(item.currency_symbol) , (item.price_incl_tax) )
                cell.rewardPointLbl.text = String(format: "%@ %@ %@",
                                                  TITLE.customer_you_will_get.localized,
                                                  item.reward_points,
                                                  TITLE.rewardPoints.localized)
                cell.actualPriceLbl.textColor = Theme.priceColor
                
                let special_price : Double = Double((item.special_price) ) ?? 0
                
                if !item.per_off.isEmpty || !item.special_price.isEmpty{
                    
                    cell.specialPriceLbl.text = String(format: "%@ %@",(item.currency_symbol), (item.special_price))
                    
                    cell.perOffLabel.text = "\(item.per_off)\(TITLE.customer_off.localized)"
                    
                    cell.actualPriceLbl.textColor = Theme.lightGray
                }
                cell.cancelLineLabel.isHidden = special_price == 0.0
            }
            
            if let time = self.viewModel.vendorDetail?.aprox_delivery{
                cell.delievryTimeLable.text = TITLE.customer_delivery_time.localized + ": " + time
            }
            
            if let item = self.viewModel.vendorDetail{
                if !item.product_pdf.isEmpty{
                    cell.infoButton.setTitle(TITLE.customer_DownloadPdf.localized, for: .normal)
                }else{
                    cell.infoButton.setTitle(TITLE.customer_info_plus.localized, for: .normal)
                }
            }
            
            cell.infoButton.touchUp = { button in
                if let item = self.viewModel.vendorDetail,!item.info.isEmpty || item.info.isEmpty && !item.product_pdf.isEmpty{
                    self.showInfoPopup(info: item.info, pdfURl: item.product_pdf)
                }else{
                    INotifications.show(message: TITLE.product_info_not_available.localized)
                }
            }
            return cell
        }
        else if detailClassType == .READYMADE {
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerDetailCell.cellIdentifier(), for: indexPath) as! SellerDetailCell
            
            cell.selectionStyle = .none
            if let item = self.viewModel.vendorDetail{
                cell.titleLabel.text = item.name
                cell.thobeTypeLabel.text = item.categories
                if let detail = item.description, detail != ""{
                    cell.descriptionLabel.text = detail.getStringFromHtml()
                }
                
                cell.actualPriceLbl.text = String(format: "%@ %@",(item.currency_symbol) , (item.price_incl_tax) )
                cell.rewardPointLbl.text = String(format: "%@ %@ %@",
                                                  TITLE.customer_you_will_get.localized,
                                                  item.reward_points,
                                                  TITLE.rewardPoints.localized)
                cell.actualPriceLbl.textColor = Theme.priceColor
                
                let special_price : Double = Double((item.special_price) ) ?? 0
                
                if !item.per_off.isEmpty || !item.special_price.isEmpty{
                    
                    cell.specialPriceLbl.text = String(format: "%@ %@",(item.currency_symbol), (item.special_price))
                    
                    cell.perOffLabel.text = "\(item.per_off)\(TITLE.customer_off.localized)"
                    
                    cell.actualPriceLbl.textColor = Theme.lightGray
                }
                cell.cancelLineLabel.isHidden = special_price == 0.0
            }
            
            if let item = self.viewModel.vendorDetail{
                if !item.product_pdf.isEmpty{
                    cell.infoButton.setTitle(TITLE.customer_DownloadPdf.localized, for: .normal)
                }else{
                    cell.infoButton.setTitle(TITLE.customer_info_plus.localized, for: .normal)
                }
            }
            
            cell.infoButton.touchUp = { button in
                if let item = self.viewModel.vendorDetail,!item.info.isEmpty || item.info.isEmpty && !item.product_pdf.isEmpty{
                    self.showInfoPopup(info: item.info, pdfURl: item.product_pdf)
                }else{
                    INotifications.show(message: TITLE.product_info_not_available.localized)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func showInfoPopup(info : String , pdfURl : String) {
        let vc = SellerDetailInfoPopup.loadFromNib()
        vc.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 380)
        vc.infoStr = info
        vc.pdfUrl = pdfURl
        
        let popupController = STPopupController.init(rootViewController: vc)
        popupController.transitionStyle = .fade
        popupController.containerView.backgroundColor = UIColor.clear
        popupController.backgroundView?.backgroundColor = UIColor.black
        popupController.backgroundView?.alpha = 0.7
        popupController.hidesCloseButton = true
        popupController.navigationBarHidden = true
        popupController.present(in: self)
    }
    
    func shareDetails(_ productTitle : String, productDescription : String) {
        let iosURL = "https://apps.apple.com/us/app/ezar/id1450373696"
        let androidURL = "https://play.google.com/store/apps/details?id=thobe.alnaseej.alnaseejthobe&hl=en_IE"
        
        let iosWebsite = URL(string: iosURL)
        let androidWebsite = URL(string: androidURL)
        
        let productDescription = productDescription.html2String
        let shareAll = [productTitle , productDescription , iosWebsite ?? "", androidWebsite ?? ""] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showLoginPopup() {
        let alert = UIAlertController(title: TITLE.customer_login_required.localized, message: TITLE.customer_guest_alert.localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: .default, handler:{ action in
            let vc = LoginViewController.loadFromNib()
            vc.isFromUserGuest = true
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
        
    }
    
    func playButtonClicked() {
        let vc = VideoPlayerVC.loadFromNib()
        vc.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 400)
        vc.navTitle = self.viewModel.vendorDetail?.name ?? ""
        vc.videoString = self.videoUrl
        
        let popupController = STPopupController.init(rootViewController: vc)
        popupController.transitionStyle = .fade
        popupController.containerView.backgroundColor = UIColor.clear
        popupController.backgroundView?.backgroundColor = UIColor.black
        popupController.backgroundView?.alpha = 0.7
        popupController.hidesCloseButton = false
        popupController.navigationBarHidden = true
        popupController.present(in: self, completion: {
            let lButton = ActionButton(type: .custom)
            lButton.setupAction()
            lButton.backgroundColor = UIColor.clear
            lButton.frame = CGRect(x: 0, y: 0, width: MAINSCREEN.size.width, height: MAINSCREEN.size.height)
            lButton.touchUp = { button in
                popupController.dismiss()
            }
            popupController.backgroundView?.addSubview(lButton)
        })
    }
}


//MARK: - UITextFieldDelegate
extension SellerDetailVC : UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            self.deliveryDateTxtFiled = textField as? CustomTextField
            self.showDatePicker()
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if self.quantityTxtField == textField {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if(newString.isEmpty) {
                return true
            }
            
            //check if the string is a valid number
            let numberValue = Int(newString)
            if(numberValue == nil) {
                return false
            }
            
            if numberValue! > COMMON_SETTING.max_capacity {
                INotifications.show(message: "\(TITLE.Max.localized) \(COMMON_SETTING.max_capacity) \(TITLE.Quantity.localized)")
                return false
            } else if numberValue == 0 {
                INotifications.show(message: TITLE.customer_nonZero_Quantity.localized)
                return false
            }
            return true
        }
        return true
    }
}

//MARK: - Tap gesture
extension SellerDetailVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === self.footerView || touch.view === self.productSizeView {
            return true
        }
        return false
    }
}

//MARK: - LocationGetter Delegate Methods
extension SellerDetailVC : LocationGetterDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        self.lat = location.coordinate.latitude
        self.long = location.coordinate.longitude
    }
}

//MARK: - BROADCAST
extension SellerDetailVC : SelectBrodCastViewDelegate {
    func onClickBrodCastView(_ type: Bool) {
        self.broadCastType = type
        self.customPlacesVcPresent()
    }
}

//MARK: - CustomMapVCDelegate
extension SellerDetailVC : CustomMapVCDelegate {
    func getLocationData(_ lat: Double, _ long: Double, _ name: String?, _ address: String?) {
        
        self.dismiss(animated: true, completion: nil)
        let vc = EditAddressVC.loadFromNib()
        COMMON_SETTING.isFromSellerRequest = true
        
        if let shoppingArray = self.viewModelShoppingBag.shoppingBagItems?.shoppingBagItemList{
            for item in shoppingArray {
                if item.iProduct_id == self.viewModel.vendorDetail?.id{
                    
                    let item_quote_id : String = item.item_quote_id
                    vc.quoteID = item.quote_id
                    var productId : String = item.sProduct_id
                    if productId.isEmpty{
                        productId = String(format: "%d", item.iProduct_id )
                    }
                    vc.productID = productId
                    vc.viewModel.requestDelegateModel.productId = productId
                    vc.viewModel.requestDelegateModel.quote_id = item_quote_id
                    
                    vc.viewModel.requestDelegateModel.setRequestFor(item_quote_id: item_quote_id, type: "measurement")//requestType)
                    vc.broadCastViewModel.requestDelegateModel.setRequestFor(item_quote_id: item_quote_id, type: "measurement")//requestType)
                }
            }
        }
        
        if let data = self.viewModelShoppingBag.shoppingBagItems?.cart_request_status {
            var request_instruction = data.request_instruction
            request_instruction?.mobileNumber = data.mobile_number
            vc.viewModel.requestDelegateModel.request_id = data.request_id
            vc.viewModel.requestDelegateModel.mobile_number = data.mobile_number
            vc.viewModel.requestDelegateModel.countryCode = data.country_code
        }
        
        let latitude = String(format: "%.4f", lat)
        let longitude = String(format: "%.4f", long)
        vc.lat = latitude
        vc.long = longitude
        
        vc.customerAddress = address ?? "No Address"
        vc.viewModel.requestDelegateModel.latitude = latitude
        
        vc.viewModel.requestDelegateModel.longitude = longitude
        vc.viewModel.requestDelegateModel.customerAddress = address ?? "No Address"
        
        vc.isRequestDelegate = true
        vc.isfromBroadCast = self.broadCastType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - API CALL
extension SellerDetailVC {
    func getWebserviceCall() {
        switch detailClassType {
        case .CHOOSESTYLE:
            productDetailsWS()
            break
        case .ADDTOBAG:
            setupUI()
            getFabricDetailsWS()
            break
        case .READYMADE:
            readyMadeProductDetailsWS()
            break
        default:
            break
        }
    }
    
    func getFabricDetailsWS(){
        self.viewModel.getFabricDetails {
            self.tableView.reloadData()
        }
    }
    
    func readyMadeProductDetailsWS() {
        self.viewModel.getReadyMadeProductDetails {
            if self.viewModel.statusCode != 200 {
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.startFrom = self.viewModel.vendorDetail?.all_options.count != 0 ? "\(self.startFrom)" : ""
            self.bottomBtnTitle = self.detailClassType == .CHOOSESTYLE ? TITLE.chooseStyles.localized :  TITLE.addToCart.localized
            self.detailClassType = self.detailClassType == .CHOOSESTYLE ? .CHOOSESTYLE :  .ADDTOCART
            self.detailClassType = .ADDTOCART
            self.bottomView = ContainerView()
            self.setupUI()
            self.setupTableView()
            self.setupNavigation()
            self.tableView.reloadData()
        }
    }
    
    func productDetailsWS() {
        self.viewModel.getProductDetails {
            if self.viewModel.statusCode != 200 {
                self.navigationController?.popViewController(animated: true)
                return
            }
            if self.viewModel.vendorDetail?.delegate_available == 0 {
                self.delay(1) {
                    COMMON_SETTING.showAlertController(icon: UIImage(named: "info"),
                                                       title: "",
                                                       message: "delegate_available".localized)
                }
            }
            
            self.bottomBtnTitle = self.detailClassType == .CHOOSESTYLE ? TITLE.chooseStyles.localized :  TITLE.addToCart.localized
            self.detailClassType = self.detailClassType == .CHOOSESTYLE ? .CHOOSESTYLE :  .ADDTOCART
            self.detailClassType = self.viewModel.is_promotion == 1 ? .ADDTOCART :  .CHOOSESTYLE
            
            self.bottomView = ContainerView()
            self.setupUI()
            self.setupNavigation()
            if self.isFromSelectModelRootVC {
                self.setUpChooseStyle()
            } else {
                self.tableView.reloadData()
            }
        }
    }
}
