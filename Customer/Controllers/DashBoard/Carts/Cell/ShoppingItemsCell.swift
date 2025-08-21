//
//  ShoppingItemsCell.swift
//  Customer
//
//  Created by webwerks on 22/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ShoppingItemsCell: UITableViewCell {

    @IBOutlet weak var invalidImgView: UIImageView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemDetailLbl: UILabel!
    @IBOutlet weak var itemQuantityBtn: ActionButton!
    @IBOutlet weak var itemInfoBtn: ActionButton!
    @IBOutlet weak var itemEditBtn: ActionButton!
    @IBOutlet weak var itemFavBtn: ActionButton!
    @IBOutlet weak var itemDeleteBtn: ActionButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyTxtLbl: UILabel!
    @IBOutlet weak var isFabricSelectedImgView: UIImageView!
    @IBOutlet weak var isMeasureSelectedImgView: UIImageView!
    @IBOutlet weak var selectFabricButton: ActionButton!
    @IBOutlet weak var selectMeasurementButton: ActionButton!
    @IBOutlet weak var selectFabricLabel: UILabel!
    @IBOutlet weak var selectFabricDescLabel: UILabel!
    @IBOutlet weak var selectMeasurementLabel: UILabel!
    @IBOutlet weak var selectMeasurementDescLabel: UILabel!
    @IBOutlet weak var styleChargesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let imageName : String = LocalDataManager.getSelectedLanguage() == LanguageSelection.ENGLISH.rawValue ? "invalid" : "arb_invalid"
        self.qtyTxtLbl.text = TITLE.customer_quantity_colon.localized
        self.invalidImgView.image = UIImage.init(named: imageName)
        self.selectFabricLabel.text = TITLE.customer_select_fabric.localized
        self.selectFabricDescLabel.text = TITLE.customer_select_fabric_to_proceed.localized
        self.selectMeasurementLabel.text = TITLE.customer_select_measurement.localized
        self.selectMeasurementDescLabel.text = TITLE.customer_select_measurement_to_proceed.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "ShoppingItemsCell"
    }
}
