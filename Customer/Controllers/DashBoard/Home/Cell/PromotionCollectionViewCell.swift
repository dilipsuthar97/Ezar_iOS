//
//  PromotionCollectionViewCell.swift
//  Customer
//
//  Created by Shruti Gupta on 1/14/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class PromotionCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func cellIdentifier() -> String {
        return "PromotionCollectionViewCell"
    }
}
