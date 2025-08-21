//
//  ChooseFabricCell.swift
//  Customer
//
//  Created by webwerks on 15/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ChooseFabricCell: UICollectionViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var modelLineView: UIView!
    @IBOutlet weak var starWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var fabricImgView: UIImageView!
    @IBOutlet weak var starImgView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var selectModelBottomView: UIView!
    @IBOutlet weak var fabricNameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var rewardPointLbl: UILabel!
    @IBOutlet weak var selectRewardPointLbl: UILabel!
    @IBOutlet weak var fabricDescLbl: UILabel!
    @IBOutlet weak var fabricCodeLbl: UILabel!
    @IBOutlet weak var fabricBlurCodeLbl: UILabel!
    @IBOutlet weak var fabricDiscountLbl: UILabel!
    @IBOutlet weak var favouriteBtn: ActionButton!
    @IBOutlet weak var isNewImageView: UIImageView!
    @IBOutlet weak var rewardPointImageView: UIImageView!
    @IBOutlet weak var bottomViewHeightConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.fabricImgView.roundCornersForView([.topLeft, .topRight], radius: 2)
        self.bottomView.roundCornersForView([.bottomLeft, .bottomRight], radius: 2)
    }
    class func cellIdentifier() -> String {
        return "ChooseFabricCell"
    }
}
