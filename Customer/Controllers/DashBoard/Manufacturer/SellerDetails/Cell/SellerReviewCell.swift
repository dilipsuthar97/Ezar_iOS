//
//  SellerReviewCell.swift
//  Customer
//
//  Created by webwerks on 3/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SellerReviewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var contentTxtView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cerifiedBLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var unlikeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var certifiedImgView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var likeBtn: ActionButton!
    @IBOutlet weak var dislikeBtn: ActionButton!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cerifiedBLabel.text = TITLE.certifiedBuyer.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String
    {
        return "SellerReviewCell"
    }
    
}
