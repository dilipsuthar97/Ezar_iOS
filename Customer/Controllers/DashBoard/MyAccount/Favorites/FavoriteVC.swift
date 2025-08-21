//
//  FavoriteVC.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 3/22/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import EmptyStateKit
import XLPagerTabStrip


class FavoriteVC: BaseViewController, IndicatorInfoProvider {
    
    //MARK: - Variable
    var viewModel: FavoriteViewModel?
    var productType : ReviewType = .Product

    var delegates : FavoriteModel?
    var manufacturers : FavoriteModel?
    var products : FavoriteModel?

    
    @IBOutlet weak var tableView: UITableView?
    
    var itemInfo = IndicatorInfo(title: "View")
    var params: NSMutableDictionary? = nil
    func setup(itemInfo: IndicatorInfo, params: NSDictionary?) {
        self.itemInfo = itemInfo
        if let params = params{
            self.params = NSMutableDictionary()
            self.params?.addEntries(from: params as! [AnyHashable: Any])
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addPullToRefresh()
        setupEmptyStateView()
        setupTableView()
    }
        
    func changeView() {
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.products {
            self.productType = .Product
        }
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.manufacturer {
            self.productType = .Seller
        }
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.delegate {
            self.productType = .Delegate
        }
        reloadTableView()
    }
    
    func setupTableView() {
        tableView?.registerCellNib(FavoriteDelegateCell.cellIdentifier())
        tableView?.registerCellNib(FavoriteManufacturerCell.cellIdentifier())
        tableView?.dataSource = self
        tableView?.delegate = self

        tableView?.separatorStyle = .none
        tableView?.estimatedRowHeight = 160
        tableView?.rowHeight = UITableView.automaticDimension
    }
    
    func getManufacturerDetails(_ type: ReviewType, item: Items) {        
        let sellerViewModel = SellerViewModel()
        sellerViewModel.category_id = Int(item.category_id) ?? 0
        sellerViewModel.vendor_id = item.vendor_id
        sellerViewModel.is_promotion = Int(item.is_promotion) ?? 0
        
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
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "\(TITLE.customer_phoneno.localized)//\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(phoneCallURL)
                }
            }
        }
    }
    
    func removeFromWishListWS(item_id: Int) {
        self.viewModel?.type = self.productType.rawValue
        self.viewModel?.item_id = item_id
        self.viewModel?.removeFromWishList {
            self.getWishList()
        }
    }
    
    func getDetails(item: Items) {
        if item.move_cart == 1 {
            self.viewModel?.addToCart(returnParametes(item: item)) {
                if self.viewModel?.errorCode == 200 {
                    self.removeFromWishListWS(item_id: item.product_id)
                } else {
                    self.gotoProductDetails(item: item)
                }
            }
        }
        else {
            self.gotoProductDetails(item: item)
        }
    }
}


// MARK: - addPullToRefresh
extension FavoriteVC {
    private func addPullToRefresh() {
        tableView?.es.addPullToRefresh {
            self.getWishList()
        }
    }
}

// MARK: - EmptyStateDelegate
extension FavoriteVC: EmptyStateDelegate {
    private func setupEmptyStateView() {
        tableView?.emptyState.format = TableState.noResult.format
        tableView?.emptyState.delegate = self
    }

    private func reloadTableView() {
        tableView?.emptyState.hide()
        tableView?.es.stopPullToRefresh()

        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.products {
            if products?.items.count == 0 {
                tableView?.emptyState.show(TableState.noResult)
            }
        }
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.manufacturer {
            if manufacturers?.items.count == 0 {
                tableView?.emptyState.show(TableState.noResult)
            }
        }
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.delegate {
            if delegates?.items.count == 0 {
                tableView?.emptyState.show(TableState.noResult)
            }
        }

        tableView?.reloadData()
    }

    func emptyState(emptyState _: EmptyState, didPressButton _: UIButton) {}
}

//MARK:- UITableViewDataSource
extension FavoriteVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.products {
            return self.products?.items.count ?? 0
        }
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.manufacturer {
            return self.manufacturers?.items.count ?? 0
        }
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.delegate {
            return self.delegates?.items.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.products {
            let favDelegateCell = tableView.dequeueReusableCell(withIdentifier: FavoriteDelegateCell.cellIdentifier(), for: indexPath) as! FavoriteDelegateCell
            favDelegateCell.selectionStyle = .none
            if self.products?.items.count ?? 0 > indexPath.row {
                let productItem = self.products?.items[indexPath.row]
                favDelegateCell.lblDelegateName.text = productItem?.name
                favDelegateCell.lblId.text = productItem?.rating ?? ""
                favDelegateCell.ratingView.value = COMMON_SETTING.getTheStarRatingValue(rating: productItem?.rating ?? "")
                if let address  =  productItem?.address, address.isNotEmpty {
                    favDelegateCell.lblAddress.text = address
                } else {
                    favDelegateCell.lblAddress.text = "-"
                }
                
                favDelegateCell.lblAvailability.text = TITLE.customer_available.localized
                
                if let imageUrl = productItem?.image {
                    let imageUrlString = URL(string: imageUrl)
                    favDelegateCell.imgViewDelegate.sd_setImage(with: imageUrlString,
                                                                placeholderImage: UIImage(named: "placeholder"),
                                                                options: .continueInBackground,
                                                                progress: nil,
                                                                completed: nil)
                }
                
                favDelegateCell.btnRemove.touchUp = { button in
                    self.removeFromWishListWS(item_id: productItem?.product_id ?? 0)
                }
            }
            return favDelegateCell
        }
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.manufacturer {
            let favManufacturerCell = tableView.dequeueReusableCell(withIdentifier: FavoriteManufacturerCell.cellIdentifier(), for: indexPath) as! FavoriteManufacturerCell
            favManufacturerCell.selectionStyle = .none

            if self.manufacturers?.items.count ?? 0 > indexPath.row {
                let sellerItem = self.manufacturers?.items[indexPath.row]
                
                let imageUrlString = URL(string: sellerItem?.profile_image ?? "")
                favManufacturerCell.imgViewManufacturer.sd_setImage(with: imageUrlString,
                                                                    placeholderImage: UIImage(named: "placeholder"),
                                                                    options: .continueInBackground,
                                                                    progress: nil,
                                                                    completed: nil)
                favManufacturerCell.lblStock.text = TITLE.customer_available.localized
                if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue{
                    favManufacturerCell.lblName.text = sellerItem?.name
                }else{
                    favManufacturerCell.lblName.text = sellerItem?.name_arabic
                }
                
                favManufacturerCell.lblRating.text = sellerItem?.rating ?? ""
                favManufacturerCell.ratingView.value = COMMON_SETTING.getTheStarRatingValue(rating: sellerItem?.rating ?? "")
                
                if let distance  =  sellerItem?.distance, distance.isNotEmpty {
                    favManufacturerCell.lblDistance.text = distance
                } else {
                    favManufacturerCell.lblDistance.text = "-"
                }
                
                favManufacturerCell.lblRate.text = sellerItem?.start_from
                favManufacturerCell.startFromLbl.text = TITLE.customer_start_from.localized
                favManufacturerCell.btnRemove.touchUp = { button in
                    self.removeFromWishListWS(item_id: sellerItem?.item_id ?? 0)
                }
            }
            return favManufacturerCell
        }
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.delegate {
            let favDelegateCell = tableView.dequeueReusableCell(withIdentifier: FavoriteDelegateCell.cellIdentifier(), for: indexPath) as! FavoriteDelegateCell
            if self.delegates?.items.count ?? 0 > indexPath.row {
                let delegateItem = self.delegates?.items[indexPath.row]
                favDelegateCell.selectionStyle = .none
                favDelegateCell.lblDelegateName.text = delegateItem?.name
                favDelegateCell.lblId.text = delegateItem?.rating ?? ""
                favDelegateCell.ratingView.value = COMMON_SETTING.getTheStarRatingValue(rating: delegateItem?.rating ?? "")
                if let address  =  delegateItem?.address, address.isNotEmpty {
                    favDelegateCell.lblAddress.text = address
                } else {
                    favDelegateCell.lblAddress.text = "-"
                }
                
                favDelegateCell.lblAvailability.text = TITLE.customer_available.localized
                favDelegateCell.lblAvailability.isHidden = delegateItem?.is_available == 1 ? false : true
                
                if let imageUrl = delegateItem?.profile_image {
                    let imageUrlString = URL(string: imageUrl)
                    favDelegateCell.imgViewDelegate.sd_setImage(with: imageUrlString,
                                                                placeholderImage: UIImage(named: "placeholder"),
                                                                options: .continueInBackground,
                                                                progress: nil,
                                                                completed: nil)
                }
                
                favDelegateCell.btnRemove.touchUp = { button in
                    self.removeFromWishListWS(item_id: delegateItem?.item_id ?? 0)
                }
            }
            return favDelegateCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.products {
            if let productItem = self.products?.items[indexPath.row] {
                self.getDetails(item: productItem)
                return
            }
        }
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.manufacturer {
            if let sellerItem = self.manufacturers?.items[indexPath.row] {
                self.getManufacturerDetails(.Seller, item: sellerItem)
                return
            }
        }
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.delegate {
            if let delegateItem = self.delegates?.items[indexPath.row]  {
                self.callNumber(phoneNumber: delegateItem.mobile_number)
                return
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tableView = tableView else {
            return
        }
        
        let tableHeight = tableView.bounds.size.height
        let contentHeight = tableView.contentSize.height
        let insetHeight = tableView.contentInset.bottom
        
        let yOffset = tableView.contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
        if (yOffsetAtBottom >= contentHeight) {
            var currentPage = 1
            if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.products {
                currentPage = self.products?.current_page != self.products?.page_count ? (self.products?.current_page ?? 1) + 1 : 0
            }
            if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.manufacturer {
                currentPage = self.manufacturers?.current_page != self.manufacturers?.page_count ? (self.manufacturers?.current_page ?? 1) + 1 : 0
            }
            if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.delegate {
                currentPage = self.delegates?.current_page != self.delegates?.page_count ? (self.delegates?.current_page ?? 1) + 1 : 0
            }
            
            if currentPage > 0 {
                self.getFavoritePagination(currentPage: currentPage)
            }
        }
    }
}

//MARK: - API CALL
extension FavoriteVC {
    private func getWishList() {
        self.viewModel?.current_page = 1
        self.viewModel?.type = ""
        self.viewModel?.getWishList {
            self.products = self.viewModel?.favoriteObject?.products
            self.manufacturers = self.viewModel?.favoriteObject?.sellers
            self.delegates = self.viewModel?.favoriteObject?.delegates
            self.reloadTableView()
        }
    }

    func getFavoritePagination(currentPage: Int) {
        self.viewModel?.type = self.productType.rawValue
        self.viewModel?.current_page = currentPage
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.products {
            if self.viewModel?.favoriteObject?.products?.items.count ?? 0 > 0 {
                self.products?.current_page = self.viewModel?.favoriteObject?.products?.current_page ?? 1
                self.products?.page_count = self.viewModel?.favoriteObject?.products?.page_count ?? 1
                self.products?.items += self.viewModel?.favoriteObject?.products?.items ?? []
                self.reloadTableView()
            }
        }
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.manufacturer {
            if self.viewModel?.favoriteObject?.sellers?.items.count ?? 0 > 0 {
                self.manufacturers?.current_page = self.viewModel?.favoriteObject?.sellers?.current_page ?? 1
                self.manufacturers?.page_count = self.viewModel?.favoriteObject?.sellers?.page_count ?? 1
                self.manufacturers?.items += self.viewModel?.favoriteObject?.sellers?.items ?? []
                self.reloadTableView()
            }
        }
        
        if COMMON_SETTING.favoriteIndex == FAVORITE_INDEX.delegate {
            if self.viewModel?.favoriteObject?.delegates?.items.count ?? 0 > 0 {
                self.delegates?.current_page = self.viewModel?.favoriteObject?.delegates?.current_page ?? 1
                self.delegates?.page_count = self.viewModel?.favoriteObject?.delegates?.page_count ?? 1
                self.delegates?.items += self.viewModel?.favoriteObject?.delegates?.items ?? []
                self.reloadTableView()
            }
        }
    }
    
    func returnParametes(item: Items) -> NSMutableDictionary {
        let params : NSMutableDictionary = NSMutableDictionary()
        if item.product_type.uppercased() == ProductType.CustomMade.rawValue.uppercased() {
            params.addEntries(from: [API_KEYS.customer_id: Profile.loadProfile()?.id ?? 0,
                                     API_KEYS.product_id: item.product_id,
                                     API_KEYS.category_name: item.category_name,
                                     API_KEYS.style: item.style,
                                     API_KEYS.qty: item.qty,
                                     API_KEYS.price: item.price,
                                     API_KEYS.special_price: item.special_price,
                                     API_KEYS.delivery_date: item.delivery_date,
                                     API_KEYS.item_quote_id: item.item_quote_id,
                                     API_KEYS.product_type: item.product_type])
        }
        else if item.product_type.uppercased() == ProductType.ReadyMade.rawValue.uppercased() {
            params.addEntries(from: [API_KEYS.product_id:item.product_id,
                                     API_KEYS.product_type:item.product_type,
                                     API_KEYS.qty:item.qty,
                                     API_KEYS.customer_id:Profile.loadProfile()?.id ?? 0,
                                     API_KEYS.category_name: item.category_name,
                                     API_KEYS.quote_id:item.quote_id])
            
            for model in item.attributes_info {
                let formatedKey : String = "super_attribute[\(model.option_id)]"
                let value : String = String(format: "%d", model.option_value)
                let dictionary : [String : String] = [formatedKey:value]
                params.addEntries(from: dictionary)
            }
        }
        return params
    }
    
    func gotoProductDetails(item: Items) {
        let vc = SellerDetailVC.loadFromNib()
        vc.classType = .SHOPPINGBAGVC
        vc.viewModel.product_id = item.product_id
        COMMON_SETTING.deliveryDate = item.delivery_date
        vc.viewModel.quotedId = String(format: "%d", item.quote_id)
        vc.viewModel.item_quote_id = item.item_quote_id
        vc.viewModel.attributesInfo = item.attributes_info
        COMMON_SETTING.quantity = item.qty
        vc.viewModel.qty = item.qty
        
        if item.product_type.uppercased() ==
            ProductType.ReadyMade.rawValue.uppercased() {
            vc.bottomBtnTitle = TITLE.choose.localized
            vc.isRatingAvail = false
            vc.detailClassType = .READYMADE
        } else {
            if item.is_promotion == "1" {
                vc.bottomBtnTitle = TITLE.chooseStyles.localized
                vc.isRatingAvail = true
                vc.detailClassType = .CHOOSESTYLE
                vc.viewModel.is_promotion = 1
                COMMON_SETTING.max_capacity = 15
            } else {
                vc.bottomBtnTitle = TITLE.chooseStyles.localized
                vc.isRatingAvail = true
                vc.detailClassType = .CHOOSESTYLE
                vc.viewModel.category_id = Int(item.category_id) ?? 0
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
