//
//  MeasurementDetailCell.swift
//  Customer
//
//  Created by webwerks on 4/5/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MeasurementDetailCell: UITableViewCell {

    //MARK:- Required Variable
    @IBOutlet weak var txtTitleLabel: UILabel!
    @IBOutlet weak var inputTxtField: CustomTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String {
        return "MeasurementDetailCell"
    }
    
    
}
