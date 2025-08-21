//
//  OrderCell.swift
//  Customer
//
//  Created by webwerks on 10/25/18.
//  Copyright © 2018 Thoab App. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderstatuc: UILabel!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var btnReturnIyem: ActionButton!
    @IBOutlet weak var reOrderBtn: ActionButton!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.idLabel.text = TITLE.customer_order_id.localized
        self.statusLabel.text = TITLE.customer_order_status.localized
        self.timeLabel.text = TITLE.customer_created_at.localized
        reOrderBtn.setTitle(TITLE.customer_reorder.localized, for: .normal)        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
    }
    
    class func cellIdentifier() -> String {
        return "OrderCell"
    }
    
}
