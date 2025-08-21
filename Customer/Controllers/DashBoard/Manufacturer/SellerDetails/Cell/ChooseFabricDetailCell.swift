//
//  ChooseFabricDetailCell.swift
//  Customer
//
//  Created by webwerks on 4/3/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ChooseFabricDetailCell: UITableViewCell {
    
    @IBOutlet weak var fabricName: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var minReqPriceLbl: UILabel!
    @IBOutlet weak var asPerPriceLbl: UILabel!
    @IBOutlet weak var fabricInfoBtn: ActionButton!
    @IBOutlet weak var perOffLbl: UILabel!
    @IBOutlet weak var cancelLineLbl: UILabel!
    @IBOutlet weak var specialPriceLbl: UILabel!
    @IBOutlet weak var actualPriceLbl: UILabel!
    @IBOutlet weak var rewardPointsLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.fabricInfoBtn.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        self.fabricInfoBtn.layer.borderWidth = 2
    }

    static func cellIdentifier() -> String{
        return "ChooseFabricDetailCell"
    }
}
