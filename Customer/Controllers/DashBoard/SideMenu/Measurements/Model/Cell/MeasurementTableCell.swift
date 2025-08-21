//
//  MeasurementTableCell.swift
//  Customer
//
//  Created by Priyanka Jagtap on 23/03/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MeasurementTableCell: UITableViewCell {

    @IBOutlet weak var measuredByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var measurementLbl: UILabel!
    @IBOutlet weak var thobeTypeLbl: UILabel!
    @IBOutlet weak var selectSizeButton: ActionButton!
    @IBOutlet weak var sizeLabel: UILabel!{
        didSet{
            sizeLabel.layer.masksToBounds = true
            sizeLabel.layer.cornerRadius = 10
            sizeLabel.layer.borderColor = UIColor.green.cgColor
            sizeLabel.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var infoButton: ActionButton!{
        didSet{
            infoButton.layer.masksToBounds = true
            infoButton.layer.cornerRadius = 14
           // infoButton.layer.borderColor = UIColor.black.cgColor
            //infoButton.layer.borderWidth = 0.5
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.infoButton.setTitle(TITLE.customer_info_plus.localized, for: .normal)
//        selectSizeButton.isHidden = true
//        selectSizeButton.setTitle(TITLE.customer_edit_size.localized, for: .normal)
        thobeTypeLbl.text = "EZAR"
        thobeTypeLbl.textColor = UIColor(named: "BorderColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
