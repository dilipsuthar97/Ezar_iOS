//
//  ChangeLaguageCell.swift
//  Customer
//
//  Created by webwerks on 4/9/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ChangeLanguageCell: UITableViewCell {

    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String {
        return "ChangeLanguageCell"
    }
    
}
