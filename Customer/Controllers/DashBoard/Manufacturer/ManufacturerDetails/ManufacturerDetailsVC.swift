//
//  ManufacturerDetailsVC.swift
//  Customer
//
//  Created by webwerks on 3/23/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import EmptyStateKit
import XLPagerTabStrip

class ManufacturerDetailsVC: BaseViewController, IndicatorInfoProvider {

    var viewModel : SellerViewModel = SellerViewModel()
    var viewModelSubcategory: SubCategoryViewModel = SubCategoryViewModel()

    lazy var spacing: CGFloat = 15.0
    var currentPage = 1
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.contentInset.top = 10
            collectionView?.contentInset.bottom = 100
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.title = TITLE.select_model.localized
        setNavigationBarHidden(hide: false)
        setLeftButton()
    }
    
    func changeView() {
        collectionView?.reloadData()
    }
    
    func setupColletionView() {
        collectionView?.registerCellNib(FabricModelCell.cellIdentifier())
    }
    
    func navigateToDetailPage(categoryId : Int, productId : String) {
        let vc = SellerDetailVC.loadFromNib()
        vc.classType = .SELECTMODELROOTVC
        vc.bottomBtnTitle = TITLE.chooseStyles.localized
        vc.isRatingAvail = true
        vc.viewModel.category_id = categoryId
        vc.viewModel.product_id = Int(productId) ?? 0
        vc.detailClassType = .CHOOSESTYLE
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func navigateToStylePage(categoryId: String, productId: String) {
        self.viewModel.product_id = Int(productId) ?? 0
        self.viewModel.category_id = Int(categoryId) ?? 0
        self.viewModel.getProductDetails {
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
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ManufacturerDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: 400)
    }
    
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return spacing
    }
}

//MARK: - UICollectionViewDataSource
extension ManufacturerDetailsVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let subcategoryDetails = self.viewModelSubcategory.subcategoryDetails {
            if subcategoryDetails.childCategories.count == 0 {
                return subcategoryDetails.subproducts.count
            } else {
                return subcategoryDetails.childCategories[COMMON_SETTING.manufacturerIndex].subcategoryProducts.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let subcategoryDetails = self.viewModelSubcategory.subcategoryDetails else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FabricModelCell.cellIdentifier(), for: indexPath) as! FabricModelCell
                
        if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
            cell.isNewImageView.image = UIImage(named: "flag_arabic")
        } else {
            cell.isNewImageView.image = UIImage(named: "newFlag_Icon")
        }
        
        if subcategoryDetails.childCategories.count == 0 {
            let productDetails = self.viewModelSubcategory.subcategoryDetails!.subproducts[indexPath.row]
            cell.titleLbl.text = productDetails.product_name
            cell.priceLbl.text =  productDetails.currency_symbol + " " + productDetails.product_price
            cell.selectRewardPointLbl.text = String(format: "%d \(TITLE.Rewards.localized)", productDetails.reward_points)
            if !productDetails.product_rating.isEmpty{
                cell.ratingLbl.text = productDetails.product_rating
            }
            
            if productDetails.isNewProduct {
                cell.isNewImageView.isHidden = false
            } else {
                cell.isNewImageView.isHidden = true
            }
            
            if let imageUrl = productDetails.product_image {
                let imageUrlString = URL(string: imageUrl)
                cell.fabricImgView.sd_setImage(with: imageUrlString,
                                               placeholderImage: UIImage(named: "placeholder"))
            }
            return cell
        }
        let productDetails = self.viewModelSubcategory.subcategoryDetails!.childCategories[COMMON_SETTING.manufacturerIndex].subcategoryProducts[indexPath.row]
        cell.titleLbl.text = productDetails.product_name
        if let specialprice = productDetails.special_price {
            if !specialprice.isEmpty {
                cell.priceLbl.text =  productDetails.currency_symbol + " " + specialprice
            }else{
                cell.priceLbl.text =  productDetails.currency_symbol + " " + productDetails.product_price
            }
        }
            
        if !productDetails.product_rating.isEmpty {
            cell.ratingLbl.text = productDetails.product_rating
        }
        
        cell.selectRewardPointLbl.text = String(format: "%d \(TITLE.Rewards.localized)", productDetails.reward_points)
        if productDetails.isNewProduct {
            cell.isNewImageView.isHidden = false
        } else {
            cell.isNewImageView.isHidden = true
        }
        
        if let imageUrl = productDetails.product_image {
            let imageUrlString = URL(string: imageUrl)
            cell.fabricImgView.sd_setImage(with: imageUrlString,
                                           placeholderImage: UIImage(named: "placeholder"))
        }
        
        cell.btnChooseStyle.touchUp = { button in
            if let subcategoryDetails = self.viewModelSubcategory.subcategoryDetails {
                if subcategoryDetails.childCategories.count == 0 {
                    let category_id = "\(self.viewModelSubcategory.category_id)"
                    let product_id = self.viewModelSubcategory.subcategoryDetails!.subproducts[indexPath.row].product_id
                    self.navigateToStylePage(categoryId: category_id, productId: product_id)
                } else {
                    let category_id = self.viewModelSubcategory.subcategoryDetails!.childCategories[COMMON_SETTING.manufacturerIndex].subcategory_id
                    let product_id = self.viewModelSubcategory.subcategoryDetails!.childCategories[COMMON_SETTING.manufacturerIndex].subcategoryProducts[indexPath.row].product_id
                    self.navigateToStylePage(categoryId: category_id, productId: product_id)
                }
            }
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let subcategoryDetails = self.viewModelSubcategory.subcategoryDetails {
            if subcategoryDetails.childCategories.count == 0 {
                let vc = SellerDetailVC.loadFromNib()
                vc.classType = .SELECTMODELVC
                vc.bottomBtnTitle = TITLE.chooseStyles.localized
                vc.isRatingAvail = true
                vc.detailClassType = .CHOOSESTYLE
                let productDetails = self.viewModelSubcategory.subcategoryDetails!.subproducts[indexPath.row]
                vc.viewModel.category_id = self.viewModelSubcategory.category_id
                vc.viewModel.product_id = Int(productDetails.product_id) ?? 0
                self.navigationController?.pushViewController(vc, animated: false)
            } else {
                let productDetails = self.viewModelSubcategory.subcategoryDetails!.childCategories[COMMON_SETTING.manufacturerIndex].subcategoryProducts[indexPath.row]
                let category_id = self.viewModelSubcategory.subcategoryDetails!.childCategories[COMMON_SETTING.manufacturerIndex].subcategory_id
                self.navigateToDetailPage(categoryId: Int(category_id) ?? 0, productId: productDetails.product_id)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            self.currentPage = self.currentPage + 1
            self.getProductList(currentPage: currentPage)
        }
    }
}

//MARK: - API CALL
extension ManufacturerDetailsVC {
    func getProductList(currentPage : Int) {
        var page_Count = 0
        if let subcategoryDetails = self.viewModelSubcategory.subcategoryDetails {
            if subcategoryDetails.childCategories.count > 0 {
                viewModelSubcategory.tab_Index = COMMON_SETTING.manufacturerIndex
                page_Count = subcategoryDetails.childCategories[COMMON_SETTING.manufacturerIndex].page_count
            } else {
                page_Count = subcategoryDetails.page_count
            }
        }
        
        if currentPage <= page_Count {
            viewModelSubcategory.currentPage = currentPage
            viewModelSubcategory.getCategoryProductList {
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
}

