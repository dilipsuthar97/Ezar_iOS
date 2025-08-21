//
//  ManufacturerCell.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 3/21/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ManufacturerCell: UITableViewCell {

    @IBOutlet weak var imgViewManufacturer: UIImageView!
    @IBOutlet weak var startFromLbl: PaddingLabel! {
        didSet{
            startFromLbl.topInset = 0
            startFromLbl.bottomInset = 0
        }
    }
    @IBOutlet weak var lblValue: PaddingLabel!{
        didSet{
            lblValue.topInset = 0
        }
    }
    @IBOutlet weak var lblManufacturerName: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var locationImgView: UIImageView!
    
    @IBOutlet weak var favouriteBtn: ActionButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        startFromLbl.text = TITLE.customer_start_from.localized
        statusLbl.layer.masksToBounds = true
        statusLbl.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func cellIdentifier() -> String {
        return "ManufacturerCell"
    }
    
    func reset(isHide: Bool = true) {
        if isHide {
            startFromLbl.text = ""
            startFromLbl.isHidden = true
            lblValue.isHidden = true
            startFromLbl.topInset = 0
            lblValue.topInset = 0
        } else {
            startFromLbl.text = TITLE.customer_start_from.localized
            startFromLbl.isHidden = false
            lblValue.isHidden = false
            startFromLbl.topInset = 5
            lblValue.topInset = 5
        }
    }
}
