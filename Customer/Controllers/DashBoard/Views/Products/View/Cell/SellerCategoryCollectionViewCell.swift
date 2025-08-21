//
//  SellerCategoryCollectionViewCell.swift
//  EZAR
//
//  Created by abc on 27/05/20.
//  Copyright © 2020 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class SellerCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingStar: HCSStarRatingView!
    @IBOutlet weak var titileLable: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var favouriteBtn: ActionButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellIdentifier() -> String {
        return "SellerCategoryCollectionViewCell"
    }

}
