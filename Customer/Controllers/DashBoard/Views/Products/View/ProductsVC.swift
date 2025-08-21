//
//  ProductsVC.swift
//  Customer
//
//  Created by webwerks on 6/27/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ProductsVC: BaseViewController {
    
    var viewModel : ProductsViewModel = ProductsViewModel()
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerBgView: ShaddowView!
    let nearestViewModel : NearestDelegateViewModel = NearestDelegateViewModel()
    
    var vendarID :String = ""
    var selectedSortIndex : Int = -1
    var isSortFilterApply : Bool = false
    var searchBar:UISearchBar = UISearchBar()
    var isTypeCategory = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupColletionView()
        self.bannerBgView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isSortFilterApply == false{
            self.getTailoreCategoryProductsWS()
        }
        
//        self.getTailoreCategoryProductsWS()
        self.setupUI()
        
    }
    
    //MARK:- Helpers for data & UI
    func setupColletionView() {
        productsCollectionView.register(UINib(nibName: ChooseFabricCell.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: ChooseFabricCell.cellIdentifier())
        self.bannerCollectionView.register(UINib(nibName:SellerCategoryCollectionViewCell.cellIdentifier(),bundle:nil), forCellWithReuseIdentifier: SellerCategoryCollectionViewCell.cellIdentifier())
    }
    
//    func setupSearchbar(){
//        searchBar.searchBarStyle = UISearchBarStyle.prominent
//        searchBar.placeholder = " Search..."
//        searchBar.sizeToFit()
//        searchBar.isTranslucent = false
//        searchBar.backgroundImage = UIImage()
//        searchBar.delegate = self
//        navigationItem.titleView = searchBar
//
//    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        if self.viewModel.tailorProducts?.subcategories.count ?? 0 > 0{
            setLeftButton()
            setRightButtonsArray(buttonArray: ["searchW_Icon"])
            
        }else{
            setLeftButton()
            setRightButtonsArray(buttonArray: ["searchW_Icon","sortW_Icon","filterW_Icon"])
        }
    }
    
    func getTailoreCategoryProductsWS() {
        self.viewModel.vendarID = self.vendarID
        self.viewModel.getTailoreCategoryProducts {
            
            self.viewModel.filteredProducts  = self.viewModel.tailorProducts
            if self.viewModel.tailorProducts?.subcategories.count ?? 0 > 0{
                self.setLeftButton()
                self.setRightButtonsArray(buttonArray: ["searchW_Icon"])
                let sortedArray =  self.viewModel.filteredProducts?.subcategories.sorted(by: {$0.category_position <  $1.category_position})
                self.viewModel.filteredProducts?.subcategories  = sortedArray ?? []
            }else{
                self.setLeftButton()
                self.setRightButtonsArray(buttonArray: ["searchW_Icon","sortW_Icon","filterW_Icon"])
                self.viewModel.filteredProducts  = self.viewModel.tailorProducts
            }
            //   self.viewModel.filteredProducts = self.viewModel.tailorProducts
            if self.viewModel.statusCode != 200{
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            if self.viewModel.tailorProducts?.products.count == 0 && self.viewModel.tailorProducts?.subcategories.count == 0
            {
                self.showEmptyShoppingBagView()
                return
            }
            
            DispatchQueue.main.async {
                
                if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                    if self.viewModel.filteredProducts?.seller_detail.count ?? 0 > 0{
                        self.bannerCollectionViewHeight.constant = 170
                        self.bannerViewHeight.constant = 190
                        self.bannerBgView.isHidden = false
                        self.pageControlViewHeight.constant = 20
                        self.pageController.isHidden = false
                        self.bannerBgView.isHidden = false
                        
                    }else{
                        self.bannerCollectionViewHeight.constant = 0
                        self.bannerViewHeight.constant = 0
                        self.bannerBgView.isHidden = true
                        self.pageControlViewHeight.constant = 0
                        self.pageController.isHidden = true
                        self.bannerBgView.isHidden = true
                        
                    }
                }else{
                    self.bannerCollectionViewHeight.constant = 0
                    self.bannerViewHeight.constant = 0
                    self.bannerBgView.isHidden = true
                    self.pageControlViewHeight.constant = 0
                    self.pageController.isHidden = true
                    self.bannerBgView.isHidden = true
                }
                
                self.productsCollectionView.reloadData()
                if self.isSortFilterApply == false{
                    self.bannerCollectionView.reloadData()
                }
            }
        }
    }
    func removeFromSuperView()
    {
        for subview in self.view.subviews
        {
            if !(subview is UICollectionView)
            {
                subview.removeFromSuperview()
                break
            }
        }
    }
    
    func showEmptyShoppingBagView()
    {
        let screenWith = MAINSCREEN.size.width
        let screenHeight = MAINSCREEN.size.height
        
        let backView : UIView = UIView.init(frame: self.view.frame)
        backView.backgroundColor = UIColor.white
        self.view.addSubview(backView)
        
        let shoppingBagImageView : UIImageView = UIImageView.init(frame: CGRect(x: (screenWith/2) - 40, y: 84, width: 80, height: 80))
        shoppingBagImageView.image = UIImage.init(named: "bag_Icon")
        backView.addSubview(shoppingBagImageView)
        
        
        
        let yPositionDefaultLabel = shoppingBagImageView.frame.size.height + shoppingBagImageView.frame.origin.y + 20
        
        let defaultLabel = UILabel.init(frame: CGRect(x: 10, y: yPositionDefaultLabel, width: screenWith - 20, height: 27))
        defaultLabel.textColor = Theme.navBarColor
        defaultLabel.textAlignment = .center
        defaultLabel.font = UIFont.init(customFont: CustomFont.FuturanHv, withSize: 20)
        defaultLabel.text = TITLE.product_list_empty.localized
        backView.addSubview(defaultLabel)
    }
    
    override func onClickRightButton(button: UIButton)
    {
        if button.tag == 0 {
            let vc = SearchVC.loadFromNib()
            //Old
            //vc.searchType = .HOMESEARCH
            //vc.categoryID = self.viewModel.category_id
            //NEW
            vc.searchType = .PRODUCTSVC
            if self.viewModel.searchString != ""{
                vc.searchtext = self.viewModel.searchString
            }
            vc.deleagate = self
            self.navigationController?.pushViewController(vc, animated: true)            
        }
        else if button.tag == 1 {
            self.setTabBarIndex(index: 2)
        }
        else if button.tag == 2 {
            let vc : SortViewController  = SortViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            vc.filterSortClassType = .PRODUCTSVC
            vc.selectedIndexpath = self.selectedSortIndex
            vc.delegate = self
            if isTypeCategory == true{
                vc.isProductsCategory = true
            }else{
                vc.isProductsCategory = false
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
           
        }
        else if button.tag == 3
        {
            let vc = FilterViewController.loadFromNib()
            vc.viewModel.filterSortClassType = .PRODUCTSVC
            vc.setTheFilterArray(filterArray: self.viewModel.filterArray)
             vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(bannerCollectionView.contentOffset.x) / Int(bannerCollectionView.frame.width)
    }
    func saveTheLocalValue(vendorid : Int, is_fav : Int)
    {
        if let sellerdetail = self.viewModel.filteredProducts?.seller_detail{
            for (index, model) in sellerdetail.enumerated()
            {
                if Int(model.id) == vendorid
                {
                    self.viewModel.filteredProducts?.seller_detail[index].is_favourite = is_fav
                    break
                }
            }
        }
        
    }
}

//MARK:- CollectionView FlowLayout

extension ProductsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize.init(width: self.bannerCollectionView.frame.size.width, height: 180)
        }else{
            if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                let width : CGFloat = (self.view.frame.width-15)/2
                let height : CGFloat = width+30//width*1.50
                return CGSize(width: width, height: height)
            }else{
                let width : CGFloat = (self.view.frame.width-15)/2
                let height : CGFloat = 260//width + 50
                return CGSize(width: width, height: height)
            }
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Used for vertical cell spacing
        if collectionView.tag == 1 {
            return 0.0
        }else{
             return 3.0
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1 {
            return 0.0
        }else{
             return 3.0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1 {
            return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        }else{
              return UIEdgeInsets(top:5, left: 5, bottom: 5, right: 5)
        }
       
    }
    
}

//MARK:- CollectionView datasoruce & delegate methods

extension ProductsVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //OLD
        //return self.viewModel.tailorProducts?.products.count ?? 0
        
        if collectionView.tag == 1{
            let count = self.viewModel.filteredProducts?.seller_detail.count ?? 0 > 0 ? self.viewModel.filteredProducts?.seller_detail.count : 1
            self.pageController.numberOfPages = count ?? 0
            return count ?? 0
        }else{
            if isSortFilterApply == true{
              //  removeFromSuperView()
                if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                    isTypeCategory = true
                    return self.viewModel.filteredProducts?.subcategories.count ?? 0
                }
                if isTypeCategory == false{
                    if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                        isTypeCategory = true
                        return self.viewModel.filteredProducts?.subcategories.count ?? 0
                    }else{
                        isTypeCategory = false
                        return self.viewModel.filteredProducts?.products.count ?? 0
                    }
                }
            }else{
                if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                    isTypeCategory = true
                    return self.viewModel.filteredProducts?.subcategories.count ?? 0
                }else if self.viewModel.filteredProducts?.products.count ?? 0 > 0{
                    isTypeCategory = false
                    return self.viewModel.filteredProducts?.products.count ?? 0
                }
            }
            //        self.removeFromSuperView()
            //        if  self.viewModel.filteredProducts?.subcategories.count ?? 0 <= 0{
            //            self.showEmptyShoppingBagView()
            //            return 0
            //        }else if self.viewModel.filteredProducts?.products.count ?? 0 <= 0 {
            //            self.showEmptyShoppingBagView()
            //            return 0
            //        }
            //        self.removeFromSuperView()
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
              let cell: SellerCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SellerCategoryCollectionViewCell.cellIdentifier(), for: indexPath as IndexPath) as! SellerCategoryCollectionViewCell
            if let sellerData =  self.viewModel.filteredProducts?.seller_detail,sellerData.count > 0
            {

                let imageUrl : String = sellerData[indexPath.row].logo

                let imageUrlString = URL.init(string: imageUrl)
                cell.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue{
                     cell.titileLable.text = sellerData[indexPath.row].name
                }else{
                     cell.titileLable.text = sellerData[indexPath.row].arabic_name
                }

                if sellerData[indexPath.row].total_rating != ""{

                    let review = sellerData[indexPath.row].total_rating
                    if review != "0"{
                        cell.ratingView.isHidden = false
                        cell.ratingStar.value = COMMON_SETTING.getTheStarRatingValue(rating: review)
                    }
                    else{
                        cell.ratingView.isHidden = true
                    }
                }else{
                    cell.ratingView.isHidden = true
                }
                
                cell.favouriteBtn.isSelected =  sellerData[indexPath.row].is_favourite == 1 ?  true : false
                                
                cell.favouriteBtn.touchUp = { button in
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
                    if sellerData[indexPath.row].id != 0{
                        self.nearestViewModel.vendorId = sellerData[indexPath.row].id
                    }
                    self.nearestViewModel.category_id = self.viewModel.category_id
                    self.nearestViewModel.is_promotion =  0
                    
                    if cell.favouriteBtn.isSelected{
                    
                        self.nearestViewModel.isSeller = 1
                        if sellerData[indexPath.row].id != 0{
                            self.nearestViewModel.vendorId = sellerData[indexPath.row].id
                        }
                        
                        self.nearestViewModel.addToFavourite {
                            cell.favouriteBtn.isSelected = false
                          //  self.saveTheLocalValue(vendorid: sellerData[indexPath.row].id, is_fav: 0)
                           // self.bannerCollectionView.reloadData()
                        }
                    }else{
                    
                        self.nearestViewModel.is_favourite = 1
                        if sellerData[indexPath.row].id != 0{
                            self.nearestViewModel.vendorId = sellerData[indexPath.row].id
                        }
                        self.nearestViewModel.addToFavourite {
                            
                            cell.favouriteBtn.isSelected = true
                          //  self.saveTheLocalValue(vendorid: sellerData[indexPath.row].id, is_fav: 1)
                           // self.bannerCollectionView.reloadData()
                        }
                    }
                }

            }
            
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseFabricCell.cellIdentifier(), for: indexPath) as! ChooseFabricCell
            
            cell.selectModelBottomView.isHidden = true
            cell.bottomView.isHidden = false
            
            if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                if let subcategories = self.viewModel.filteredProducts?.subcategories{
                    
                    if LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue
                    {
                        cell.fabricNameLbl.text = subcategories[indexPath.row].category_name
                    }else{
                        cell.fabricNameLbl.text = subcategories[indexPath.row].category_name_arabic
                    }
                    
                    if !(subcategories[indexPath.row].category_image.isEmpty){
                        cell.fabricImgView.contentMode = .scaleToFill
                    }else{
                        cell.fabricImgView.contentMode = .center
                    }
                    
                    let image =  subcategories[indexPath.row].category_image
                    let imageUrlString = URL.init(string: image)
                    cell.fabricImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                    // }
                }
                cell.favouriteBtn.isHidden = true
                cell.rewardPointLbl.isHidden = true
                cell.rewardPointImageView.isHidden = true
                cell.fabricCodeLbl.isHidden = true
                cell.fabricDiscountLbl.isHidden = true
                cell.fabricDescLbl.isHidden = true
                cell.bottomViewHeightConstraints.constant = 30
            }else{
                if let product = self.viewModel.filteredProducts?.products[indexPath.row]{
                    cell.bottomViewHeightConstraints.constant = 80
                    
                    if !(product.image.isEmpty)
                    {
                        cell.fabricImgView.contentMode = .scaleToFill
                    }else{
                        cell.fabricImgView.contentMode = .center
                    }
                    
                    let imageUrlString = URL.init(string: product.image)
                    cell.fabricImgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
                    
                    
                    // }
                    cell.isNewImageView.isHidden = product.is_new == 1 ? false : true
                    cell.fabricNameLbl.text = product.name
                    cell.favouriteBtn.isSelected = product.is_favourite == 1
                    cell.fabricCodeLbl.text = String(format: "%@ %@",(product.currency_symbol), (product.price))
                    // cell.rewardPointLbl.text = String(format: "%d Rewards", product.reward_points)
                    cell.rewardPointLbl.text = String(format: "%d \(TITLE.Rewards.localized)", product.reward_points)
                    let special_price : Double = Double((product.special_price) ) ?? 0
                    
                    if !product.per_off.isEmpty || !product.special_price.isEmpty{
                        
                        cell.fabricBlurCodeLbl.text = String(format: "%@ %@",(product.currency_symbol), (product.special_price))
                        
                        cell.fabricDiscountLbl.text = "\(product.per_off)\(TITLE.customer_off.localized)"
                        cell.fabricCodeLbl.textColor = Theme.lightGray
                    }else{
                        cell.fabricDiscountLbl.text = ""
                        cell.fabricBlurCodeLbl.text = ""
                        cell.fabricCodeLbl.textColor = Theme.priceColor
                    }
                    
                    cell.lineView.isHidden = special_price == 0.0
                    if !product.sku.isEmpty{
                        cell.fabricDescLbl.text = product.sku
                    }else{
                        cell.fabricDescLbl.text = TITLE.noDescription.localized
                    }
                    
                    cell.favouriteBtn.touchUp = { button in
                        if !(LocalDataManager.getGuestUser()){
                            
                            self.viewModel.product_id = product.id
                            let product_id : Int = Int(product.id ) ?? 0
                            let category_id : Int = Int(self.viewModel.tailorProducts?.category_id ?? "0") ?? 0
                            let params = COMMON_SETTING.addToWishListParameters(product_id,
                                                                                 category_name: "",
                                                                                 style: "",
                                                                                 qty: 1,
                                                                                 price: product.price ,
                                                                                 special_price: product.special_price ,
                                                                                 delivery_date: "",
                                                                                 item_quote_id: "",
                                                                                 quote_id: "",
                                                                                 avlOptionArray: [],
                                                                                 category_id: category_id,
                                                                                 is_promotion: 0)
                            if cell.favouriteBtn.isSelected == false
                            {
                                self.viewModel.addToWishlist(params) {
                                    cell.favouriteBtn.isSelected = true
                                }
                            }
                            else
                            {
                                self.viewModel.removeFromWishList {
                                    cell.favouriteBtn.isSelected = false
                                }
                            }
                        }else{
                            let alert = UIAlertController(title: TITLE.customer_login_required.localized, message: TITLE.customer_guest_alert.localized, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: TITLE.yes.localized, style: .default, handler:{ action in
                                let vc = LoginViewController.loadFromNib()
                                vc.isFromUserGuest = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            }))
                            alert.addAction(UIAlertAction(title: TITLE.no.localized, style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return}
                    }
                }
                cell.layoutIfNeeded()
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
                          
        }else{
            if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                let vc = ProductsVC.loadFromNib()
                if let catId = self.viewModel.filteredProducts?.subcategories[indexPath.row].category_id{
                    vc.viewModel.category_id = Int(catId) ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if let productID = self.viewModel.filteredProducts?.products[indexPath.row].id{
                    let vc = SellerDetailVC.loadFromNib()
                    vc.bottomBtnTitle = TITLE.choose.localized
                    vc.isRatingAvail = false
                    vc.detailClassType = .READYMADE
                    vc.viewModel.product_id = Int(productID ) ?? 0
                    // vc.viewModel.category_id = self.viewModel.category_id
                    vc.classType = .PRODUCTSVC
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        let tableHeight = productsCollectionView.bounds.size.height
//        let contentHeight = productsCollectionView.contentSize.height
//        let insetHeight = productsCollectionView.contentInset.bottom
//        
//        let yOffset = productsCollectionView.contentOffset.y
//        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
//        if (yOffsetAtBottom >= contentHeight) && (self.viewModel.current_page != self.viewModel.filteredProducts?.page_count)
//        {
//            self.viewModel.current_page = self.viewModel.current_page + 1
//            if self.viewModel.current_page <= self.viewModel.filteredProducts?.page_count ?? 0{
//                if self.viewModel.current_page > 0{
//                   self.getTailoreCategoryProductsWS()
//                }
//            }
//        }
//    }
}


//MARK: -SearchProductDelegate
extension ProductsVC : SearchProductDelegate {
    
    func callsearchApi(searchtext: String, isfromProduct: Bool) {
        print(searchtext)
        if productsCollectionView.tag == 0{
            self.isSortFilterApply = isfromProduct
            self.viewModel.searchString = searchtext
            if searchtext == ""{
                self.getTailoreCategoryProductsWS()
                
            }
            if self.viewModel.filteredProducts?.subcategories.count ?? 0 > 0{
                if let subcategoryList = self.viewModel.filteredProducts?.subcategories{
                    self.viewModel.filteredProducts?.subcategories = searchtext.isEmpty ? subcategoryList : subcategoryList.filter({(dataString: Subcategories) -> Bool in
                        
                        return dataString.category_name.range(of: searchtext, options: .caseInsensitive) != nil
                        
                    })
                }
            }else{
                if let productList = self.viewModel.filteredProducts?.products{
                    self.viewModel.filteredProducts?.products = searchtext.isEmpty ? productList : productList.filter({(dataString: ProductsList) -> Bool in
                        
                        return dataString.name.range(of: searchtext, options: .caseInsensitive) != nil
                        
                    })
                }
            }
            productsCollectionView.reloadData()
        }else{
         //  self.bannerCollectionView.reloadData()
        }
        
    }
}

//MARK:- SortViewControllerDelegate
extension ProductsVC : SortViewControllerDelegate{
    func getSelectedValueForSort(selectedValue: String, isCallApi : Bool ,selectedIndex : Int ) {
        
//        if selectedValue == "customer_nameAZ" {
//           self.viewModel.filteredProducts?.subcategories = selectedValue.isEmpty ? subcategoryList : self.viewModel.filteredProducts?.subcategories.sort({(dataString: Subcategories) -> Bool in
//
//            return self.category_name.sorted()
//
//           })
//        }else{
//           var sortedArray = self.viewModel.filteredProducts?.subcategories.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderDe }
//            self.viewModel.filteredProducts?.subcategories = sortedArray
//        }
        self.isSortFilterApply = isCallApi
        self.selectedSortIndex = selectedIndex
        if selectedValue == "customer_nameAZ" {
            if let subCategories = self.viewModel.filteredProducts?.subcategories{
                let sortedArray = subCategories.sorted(by: { $0.category_name.localizedCaseInsensitiveCompare($1.category_name).rawValue == ComparisonResult.orderedAscending.rawValue})
                print(sortedArray)
                self.viewModel.filteredProducts?.subcategories.removeAll()
                self.viewModel.filteredProducts?.subcategories = sortedArray
            }
        }else{
            if let subCategories = self.viewModel.filteredProducts?.subcategories{
                let sortedArray = subCategories.sorted(by: { $0.category_name.localizedCaseInsensitiveCompare($1.category_name).rawValue == ComparisonResult.orderedDescending.rawValue})
                print(sortedArray)
                self.viewModel.filteredProducts?.subcategories.removeAll()
                self.viewModel.filteredProducts?.subcategories = sortedArray
            }
        }
        productsCollectionView.reloadData()
        
    }
    
    func getSelectedValue(orderBy: String, selectedIndex: Int) {
        self.viewModel.order_by = orderBy
        self.selectedSortIndex = selectedIndex
        self.getTailoreCategoryProductsWS()
    }
    
}

//MARK:-FilterViewControllerDelegate
extension ProductsVC : FilterViewControllerDelegate{
    func getSelectedValue(applyFilterArray: [NSMutableDictionary]) {
        self.viewModel.applyFilterArray  = applyFilterArray
        self.getTailoreCategoryProductsWS()
    }
}

//MARK:-SellerDetailVCDelegate
extension ProductsVC : SellerDetailVCDelegate{
    func navigateToCuffStyle(categoryId: Int, productId: String) {
        
    }
    
    
    func getSelectedID(vandorID: String, categoryID: Int ,isSortFilterApply: Bool) {
        self.vendarID = vandorID
        self.isSortFilterApply = isSortFilterApply
        //self.viewModel.category_id = categoryID
    }
}
