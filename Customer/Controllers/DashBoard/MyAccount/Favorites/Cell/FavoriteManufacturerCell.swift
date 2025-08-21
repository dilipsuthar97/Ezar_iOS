//
//  FavoriteManufacturerCell.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 3/22/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class FavoriteManufacturerCell: UITableViewCell {

    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var imgViewManufacturer: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var btnRemove: ActionButton!
    @IBOutlet weak var startFromLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellIdentifier() -> String {
        return "FavoriteManufacturerCell"
    }    
}
