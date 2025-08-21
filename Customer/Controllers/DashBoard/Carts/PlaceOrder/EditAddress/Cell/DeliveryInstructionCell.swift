//
//  DeliveryInstructionCell.swift
//  Customer
//
//  Created by webwerks on 5/31/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class DeliveryInstructionCell: UITableViewCell {

    @IBOutlet weak var textFieldName: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: ActionButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "DeliveryInstructionCell"
    }
    
}
