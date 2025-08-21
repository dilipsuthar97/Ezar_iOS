//
//  PaymentCardCell.swift
//  Customer
//
//  Created by Shrikant Kanakatti on 3/28/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class PaymentCardCell: UITableViewCell {

    @IBOutlet weak var txtFieldCardNumber: UITextField!
    
    @IBOutlet weak var txtFieldName: UITextField!
    
    @IBOutlet weak var txtFieldExpiry: UITextField!
    
    @IBOutlet weak var txtFieldCvv: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellIdentifier() -> String {
        return "PaymentCardCell"
    }
}
