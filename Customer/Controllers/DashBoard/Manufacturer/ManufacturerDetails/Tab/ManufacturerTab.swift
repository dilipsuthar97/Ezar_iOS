//
//  ManufacturerTab.swift
//  Business
//
//  Created by Volkoff on 28/04/22.
//

import UIKit
import XLPagerTabStrip
import STPopup

class ManufacturerTab: ButtonBarPagerTabStripViewController {
        
    var sellerViewModel: SellerViewModel = SellerViewModel()
    var viewModelSubcategory : SubCategoryViewModel = SubCategoryViewModel()

    var videoUrl: String = ""
    var isRatingAvail: Bool = false
    var reviewIdDictionary : [NSMutableDictionary] = [[:]]
    lazy var footerView : UIView = UIView()

    var childVC: [ManufacturerDetailsVC] = []

    //MARK: - IBOutlet
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
        }
    }
    @IBOutlet var segmentControl: UISegmentedControl!

    @IBOutlet var scroView: UIScrollView!
    @IBOutlet var TabWidth: NSLayoutConstraint!
    @IBOutlet var tabViewHeight: NSLayoutConstraint! {
        didSet{
            tabViewHeight.constant = 40
        }
    }

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = Theme.primaryColor
        settings.style.buttonBarItemFont = FontType.regular(size: 16)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemTitleColor = UIColor.gray
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarItemLeftRightMargin = 0
        COMMON_SETTING.manufacturerIndex = 0

        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?,
                                          newCell: ButtonBarViewCell?,
                                          progressPercentage: CGFloat,
                                          changeCurrentIndex: Bool,
                                          animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.gray
            newCell?.label.textColor = Theme.primaryColor
        }
        
        super.viewDidLoad()
        configureUI()
        setupTableView()
        sellerDetailsWebservice()
        let vc = self.childVC[COMMON_SETTING.manufacturerIndex]
        vc.collectionView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.moveToViewController(at: COMMON_SETTING.manufacturerIndex, animated: true)
        self.updateContent()
        self.delay(0.1) {
            let vc = self.childVC[COMMON_SETTING.manufacturerIndex]
            vc.viewModelSubcategory = self.viewModelSubcategory
            vc.collectionView?.isHidden = false
            vc.changeView()
        }
    }
      
    private func configureUI() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for: .normal)
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentControl.setTitle("seller_bio".localized, forSegmentAt: 0)
        segmentControl.setTitle(TITLE.model.localized, forSegmentAt: 1)
    }
    
    func setupNavigation()  {
        navigationItem.title = TITLE.select_model.localized
        setNavigationBarHidden(hide: false)
        setLeftButton()
    }
        
    //MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        childVC.removeAll()
        guard let childCategories = self.viewModelSubcategory.subcategoryDetails?.childCategories else {
            return childVC
        }

        for i in 0..<childCategories.count {
            let vc = ManufacturerDetailsVC(nibName: String(describing: ManufacturerDetailsVC.self), bundle: nil)
            vc.setup(itemInfo: IndicatorInfo(title: childCategories[i].subcategory_name.capitalized), params: nil)
            vc.viewModelSubcategory = self.viewModelSubcategory
            childVC.append(vc)
        }
        return childVC
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController,
                                  fromIndex: Int,
                                  toIndex: Int,
                                  withProgressPercentage progressPercentage: CGFloat,
                                  indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex,
                              toIndex: toIndex,
                              withProgressPercentage: progressPercentage,
                              indexWasChanged: indexWasChanged)
        if progressPercentage > 0 {
            if indexWasChanged {
                self.delay(0) {
                    COMMON_SETTING.manufacturerIndex = toIndex
                    let vc = self.childVC[COMMON_SETTING.manufacturerIndex]
                    vc.viewModelSubcategory = self.viewModelSubcategory
                    vc.changeView()
                }
            }
        }
    }
    
    @IBAction func onClickSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tabViewHeight.constant = 0
            tableView.isHidden = false
            scroView.isScrollEnabled = false
            tableView.reloadData()
        } else {
            tabViewHeight.constant = 40
            tableView.isHidden = true
            scroView.isScrollEnabled = true
        }
        view.layoutIfNeeded()
    }

    func getReviewType() -> (String, Int) {
        return ("p", self.sellerViewModel.product_id)
    }

    func setupTableView() {
        tableView.register(UINib(nibName: SellerImageCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerImageCell.cellIdentifier())
        tableView.register(UINib(nibName: SellerReviewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerReviewCell.cellIdentifier())
        tableView.register(UINib(nibName: SelectModelDetailCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SelectModelDetailCell.cellIdentifier())
        tableView.register(UINib(nibName: SellerDetailQDDCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: SellerDetailQDDCell.cellIdentifier())

        let headerView = UINib.init(nibName: "SellerDetailHeaderView", bundle: Bundle.main)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "SellerDetailHeaderView")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func playButtonClicked() {
        let vc = VideoPlayerVC.loadFromNib()
        vc.contentSizeInPopup = CGSize(width: self.view.frame.width - 30, height: 400)
        vc.navTitle = self.sellerViewModel.vendorDetail?.name ?? ""
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
    
    func viewForFooterInTableView() {
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
            vc.viewModel.total_reviews = self.sellerViewModel.vendorDetail?.reviewRatings?.reviews?.total ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.footerView.addSubview(showMoreLabel)
        self.footerView.addSubview(lButton)
    }
    
    func showLoginPopup() {
        let alert = UIAlertController(title: TITLE.customer_login_required.localized,
                                      message: TITLE.customer_guest_alert.localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: TITLE.yes.localized,
                                      style: .default,
                                      handler:{ action in
            let vc = LoginViewController.loadFromNib()
            vc.isFromUserGuest = true
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: TITLE.no.localized,
                                      style: .cancel,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
        
    }
}

//MARK: - UITableViewDataSource
extension ManufacturerTab : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return sellerViewModel.reviewList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SellerImageCell.cellIdentifier(), for: indexPath) as! SellerImageCell
                cell.selectionStyle = .none
                if let item = self.sellerViewModel.vendorDetail?.storeData {
                    cell.bannerImageList = item.banners
                    cell.logoUrl = item.logo
                    cell.playButton.setImage(UIImage(named : "play_Icon")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
                    cell.ratingView.isHidden = !self.isRatingAvail
                    if let review = self.sellerViewModel.vendorDetail?.reviewRatings,
                       review.rating != "0" {
                        cell.ratingView.isHidden = false
                        cell.ratingStar.value = COMMON_SETTING.getTheStarRatingValue(rating: review.rating)
                    } else {
                        cell.ratingView.isHidden = true
                    }
                    
                    if !item.video.isEmpty {
                        cell.playButton.isHidden = false
                        self.videoUrl = item.video
                    } else {
                        cell.playButton.isHidden =  true
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
        let item = sellerViewModel.reviewList[indexPath.row]
        
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
            if (LocalDataManager.getGuestUser()){
                self.showLoginPopup()
                return
            }
            self.sellerViewModel.review_id = item.review_id
            self.sellerViewModel.upVote = 1
            let value = self.getReviewType()
            self.sellerViewModel.reivewType = value.0
            if !(self.keyValue(review_id: item.review_id ?? -1,
                               checkValue: 1,
                               removeValue: 0)) {
                self.sellerViewModel.setReviewLikeDislike {
                    let dic : NSMutableDictionary = [item.review_id ?? 0 : self.sellerViewModel.upVote ?? -1]
                    self.reviewIdDictionary.append(dic)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        
        cell.dislikeBtn.touchUp = { button in
            if (LocalDataManager.getGuestUser()){
                self.showLoginPopup()
                return
            }
            self.sellerViewModel.review_id = item.review_id
            self.sellerViewModel.upVote = 0
            self.sellerViewModel.reivewType = self.getReviewType().0
            if !(self.keyValue(review_id: item.review_id ?? -1,
                               checkValue: 0,
                               removeValue: 1)) {
                self.sellerViewModel.setReviewLikeDislike {
                    let dic : NSMutableDictionary = [item.review_id ?? 0 : self.sellerViewModel.upVote ?? -1]
                    self.reviewIdDictionary.append(dic)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        cell.selectionStyle = .none
        self.viewForFooterInTableView()
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        
        if sellerViewModel.reviewList.count > 0 {
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
        if indexPath.section == 0,
           indexPath.row == 0 {
            return MAINSCREEN.height - (MAINSCREEN.height/3)
        }
        return UITableView.automaticDimension
    }
    
    func getCellForDetailView(tableView : UITableView,
                              indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectModelDetailCell.cellIdentifier(),
                                                 for: indexPath) as! SelectModelDetailCell
        if let item = self.sellerViewModel.vendorDetail{
            cell.selectionStyle = .none
            cell.vendorName.text = item.storeData?.name
            cell.ratingView.isHidden = true
            cell.reviewCountLabel.isHidden = true
            cell.ratingLabel.isHidden = true
            cell.vendorAddress.text = item.address
            if let detail = item.storeData?.short_description,
               detail != "" {
                cell.vendorDetailLabel.text = detail
            } else {
                cell.vendorDetailLabel.text = TITLE.noDescription.localized
            }
        }
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
}

//MARK: - API CALL
extension ManufacturerTab {
    func sellerDetailsWebservice() {
        sellerViewModel.getVendorDetails {
            self.tableView.reloadData()
        }
    }
}
