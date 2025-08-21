//
//  ChooseFabricVC.swift
//  Customer
//
//  Created by webwerks on 15/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ChooseFabricVC: BaseViewController {
    
    var isSortFilterApply : Bool = false
    var searchString : String = ""
    var selectedSortIndex : Int = -1
    
    @IBOutlet weak var fabricsCollectionView: UICollectionView!
    @IBOutlet weak var infoLable: PaddingLabel!

    let viewModel : ChooseFabricViewModel = ChooseFabricViewModel()
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        setupUI()
    }
    
    override func onClickRightButton(button: UIButton) {
        if button.tag == 0 {
            let vc  = SearchVC.loadFromNib()
            vc.searchType = .CHOOSEFABRIC
            if self.searchString != ""{
                vc.searchtext = self.searchString
            }
            vc.deleagate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else if button.tag == 1 {
            let vc = SortViewController(nibName: String(describing: BaseTableViewController.self), bundle: nil)
            vc.filterSortClassType = .CHOOSEFABRICVC
            vc.selectedIndexpath = self.selectedSortIndex
            self.navigationController?.pushViewController(vc, animated: true)
        } else if button.tag == 2 {
            let vc = FilterViewController.loadFromNib()
            vc.viewModel.filterSortClassType = .CHOOSEFABRICVC
            vc.setTheFilterArray(filterArray: (self.viewModel.chooseFabricProduct?.filters) ?? [])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupColletionView() {
        fabricsCollectionView.register(UINib(nibName: ChooseFabricCell.cellIdentifier(),
                                             bundle: nil),
                                       forCellWithReuseIdentifier: ChooseFabricCell.cellIdentifier())
        fabricsCollectionView.reloadData()
    }
    
    func setupUI() {
        infoLable.text = "info_choose_fabric_info".localized
        if isSortFilterApply == false {
            getAvailableFabric()
        }
    }
    
    func setupNavigation() {
        setNavigationBarHidden(hide: false)
        setLeftButton()
        navigationItem.title = TITLE.chooseFabric.localized
        setRightButtonsArray(buttonArray: ["searchW_Icon", "sortW_Icon","filterW_Icon"])
    }
    
    func removeFromSuperView() {
        for subview in self.view.subviews {
            if !(subview is UICollectionView) {
                subview.removeFromSuperview()
                break
            }
        }
    }
    
    func showEmptyShoppingBagView() {
        let screenWith = MAINSCREEN.size.width
        let backView : UIView = UIView.init(frame: self.view.frame)
        backView.backgroundColor = UIColor.white
        self.view.addSubview(backView)
        
        let shoppingBagImageView : UIImageView = UIImageView.init(frame: CGRect(x: (screenWith/2) - 40, y: 104, width: 80, height: 80))
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
}

//MARK: -SearchProductDelegate
extension ChooseFabricVC : SearchProductDelegate {
    func callsearchApi(searchtext: String, isfromProduct: Bool) {
        if searchtext == "" {
            self.getAvailableFabric()
        }
        if let productList = self.viewModel.chooseFabricProduct?.products {
            self.viewModel.filteredData = searchtext.isEmpty ? productList : productList.filter({(dataString: ProductsList) -> Bool in
                return dataString.name.range(of: searchtext, options: .caseInsensitive) != nil
            })
        }
        fabricsCollectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension ChooseFabricVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isSortFilterApply == true {
            self.removeFromSuperView()
            if self.viewModel.filteredData.count <= 0 {
                self.showEmptyShoppingBagView()
            }
            return self.viewModel.filteredData.count
        } else{
            return (self.viewModel.chooseFabricProduct?.products.count) ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseFabricCell.cellIdentifier(), for: indexPath) as! ChooseFabricCell
        cell.backgroundColor = UIColor.clear
        cell.selectModelBottomView.isHidden = true
        cell.bottomView.isHidden = false
        cell.priceLbl.isHidden = true
        cell.fabricImgView.layer.cornerRadius = 15
        cell.fabricImgView.layer.masksToBounds = true
        cell.bottomViewHeightConstraints.constant = 80
        
        if isSortFilterApply == true {
            if self.viewModel.filteredData.count > 0 {
                let product = self.viewModel.filteredData[indexPath.row]
                if !(product.image.isEmpty) {
                    let imageUrlString = URL(string: product.image)
                    cell.fabricImgView.sd_setImage(with: imageUrlString,
                                                   placeholderImage: UIImage(named: "placeholder"),
                                                   options: .continueInBackground,
                                                   progress: nil,
                                                   completed: nil)
                    cell.fabricImgView.contentMode = .scaleToFill
                } else {
                    cell.fabricImgView.image = UIImage(named:"placeholder")
                    cell.fabricImgView.contentMode = .center
                }
                
                cell.isNewImageView.isHidden = product.is_new == 1 ? false : true
                if product.is_new == 1{
                    if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
                        cell.isNewImageView.image = UIImage(named: "flag_arabic")
                    }else{
                        cell.isNewImageView.image = UIImage(named: "newFlag_Icon")
                    }
                }
                
                cell.fabricNameLbl.text = product.name
                cell.fabricCodeLbl.text = String(format: "%@ %@",(product.currency_symbol) , (product.price) )
                cell.rewardPointLbl.text = String(format: "%d \(TITLE.Rewards.localized)", product.reward_points)
                cell.fabricCodeLbl.textColor = Theme.priceColor
                let special_price = Double((product.special_price) ) ?? 0
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
            }
            
            cell.favouriteBtn.isHidden = true
            cell.layoutIfNeeded()
            return cell
        } else {
            if let product = self.viewModel.chooseFabricProduct?.products[indexPath.row]{
                if !(product.image.isEmpty) {
                    let imageUrlString = URL(string: product.image)
                    cell.fabricImgView.sd_setImage(with: imageUrlString,
                                                   placeholderImage: UIImage(named: "placeholder"),
                                                   options: .continueInBackground,
                                                   progress: nil,
                                                   completed: nil)
                    cell.fabricImgView.contentMode = .scaleToFill
                } else {
                    cell.fabricImgView.image = UIImage(named:"placeholder")
                    cell.fabricImgView.contentMode = .center
                }
                
                cell.isNewImageView.isHidden = product.is_new == 1 ? false : true
                if product.is_new == 1 {
                    if LocalDataManager.getSelectedLanguage() == LanguageSelection.ARABIC.rawValue{
                        cell.isNewImageView.image = UIImage(named: "flag_arabic")
                    }else{
                        cell.isNewImageView.image = UIImage(named: "newFlag_Icon")
                    }
                }
                
                cell.fabricNameLbl.text = product.name
                cell.fabricCodeLbl.text = String(format: "%@ %@",(product.currency_symbol) , (product.price) )
                cell.rewardPointLbl.text = String(format: "%d \(TITLE.Rewards.localized)", product.reward_points)
                cell.fabricCodeLbl.textColor = Theme.priceColor
                let special_price : Double = Double((product.special_price) ) ?? 0
                if !product.per_off.isEmpty || !product.special_price.isEmpty{
                    cell.fabricBlurCodeLbl.text = String(format: "%@ %@",(product.currency_symbol), (product.special_price))
                    cell.fabricDiscountLbl.text = "\(product.per_off)\(TITLE.customer_off.localized)"
                    cell.fabricCodeLbl.textColor = Theme.lightGray
                } else {
                    cell.fabricDiscountLbl.text = ""
                    cell.fabricBlurCodeLbl.text = ""
                    cell.fabricCodeLbl.textColor = Theme.priceColor
                }
                
                cell.lineView.isHidden = special_price == 0.0
            }
            
            cell.favouriteBtn.isHidden = true
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let product = self.viewModel.chooseFabricProduct?.products[indexPath.row]
        let vc = SellerDetailVC.loadFromNib()
        vc.classType = .CHOOSEFABRICVC
        vc.bottomBtnTitle = TITLE.choose.localized
        vc.isRatingAvail = false
        vc.detailClassType = .ADDTOBAG
        vc.viewModel.category_id = self.viewModel.chooseFabricProduct?.category_id ?? 0
        vc.viewModel.product_id = Int((product?.id) ?? "0") ?? 0
        vc.viewModel.quotedId = (self.viewModel.chooseFabricProduct?.quote_id) ?? ""
        vc.viewModel.item_quote_id = (self.viewModel.chooseFabricProduct?.item_quote_id) ?? ""
        vc.viewModel.qty = self.viewModel.qty
        vc.viewModel.delivery_date = self.viewModel.delivery_date
        vc.viewModel.fabric_offline = self.viewModel.fabric_offline
        vc.viewModel.minFabricReq = self.viewModel.minFabricRequired
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ChooseFabricVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (self.view.frame.width-15)/2
        let height : CGFloat = width*1.53
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:5, left: 5, bottom: 5, right: 5)
    }
}

//MARK: - APICALL
extension ChooseFabricVC {
    func getAvailableFabric() {
        viewModel.chooseFabricProduct = nil
        viewModel.getAvailableFabric {
            DispatchQueue.main.async {
                self.fabricsCollectionView.reloadData()
            }
        }
    }
}
