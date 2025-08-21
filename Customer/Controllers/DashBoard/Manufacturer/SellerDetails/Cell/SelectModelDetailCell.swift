//
//  SelectModelDetailCell.swift
//  Customer
//
//  Created by webwerks on 3/30/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class SelectModelDetailCell: UITableViewCell {

    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorAddress: UILabel!
    @IBOutlet weak var vendorDetailLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String
    {
        return "SelectModelDetailCell"
    }
}
