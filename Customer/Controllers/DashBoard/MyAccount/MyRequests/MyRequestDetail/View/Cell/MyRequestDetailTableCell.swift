//
//  RequestDetailTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 27/08/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView


class MyRequestDetailTableCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!{
        didSet{
            profileImgView.layer.masksToBounds = true
            profileImgView.layer.cornerRadius = profileImgView.frame.width/2
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "MyRequestDetailTableCell"
    }
    
}
