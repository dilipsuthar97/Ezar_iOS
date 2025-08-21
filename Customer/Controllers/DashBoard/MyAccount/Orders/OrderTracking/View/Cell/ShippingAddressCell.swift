//
//  ShippingAddressCell.swift
//  Customer
//
//  Created by webwerks on 10/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ShippingAddressCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var defaultLbl: UILabel!
    @IBOutlet weak var addressTypeLbl: ActionButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ShippingAddressCell"
    }
}
