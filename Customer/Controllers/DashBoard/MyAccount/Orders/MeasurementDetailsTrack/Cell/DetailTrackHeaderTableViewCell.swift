//
//  DetailTrackHeaderTableViewCell.swift
//  EZAR
//
//  Created by Shruti Gupta on 5/3/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class DetailTrackHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var measurementTypeTxtLbl: UILabel!
    @IBOutlet weak var measurementTypeValLbl: UILabel!
    @IBOutlet weak var modelTypeTxtLbl: UILabel!
    @IBOutlet weak var modelTypeValLbl: UILabel!
    @IBOutlet weak var nameTxtLbl: UILabel!
    @IBOutlet weak var nameTypeValLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameTxtLbl.text = TITLE.Name.localized + " :"
       self.measurementTypeTxtLbl.text = TITLE.customer_measurement_type.localized + " :"
        self.modelTypeTxtLbl.text = TITLE.customer_model_type.localized + " :"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func cellIdentifier() -> String {
        return "DetailTrackHeaderTableViewCell"
    }
}
