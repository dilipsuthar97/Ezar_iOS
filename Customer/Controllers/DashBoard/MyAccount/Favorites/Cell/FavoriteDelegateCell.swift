//
//  FavoriteDelegateCell.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 3/22/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class FavoriteDelegateCell: UITableViewCell {

    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var imgViewDelegate: UIImageView!
    @IBOutlet weak var lblDelegateName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnRemove: ActionButton!
    @IBOutlet weak var ratingView: HCSStarRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func cellIdentifier() -> String {
        return "FavoriteDelegateCell"
    }    
}
