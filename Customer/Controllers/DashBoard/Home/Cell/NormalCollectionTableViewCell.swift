//
//  NormalCollectionTableViewCell.swift
//  Customer
//
//  Created by Shruti Gupta on 1/11/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class NormalCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: NormalCollectionViewCell.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: NormalCollectionViewCell.cellIdentifier())
        //collectionView.dataSource = self
       // collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "NormalCollectionTableViewCell"
    }
}

extension NormalCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
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


//extension NormalCollectionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate
//{
//    // MARK: UICollectionViewDataSource
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel.exploreProductList?.categories.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell: NormalCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.cellIdentifier(), for: indexPath as IndexPath) as! NormalCollectionViewCell
//
//        cell.titleLbl.backgroundColor = UIColor.lightGrayColor
//        let homePromotion = self.viewModel.exploreProductList?.categories[indexPath.row]
//        cell.titleLbl.text = homePromotion?.name
//
//        if let imageUrl = homePromotion?.imageUrl, !(imageUrl.isEmpty)
//        {
//            let imageUrlString = URL.init(string: imageUrl)
//            cell.productImage.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: nil)
//        }
//        cell.layoutIfNeeded()
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let homePromotion = self.viewModel.exploreProductList?.categories[indexPath.row]
//        var max_capacity : String = homePromotion?.max_capacity ?? "0"
//        if max_capacity == "0"
//        {
//            max_capacity = String(format: "%d", homePromotion?.imax_capacity ?? 0)
//        }
//        self.delegate.navigateToSearch(categoryID: homePromotion?.id ?? 0, productId: 0, categoryName: homePromotion?.name ?? "", max_capacity: max_capacity, index: indexPath.row, isPromotion: false)
//    }
//}

