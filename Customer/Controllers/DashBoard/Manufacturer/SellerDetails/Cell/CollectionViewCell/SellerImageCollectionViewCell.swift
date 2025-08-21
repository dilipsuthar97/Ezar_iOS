//
//  TextCollectionViewCell.swift
//  Customer
//
//  Created by webwerks on 4/23/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SellerImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var detailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func cellIdentifier() -> String {
        return "SellerImageCollectionViewCell"
    }

    func bindWithModel() {
        self.contentView.setNeedsLayout()
    }
}
