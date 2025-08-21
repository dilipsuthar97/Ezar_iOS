//
//  ShoppingReadyMadeCell.swift
//  Customer
//
//  Created by webwerks on 7/26/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ShoppingReadyMadeCell: UITableViewCell {
    
    @IBOutlet weak var invalidImgView: UIImageView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemDetailLbl: UILabel!
    @IBOutlet weak var itemEditBtn: ActionButton!
    @IBOutlet weak var itemFavBtn: ActionButton!
    @IBOutlet weak var itemDeleteBtn: ActionButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var txtLabel1: UILabel!
    @IBOutlet weak var txtLabel2: UILabel!
    @IBOutlet weak var txtLabel3: UILabel!
    @IBOutlet weak var txtLabel4: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtLabel1.isHidden = true
        txtLabel2.isHidden = true
        txtLabel3.isHidden = true
        txtLabel4.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ShoppingReadyMadeCell"
    }
    
}
