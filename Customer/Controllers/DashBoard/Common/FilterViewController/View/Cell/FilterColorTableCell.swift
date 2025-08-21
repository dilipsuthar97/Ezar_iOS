//
//  FilterColorTableCell.swift
//  Customer
//
//  Created by webwerks on 7/17/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class FilterColorTableCell: UITableViewCell {

    @IBOutlet weak var colorView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "FilterColorTableCell"
    }
    
}
