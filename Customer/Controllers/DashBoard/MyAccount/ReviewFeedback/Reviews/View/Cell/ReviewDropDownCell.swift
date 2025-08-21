//
//  ReviewDropDownCell.swift
//  Customer
//
//  Created by webwerks on 9/24/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReviewDropDownCell: UITableViewCell {

    @IBOutlet weak var questionTxt: UILabel!
    @IBOutlet weak var selectAnswer: CustomTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ReviewDropDownCell"
    }
    
}
