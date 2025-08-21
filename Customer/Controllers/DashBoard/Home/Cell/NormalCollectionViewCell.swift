//
//  NormalCollectionViewCell.swift
//  Customer
//
//  Created by Shruti Gupta on 1/11/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class NormalCollectionViewCell: UICollectionViewCell {

     @IBOutlet var imgView: DesignableImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView.showBottomShadow(height: 3, color: UIColor.lightGray)
        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "NormalCollectionViewCell"
    }

}
