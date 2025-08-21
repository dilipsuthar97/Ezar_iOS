//
//  CmsPagesTableViewCell.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/23/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class CmsPagesTableViewCell: UITableViewCell {

    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "CmsPagesTableViewCell"
    }
}
