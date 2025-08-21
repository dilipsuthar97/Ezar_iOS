//
//  SelectFabricCell.swift
//  Customer
//
//  Created by webwerks on 4/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class SelectFabricCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func cellIdentifier() -> String {
        return "SelectFabricCell"
    }
}
