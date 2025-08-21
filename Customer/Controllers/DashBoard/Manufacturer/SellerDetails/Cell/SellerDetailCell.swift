//
//  SellerDetailCell.swift
//  Customer
//
//  Created by webwerks on 3/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SellerDetailCell: UITableViewCell {

    @IBOutlet weak var cancelLineLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thobeTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: ActionButton!
    @IBOutlet weak var perOffLabel: UILabel!
    @IBOutlet weak var specialPriceLbl: UILabel!
    @IBOutlet weak var actualPriceLbl: UILabel!
    @IBOutlet weak var rewardPointLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // self.infoButton.setTitle(TITLE.customer_info_plus.localized, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String
    {
        return "SellerDetailCell"
    }
    
}
