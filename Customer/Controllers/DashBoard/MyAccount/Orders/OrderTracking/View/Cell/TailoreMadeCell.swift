//
//  TailoreMadeCell.swift
//  Customer
//
//  Created by webwerks on 10/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class TailoreMadeCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemQuantityBtn: ActionButton!
    @IBOutlet weak var reviewItemBtn: ActionButton!
    @IBOutlet weak var reOrderBtn: ActionButton!
    @IBOutlet weak var reviewItemBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewViewHeight: NSLayoutConstraint!
    @IBOutlet weak var checkBoxImgView: UIImageView!
    @IBOutlet weak var itemQuantityTxtField: CustomTextField!
    @IBOutlet weak var mesurementDetailView: UIView!
    @IBOutlet weak var mesurementDetailBtn: ActionButton!
    @IBOutlet weak var styleInfoView: UIView!
    @IBOutlet weak var styleInfoBtn: ActionButton!
    @IBOutlet weak var qtyLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    self.mesurementDetailBtn.setTitle(TITLE.MeasurementDetail.localized, for: .normal)
        self.styleInfoBtn.setTitle(TITLE.customer_style_info.localized, for: .normal)
        self.mesurementDetailView.isHidden = true
        self.styleInfoView.isHidden = true
        reOrderBtn.setTitle(TITLE.customer_reorder.localized, for: .normal)
        qtyLbl.text = TITLE.Quantity.localized
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "TailoreMadeCell"
    }
    
}
