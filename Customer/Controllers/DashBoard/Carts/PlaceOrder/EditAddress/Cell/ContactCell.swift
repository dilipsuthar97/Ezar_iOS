//
//  AddressCell.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var contactTextField: CustomTextField!
    @IBOutlet weak var codeTextField: CustomTextField!
    @IBOutlet weak var importantLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "ContactCell"
    }
}
