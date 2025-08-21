//
//  FabricModelCell.swift
//  Customer
//
//  Created by webwerks on 15/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

// Temp extensions for View and imageView

extension UIView {
    
    func roundCornersForView(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

class FabricModelCell: UICollectionViewCell {

    @IBOutlet weak var fabricImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var selectRewardPointLbl: UILabel!
    @IBOutlet weak var isNewImageView: UIImageView!
    
    @IBOutlet weak var btnChooseStyle: ActionButton!
    @IBOutlet weak var btnMoreInfo: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        priceLbl.roundCorners([.topRight,.bottomRight], radius: 15)
        fabricImgView.heightAnchor.constraint(equalToConstant: CGFloat(230)).isActive = true
        
        btnChooseStyle.setTitle("choose_styles".localized, for: .normal)
        btnMoreInfo.setTitle("model_details".localized, for: .normal)
    }
        
    class func cellIdentifier() -> String {
        return "FabricModelCell"
    }
}
