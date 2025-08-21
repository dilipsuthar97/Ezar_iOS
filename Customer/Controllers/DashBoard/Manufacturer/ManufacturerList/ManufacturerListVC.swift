//
//  ManufacturerListVC.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 3/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ManufacturerListVC: BaseViewController {
    
    //MARK: - Variable declaration
    var searchViewModel         : SearchViewModel?
    let nearestViewModel : NearestDelegateViewModel = NearestDelegateViewModel()
    var isSortFilterApply : Bool = false
    var selectedSortIndex : Int = -1
    var is_delegate_available : Int = 1

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var BgView: UIView!

    var selectedDate:String?
    var deliveryDateFetch :Date?
    var dateSelectedBtnTap : ((_ selectedDate: String) -> ())?
    let todaydate = Date()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    

    //MARK: - View LifeCycle
    @IBOutlet weak var withDelegateLabel: ActionLabel! {
        didSet {
            withDelegateLabel.text = "with_delegate".localized
            withDelegateLabel.layer.cornerRadius = 15
            withDelegateLabel.font = FontType.regular(size: 16)
        }
    }
    @IBOutlet weak var allLabel: ActionLabel!{
        didSet {
            allLabel.text = "all".localized
            allLabel.layer.cornerRadius = 15
            allLabel.font = FontType.regular(size: 16)
        }
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCalenderUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        if isSortFilterApply {
            isSortFilterApply = false
            searchViewModel?.seller_list.removeAll()
            searchViewModel?.current_page = 1
            getLatestList()
        }
    }
    
    func setupNavigation() {
        setNavigationBarHidden(hide: false)
        navigationItem.title = "customer_manufacturer_tailor".localized
        setLeftButton()
        setRightButtonsArray(buttonArray: ["searchW_Icon","sortW_Icon","filterW_Icon"])
    }
    
    private func configureUI() {
        updateWithDelegateTextColor()
        
        withDelegateLabel.touchUp = { lable in
            self.updateWithDelegateTextColor()
            self.searchViewModel?.is_delegate_available = 1
            self.searchViewModel?.seller_list.removeAll()
            self.searchViewModel?.current_page = 1
            self.getLatestList()
        }
        
        allLabel.touchUp = { label in
            self.updateAllTextColor()
            self.searchViewModel?.is_delegate_available = 0
            self.searchViewModel?.seller_list.removeAll()
            self.searchViewModel?.current_page = 1
            self.getLatestList()
        }
    }
    
    private
    func updateWithDelegateTextColor() {
        withDelegateLabel.textColor = Theme.primaryColor
        withDelegateLabel.backgroundColor = Theme.primaryBGColor
        allLabel.textColor = Theme.blackColor
        allLabel.backgroundColor = Theme.bgDarkColor
    }
    
    private
    func updateAllTextColor() {
        allLabel.textColor = Theme.primaryColor
        allLabel.backgroundColor = Theme.primaryBGColor
        withDelegateLabel.textColor = Theme.blackColor
        withDelegateLabel.backgroundColor = Theme.bgDarkColor
    }

    func configureCalenderUI() {
        self.calendar.dataSource = self
        self.calendar.delegate = self
        let date = convertDateFormater(COMMON_SETTING.deliveryDate)
        self.deliveryDateFetch = date
        self.selectedDate = fetchDateFormater(date: date)
        self.calendar.select(date)
        self.calendar.scope = .week
        self.calendar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.calendar.appearance.headerTitleColor = UIColor.black
        self.calendar.appearance.weekdayTextColor = UIColor.black
        self.calendar.appearance.weekdayFont = UIFont.init(customFont: CustomFont.FuturanM, withSize: 15)
        self.calendar.appearance.headerTitleFont = UIFont.init(customFont: CustomFont.FuturanBold, withSize: 16)
        self.calendar.appearance.titleFont = UIFont.init(customFont: CustomFont.FuturanM, withSize: 15)
        self.calendar.appearance.selectionColor = UIColor(named: "BorderColor")
        self.calendar.today = nil
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ManufacturerCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: ManufacturerCell.cellIdentifier())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
    
    override func onClickRightButton(button: UIButton) {
        if button.tag == 0 {
            let vc = SearchVC.loadFromNib()
            vc.searchType = .MANUFACTURERSEARCH
            if self.searchViewModel?.search_String != ""{
                vc.searchtext = self.searchViewModel?.search_String ?? ""
            }
            vc.deleagate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if button.tag == 1 {
            let vc : SortViewController  = SortViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            vc.filterSortClassType = .MANUFACTURESARCHLISTVC
            vc.selectedIndexpath = self.selectedSortIndex
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if button.tag == 2 {
            let vc = FilterViewController.loadFromNib()
            vc.viewModel.filterSortClassType = .MANUFACTURESARCHLISTVC
            vc.setTheFilterArray(filterArray: self.searchViewModel?.filterArray ?? [])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func convertDateFormater(_ date: String) -> Date {
        if date != ""{
            let convertDate = dateFormatter.date(from: date)
            return convertDate!
        }
        return Date()
    }
    
    func fetchDateFormater(date: Date) -> String{
        let formatter =  DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let convertDate = formatter.string(from: date)
        print(convertDate)
        let newConvertDate = dateFormatter.string(from: date)
        print(newConvertDate)
        return newConvertDate
    }
    func getCurrentDate()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.day = Calendar.current.component(.day, from: now)
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
}

//MARK:- TableView datasoruce & delegate methods

extension ManufacturerListVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchViewModel!.seller_list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let manufacturerCell = tableView.dequeueReusableCell(withIdentifier: ManufacturerCell.cellIdentifier(), for: indexPath) as! ManufacturerCell
        
        manufacturerCell.reset()
        manufacturerCell.selectionStyle = .none
        
        let sellerData = searchViewModel!.seller_list[indexPath.section]
        if let imageUrl = sellerData.logoUrl, !(imageUrl.isEmpty) {
            let imageUrlString = URL.init(string: imageUrl)
            manufacturerCell.imgViewManufacturer.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        }else{
            manufacturerCell.imgViewManufacturer.image = UIImage(named:"placeholder" )
        }
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue{
            if !sellerData.name.isEmpty{
                manufacturerCell.lblManufacturerName.text = sellerData.name
            }
        }else{
            if !sellerData.name_arabic.isEmpty{
                manufacturerCell.lblManufacturerName.text = sellerData.name_arabic
            }
        }
        
        if !sellerData.duration.isEmpty{
            manufacturerCell.lblDistance.text = sellerData.duration
        }else{
            manufacturerCell.lblDistance.text = TITLE.customer_na.localized
        }
        if sellerData.is_available  == 1{
            // manufacturerCell.statusLbl.textColor = Theme.greenColor
            manufacturerCell.statusLbl.textColor = UIColor.white
            manufacturerCell.statusLbl.text = TITLE.customer_available.localized
        }else{
            manufacturerCell.statusLbl.textColor = Theme.redColor
            manufacturerCell.statusLbl.text = TITLE.customer_not_available.localized
        }
        
        if !sellerData.start_from.isEmpty {
            manufacturerCell.reset(isHide: false)
            manufacturerCell.lblValue.text = sellerData.start_from
        }
        
        if !sellerData.last_purchase.isEmpty{
            manufacturerCell.lblTimeAgo.text = "\(TITLE.LatestPurchase.localized) : \(String(describing: sellerData.last_purchase))"
        }
        
        manufacturerCell.lblRating.text = sellerData.rating
        
        manufacturerCell.ratingView.value = COMMON_SETTING.getTheStarRatingValue(rating: String(sellerData.rating))
        
        manufacturerCell.favouriteBtn.isSelected =  sellerData.is_favourite == 1 ?  true : false
        
        manufacturerCell.favouriteBtn.touchUp = { button in
            //favourite delegate
            if (LocalDataManager.getGuestUser()){
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
            self.nearestViewModel.isSeller = 1
            if let vendorid = sellerData.vendorId{
                self.nearestViewModel.vendorId = vendorid
            }
            self.nearestViewModel.category_id = self.searchViewModel?.category_id ?? 0
            self.nearestViewModel.is_promotion = self.searchViewModel?.is_promotion ?? 0
            if manufacturerCell.favouriteBtn.isSelected{
                
                self.nearestViewModel.isSeller = 1
                if let vendorid = sellerData.vendorId{
                    self.nearestViewModel.vendorId = vendorid
                }
                
                self.nearestViewModel.addToFavourite {
                    manufacturerCell.favouriteBtn.isSelected = false
                    self.saveTheLocalValue(vendorid: sellerData.vendorId ?? 0, is_fav: 0)
                    self.tableView.reloadData()
                }
            }else{
                self.nearestViewModel.is_favourite = 1
                self.nearestViewModel.addToFavourite {
                    
                    manufacturerCell.favouriteBtn.isSelected = true
                    self.saveTheLocalValue(vendorid: sellerData.vendorId ?? 0, is_fav: 1)
                    self.tableView.reloadData()
                }
            }
        }
        return manufacturerCell
    }
    
    func saveTheLocalValue(vendorid : Int, is_fav : Int) {
        for (index, model) in searchViewModel!.seller_list.enumerated() {
            if model.vendorId == vendorid {
                self.searchViewModel?.seller_list[index].is_favourite = is_fav
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerData = searchViewModel!.seller_list[indexPath.section]
        let vendor_id = sellerData.vendorId ?? 0
        if sellerData.is_available == 1 {
            isSortFilterApply = true
            let sellerViewModel = SellerViewModel()
            sellerViewModel.category_id = searchViewModel!.category_id
            sellerViewModel.vendor_id = vendor_id
            sellerViewModel.is_promotion = self.searchViewModel?.is_promotion ?? 0
            
            if sellerData.delegate_available == 0 {
                let alert = EMAlertController(icon: UIImage(named: "info"),
                                              title: "",
                                              message: "delegate_available".localized)
                let action1 = EMAlertAction(title: "Ok".localized, style: .defults) {
                    self.delay(0.1) {
                        self.gotoManufacturerDetails(sellerViewModel: sellerViewModel)
                    }
                }
                alert.isSingleButton = true
                alert.addAction(action: action1)
                (APP_DELEGATE.window?.rootViewController)?.present(alert, animated: true, completion: nil)
            } else {
                self.gotoManufacturerDetails(sellerViewModel: sellerViewModel)
            }
        } else {
            INotifications.show(message: TITLE.customer_seller_not_avaliable.localized)
        }
    }
    
    func gotoManufacturerDetails(sellerViewModel: SellerViewModel) {
        let viewModel  = SubCategoryViewModel()
        viewModel.category_id = sellerViewModel.category_id
        viewModel.vendor_id = sellerViewModel.vendor_id
        
        viewModel.getSubCategoryDetails {
            if viewModel.subcategoryDetails!.childCategories.count > 0 {
                let vc = ManufacturerTab.loadFromNib()
                vc.viewModelSubcategory = viewModel
                vc.sellerViewModel = sellerViewModel
                vc.isRatingAvail = false
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ManufacturerDetailsVC.loadFromNib()
                vc.viewModelSubcategory = viewModel
                vc.viewModel = sellerViewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let tableHeight = tableView.bounds.size.height
        let contentHeight = tableView.contentSize.height
        let insetHeight = tableView.contentInset.bottom
        
        let yOffset = tableView.contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
        let currentPage : Int = Int((self.searchViewModel?.searchResult?.current_page) ?? "0") ?? 0
        if yOffsetAtBottom >= contentHeight && (self.searchViewModel?.seller_list.count) ?? 0 < (self.searchViewModel?.searchResult?.total_sellers) ?? 0 {
            self.searchViewModel?.current_page = currentPage + 1
            
            if let current_page = self.searchViewModel?.current_page,let page_count = self.searchViewModel?.searchResult?.page_count{
                if current_page <= page_count{
                    self.getLatestList()
                }
            }
        }
    }
}

//MARK: -SearchProductDelegate
extension ManufacturerListVC : SearchProductDelegate{
    func callsearchApi(searchtext: String, isfromProduct: Bool) {
        self.searchViewModel?.search_String = searchtext
        getLatestList()
    }
}

//MARK:- FSCalendarDataSource & FSCalendarDelegate Methods
extension ManufacturerListVC : FSCalendarDataSource, FSCalendarDelegate{
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let calendar1 = NSCalendar.autoupdatingCurrent
        let currentDate = dateFormatter.string(from: todaydate)
        guard let stringDate = dateFormatter.date(from: currentDate) else { return Date() }
        let newDate = calendar1.date(byAdding: .day, value: 3, to: stringDate)
        return newDate ?? Date()
        
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let calendar1 = NSCalendar.autoupdatingCurrent
        let newDate = calendar1.date(byAdding: .month, value: 6, to: convertDateFormater(COMMON_SETTING.selectedDeliveryDate))
        return newDate ?? Date()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.calendarHeightConstraint.constant = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = fetchDateFormater(date: date)
        searchViewModel?.delivery_date = self.selectedDate ?? ""
        searchViewModel?.seller_list.removeAll()
        searchViewModel?.current_page = 1
        getLatestList()
    }
}

//MARK: - API CALL
extension ManufacturerListVC {
    func getLatestList() {
        self.searchViewModel?.getSearchData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
