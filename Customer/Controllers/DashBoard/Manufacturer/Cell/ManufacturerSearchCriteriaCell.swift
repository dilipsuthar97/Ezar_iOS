//
//  ManufacturerSearchCriteriaCell.swift
//  Customer
//
//  Created by webwerks on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ManufacturerSearchCriteriaCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblproductType: UILabel!
    @IBOutlet weak var txtFieldThoab: CustomTextField!
    @IBOutlet weak var txtFieldDeliveryDate: CustomTextField!
    @IBOutlet weak var txtFieldQuantity: CustomTextField!
    @IBOutlet weak var txtFieldLocation: CustomTextField!
    @IBOutlet weak var btnSearch: ActionButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtFieldQuantity.addToolBar()
        self.setupValidations()
    }
    
    
    func setupValidations() {
       
        txtFieldThoab.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.please_text.localized + " " + TITLE.customer_select_category.localized, EmptyMessage: MESSAGE.please_text.localized + " " + TITLE.customer_select_category.localized))
    
        txtFieldDeliveryDate.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.enterMsg.localized + TITLE.customer_delivery_date.localized, EmptyMessage: MESSAGE.enterMsg.localized + TITLE.customer_delivery_date.localized))
        
        txtFieldQuantity.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage: TITLE.customer_error_empty_quantity.localized, EmptyMessage: TITLE.customer_error_empty_quantity.localized))
        
        //txtFieldLocation.add(validator: PatternValidator.init(pattern: ValidatorRegex.notEmpty, ErrorMessage:  MESSAGE.enterMsg + "location", EmptyMessage: MESSAGE.enterMsg + "location"))
        
        self.txtFieldDeliveryDate.placeholder = TITLE.customer_shippingDate.localized
        self.txtFieldQuantity.placeholder = TITLE.Quantity.localized
        self.txtFieldLocation.placeholder = TITLE.customer_search_location.localized
        self.btnSearch.setTitle(TITLE.customer_let_search.localized, for: .normal)
        self.txtFieldThoab.placeholder = TITLE.customer_select_category.localized
    
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "ManufacturerSearchCriteriaCell"
    }
}
