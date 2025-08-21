//
//  TestCell.swift
//  Customer
//
//  Created by webwerks on 4/23/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class SellerImageCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var playButton: ActionButton!
    @IBOutlet weak var ratingStar: HCSStarRatingView!

    var bannerImageList: NSArray = NSArray()
    var logoUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCellNib(SellerImageCollectionViewCell.cellIdentifier())
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    static func cellIdentifier() -> String {
        return "SellerImageCell"
    }
    
    @IBAction func pageControlChanged(page:UIPageControl)  {
        let width = self.collectionView.frame.size.width
        let scrollTo = CGPoint.init(x: width * CGFloat(pageController.currentPage), y: 0)
        self.collectionView.setContentOffset(scrollTo, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension SellerImageCell : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let count = bannerImageList.count > 0 ? bannerImageList.count : 1
        self.pageController.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SellerImageCollectionViewCell.cellIdentifier(), for: indexPath as IndexPath) as! SellerImageCollectionViewCell
        
        if self.bannerImageList.count > 0,
           let imageUrl = self.bannerImageList[indexPath.row] as? String {
            cell.detailImageView.sd_setImage(with: URL(string: imageUrl),
                                             placeholderImage: UIImage(named: "placeholder"))
            return cell
        }
        cell.detailImageView.sd_setImage(with: URL(string: logoUrl),
                                         placeholderImage: UIImage.init(named: "placeholder"))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(collectionView.contentOffset.x) / Int(collectionView.frame.width)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Delegate
extension SellerImageCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0, bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
