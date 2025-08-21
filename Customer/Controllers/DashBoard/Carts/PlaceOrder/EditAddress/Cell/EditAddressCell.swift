//
//  EditAddressCell.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class EditAddressCell: UITableViewCell {

    @IBOutlet weak var importantLbl: UILabel!
    @IBOutlet weak var textFiledName: UILabel!
    @IBOutlet weak var inputTextField: CustomTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "EditAddressCell"
    }
    
}
