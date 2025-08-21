//
//  SellerDetailQDDCell.swift
//  Customer
//
//  Created by webwerks on 6/14/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SellerDetailQDDCell: UITableViewCell {

    @IBOutlet weak var cancelLineLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thobeTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: ActionButton!
    @IBOutlet weak var perOffLabel: UILabel!
    @IBOutlet weak var specialPriceLbl: UILabel!
    @IBOutlet weak var actualPriceLbl: UILabel!
    @IBOutlet weak var rewardPointLbl: UILabel!
    @IBOutlet weak var quatityTxtFiled: CustomTextField!
    @IBOutlet weak var deliveryDateTxtFiled: CustomTextField!
    @IBOutlet weak var dateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var vendorNameButton: ActionButton!
    @IBOutlet weak var qtyTxtLabel: UILabel!
    @IBOutlet weak var shippingDateTxtLbl: UILabel!
    @IBOutlet weak var soldByLabel: UILabel!
    @IBOutlet weak var soldByView: UIView!
    @IBOutlet weak var soldByViewHeight: NSLayoutConstraint!
    @IBOutlet weak var plusButton: ActionButton!
    @IBOutlet weak var minusButton: ActionButton!
     @IBOutlet weak var delievryTimeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quatityTxtFiled.addToolBar()
        self.setupValidations()
    }
    
    func setupValidations() {
        
        self.soldByLabel.text = TITLE.customer_soldBy.localized
       // self.infoButton.setTitle(TITLE.customer_info_plus.localized, for: .normal)
        self.shippingDateTxtLbl.text = TITLE.customer_shippingDate.localized + ":"
        qtyTxtLabel.text = TITLE.customer_qty.localized + ":"
        quatityTxtFiled.placeholder = TITLE.customer_qty.localized
        quatityTxtFiled.tag = 0
        deliveryDateTxtFiled.tag = 1
        deliveryDateTxtFiled.placeholder = TITLE.customer_select_delivery_date.localized
        COMMON_SETTING.getTextFieldAligment(textField: quatityTxtFiled)
        
        quatityTxtFiled.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.enterMsg.localized + TITLE.Quantity.localized, EmptyMessage: MESSAGE.enterMsg.localized + TITLE.Quantity.localized))
        
        deliveryDateTxtFiled.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.enterMsg.localized + TITLE.customer_delivery_date.localized, EmptyMessage: MESSAGE.enterMsg.localized + TITLE.customer_delivery_date.localized))
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String
    {
        return "SellerDetailQDDCell"
    }
    
}
