//
//  SearchVC.swift
//  Customer
//
//  Created by webwerks on 10/8/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import EmptyStateKit


protocol SearchProductDelegate{
    func callsearchApi(searchtext : String ,isfromProduct : Bool)
}

class SearchVC: BaseViewController {
    
    lazy var spacing: CGFloat = 15.0

    var searchType : SearchType = .NONE
    var categoryID : Int = 0
    var searchtext : String = ""
    var viewModel : TailoreProductViewModel = TailoreProductViewModel()
    var isFromManufactureSearch = false
    var deleagate : SearchProductDelegate?
    var selectedSortIndex : Int = -1
    
    private lazy var resultSearchController = UISearchController()

    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet{
            productsCollectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletionView()
        setupSearchController()
        setupEmptyStateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupNavigation()
    }
    
    private func setupNavigation() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = "Search".localized
        
        navigationItem.hidesSearchBarWhenScrolling = false
        resultSearchController.searchBar.isHidden = false
        navigationItem.searchController = resultSearchController
    }
    
    
    func setupUI(){
        if !(self.viewModel.order_by.isEmpty) ||
            (self.viewModel.applyFilterArray.count > 0) {
            self.getSearchAPICall()
        }
    }
    
    private func setupSearchController() {
        self.delay(1) {
            self.resultSearchController.searchBar.becomeFirstResponder()
        }
        resultSearchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.backgroundColor = .clear
            controller.searchBar.delegate = self
            controller.searchBar.tintColor = Theme.darkGray
            controller.delegate = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.text = self.searchtext
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search".localized
            controller.searchBar.setValue("cancel".localized, forKey: "cancelButtonText")
            if #available(iOS 13.0, *) {
                controller.searchBar.searchTextField.font = FontType.regular(size: 15)
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: Theme.darkGray,
                    .font: FontType.regular(size: 15),
                ]
                UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
            }
            return controller
        }()
    }
    
    override func onClickRightButton(button: UIButton) {
        if self.viewModel.searchProducts?.products.count ?? 0 > 0 {
            if button.tag == 0 {
                let vc : SortViewController  = SortViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
                vc.filterSortClassType = .TAILOREPRODUCTVC
                vc.selectedIndexpath = self.selectedSortIndex
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if button.tag == 1 {
                let vc = FilterViewController.loadFromNib()
                vc.viewModel.filterSortClassType = .TAILOREPRODUCTVC
                vc.setTheFilterArray(filterArray: self.viewModel.filterArray)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func setupColletionView() {
        productsCollectionView.registerCellNib(SearchCell.cellIdentifier())
    }
}

// MARK: - UISearchController

extension SearchVC: UISearchControllerDelegate, UISearchBarDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text?.lowercased() ?? ""
        if searchText.count > 0 {
            self.viewModel.search_String = searchText
            self.loadResults()
        }
    }
    
    func didDismissSearchController(_: UISearchController) {
        if resultSearchController.searchBar.text?.count ?? 0 < 1 {
            resetView()
        }
    }
    
    func loadResults() {
        if searchType == .HOMESEARCH {
            self.getSearchAPICall()
            self.searchtext = self.viewModel.search_String
        } else if searchType == .MANUFACTURERSEARCH {
            let vc = COMMON_SETTING.popToAnyController(type: ManufacturerListVC.self, fromController: self)
            vc.searchViewModel?.search_String = self.viewModel.search_String
            vc.isSortFilterApply = true
            if resultSearchController.searchBar.text == "" {
                vc.searchViewModel?.search_String = ""
                self.viewModel.search_String = ""
            }
            self.navigationController?.popToViewController(vc, animated: true)
        } else if searchType == .CHOOSEFABRIC {
            let vc = COMMON_SETTING.popToAnyController(type: ChooseFabricVC.self, fromController: self)
            vc.searchString = self.viewModel.search_String
            vc.isSortFilterApply = true
            deleagate?.callsearchApi(searchtext: self.viewModel.search_String,
                                     isfromProduct: false)
            if resultSearchController.searchBar.text == "" {
                vc.searchString = ""
                self.viewModel.search_String = ""
            }
            self.navigationController?.popToViewController(vc, animated: true)
        } else if searchType == .PRODUCTSVC {
            let vc = ProductsVC.loadFromNib()
            vc.viewModel.searchString = self.viewModel.search_String
            vc.isSortFilterApply = true
            deleagate?.callsearchApi(searchtext: self.viewModel.search_String,
                                     isfromProduct: true)
            if resultSearchController.searchBar.text == "" {
                vc.viewModel.searchString = ""
                self.viewModel.search_String = ""
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func resetView() {
        resultSearchController.searchBar.text = ""
        if searchType == .MANUFACTURERSEARCH{
            if resultSearchController.searchBar.text == "" {
                let vc = COMMON_SETTING.popToAnyController(type: ManufacturerListVC.self, fromController: self)
                deleagate?.callsearchApi(searchtext: "", isfromProduct: false)
                vc.searchViewModel?.search_String = ""
                self.viewModel.search_String = ""
                self.navigationController?.popToViewController(vc, animated: true)
            }
        } else if searchType == .CHOOSEFABRIC {
            if resultSearchController.searchBar.text == "" {
                let vc = COMMON_SETTING.popToAnyController(type: ChooseFabricVC.self, fromController: self)
                deleagate?.callsearchApi(searchtext: "", isfromProduct: false)
                vc.searchString = ""
                vc.isSortFilterApply = true
                self.viewModel.search_String = ""
                self.navigationController?.popToViewController(vc, animated: true)
            }
        } else if searchType == .PRODUCTSVC{
            if resultSearchController.searchBar.text == "" {
                let vc = ProductsVC.loadFromNib()
                deleagate?.callsearchApi(searchtext: "", isfromProduct: true)
                vc.viewModel.searchString = ""
                vc.isSortFilterApply = true
                self.viewModel.search_String = ""
                self.navigationController?.popViewController(animated: true)
            }
        } else if searchType == .HOMESEARCH{
            if resultSearchController.searchBar.text == "" {
                self.viewModel.search_String = ""
                self.getSearchAPICall()
            }
        }
    }
}

// MARK: - EmptyStateDelegate

extension SearchVC: EmptyStateDelegate {
    private func setupEmptyStateView() {
        productsCollectionView.emptyState.format = TableState.noSearch.format
        productsCollectionView.emptyState.delegate = self
    }

    private func reloadTableView() {
        productsCollectionView.emptyState.hide()
        productsCollectionView.es.stopPullToRefresh()
        if self.viewModel.searchProducts?.products.count == 0 {
            productsCollectionView.emptyState.show(TableState.noSearch)
        }
        productsCollectionView.reloadData()
    }

    func emptyState(emptyState _: EmptyState, didPressButton _: UIButton) {}
}

//MARK: - UICollectionViewDataSource
extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.searchProducts?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.cellIdentifier(), for: indexPath) as? SearchCell else {
            return UICollectionViewCell()
        }
                
        if let product = self.viewModel.searchProducts?.products[indexPath.row] {
            if !(product.image.isEmpty) {
                let imageUrlString = URL(string: product.image)
                cell.fabricImgView.sd_setImage(with: imageUrlString,
                                               placeholderImage: UIImage(named: "placeholder"),
                                               options: .continueInBackground,
                                               progress: nil,
                                               completed: nil)
            }
            
            cell.isNewImageView.isHidden = product.is_new == 1 ? false : true
            cell.titleLbl.text = product.name
            cell.priceLbl.text =  product.currency_symbol + " " + product.price
            cell.ratingLbl.text = "\(product.rating_summary)/5"
            cell.rewardPointLbl.text = String(format: "%d \(TITLE.Rewards.localized)", product.reward_points)

            cell.favouriteBtn.isSelected = product.is_favourite == 1 ? true : false
            cell.btnMoreInfo.touchUp = { button in
                self.gotoProductDetails(indexPath: indexPath)
            }
            
            cell.favouriteBtn.touchUp = { button in
                if cell.favouriteBtn.isSelected {
                    cell.favouriteBtn.isSelected = false
                }else{
                    let product_id : Int = Int(product.id ) ?? 0
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
                                                                         category_id: 0,
                                                                         is_promotion: 1)
                    
                    self.viewModel.addToWishlist(params) {
                        cell.favouriteBtn.isSelected = true
                    }
                }
            }
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    private func gotoProductDetails(indexPath: IndexPath) {
        let product = self.viewModel.searchProducts?.products[indexPath.row]
        let vc = SellerDetailVC.loadFromNib()
        vc.classType = .HOMEREQUESTSVC
        vc.bottomBtnTitle = TITLE.chooseStyles.localized
        vc.isRatingAvail = true
        vc.viewModel.product_id = Int(product?.id ?? "0") ?? 0
        vc.viewModel.category_id = self.categoryID
        vc.detailClassType = .CHOOSESTYLE
        vc.viewModel.is_promotion = 1
        COMMON_SETTING.max_capacity = 15
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let tableHeight = productsCollectionView.bounds.size.height
        let contentHeight = productsCollectionView.contentSize.height
        let insetHeight = productsCollectionView.contentInset.bottom
        
        let yOffset = productsCollectionView.contentOffset.y
        let yOffsetAtBottom = yOffset + tableHeight - insetHeight
        if (yOffsetAtBottom >= contentHeight) && (self.viewModel.current_page != self.viewModel.searchProducts?.page_count) {
            self.viewModel.page_count = self.viewModel.searchProducts?.page_count ?? 0
            self.viewModel.current_page = self.viewModel.current_page + 1
            if self.viewModel.current_page <= self.viewModel.searchProducts?.page_count ?? 0 {
                self.getSearchAPICall()
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacing)
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: 365)
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

//MARK: - API CALL
extension SearchVC {
    func getSearchAPICall() {
        resultSearchController.searchBar.resignFirstResponder()
        self.viewModel.getSearch {
            self.reloadTableView()
        }
    }
}
