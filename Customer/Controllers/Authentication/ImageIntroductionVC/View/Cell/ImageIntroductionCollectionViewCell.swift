//
//  ImageIntroductionCollectionViewCell.swift
//  Customer
//
//  Created by Shruti Gupta on 1/14/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class ImageIntroductionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class func cellIdentifier() -> String {
        return "ImageIntroductionCollectionViewCell"
    }
}
