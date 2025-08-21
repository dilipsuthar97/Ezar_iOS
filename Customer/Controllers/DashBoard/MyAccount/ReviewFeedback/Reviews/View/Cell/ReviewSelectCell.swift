//
//  ReviewSelectCell.swift
//  Customer
//
//  Created by webwerks on 9/24/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReviewSelectCell: UITableViewCell {

    @IBOutlet weak var questionTxt: UILabel!
    @IBOutlet weak var yesImgView: UIImageView!
    @IBOutlet weak var noImgView: UIImageView!
    @IBOutlet weak var yesButton: ActionButton!
    @IBOutlet weak var noButton: ActionButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ReviewSelectCell"
    }
    
}
