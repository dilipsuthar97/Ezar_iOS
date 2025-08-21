
//  CustomCollectionTableCell.swift
//  Customer -- Praful
//
//  Created by webwerks on 3/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class CustomCollectionTableCell: UITableViewCell{
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    var delegate : HomeVCDelegate!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryTitleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    
    
    var viewModel : HomeRequestsViewModel = HomeRequestsViewModel()
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: HomeApprovedRequestCell.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: HomeApprovedRequestCell.cellIdentifier())
        
        collectionView.dataSource = self
        collectionView.delegate = self
       //self.collectionView.reloadData()
    }
    
    func setCollectionViewDataSourceDelegate() {
    collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "CustomCollectionTableCell"
    }
}

extension CustomCollectionTableCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 190)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
}


extension CustomCollectionTableCell : UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.exploreProductList?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell: HomeApprovedRequestCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeApprovedRequestCell.cellIdentifier(), for: indexPath as IndexPath) as! HomeApprovedRequestCell
        
        cell.titleLbl.backgroundColor = Theme.lightGray
        let homePromotion = self.viewModel.exploreProductList?.categories[indexPath.row]
        cell.titleLbl.text = homePromotion?.name
      
        if let imageUrl = homePromotion?.imageUrl
            //, !(imageUrl.isEmpty)
        {
            let imageUrlString = URL.init(string: imageUrl)
            cell.productImage.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
        }
      cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homePromotion = self.viewModel.exploreProductList?.categories[indexPath.row]
        var max_capacity : String = homePromotion?.max_capacity ?? "0"
        if max_capacity == "0"
        {
            max_capacity = String(format: "%d", homePromotion?.imax_capacity ?? 0)
        }
        
        //MARK:- CLient requirement
    
//        if LocalDataManager.getUserSelection() == ProductType.CustomMade.rawValue{
//           LocalDataManager.setUserSelection(ProductType.ReadyMade.rawValue)
//        }else{
//            LocalDataManager.setUserSelection(ProductType.CustomMade.rawValue)
//        }
        
       
        self.delegate.navigateToSearch(categoryID: homePromotion?.id ?? 0, productId: 0, categoryName: homePromotion?.name ?? "", max_capacity: max_capacity, index: indexPath.row, isPromotion: false, promoType: "", isFromExploreMore: true)
    }
}

