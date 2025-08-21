//
//  StyleInfoTableViewCell.swift
//  EZAR
//
//  Created by Shruti Gupta on 4/30/19.
//  Copyright © 2019 Thoab App. All rights reserved.
//

import UIKit

class StyleInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTxtLbl: UILabel!
    @IBOutlet weak var styleImageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.selectedView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func cellIdentifier() -> String {
        return "StyleInfoTableViewCell"
    }
}
