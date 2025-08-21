//
//  HomeRequestsVC.swift
//  Customer
//
//  Created by webwerks on 21/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import SDWebImage
import STPopup

protocol HomeVCDelegate {
    func navigateToSearch(categoryID : Int, productId : Int, categoryName : String, max_capacity : String, index : Int, isPromotion : Bool ,promoType :String , isFromExploreMore : Bool)
}

class HomeRequestsVC: BaseViewController {
    
    //MARK: - Variable declaration
    var viewModel : HomeRequestsViewModel = HomeRequestsViewModel()
    var viewModelProfile = ProfileViewModel()
    var dotMenuView : DotMenuView!
    var index :Int?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        COMMON_SETTING.max_capacity = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue ? 999 : 0
        setupColletionView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        homeCategoryAPICall()
        homeExploreMoreProductAPICall()
        homePromotionsAPICall()
        registerDeviceTokenForNotification()
        myAccountApiCall()
    }

    private func setupNavigation() {
        setNavigationBarHidden(hide: false)
        setUpSideMenu()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo1")
        imageView.image = image
        navigationItem.titleView = imageView
        setRightButtonsArray(buttonArray: ["Search",
                                                "Notifications",
                                                "threeDots"])
    }
    
    func setUpSideMenu() {
        let navigationButton =  self.navigationItem.leftButton(imgName: "ic_menu")
        navigationButton.touchUp = { button in
            self.panel?.openPandel()
        }
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "SideViewContoller"),
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.gotoViewController(notification:)),
                                               name: NSNotification.Name(rawValue: "SideViewContoller"),
                                               object: nil)
    }
    
    
    func setupColletionView() {
        collectionView.register(UINib(nibName: HomeApprovedRequestCell.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: HomeApprovedRequestCell.cellIdentifier())
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: NormalTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: NormalTableCell.cellIdentifier())
        tableView.register(UINib(nibName: PromotionTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: PromotionTableViewCell.cellIdentifier())
        tableView.register(UINib(nibName: CustomCollectionTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: CustomCollectionTableCell.cellIdentifier())
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
        
    override func onClickRightButton(button: UIButton) {
        if button.tag == 0 {
            let vc = SearchVC.loadFromNib()
            vc.searchType = .HOMESEARCH
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if button.tag == 1 {
            let vc = NotificationsViewController.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if button.tag == 2 {
            self.addDotMenuView()
        }
    }
    
    @objc
    func gotoViewController(notification: NSNotification)  {
        let index = notification.userInfo?["index"] as? Int
        switch index {
        case SideMenuIndex.home.key:
            self.setTabBarIndex(index: 0)
            break
        case SideMenuIndex.profile.key:
            if (LocalDataManager.getGuestUser()){
               self.showLoginPopup()
               return
            }
            
            self.setTabBarIndex(index: 3)
            break
        case SideMenuIndex.my_account.key:
            if (LocalDataManager.getGuestUser()){
               self.showLoginPopup()
               return
            }
            self.setTabBarIndex(index: 3)
            break
        case SideMenuIndex.measurements.key:
            if (LocalDataManager.getGuestUser()){
                self.showLoginPopup()
                return
            }
            let vc = MeasurementVC.loadFromNib()
            vc.isProfileMeasurement = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case SideMenuIndex.scanIntro.key:
            let vc = ScanBodyMeasurementVC.loadFromNib()
            vc.isFromIntro = true
            self.navigationController?.pushViewController(vc, animated: true)
        case SideMenuIndex.settings.key:
            if (LocalDataManager.getGuestUser()) {
                self.showLoginPopup()
                return
            }
            let vc = SettingsViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case SideMenuIndex.termsAndCondition.key:
            if (LocalDataManager.getGuestUser()) {
               self.showLoginPopup()
               return
            }
            let vc = TermsAndConditionVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case SideMenuIndex.privacy_policy.key:
            if (LocalDataManager.getGuestUser()) {
               self.showLoginPopup()
               return
            }
            let vc = PrivacyPolicyVC(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case SideMenuIndex.help.key:
            if (LocalDataManager.getGuestUser()) {
               self.showLoginPopup()
               return
            }
            let vc = HelpViewController(nibName: String(describing: BaseTableViewController.self),
                             bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case SideMenuIndex.offer.key:
            if (LocalDataManager.getGuestUser()) {
               self.showLoginPopup()
               return
            }
            let vc = OfferVC.loadFromNib()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case SideMenuIndex.invite_friends.key:
            if (LocalDataManager.getGuestUser()) {
               self.showLoginPopup()
               return
            }
            inviteFriends()
            break

        case SideMenuIndex.whatsApp_us.key:
            if (LocalDataManager.getGuestUser()) {
               self.showLoginPopup()
               return
            }
            openWhatapp()
            break
        default:
            break
        }
    }
    
    func inviteFriends() {
        let vc = InviteFriendsVC.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openWhatapp() {
        let profile = Profile.loadProfile()
        let whatsapp_us  = profile?.whatsapp_us
        let mobile_number = whatsapp_us
        if let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(mobile_number ?? "")"){
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                }
                else {
                    UIApplication.shared.openURL(appURL)
                }
            }
        } else {
            if let appURL = URL(string: "https://wa.me/\(mobile_number ?? "")"){
                if UIApplication.shared.canOpenURL(appURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                }
            }
        }
    }
    
    func showLoginPopup(){
        let alert = UIAlertController(title: "customer_login_required".localized,
                                      message: "customer_guest_alert".localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes".localized,
                                      style: .default,
                                      handler:{ action in
            let vc = LoginViewController.loadFromNib()
            vc.isFromUserGuest = true
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "no".localized,
                                      style: .cancel,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func addDotMenuView() {
        self.view.alpha = 0.5
        self.dotMenuView = Bundle.main.loadNibNamed("DotMenuView", owner: DotMenuView.self, options: nil)![0] as? DotMenuView
        self.dotMenuView.delegate = self
        self.dotMenuView.backgroundColor = Theme.darkGray.withAlphaComponent(0.8)

        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.removeDotMenuView))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.dotMenuView?.addGestureRecognizer(tapGesture)
        self.view.window?.addSubview(self.dotMenuView)
    }
    
    @objc func removeDotMenuView() {
        self.view.alpha = 1.0
        self.dotMenuView?.removeFromSuperview()
    }
}

//MARK: - Dot Menu Delegate Methods
extension HomeRequestsVC : DotMenuViewDelegate {
    func onClickCloseInfoBtn() {
        self.removeDotMenuView()
    }
    
    func getGenderSelectionAction(isFemale: Bool) {
        self.removeDotMenuView()
        self.viewModel = HomeRequestsViewModel()
        self.homeCategoryAPICall()
        self.homeExploreMoreProductAPICall()
        self.homePromotionsAPICall()
        DispatchQueue.main.async() {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    func getLanguageSelectionAction(isArabic: Bool) {            EzarApp.setLanguageRootViewController(isArabic: isArabic)
        removeDotMenuView()
    }
    
    func getProductTypeSelectionAction(isCustomMade: Bool) {
        removeDotMenuView()
        viewModel = HomeRequestsViewModel()
        COMMON_SETTING.max_capacity = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue ? 999 : 0
        homeCategoryAPICall()
        homeExploreMoreProductAPICall()
        homePromotionsAPICall()
        DispatchQueue.main.async() {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
}

//MARK:- Tap gesture
extension HomeRequestsVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === self.dotMenuView {
            return true
        }
        return false
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeRequestsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 240)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:5, left: 5, bottom: 5, right: 5)
    }
}


//MARK: - UICollectionViewDataSource
extension HomeRequestsVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.viewModel.homeCategoryList?.categories.count ?? 0
        }
        else{
            return self.viewModel.exploreProductList?.categories.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeApprovedRequestCell.cellIdentifier(),
                                                      for: indexPath) as! HomeApprovedRequestCell
        if collectionView.tag == 0 {
            let homeCategory = self.viewModel.homeCategoryList?.categories[indexPath.row]
            cell.titleLbl.text = homeCategory?.name
            cell.titleLblHeightConstraints.constant = 0
            if let img = homeCategory?.imageUrl {
                cell.productImage.setShowActivityIndicator(true)
                cell.productImage.setIndicatorStyle(UIActivityIndicatorView.Style.medium)
                cell.productImage.sd_setImage(with: URL(string: img),
                                              placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
            cell.layoutIfNeeded()
            return cell
        } else {
            let homeExploreCategory = self.viewModel.exploreProductList?.categories[indexPath.row]
            cell.titleLbl.text = homeExploreCategory?.name
            if let img = homeExploreCategory?.imageUrl {
                cell.productImage.setShowActivityIndicator(true)
                cell.productImage.setIndicatorStyle(UIActivityIndicatorView.Style.medium)
                cell.productImage.sd_setImage(with: URL(string: img),
                                              placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if self.viewModel.homeCategoryList?.categories.count ?? 0 > 0 {
            let homeCategory = self.viewModel.homeCategoryList?.categories[indexPath.row]
            self.navigateToSearch(categoryID: homeCategory?.id ?? 0,
                                  productId: 0,
                                  categoryName: homeCategory?.name ?? "",
                                  max_capacity: homeCategory?.max_capacity ?? "",
                                  index: indexPath.row,
                                  isPromotion: false, promoType: "",
                                  isFromExploreMore: false)
        }
    }
}

//MARK: - UITableViewDataSource
extension HomeRequestsVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            return self.viewModel.bottomPromotionsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: PromotionTableViewCell.cellIdentifier(),
                                                         for: indexPath) as! PromotionTableViewCell
                cell.selectionStyle = .none
                self.index = indexPath.row
                cell.delegate = self
                cell.backgroundColor = UIColor.clear
                cell.promotionList = self.viewModel.homePromotions
                cell.collectionView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
                cell.collectionView.reloadData()
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomCollectionTableCell.cellIdentifier(),
                                                         for: indexPath) as! CustomCollectionTableCell
                cell.selectionStyle = .none
                cell.delegate = self
                self.index = indexPath.row
                cell.backgroundColor = UIColor.clear
                cell.categoryTitleLabel.text = TITLE.ExploreMoreProducts.localized
                cell.viewModel = self.viewModel
                cell.collectionView.backgroundColor = indexPath.row == 0 ? UIColor.black : UIColor.white
                if self.viewModel.exploreProductList?.categories.count ?? 0 > 0{
                    cell.categoryTitleLabel.isHidden = false
                    cell.categoryTitleLabelHeight.constant = 28
                    cell.viewTop.constant = 10
                } else {
                    cell.categoryTitleLabel.isHidden = true
                    cell.categoryTitleLabelHeight.constant = 0
                    cell.viewTop.constant = 0
                }
                cell.collectionView.reloadData()
                return cell
            default:
                return UITableViewCell()
            }
        } else {
            if viewModel.bottomPromotionsList.count > 0 {
                let promotion = viewModel.bottomPromotionsList[indexPath.row]
                self.index = indexPath.row
                return configurePromotionalCell(promotion: promotion, indexPath : indexPath)
            }else{
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                guard let promotionTableViewCell = cell as? PromotionTableViewCell else{return}
                DispatchQueue.main.async {
                    promotionTableViewCell.setCollectionViewDataSourceDelegate()
                }
                
            case 1:
                guard let customCollectionTableCell = cell as? CustomCollectionTableCell else{return}
                DispatchQueue.main.async { customCollectionTableCell.setCollectionViewDataSourceDelegate()//indexPath.row)
                }
            default:
                break
            }
        }
    }
    
    func configurePromotionalCell(promotion: HomePromotion,
                                  indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NormalTableCell.cellIdentifier(), for: indexPath) as! NormalTableCell
        cell.selectionStyle = .none
        cell.imgView.contentMode = .scaleToFill
        cell.imgView.setShowActivityIndicator(true)
        cell.imgView.setIndicatorStyle(UIActivityIndicatorView.Style.medium)
        cell.imgView.sd_setImage(with: URL(string: promotion.promotionImageUrl),
                                      placeholderImage: #imageLiteral(resourceName: "placeholder"))
        return cell
    }
    
    //New Change
    func imageResize(_ image:UIImage)-> UIImage{
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 220)
        let hasAlpha = true
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if self.viewModel.homePromotions.count > 0 {
                    return 240
                }else{
                    return 0
                }
            case 1:
                if self.viewModel.exploreProductList?.categories.count ?? 0 > 0 {
                    return 230
                } else {
                    return 0
                }
            default:
                return 0
            }
        } else {
            if viewModel.bottomPromotionsList.count > 0 {
                return 230
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if viewModel.homePromotions.count > 0{
                    let promotion = viewModel.homePromotions[indexPath.row]
                    let max_cap : String = String(format : "%d", promotion.max_capacity)
                    self.navigateToSearch(categoryID: promotion.parent_category_id,
                                          productId: promotion.promotionId,
                                          categoryName: "",
                                          max_capacity: max_cap,
                                          index: indexPath.row,
                                          isPromotion: true,
                                          promoType: promotion.promotionType,
                                          isFromExploreMore: false)
                }
            }
        } else {
            if viewModel.bottomPromotionsList.count > 0{
                let promotion = viewModel.bottomPromotionsList[indexPath.row]
                let max_cap : String = String(format : "%d", promotion.max_capacity)
                self.navigateToSearch(categoryID: promotion.parent_category_id,
                                      productId: promotion.promotionId,
                                      categoryName: "",
                                      max_capacity: max_cap,
                                      index: indexPath.row,
                                      isPromotion: true,
                                      promoType: promotion.promotionType,
                                      isFromExploreMore: false)
            }
        }
    }
}

//MARK: - HomeVCDelegate
extension HomeRequestsVC: HomeVCDelegate {
    func navigateToSearch(categoryID: Int,
                          productId: Int,
                          categoryName: String,
                          max_capacity: String,
                          index: Int,
                          isPromotion: Bool,
                          promoType: String,
                          isFromExploreMore: Bool) {
        COMMON_SETTING.max_capacity = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue ? 999 : 0
        if isPromotion == false {
            if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                let vc = ManufacturerVC.loadFromNib()
                vc.viewModel.category_id = categoryID
                vc.viewModel.categoryName = categoryName
                vc.viewModel.max_capacity = max_capacity
                vc.selectedIndex = index
                vc.isPromotion = isPromotion
                vc.homeViewModel = self.viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = ProductsVC.loadFromNib()
                vc.viewModel.current_page = 1
                vc.viewModel.category_id = categoryID//isPromotion ? productId : categoryID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if promoType == "category"{
                if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                    let vc = ManufacturerVC.loadFromNib()
                    vc.viewModel.category_id = categoryID
                    vc.viewModel.categoryName = categoryName
                    vc.viewModel.max_capacity = max_capacity
                    vc.selectedIndex = index
                    vc.isPromotion = false
                    vc.homeViewModel = self.viewModel
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let vc = ProductsVC.loadFromNib()
                    vc.viewModel.current_page = 1
                    vc.viewModel.category_id = isPromotion ? productId : categoryID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                    let vc = SellerDetailVC.loadFromNib()
                    vc.classType = .HOMEREQUESTSVC
                    vc.bottomBtnTitle = TITLE.chooseStyles.localized
                    vc.isRatingAvail = true
                    vc.viewModel.category_id = categoryID
                    vc.viewModel.product_id = productId
                    vc.detailClassType = .CHOOSESTYLE
                    vc.viewModel.is_promotion = 1
                    COMMON_SETTING.max_capacity = Int(max_capacity) ?? 0
                    self.navigationController?.pushViewController(vc, animated: false)
                }else{
                    let vc = SellerDetailVC.loadFromNib()
                    vc.classType = .HOMEREQUESTSVC
                    vc.bottomBtnTitle = TITLE.addToCart.localized
                    vc.isRatingAvail = true
                    vc.viewModel.category_id = categoryID
                    vc.viewModel.product_id = productId
                    vc.detailClassType = .READYMADE
                    vc.viewModel.is_promotion = 1
                    COMMON_SETTING.max_capacity = Int(max_capacity) ?? 0
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
}

//MARK: - UICollectionViewFlowLayout
class RTLCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            return true
        } else {
            return false
        }
    }
    
    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            return UIUserInterfaceLayoutDirection.leftToRight
        } else {
            return UIUserInterfaceLayoutDirection.rightToLeft
        }
    }
}

//MARK: - API CALL
extension HomeRequestsVC {
    
    func myAccountApiCall() {
        
        let profile = Profile.loadProfile()
        guard let customer_id = profile?.id else {
            return
        }
        
        self.viewModelProfile.customer_id = customer_id
        self.viewModelProfile.getMyAccountDetails {
            if self.viewModelProfile.responseCode == 200 {
                let profile1 = Profile.loadProfile()
                if  profile1?.mobileNo == "" {
                    let vc = MobileNumberPopupVC.loadFromNib()
                    vc.contentSizeInPopup = CGSize(width: self.view.frame.width, height:self.view.frame.height)
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
        }
    }
    
    func homeCategoryAPICall() {
        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
            if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue{
                self.viewModel.root_Category = GenderSelection.MEN.rawValue
            }else{
                self.viewModel.root_Category = GenderSelection.WOMEN.rawValue
            }
        }else{
            if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue{
                self.viewModel.root_Category = GenderSelection.MENREADYMADE.rawValue
            }else{
                self.viewModel.root_Category = GenderSelection.WOMENREADYMADE.rawValue
            }
        }
        
        self.viewModel.productType = LocalDataManager.getUserSelection()
        self.viewModel.getHomeCategory {
            APP_DELEGATE.updateBadgeCount(count: self.viewModel.homeCategoryList?.cart_count ?? 0)
            
            if self.viewModel.homeCategoryList?.categories.count ?? 0 <= 0 {
                self.noDataFoundLabel.text = self.viewModel.responseMessage
                self.noDataFoundView.isHidden = false
                self.collectionView.isHidden = true
            } else {
                self.noDataFoundView.isHidden = true
                self.collectionView.isHidden = false
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func homeExploreMoreProductAPICall() {
        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue {
            if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue {
                self.viewModel.root_Category = GenderSelection.MEN.rawValue
            } else {
                self.viewModel.root_Category = GenderSelection.WOMEN.rawValue
            }
        } else {
            if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue {
                self.viewModel.root_Category = GenderSelection.MENREADYMADE.rawValue
            } else {
                self.viewModel.root_Category = GenderSelection.WOMENREADYMADE.rawValue
            }
        }
        
        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue {
            self.viewModel.productType = ProductType.CustomMade.rawValue
        } else {
            self.viewModel.productType = ProductType.ReadyMade.rawValue
        }
        
        self.viewModel.exploreMoreProduct {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func homePromotionsAPICall() {
        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue {
            if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue {
                self.viewModel.root_Category = GenderSelection.MEN.rawValue
            } else {
                self.viewModel.root_Category = GenderSelection.WOMEN.rawValue
            }
        } else {
            if LocalDataManager.getGenderSelection() == GenderSelection.MEN.rawValue {
                self.viewModel.root_Category = GenderSelection.MENREADYMADE.rawValue
            } else {
                self.viewModel.root_Category = GenderSelection.WOMENREADYMADE.rawValue
            }
        }
        
        self.viewModel.productType = LocalDataManager.getUserSelection()
        self.viewModel.getHomePromotions {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func registerDeviceTokenForNotification() {
        viewModel.getRegisterDeviceToken {
            print("Check For Success or Failure")
        }
    }
}
