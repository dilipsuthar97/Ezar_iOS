//
//  FabricRequestCell.swift
//  Customer
//
//  Created by webwerks on 4/4/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class FabricRequestCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelButtton: ActionButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //titleLbl.text = "customer_request_broadcasted".localized
        cancelButtton.setTitle("cancel".localized, for: .normal)
        cancelButtton.isHidden = true
    }
    
    static func cellIdentifier() -> String {
        return "FabricRequestCell"
    }
}
