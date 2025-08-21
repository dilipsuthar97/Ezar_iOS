//
//  ProductSizeTableCell.swift
//  Customer
//
//  Created by webwerks on 4/18/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ProductSizeTableCell: UITableViewCell {

    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: ProductSizeCCell.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: ProductSizeCCell.cellIdentifier())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ProductSizeTableCell"
    }
}
