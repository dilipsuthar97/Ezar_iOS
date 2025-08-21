//
//  PriceDetailTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 04/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class PriceDetailTableCell: UITableViewCell {
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var vatTxtLbl: UILabel!
    @IBOutlet weak var vatLbl: UILabel!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var totalPayableLbl: UILabel!
    @IBOutlet weak var giftTotalLbl: UILabel!
    @IBOutlet weak var giftWrapLbl: UILabel!
    @IBOutlet weak var giftHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var giftTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var bagTotalTxtLbl: UILabel!
    @IBOutlet weak var coupanDiscountTxtLbl: UILabel!
    @IBOutlet weak var deliveryTxtLbl: UILabel!
    @IBOutlet weak var totalPayableTxtLbl: UILabel!
    @IBOutlet weak var delegateCommisionTxtLbl: UILabel!
    @IBOutlet weak var delegateCommisionLbl: UILabel!
    @IBOutlet weak var delegateCommisionHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var totalPayableTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var styleChargesTxtLbl: UILabel!
    @IBOutlet weak var styleChargesLbl: UILabel!
    @IBOutlet weak var vatPriceTxtLbl: UILabel!
    @IBOutlet weak var vatPriceValLbl: UILabel!
    @IBOutlet weak var styleChargesHeight: NSLayoutConstraint!
    @IBOutlet weak var styleChargesTxtHeight: NSLayoutConstraint!
    
    @IBOutlet weak var styleChargesTop: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bagTotalTxtLbl.text = TITLE.bagTotal.localized
        coupanDiscountTxtLbl.text = TITLE.customer_coupon_discount.localized
        deliveryTxtLbl.text = TITLE.customer_delivery.localized
        deliveryLbl.text = TITLE.customer_na.localized
        giftWrapLbl.text = TITLE.GiftWrap.localized
        totalPayableTxtLbl.text = TITLE.customer_total_payable.localized
        delegateCommisionTxtLbl.text = TITLE.customer_commision.localized
        vatTxtLbl.text = TITLE.customer_vat.localized
        styleChargesTxtLbl.text = TITLE.customer_style_charges.localized
        
        vatPriceTxtLbl.text = TITLE.customer_vat_price.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "PriceDetailTableCell"
    }
}
