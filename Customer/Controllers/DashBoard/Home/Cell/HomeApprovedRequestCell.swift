//
//  HomeApprovedRequestCell.swift
//  Customer
//
//  Created by webwerks on 21/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class HomeApprovedRequestCell: UICollectionViewCell {

    @IBOutlet weak var imgBgView: ShaddowView!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleLblHeightConstraints: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBgView.clipsToBounds = true
        imgBgView.cornerRadius = 4
    }
    
    class func cellIdentifier() -> String {
        return "HomeApprovedRequestCell"
    }
}
