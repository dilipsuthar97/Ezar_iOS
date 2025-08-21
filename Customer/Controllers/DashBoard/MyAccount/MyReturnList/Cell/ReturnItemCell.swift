//
//  ReturnItemCell.swift
//  Customer
//
//  Created by webwerks on 10/30/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class ReturnItemCell: UITableViewCell {

    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblReturnId: UILabel!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var returnIdLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.idLabel.text = TITLE.customer_order_id.localized
        self.returnIdLabel.text = TITLE.ReturnId.localized
        self.timeLabel.text = TITLE.UpdatedAt.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    static func cellIdentifier() -> String {
        return "ReturnItemCell"
    }
}
