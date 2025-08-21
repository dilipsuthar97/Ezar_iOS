//
//  ManufacturerAdvertiseCell.swift
//  Customer
//
//  Created by webwerks on 20/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ManufacturerAdvertiseCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "ManufacturerAdvertiseCell"
    }
}
