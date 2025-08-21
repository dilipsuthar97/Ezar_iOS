//
//  PriceRangeTableViewCell.swift
//  Customer
//
//  Created by webwerks on 7/23/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class PriceRangeTableViewCell: UITableViewCell {

    @IBOutlet weak var rangeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "PriceRangeTableViewCell"
    }
    
}
