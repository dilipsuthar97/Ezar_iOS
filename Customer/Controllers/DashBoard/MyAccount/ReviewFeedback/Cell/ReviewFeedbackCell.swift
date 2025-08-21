//
//  RequestFeedbackCell.swift
//  Customer
//
//  Created by webwerks on 26/02/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReviewFeedbackCell: UITableViewCell {

    @IBOutlet weak var deliveredImgView: UIImageView!
    
    @IBOutlet weak var deliveredDateLbl: UILabel!
    
    @IBOutlet weak var deliveredLbl: UILabel!
    
    @IBOutlet weak var reviewBtn: UIButton!
    
    @IBOutlet weak var reviewImgView: UIImageView!
    
    @IBOutlet weak var thoabLbl: UILabel!
    
    @IBOutlet weak var paymentModeLbl: UILabel!
    
    @IBOutlet weak var codeLbl: UILabel!
    
    @IBOutlet weak var deliveredImgViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "ReviewFeedbackCell"
    }
}
