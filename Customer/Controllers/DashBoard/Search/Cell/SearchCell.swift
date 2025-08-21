//
//  SearchCell.swift
//  Customer
//
//  Created by webwerks on 15/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var fabricImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var rewardPointLbl: UILabel!
    @IBOutlet weak var favouriteBtn: ActionButton!
    @IBOutlet weak var isNewImageView: UIImageView!

    @IBOutlet weak var btnMoreInfo: ActionButton!
        
    class func cellIdentifier() -> String {
        return "SearchCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutSubviews()
        priceLbl.font = FontType.bold(size: 14)
        titleLbl.font = FontType.bold(size: 14)
        btnMoreInfo.setTitle("model_details".localized, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        priceLbl.roundCorners([.topRight, .bottomRight], radius: 15)
        bgView.layer.cornerRadius = 15
    }
}
