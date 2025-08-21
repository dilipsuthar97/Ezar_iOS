//
//  ShoppingProductTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 03/04/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ShoppingProductTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ShoppingProductTableCell"
    }
    
}
