//
//  ProductSizeCCell.swift
//  Customer
//
//  Created by webwerks on 4/18/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ProductSizeCCell: UICollectionViewCell {

    @IBOutlet weak var backGView: UIView!
    @IBOutlet weak var selectedView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var noAvailableView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellIdentifier() -> String {
        return "ProductSizeCCell"
    }
}
