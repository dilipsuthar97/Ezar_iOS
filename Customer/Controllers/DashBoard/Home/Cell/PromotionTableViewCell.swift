//
//  PromotionTableViewCell.swift
//  Customer
//
//  Created by Shruti Gupta on 1/14/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
//    var viewModel : HomeRequestsViewModel = HomeRequestsViewModel()
    var delegate : HomeVCDelegate!
    var promotionList : [HomePromotion] = [HomePromotion]()

    override func awakeFromNib() {
        super.awakeFromNib()
         collectionView.register(UINib(nibName: PromotionCollectionViewCell.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: PromotionCollectionViewCell.cellIdentifier())
        collectionView.dataSource = self
        collectionView.delegate = self
        
       // collectionView.reloadData()
        self.startTimer()
    }
    
    func setCollectionViewDataSourceDelegate() {
    collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellIdentifier() -> String {
        return "PromotionTableViewCell"
    }
    
    //New Change
    func imageResize (_ image:UIImage)-> UIImage{
        
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 250)
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    //Auto scroll
    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextCell(){
        
        let contentOffset = collectionView.contentOffset;
        
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + collectionView.frame.width , y:contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height), animated: true)
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension PromotionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    }
}


extension PromotionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PromotionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCollectionViewCell.cellIdentifier(), for: indexPath as IndexPath) as! PromotionCollectionViewCell
        
         let promotion = promotionList[indexPath.row]
            let imageUrlString = URL.init(string: promotion.promotionImageUrl)
        cell.imgView.sd_setImage(with: imageUrlString, placeholderImage: UIImage.init(named: "placeholder"), options: .continueInBackground, progress: nil, completed: { _,_,_,_  in
            cell.imgView.image = self.imageResize(cell.imgView.image ?? UIImage())
        })
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
            let promotion = promotionList[indexPath.row]
            let max_cap : String = String(format : "%d", promotion.max_capacity)
        self.delegate.navigateToSearch(categoryID:promotion.parent_category_id, productId: promotion.promotionId, categoryName: "", max_capacity: max_cap, index: indexPath.row, isPromotion: true, promoType: promotion.promotionType, isFromExploreMore: false)
    }
}
