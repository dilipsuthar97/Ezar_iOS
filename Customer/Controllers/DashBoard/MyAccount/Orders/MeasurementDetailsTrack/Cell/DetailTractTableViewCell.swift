//
//  DetailTractTableViewCell.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/30/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class DetailTractTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTxtLbl: UILabel!
    @IBOutlet weak var valLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func cellIdentifier() -> String {
        return "DetailTractTableViewCell"
    }
}
