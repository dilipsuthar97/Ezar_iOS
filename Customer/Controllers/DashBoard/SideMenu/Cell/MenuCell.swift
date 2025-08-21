//
//  MenuCell.swift
//  Thoab App
//
//  Created by webwerks on 4/20/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {


    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var controllerTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "MenuCell"
    }
    
}
