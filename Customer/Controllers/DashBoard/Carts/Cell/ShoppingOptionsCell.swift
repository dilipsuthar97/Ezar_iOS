//
//  ShoppingOptionsCell.swift
//  Customer
//
//  Created by webwerks on 22/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ShoppingOptionsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var giftWrapImgView: UIImageView!
    @IBOutlet weak var couponCodeTxt: CustomTextField!
    @IBOutlet weak var applyButton: ActionButton!
    @IBOutlet weak var couponHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var couponCodeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupValidations()
    }

    func setupValidations() {
        couponCodeTxt.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  TITLE.customer_coupon_empty_message.localized, EmptyMessage: TITLE.customer_coupon_empty_message.localized))
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "ShoppingOptionsCell"
    }
}
