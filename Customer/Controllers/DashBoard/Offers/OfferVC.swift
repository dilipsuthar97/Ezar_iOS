//
//  OfferVC.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/3/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class OfferVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : HomeRequestsViewModel = HomeRequestsViewModel()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        homePromotionsAPICall()
    }
    
    func setupUI(){
        setNavigationBarHidden(hide: false)
        navigationItem.title = TITLE.customer_offer.localized
    }
    
    func homePromotionsAPICall() {
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
        self.viewModel.getHomePromotionsOffer {
            self.viewModel.homePromotions.append(contentsOf: self.viewModel.bottomPromotionsList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: NormalTableCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: NormalTableCell.cellIdentifier())
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    func imageResize (_ image:UIImage)-> UIImage{
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 220)
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

//MARK:- TableView datasoruce & delegate methods
extension OfferVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.homePromotions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NormalTableCell = tableView.dequeueReusableCell(withIdentifier: NormalTableCell.cellIdentifier(), for: indexPath) as! NormalTableCell
        cell.selectionStyle = .none
        let promotion = self.viewModel.homePromotions[indexPath.row]
        let imageUrlString = URL.init(string: promotion.promotionImageUrl)
        cell.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        cell.imgView.image = self.imageResize(cell.imgView.image!)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        COMMON_SETTING.max_capacity = LocalDataManager.getUserSelection() == ProductType.ReadyMade.rawValue ? 999 : 0
        
        let promotion = self.viewModel.homePromotions[indexPath.row]
        
        if promotion.promotionType == "category"{
            if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                let vc = ManufacturerVC.loadFromNib()
                vc.viewModel.category_id = promotion.parent_category_id
                vc.viewModel.categoryName = ""
                vc.viewModel.max_capacity = String(promotion.max_capacity)
                vc.selectedIndex = indexPath.row
                vc.isPromotion = false
                vc.homeViewModel = self.viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = ProductsVC.loadFromNib()
                vc.viewModel.current_page = 1
                vc.viewModel.category_id =  promotion.promotionId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
                let vc = SellerDetailVC.loadFromNib()
                vc.classType = .HOMEREQUESTSVC
                vc.bottomBtnTitle = TITLE.chooseStyles.localized
                vc.isRatingAvail = true
                vc.viewModel.category_id = promotion.parent_category_id
                vc.viewModel.product_id = promotion.promotionId
                vc.detailClassType = .CHOOSESTYLE
                vc.viewModel.is_promotion = 1
                COMMON_SETTING.max_capacity = Int(promotion.max_capacity)
                self.navigationController?.pushViewController(vc, animated: false)
            } else {
                let vc = SellerDetailVC.loadFromNib()
                vc.classType = .HOMEREQUESTSVC
                vc.bottomBtnTitle = TITLE.addToCart.localized
                vc.isRatingAvail = true
                vc.viewModel.category_id = promotion.parent_category_id
                vc.viewModel.product_id = promotion.promotionId
                vc.detailClassType = .READYMADE
                vc.viewModel.is_promotion = 1
                COMMON_SETTING.max_capacity = Int(promotion.max_capacity)
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}
