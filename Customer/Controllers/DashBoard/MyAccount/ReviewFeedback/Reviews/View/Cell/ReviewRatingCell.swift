//
//  ReviewRatingCell.swift
//  Customer
//
//  Created by webwerks on 9/24/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewRatingCell: UITableViewCell {

    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headerLabel.isHidden = true
        self.headerLabel.text = TITLE.customer_please_rate.localized
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ReviewRatingCell"
    }
    
}
