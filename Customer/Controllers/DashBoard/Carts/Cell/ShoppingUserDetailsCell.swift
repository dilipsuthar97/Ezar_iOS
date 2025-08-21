//
//  ShoppingUserDetailsCell.swift
//  Customer
//
//  Created by webwerks on 22/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ShoppingUserDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var requestIdLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "ShoppingUserDetailsCell"
    }
}
